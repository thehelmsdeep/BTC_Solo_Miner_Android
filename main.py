import ctypes
import hashlib
import json
import logging
import queue
import os
import secrets
import pathlib
import platform
import shutil
import subprocess
import socket
import threading
import time
from datetime import datetime
from signal import SIGINT, signal

from colorama import Back, Fore, Style

import miner_context as ctx
from miner_config import CONFIG
from miner_metrics import MinerMetrics
from miner_state import MinerState, MinerStateMachine
from miner_logging import StructuredLogger
from miner_diagnostics import memory_snapshot, worker_count_snapshot


# Backward-compatible aliases. Configuration ownership lives in miner_config.py.
ADDRESS = CONFIG.address
UPSTREAM_HOST = CONFIG.upstream_host
UPSTREAM_PORT = CONFIG.upstream_port
WORKER_PASSWORD = CONFIG.worker_password
CPU_THREADS = CONFIG.cpu_threads
NONCE_BATCH = CONFIG.nonce_batch
REPORT_INTERVAL = CONFIG.report_interval
HEADER_ROTATE_INTERVAL = max(1.0, float(os.getenv("BTC_MINER_HEADER_ROTATE_SECONDS", "5")))
RECONNECT_DELAY = CONFIG.reconnect_delay
SUBMIT_TIMEOUT = CONFIG.submit_timeout
NATIVE_DIR = pathlib.Path(__file__).resolve().parent / "native"
NATIVE_LIB = NATIVE_DIR / ("b_m_sha256.dll" if os.name == "nt" else "libb_m_sha256.so")
NATIVE_ENABLED = CONFIG.native_enabled
_native = None
_native_engine = None
metrics = MinerMetrics()
state_machine = MinerStateMachine()
structured_logger = StructuredLogger(
    event_path=os.getenv("MINER_EVENT_LOG", "miner-events.jsonl")
)

# Share telemetry for the live dashboard (runtime session).
share_stats_lock = threading.Lock()
share_stats = {
    "last_submit_at": None,
    "last_result": "none",
    "last_result_at": None,
    "last_error": "",
    "latency_total": 0.0,
    "latency_count": 0,
    "latency_max": 0.0,
    "first_submit_at": None,
    "submit_times": [],
}

# Proof-of-work candidate telemetry for the live dashboard (runtime session).
pow_stats_lock = threading.Lock()
pow_stats = {
    "candidates": 0,
    "verified": 0,
    "verification_failed": 0,
    "last_at": None,
    "last_status": "none",
    "last_job": "",
    "last_nonce": "",
    "last_engine": "",
}

# Best observed digest normalized against its own job target.
# Native mode samples one nonce per completed scan chunk, so this is the best
# OBSERVED sample, not a guarantee of the best digest among every computed hash.
best_hash_lock = threading.Lock()
best_hash_stats = {
    "value": None,
    "target": None,
    "job_id": None,
    "nonce": None,
    "engine": None,
}

def record_best_hash(digest, target, job_id, nonce, engine):
    """Keep the hash closest to its target, comparing hashes across job difficulties."""
    value = int.from_bytes(digest, "little")
    target = int(target)
    if value <= 0 or target <= 0:
        return
    with best_hash_lock:
        previous_value = best_hash_stats["value"]
        previous_target = best_hash_stats["target"]
        # Lower hash/target is better. Normalize because the target can change
        # when the pool changes difficulty or sends a new job.
        if (previous_value is None or previous_target is None or
                value * previous_target < previous_value * target):
            best_hash_stats.update(
                value=value, target=target, job_id=str(job_id),
                nonce="%08x" % int(nonce), engine=engine
            )

# Current header recipe shown in the live dashboard.
mining_header_status = {
    "job_id": None,
    "extranonce2": None,
    "ntime": None,
    "mode": "waiting for job",
}

def record_pow_status(status, job_id, nonce, engine):
    """Keep the latest candidate and verification outcome visible on screen."""
    with pow_stats_lock:
        if status == "candidate":
            pow_stats["candidates"] += 1
        elif status == "verified":
            pow_stats["verified"] += 1
        elif status == "verification_failed":
            pow_stats["verification_failed"] += 1
        pow_stats["last_at"] = time.monotonic()
        pow_stats["last_status"] = status
        pow_stats["last_job"] = str(job_id)
        pow_stats["last_nonce"] = "%08x" % int(nonce)
        pow_stats["last_engine"] = engine


def timer():
    return datetime.now().time()


def logg(msg):
    """Compatibility logging API backed by human + JSONL event logs."""
    text = str(msg)
    severity = structured_logger.classify_issue(text)
    if severity:
        structured_logger.report_issue(text)
        structured_logger.event("log", severity=severity, message=text)
    else:
        structured_logger.log(text)
        structured_logger.event("log", message=text)


def debug_log(message, **fields):
    """Write diagnostics; count issues from the primary log message only.

    Connection setup metadata may contain words such as "timeout" in a
    configured deadline, which must not turn a successful connection into a
    warning. Handshake-timeout and session-failure records are diagnostic
    details for the exception already counted by logg(), so do not count them
    again.
    """
    message = str(message)
    structured_logger.debug(message, **fields)
    if message in ("Stratum handshake timeout", "Connection/session failure"):
        return
    severity = structured_logger.classify_issue(message)
    if severity:
        structured_logger.report_issue(message, source="debug_log")


def render_dashboard(rate, interval_hashes=None):
    """Render a compact live status screen without deleting saved log files."""
    # ANSI clear/home works in Termux and modern Windows terminals.
    print("\033[2J\033[H", end="")
    print(Fore.BLUE + "============== CPU Solo Miner ==============" + Style.RESET_ALL)
    print("Wallet       : " + ADDRESS)
    print("Status       : " + ("Mining..." if ctx.upstream_alive else "Connecting..."))
    print("Hashrate     : %s MH/s" % format(rate / 1_000_000, ",.6f"))
    print("Total Hashes : %s" % format(ctx.total_hashes, ","))
    now_mono = time.monotonic()
    with share_stats_lock:
        submit_times = [stamp for stamp in share_stats["submit_times"] if now_mono - stamp <= 60.0]
        share_stats["submit_times"] = submit_times
        last_submit_at = share_stats["last_submit_at"]
        last_result = share_stats["last_result"]
        last_result_at = share_stats["last_result_at"]
        last_error = share_stats["last_error"]
        latency_count = share_stats["latency_count"]
        latency_total = share_stats["latency_total"]
        latency_max = share_stats["latency_max"]
        first_submit_at = share_stats["first_submit_at"]
    with ctx.pending_submits_lock:
        pending_count = len(ctx.pending_submits)
    resolved = ctx.shares_accepted + ctx.shares_rejected
    acceptance_rate = (100.0 * ctx.shares_accepted / resolved) if resolved else 0.0
    rejection_rate = (100.0 * ctx.shares_rejected / resolved) if resolved else 0.0
    average_latency = latency_total / latency_count if latency_count else 0.0
    submit_age = now_mono - last_submit_at if last_submit_at is not None else None
    result_age = now_mono - last_result_at if last_result_at is not None else None
    submit_elapsed = max(now_mono - first_submit_at, 1.0) if first_submit_at is not None else 0.0
    submit_per_min = ctx.shares_submitted * 60.0 / submit_elapsed if submit_elapsed else 0.0

    # Group the live dashboard by subsystem so operators can spot issues quickly.
    print("")
    print(Fore.CYAN + "=== 1. MINING / HASH ENGINE ===" + Style.RESET_ALL)
    print("Mining Time       : %s" % structured_logger.dashboard_snapshot()["mining_duration"])
    print("Hashrate          : %s MH/s" % format(rate / 1_000_000, ",.6f"))
    print("Total Hashes      : %s" % format(ctx.total_hashes, ","))
    print("Best Hash Quality : %s" % ("%.12g%%" % min(100.0, (best_target / best_value) * 100.0) if best_value is not None and best_target else "waiting for hash"))
    print("Target Status     : %s" % (("VALID (hash <= target)" if best_value <= best_target else "above target") if best_value is not None and best_target else "waiting for hash"))
    print("")
    print(Fore.CYAN + "=== 2. POOL CONNECTION / JOB ===" + Style.RESET_ALL)
    print("Connection        : %s" % ("connected" if ctx.upstream_alive else "disconnected / connecting"))
    print("Pool Difficulty   : %s" % (ctx.upstream_difficulty if ctx.upstream_difficulty is not None else "unknown"))
    print("Last Job          : %s" % (ctx.job_id or "none"))
    print("")
    print(Fore.CYAN + "=== 3. SHARES / SUBMISSIONS ===" + Style.RESET_ALL)
    print("Submitted         : %s" % format(ctx.shares_submitted, ","))
    print("Accepted          : %s" % format(ctx.shares_accepted, ","))
    print("Rejected          : %s" % format(ctx.shares_rejected, ","))
    print("Pending           : %s" % format(pending_count, ","))
    print("Acceptance        : %s" % ("%.2f%%" % acceptance_rate if resolved else "N/A (no resolved shares)"))
    print("Rejection         : %s" % ("%.2f%%" % rejection_rate if resolved else "N/A (no resolved shares)"))
    print("Last Submit       : %s" % ("never" if submit_age is None else "%.1fs ago" % submit_age))
    print("Last Result       : %s%s" % (last_result, (" | " + last_error) if last_error else ""))
    print("Result Age        : %s" % ("never" if result_age is None else "%.1fs ago" % result_age))
    print("Submit Rate       : %.2f/min" % submit_per_min)
    print("Submit Latency    : avg %.3fs | max %.3fs | samples %s" % (
        latency_total / latency_count if latency_count else 0.0,
        latency_max, format(latency_count, ",")
    ))
    print("")
    print(Fore.CYAN + "=== 4. PROOF OF WORK ===" + Style.RESET_ALL)
    with pow_stats_lock:
        candidate_count = pow_stats["candidates"]
        verified_count = pow_stats["verified"]
        verification_failed_count = pow_stats["verification_failed"]
        pow_last_at = pow_stats["last_at"]
        pow_last_status = pow_stats["last_status"]
        pow_last_job = pow_stats["last_job"]
        pow_last_nonce = pow_stats["last_nonce"]
        pow_last_engine = pow_stats["last_engine"]
    pow_age = now_mono - pow_last_at if pow_last_at is not None else None
    print("PoW Candidates    : %s" % format(candidate_count, ","))
    print("PoW Verified      : %s" % format(verified_count, ","))
    print("PoW Verify Fail   : %s" % format(verification_failed_count, ","))
    print("Last PoW Hit      : %s" % ("never" if pow_age is None else "%.1fs ago" % pow_age))
    print("Last PoW State    : %s" % pow_last_status)
    if pow_last_job:
        print("PoW Job / Nonce   : %s / %s (%s)" % (pow_last_job, pow_last_nonce, pow_last_engine))
    print("")
    print(Fore.CYAN + "=== 5. HEADER MANAGEMENT ===" + Style.RESET_ALL)
    header_status = mining_header_status
    print("Header Source     : %s" % header_status["mode"])
    print("Header Job        : %s" % (header_status["job_id"] or "waiting"))
    print("Header Fields     : Prev Hash + Merkle Root(extranonce2) + ntime + nBits + nonce")
    print("Variable Now      : Nonce (changes on every hash)")
    print("Header Rotate     : every %.0fs (extranonce2 + ntime)" % HEADER_ROTATE_INTERVAL if header_status["mode"] != "waiting for job" else "Header Rotate     : waiting for job")
    print("Active Extra2     : %s" % (header_status["extranonce2"] or "waiting"))
    print("Active ntime      : %s" % (header_status["ntime"] or "waiting"))
    print("")
    print(Fore.CYAN + "=== 6. DIAGNOSTICS ===" + Style.RESET_ALL)
    snapshot = structured_logger.dashboard_snapshot()
    print("Bugs (total %s):" % format(snapshot["error_count"], ","))
    if snapshot["errors"]:
        for index, message in enumerate(snapshot["errors"], 1):
            print("  %d. %s" % (index, message))
    else:
        print("  None")
    print("Warnings (total %s):" % format(snapshot["warning_count"], ","))
    if snapshot["warnings"]:
        for index, message in enumerate(snapshot["warnings"], 1):
            print("  %d. %s" % (index, message))
    else:
        print("  None")
    print("Debug Log         : miner-debug.log")
    print("Event Log         : %s" % structured_logger.event_path)
    structured_logger.log_mining_status(
        total_hashes=ctx.total_hashes,
        shares_submitted=ctx.shares_submitted,
        shares_accepted=ctx.shares_accepted,
        shares_rejected=ctx.shares_rejected,
        upstream_alive=ctx.upstream_alive,
    )
    print("================================================")


def handler(signal_received, frame):
    ctx.fShutdown = True
    print(Fore.MAGENTA, "[", timer(), "]", Fore.YELLOW,
          "Stopping CPU solo miner...")


def parse_messages(buffer):
    messages = []
    while b"\n" in buffer:
        line, buffer = buffer.split(b"\n", 1)
        line = line.strip()
        if not line:
            continue
        try:
            message = json.loads(line.decode("utf-8"))
            if not isinstance(message, dict):
                raise ValueError("Stratum message must be a JSON object")
            messages.append(message)
        except (UnicodeDecodeError, json.JSONDecodeError, ValueError, TypeError):
            logg("[!] Invalid Stratum JSON/object: %r" % line)
    return messages, buffer


def send_json(sock, payload):
    sock.sendall(
        (json.dumps(payload, separators=(",", ":")) + "\n").encode()
    )


def double_sha256(data):
    return hashlib.sha256(hashlib.sha256(data).digest()).digest()


def compute_merkle_root(tx_hashes):
    """Compute a Bitcoin Merkle root from display-order transaction IDs.

    tx_hashes are conventional 64-hex-character txids as displayed by Bitcoin
    explorers. Internally Bitcoin hashes are byte-reversed before pairwise
    double-SHA256 hashing; the final root is returned in display order.
    """
    if not tx_hashes:
        raise ValueError("Merkle tree requires at least one transaction hash")

    level = []
    for txid in tx_hashes:
        if not isinstance(txid, str) or len(txid) != 64:
            raise ValueError("Invalid transaction hash")
        try:
            level.append(bytes.fromhex(txid)[::-1])
        except ValueError as exc:
            raise ValueError("Invalid transaction hash hex") from exc

    while len(level) > 1:
        if len(level) & 1:
            level.append(level[-1])
        level = [
            double_sha256(level[i] + level[i + 1])
            for i in range(0, len(level), 2)
        ]

    return level[0][::-1].hex()


def ensure_native():
    global _native
    if not NATIVE_ENABLED or _native is not None:
        return _native

    source_file = NATIVE_DIR / "sha256_engine.c"
    build_stamp = NATIVE_LIB.with_suffix(NATIVE_LIB.suffix + ".build-config")

    # Tune the native engine for this device by default; set BTC_MINER_CPU_TUNE=generic
    # to build a more portable ARMv8+crypto binary for cross-device use.
    requested_cc = os.getenv("BTC_MINER_CC", "auto").strip()
    if requested_cc.lower() == "auto":
        compiler = shutil.which("gcc") or shutil.which("clang") or shutil.which("cc")
    else:
        compiler = shutil.which(requested_cc)
    if not compiler:
        message = f"[!] C compiler {requested_cc!r} unavailable; native C engine required; Python PoW hashing is disabled"
        print(Fore.YELLOW, message)
        logg(message)
        return None

    cpu_tune = os.getenv("BTC_MINER_CPU_TUNE", "native").strip().lower()
    if cpu_tune not in ("generic", "native"):
        message = "[!] BTC_MINER_CPU_TUNE must be 'generic' or 'native'; using generic"
        print(Fore.YELLOW, message)
        logg(message)
        cpu_tune = "generic"

    if os.name == "nt":
        flags = ["-O3", "-march=native", "-mtune=native", "-flto",
                 "-funroll-loops", "-fomit-frame-pointer", "-DNDEBUG",
                 "-shared"]
    else:
        machine = platform.machine().lower()
        if cpu_tune == "native":
            # Use the local phone CPU features; generic mode remains available by environment override.
            cpu_flags = ["-mcpu=native"]
        else:
            march = "armv8-a+crypto" if machine in ("aarch64", "arm64") else "native"
            cpu_flags = [f"-march={march}", "-mtune=native"]
        flags = ["-O3", *cpu_flags, "-flto", "-funroll-loops",
                 "-fomit-frame-pointer", "-DNDEBUG", "-fPIC", "-shared"]

    machine = platform.machine().lower()
    asm_file = NATIVE_DIR / "sha256_arm64.S"
    # Keep compiler-generated ARMv8 SHA2 intrinsics as the default.
    # The hand-written assembly remains opt-in via BTC_MINER_ARM64_ASM=1.
    asm_setting = os.getenv("BTC_MINER_ARM64_ASM", "0").strip().lower()
    use_arm_asm = (
        os.name != "nt"
        and machine in ("aarch64", "arm64")
        and asm_file.exists()
        and asm_setting in ("1", "true", "yes", "on")
    )
    source_files = [source_file]
    if use_arm_asm:
        source_files.append(asm_file)
        flags = [*flags, "-DBTC_MINER_ARM64_ASM"]

    # Pair the staged eight-nonce pipeline with the selected ARM SHA2 compressor.
    # CPU thread count remains controlled independently by CPU_THREADS.
    # The existing native correctness self-tests run before the engine is used.
    octo_setting = os.getenv("BTC_MINER_ARM64_OCTO", "1").strip().lower()
    quad_setting = os.getenv("BTC_MINER_ARM64_QUAD", "0").strip().lower()
    arm64_crypto_build = (
        os.name != "nt"
        and machine in ("aarch64", "arm64")
    )
    if arm64_crypto_build and octo_setting in ("1", "true", "yes", "on"):
        flags = [*flags, "-DBTC_MINER_ARM64_OCTO"]
    elif arm64_crypto_build and quad_setting in ("1", "true", "yes", "on"):
        flags = [*flags, "-DBTC_MINER_ARM64_QUAD"]

    cmd = [compiler, *flags, "-o", str(NATIVE_LIB), *(str(path) for path in source_files)]
    build_signature = "\n".join([
        str(pathlib.Path(compiler).resolve()),
        *flags,
        *(str(path.resolve()) for path in source_files),
    ])
    try:
        old_signature = build_stamp.read_text().strip() if build_stamp.exists() else ""
    except OSError:
        old_signature = ""

    needs_build = (
        not NATIVE_LIB.exists()
        or not build_stamp.exists()
        or old_signature != build_signature
        or any(path.stat().st_mtime > NATIVE_LIB.stat().st_mtime for path in source_files)
    )
    if needs_build:
        NATIVE_DIR.mkdir(exist_ok=True)
        try:
            subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            build_stamp.write_text(build_signature + "\n")
            print(Fore.GREEN, f"[*] Native SHA256 engine built with {pathlib.Path(compiler).name}: {' '.join(flags)}")
        except (OSError, subprocess.CalledProcessError) as exc:
            detail = exc.stderr.strip() if isinstance(exc, subprocess.CalledProcessError) and exc.stderr else str(exc)
            message = "[!] Native build unavailable; Python PoW hashing is disabled: %s" % detail
            print(Fore.YELLOW, message)
            logg(message)
            return None
    try:
        lib=ctypes.CDLL(str(NATIVE_LIB))
        byte_ptr = ctypes.POINTER(ctypes.c_uint8)
        lib.b_m_mine.argtypes = [
            byte_ptr, byte_ptr, ctypes.c_uint32, ctypes.c_uint32,
            ctypes.c_uint64, ctypes.POINTER(ctypes.c_uint32),
            ctypes.POINTER(ctypes.c_uint64)
        ]
        lib.b_m_mine.restype = ctypes.c_int
        lib.b_m_mine_parallel.argtypes = [
            byte_ptr, byte_ptr, ctypes.c_uint32, ctypes.c_uint32,
            ctypes.c_uint64, ctypes.POINTER(ctypes.c_uint32),
            ctypes.POINTER(ctypes.c_uint64)
        ]
        lib.b_m_mine_parallel.restype = ctypes.c_int
        lib.b_m_selftest.argtypes = []
        lib.b_m_selftest.restype = ctypes.c_int
        lib.b_m_engine_selftest.argtypes = []
        lib.b_m_engine_selftest.restype = ctypes.c_int

        lib.b_m_engine_exhausted.argtypes = [ctypes.c_void_p]
        lib.b_m_engine_exhausted.restype = ctypes.c_int
        lib.b_m_engine_sample_nonce.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
        lib.b_m_engine_sample_nonce.restype = ctypes.c_int
        # All proof-of-work SHA256d digests are computed in native C.
        lib.b_m_debug_sha256d_optimized.argtypes = [
            byte_ptr, ctypes.c_uint32, byte_ptr
        ]
        lib.b_m_debug_sha256d_optimized.restype = None
        lib.b_m_engine_next_nonce.argtypes = [ctypes.c_void_p]
        lib.b_m_engine_next_nonce.restype = ctypes.c_uint64

        lib.b_m_engine_create.argtypes = [ctypes.c_uint32]
        lib.b_m_engine_create.restype = ctypes.c_void_p
        lib.b_m_engine_set_job.argtypes = [
            ctypes.c_void_p, byte_ptr, byte_ptr
        ]
        lib.b_m_engine_set_job.restype = ctypes.c_int
        lib.b_m_engine_poll.argtypes = [
            ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32),
            ctypes.POINTER(ctypes.c_uint64)
        ]
        lib.b_m_engine_poll.restype = ctypes.c_int
        lib.b_m_engine_stop_job.argtypes = [ctypes.c_void_p]
        lib.b_m_engine_stop_job.restype = None
        lib.b_m_engine_destroy.argtypes = [ctypes.c_void_p]
        lib.b_m_engine_destroy.restype = None

        # Native self-tests use 0 for PASS and non-zero for FAIL.
        # Do not use "if not ..." here: that incorrectly treats PASS (0) as failure.
        selftest = lib.b_m_selftest()
        if selftest != 0:
            print(Fore.RED, "[!] Native SHA256 self-test FAILED (code=%d); native mining is disabled" % selftest)
            debug_log("Self-test failed", test="native_sha256", return_code=selftest)
            return None
        print(Fore.GREEN, "[*] Native SHA256 self-test: PASS")
        debug_log("Self-test passed", test="native_sha256")

        engine_test = lib.b_m_engine_selftest()
        if engine_test != 0:
            print(Fore.RED, "[!] Native engine integration self-test FAILED (code=%d)" % engine_test)
            debug_log("Self-test failed", test="native_engine_integration", return_code=engine_test)
            return None
        print(Fore.GREEN, "[*] Native engine integration self-test: PASS")
        debug_log("Self-test passed", test="native_engine_integration")
        _native=lib
        return lib
    except OSError as exc:
        message = "[!] Native engine load failed; Python PoW hashing is disabled: %s" % exc
        print(Fore.YELLOW, message)
        logg(message)
        return None


def native_engine_create(header_prefix, target, thread_count=None):
    global _native_engine
    lib = ensure_native()
    if lib is None:
        return None

    prefix = (ctypes.c_uint8 * 76).from_buffer_copy(header_prefix)
    target_bytes = (ctypes.c_uint8 * 32).from_buffer_copy(
        target.to_bytes(32, "little")
    )
    engine_threads = CPU_THREADS if thread_count is None else max(1, int(thread_count))
    engine = lib.b_m_engine_create(ctypes.c_uint32(engine_threads))
    if not engine:
        raise RuntimeError("Failed to create persistent native mining engine")

    if not lib.b_m_engine_set_job(engine, prefix, target_bytes):
        lib.b_m_engine_destroy(engine)
        raise RuntimeError("Failed to set native mining job")

    _native_engine = engine
    return engine


def native_engine_set_job(engine, header_prefix, target):
    lib = ensure_native()
    if lib is None:
        return False

    prefix = (ctypes.c_uint8 * 76).from_buffer_copy(header_prefix)
    target_bytes = (ctypes.c_uint8 * 32).from_buffer_copy(
        target.to_bytes(32, "little")
    )
    return bool(lib.b_m_engine_set_job(engine, prefix, target_bytes))


def native_engine_poll(engine):
    lib = ensure_native()
    if lib is None:
        return False, 0, 0

    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)
    hit = lib.b_m_engine_poll(
        engine, ctypes.byref(found), ctypes.byref(hashes)
    )
    return bool(hit), found.value, hashes.value


def native_engine_sample_nonce(engine):
    lib = ensure_native()
    if lib is None or not engine:
        return None
    nonce = ctypes.c_uint32(0)
    if not lib.b_m_engine_sample_nonce(engine, ctypes.byref(nonce)):
        return None
    return nonce.value


def native_engine_exhausted(engine):
    lib = ensure_native()
    return bool(lib and engine and lib.b_m_engine_exhausted(engine))


def native_engine_next_nonce(engine):
    """Return the upper boundary of nonce chunks allocated to native workers."""
    lib = ensure_native()
    return int(lib.b_m_engine_next_nonce(engine)) if lib is not None and engine else 0


def native_engine_stop_job(engine):
    lib = ensure_native()
    if lib is not None and engine:
        lib.b_m_engine_stop_job(engine)


def native_sha256d(header_prefix, nonce):
    """Return a proof-of-work digest computed by native C, never Python."""
    if len(header_prefix) != 76:
        raise ValueError("Invalid header prefix length")
    if not 0 <= nonce <= 0xFFFFFFFF:
        raise ValueError("Invalid nonce")
    lib = ensure_native()
    if lib is None:
        raise RuntimeError("Native C SHA256 engine unavailable; Python hashing is disabled")
    prefix = (ctypes.c_uint8 * 76).from_buffer_copy(header_prefix)
    digest = (ctypes.c_uint8 * 32)()
    lib.b_m_debug_sha256d_optimized(prefix, ctypes.c_uint32(nonce), digest)
    return bytes(digest)


def verify_header_pow(header_prefix, nonce, target):
    """Verify a native-computed digest before submission; never hash in Python."""
    return int.from_bytes(native_sha256d(header_prefix, nonce), "little") <= target


def native_engine_destroy(engine=None):
    global _native_engine
    engine = engine or _native_engine
    if engine and _native is not None:
        try:
            _native.b_m_engine_stop_job(engine)
            _native.b_m_engine_destroy(engine)
        finally:
            if engine == _native_engine:
                _native_engine = None


def native_mine_parallel(header_prefix, target, start):
    lib = ensure_native()
    if lib is None:
        return None
    prefix = (ctypes.c_uint8 * 76).from_buffer_copy(header_prefix)
    target_bytes = (ctypes.c_uint8 * 32).from_buffer_copy(
        target.to_bytes(32, "little")
    )
    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)
    hit = lib.b_m_mine_parallel(
        prefix,
        target_bytes,
        ctypes.c_uint32(start),
        ctypes.c_uint32(CPU_THREADS),
        ctypes.c_uint64(NONCE_BATCH),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )
    return bool(hit), found.value, hashes.value


def native_mine(header_prefix, target, start, step):
    return native_mine_parallel(header_prefix, target, start)


def compact_to_target(nbits):
    """Decode Bitcoin compact nBits into a non-negative 256-bit target.

    This is intentionally strict: malformed/overflow targets must never reach
    the native miner. Negative compact values are invalid for proof-of-work.
    """
    if not isinstance(nbits, str) or len(nbits) != 8:
        raise ValueError("Invalid nbits encoding")
    try:
        value = int(nbits, 16)
    except ValueError as exc:
        raise ValueError("Invalid nbits hex") from exc

    exponent = value >> 24
    mantissa = value & 0x007FFFFF
    if value & 0x00800000:
        raise ValueError("Negative compact target")

    if mantissa == 0:
        raise ValueError("Zero compact target")

    if exponent <= 3:
        target = mantissa >> (8 * (3 - exponent))
    else:
        target = mantissa << (8 * (exponent - 3))

    if target <= 0 or target >= (1 << 256):
        raise ValueError("Compact target outside 256-bit range")

    # Bitcoin's compact representation is canonical only when the top byte
    # does not make the mantissa sign bit ambiguous. Reject non-canonical
    # encodings that would otherwise decode to the same target.
    if exponent > 3:
        shifted = target >> (8 * (exponent - 3))
        if shifted != mantissa:
            raise ValueError("Non-canonical compact target")

    return target


def stratum_prevhash_to_header(prevhash):
    """Convert Stratum V1's 8 little-endian uint32 words to header bytes."""
    raw = bytes.fromhex(prevhash)
    if len(raw) != 32:
        raise ValueError("Invalid prevhash length")
    return b"".join(raw[i:i + 4][::-1] for i in range(0, 32, 4))


def build_header_prefix(job, extranonce2, ntime=None, version=None):
    """Build a header prefix, optionally rolling Stratum-authorized header fields."""
    extranonce1 = job.get("extranonce1")
    extranonce2_size = job.get("extranonce2_size")
    if not isinstance(extranonce1, str):
        raise ValueError("Job snapshot is missing extranonce1")
    _validate_hex_blob(extranonce1, "job extranonce1")
    _validate_hex_blob(extranonce2, "extranonce2")
    if isinstance(extranonce2_size, bool) or not isinstance(extranonce2_size, int):
        raise ValueError("Job snapshot is missing extranonce2_size")
    if len(extranonce2) != extranonce2_size * 2:
        raise ValueError("extranonce2 length does not match subscribed Stratum size")

    coinbase = bytes.fromhex(
        job["coinb1"] + extranonce1 + extranonce2 + job["coinb2"]
    )

    coinbase_hash = double_sha256(coinbase)
    merkle_root = coinbase_hash

    for branch in job["merkle_branch"]:
        merkle_root = double_sha256(
            merkle_root + bytes.fromhex(branch)
        )

    header = (
        bytes.fromhex(version if version is not None else job["version"])[::-1]
        + stratum_prevhash_to_header(job["prevhash"])
        + merkle_root
        + bytes.fromhex(ntime if ntime is not None else job["ntime"])[::-1]
        + bytes.fromhex(job["nbits"])[::-1]
    )

    if len(header) != 76:
        raise ValueError("Invalid block header prefix length")

    return header


def cpu_worker(*args, **kwargs):
    """Disabled legacy entry point: proof-of-work scanning must run in C."""
    raise RuntimeError("Python PoW worker is disabled; use the persistent native C engine")


def stop_workers(workers, stop_event):
    """Stop legacy worker handles; no Python PoW workers may be started."""
    if stop_event is not None:
        stop_event.set()
    for process in workers or ():
        process.join(timeout=1)
        if process.is_alive():
            process.terminate()
            process.join(timeout=1)


def start_workers(job):
    """Disabled legacy entry point: never start a Python nonce scanner."""
    raise RuntimeError("Python mining is disabled; use miner_loop() with the native C engine")


def submit_payload(job_id, extranonce2, ntime, nonce, submit_id):
    return {
        "id": submit_id,
        "method": "mining.submit",
        "params": [
            ADDRESS,
            job_id,
            extranonce2,
            ntime,
            "%08x" % nonce,
        ],
    }


def submit_selftest():
    job_id = "selftest-job"
    extranonce2 = "01020304"
    ntime = "65abcdef"
    nonce = 0x12345678
    submit_id = 4242

    payload = submit_payload(
        job_id, extranonce2, ntime, nonce, submit_id
    )

    if payload["method"] != "mining.submit":
        return False
    if payload["id"] != submit_id:
        return False
    if payload["params"] != [
        ADDRESS,
        job_id,
        extranonce2,
        ntime,
        "12345678",
    ]:
        return False

    encoded = (json.dumps(payload, separators=(",", ":")) + "\n").encode()
    decoded = json.loads(encoded.decode("utf-8").strip())
    return decoded == payload


def submit_share(job_id, extranonce2, ntime, nonce, expected_generation=None):
    """Submit a verified candidate only while its exact Stratum job is current."""
    if not isinstance(job_id, str) or not job_id:
        raise ValueError("Invalid job id for mining.submit")
    _validate_hex_blob(extranonce2, "submit extranonce2")
    _validate_hex(ntime, 8, "submit ntime")
    if isinstance(nonce, bool) or not isinstance(nonce, int) or not 0 <= nonce <= 0xFFFFFFFF:
        raise ValueError("Invalid nonce for mining.submit")

    # Keep job generation stable from the final freshness check through socket
    # write. Otherwise mining.notify/set_extranonce can race between the check
    # and send, causing a valid candidate to be submitted against stale metadata.
    with ctx.job_lock:
        if expected_generation is None or ctx.job_generation != expected_generation:
            debug_log(
                "Candidate not submitted because job changed or generation is missing",
                job_id=job_id, expected_generation=expected_generation,
                current_generation=ctx.job_generation, nonce="%08x" % nonce,
            )
            logg("[!] Candidate not submitted: job changed or generation missing")
            return None
        if not ctx.upstream_alive or ctx.upstream_sock is None:
            raise ConnectionError("Cannot submit candidate: Stratum connection is not active")

        # Final end-to-end gate: reconstruct the current job's exact header
        # and independently verify proof of work immediately before socket send.
        if ctx.job_id != job_id:
            raise ValueError("Candidate job does not match the active Stratum job")
        candidate_time = int(ntime, 16)
        base_time = int(ctx.ntime, 16)
        if candidate_time < base_time or candidate_time > min(0xFFFFFFFF, int(time.time()) + 7200):
            raise ValueError("Candidate timestamp is outside the permitted rolling window")
        verification_job = {
            "job_id": ctx.job_id,
            "prevhash": ctx.prevhash,
            "coinb1": ctx.coinb1,
            "coinb2": ctx.coinb2,
            "merkle_branch": list(ctx.merkle_branch or []),
            "version": ctx.version,
            "nbits": ctx.nbits,
            "ntime": ntime,
            "clean_jobs": ctx.clean_jobs,
            "extranonce1": ctx.upstream_extranonce1,
            "extranonce2_size": ctx.upstream_extranonce2_size,
            "generation": ctx.job_generation,
        }
        verification_prefix = build_header_prefix(verification_job, extranonce2)
        verification_target = compact_to_target(verification_job["nbits"])
        if not verify_header_pow(verification_prefix, nonce, verification_target):
            structured_logger.event(
                "pow_candidate_rejected_local_verification",
                job_id=job_id, nonce="%08x" % nonce,
                job_generation=ctx.job_generation,
            )
            raise ValueError("Candidate failed final independent SHA256d/target verification")

        with ctx.pending_submits_lock:
            submit_id = ctx.next_submit_id
            ctx.next_submit_id += 1
            ctx.pending_submits[submit_id] = time.monotonic()

        payload = submit_payload(job_id, extranonce2, ntime, nonce, submit_id)
        debug_log("Share submission attempt", submit_id=submit_id, job_id=job_id,
                  nonce="%08x" % nonce, extranonce2=extranonce2, ntime=ntime,
                  wallet=ADDRESS, payload_method=payload["method"],
                  job_generation=expected_generation)

        try:
            with ctx.upstream_send_lock:
                send_json(ctx.upstream_sock, payload)
        except Exception:
            with ctx.pending_submits_lock:
                ctx.pending_submits.pop(submit_id, None)
            raise

    ctx.shares_submitted += 1
    metrics.share_submitted()
    submitted_at = time.monotonic()
    with share_stats_lock:
        share_stats["last_submit_at"] = submitted_at
        if share_stats["first_submit_at"] is None:
            share_stats["first_submit_at"] = submitted_at
        share_stats["submit_times"].append(submitted_at)
    logg("[*] Share submitted: id=%s job=%s nonce=%08x" %
         (submit_id, job_id, nonce))
    structured_logger.event(
        "share_submitted", submit_id=submit_id, job_id=job_id,
        nonce="%08x" % nonce, extranonce2=extranonce2, ntime=ntime,
        wallet=ADDRESS, job_generation=expected_generation,
    )
    return submit_id


def upstream_listener(sock):
    buffer = b""

    try:
        while not ctx.fShutdown and ctx.upstream_alive:
            try:
                chunk = sock.recv(8192)
            except socket.timeout:
                expire_pending_submits()
                continue

            if not chunk:
                raise ConnectionError("Upstream connection closed")

            buffer += chunk
            messages, buffer = parse_messages(buffer)

            for msg in messages:
                try:
                    method = msg.get("method")

                    if method == "mining.notify":
                        try:
                            update_job(msg.get("params", []))
                        except (TypeError, ValueError, KeyError) as exc:
                            logg("[!] Invalid mining.notify ignored: %s" % exc)
                            print(Fore.RED, "[!] Invalid mining job ignored:", exc)
                            continue
                        print(Fore.YELLOW, "[*] New mining job:", ctx.job_id)

                    elif method == "mining.set_difficulty":
                        params = msg.get("params", [])
                        if params:
                            ctx.upstream_difficulty = params[0]
                        print(Fore.CYAN, "[*] Pool difficulty:",
                              ctx.upstream_difficulty)
                        debug_log("Pool difficulty updated", difficulty=ctx.upstream_difficulty)

                    elif method == "mining.set_extranonce":
                        params = msg.get("params", [])
                        try:
                            if len(params) < 2:
                                raise ValueError("missing extranonce parameters")
                            _validate_hex_blob(params[0], "extranonce1")
                            size = int(params[1])
                            if not 1 <= size <= 32:
                                raise ValueError("invalid extranonce2_size")
                        except (TypeError, ValueError) as exc:
                            logg("[!] Invalid mining.set_extranonce ignored: %s" % exc)
                            print(Fore.RED, "[!] Invalid extranonce update ignored:", exc)
                            continue
                        with ctx.job_lock:
                            # A new extranonce changes the coinbase and Merkle root.
                            # Invalidate the old job until a matching notify arrives.
                            ctx.job_id = None
                            ctx.prevhash = None
                            ctx.coinb1 = None
                            ctx.coinb2 = None
                            ctx.merkle_branch = None
                            ctx.version = None
                            ctx.nbits = None
                            ctx.ntime = None
                            ctx.clean_jobs = False
                            ctx.upstream_extranonce1 = params[0]
                            ctx.upstream_extranonce2_size = size
                            ctx.job_generation += 1
                        print(Fore.CYAN, "[*] Pool extranonce updated; waiting for a fresh job")
                        debug_log(
                            "Pool extranonce updated",
                            extranonce1_length=len(params[0]),
                            extranonce2_size=size,
                        )

                    elif "id" in msg:
                        msg_id = msg.get("id")
                        with ctx.pending_submits_lock:
                            submitted_at = ctx.pending_submits.pop(msg_id, None)

                        if submitted_at is not None:
                            accepted = (
                                msg.get("result") is True
                                and msg.get("error") is None
                            )
                            if accepted:
                                ctx.shares_accepted += 1
                                metrics.share_result(True)
                            else:
                                ctx.shares_rejected += 1
                                metrics.share_result(False)

                            elapsed = time.monotonic() - submitted_at
                            with share_stats_lock:
                                share_stats["last_result"] = "ACCEPTED" if accepted else "REJECTED"
                                share_stats["last_result_at"] = time.monotonic()
                                error_value = msg.get("error")
                                share_stats["last_error"] = "" if accepted else str(error_value or "Pool rejected share")
                                share_stats["latency_total"] += elapsed
                                share_stats["latency_count"] += 1
                                share_stats["latency_max"] = max(share_stats["latency_max"], elapsed)
                            if accepted:
                                print(
                                    Style.BRIGHT + Fore.WHITE + Back.GREEN,
                                    "[+] SHARE ACCEPTED | id=%s | latency=%.3fs"
                                    % (msg_id, elapsed),
                                    Style.RESET_ALL,
                                )
                            else:
                                print(
                                    Style.BRIGHT + Fore.WHITE + Back.RED,
                                    "[-] SHARE REJECTED | id=%s | latency=%.3fs | error=%s"
                                    % (msg_id, elapsed, msg.get("error") or ""),
                                    Style.RESET_ALL,
                                )
                            structured_logger.event(
                                "share_accepted" if accepted else "share_rejected",
                                submit_id=msg_id, latency_seconds=round(elapsed, 6),
                                error=msg.get("error"), result=msg.get("result")
                            )
                            if accepted:
                                print(
                                    Fore.YELLOW,
                                    "[*] Pool accepted the candidate submission; payout still requires the block to be accepted by the Bitcoin network."
                                )
                            logg(
                                "[*] Share %s: id=%s latency=%.3fs error=%s"
                                % (
                                    "ACCEPTED" if accepted else "REJECTED",
                                    msg_id,
                                    elapsed,
                                    msg.get("error") or "",
                                )
                            )
                        else:
                            logg("[*] Upstream response: %s" % msg)
                            debug_log("Unmatched upstream response", response=msg)

                except Exception as exc:
                    logg("[!] Upstream message handler error: %s" % exc)
                    print(Fore.RED, "[!] Upstream message ignored:", exc)

            expire_pending_submits()

    except (ConnectionError, OSError) as exc:
        if not ctx.fShutdown:
            print(Fore.RED, "[!] Upstream listener stopped:", exc)
            logg("[!] Upstream listener stopped: %s" % exc)
            debug_log("Upstream listener exception", error=repr(exc))
    finally:
        # A reconnect can leave an older daemon listener briefly alive while
        # the next connection is already active. Only the listener that still
        # owns the current socket may mutate global connection state or drain
        # the current submission map.
        if ctx.upstream_sock is sock:
            ctx.upstream_alive = False
            expire_pending_submits(force=True)

def expire_pending_submits(force=False):
    """Retire unanswered submissions without misclassifying them as rejects."""
    now = time.monotonic()
    expired = []

    with ctx.pending_submits_lock:
        for submit_id, submitted_at in list(ctx.pending_submits.items()):
            if force or now - submitted_at > SUBMIT_TIMEOUT:
                expired.append((submit_id, submitted_at))
                del ctx.pending_submits[submit_id]

    for submit_id, submitted_at in expired:
        age = max(0.0, now - submitted_at)
        logg("[?] Share response unknown: id=%s after %.1fs" % (submit_id, age))
        structured_logger.event(
            "share_response_unknown", submit_id=submit_id,
            age_seconds=round(age, 6),
            reason="response_timeout" if not force else "connection_closed_before_response",
        )
        debug_log(
            "Share response unknown", submit_id=submit_id,
            age_seconds=round(age, 6), forced=force,
        )


def _validate_hex(value, length, field):
    if not isinstance(value, str) or len(value) != length:
        raise ValueError("Invalid %s length" % field)
    try:
        bytes.fromhex(value)
    except ValueError as exc:
        raise ValueError("Invalid %s hex" % field) from exc


def _validate_hex_blob(value, field):
    if not isinstance(value, str) or len(value) % 2:
        raise ValueError("Invalid %s hex" % field)
    try:
        bytes.fromhex(value)
    except ValueError as exc:
        raise ValueError("Invalid %s hex" % field) from exc


def validate_notify_params(params):
    """Validate a Stratum mining.notify before mutating shared job state."""
    if not isinstance(params, (list, tuple)) or len(params) != 9:
        raise ValueError("Unexpected mining.notify parameter count")

    (
        job_id, prevhash, coinb1, coinb2, merkle_branch,
        version, nbits, ntime, clean_jobs
    ) = params

    if not isinstance(job_id, str) or not job_id or len(job_id) > 256:
        raise ValueError("Invalid job_id")
    _validate_hex(prevhash, 64, "prevhash")
    _validate_hex_blob(coinb1, "coinb1")
    _validate_hex_blob(coinb2, "coinb2")
    if not isinstance(merkle_branch, list) or len(merkle_branch) > 256:
        raise ValueError("Invalid merkle_branch")
    for branch in merkle_branch:
        _validate_hex(branch, 64, "merkle branch")
    _validate_hex(version, 8, "version")
    _validate_hex(nbits, 8, "nbits")
    _validate_hex(ntime, 8, "ntime")
    if not isinstance(clean_jobs, bool):
        raise ValueError("Invalid clean_jobs flag")
    return True


def update_job(params):
    validate_notify_params(params)

    (
        job_id, prevhash, coinb1, coinb2, merkle_branch,
        version, nbits, ntime, clean_jobs
    ) = params

    # Decode and validate consensus target before touching shared job state.
    # Otherwise malformed nBits could partially replace a valid active job
    # even though this notification is subsequently rejected.
    try:
        decoded_target = compact_to_target(nbits)
    except (TypeError, ValueError) as exc:
        debug_log("Target decode failed", job_id=job_id, nbits=nbits, error=repr(exc))
        raise

    with ctx.job_lock:
        previous_job_id = ctx.job_id
        ctx.job_id = job_id
        ctx.prevhash = prevhash
        ctx.coinb1 = coinb1
        ctx.coinb2 = coinb2
        ctx.merkle_branch = list(merkle_branch)
        ctx.version = version
        ctx.nbits = nbits
        ctx.ntime = ntime
        ctx.clean_jobs = clean_jobs
        ctx.job_generation += 1
        generation = ctx.job_generation
    debug_log("Job lifecycle update", previous_job_id=previous_job_id,
              job_id=job_id, generation=generation, nbits=nbits,
              ntime=ntime, clean_jobs=clean_jobs, merkle_branches=len(merkle_branch))
    debug_log("Target decoded", job_id=job_id, nbits=nbits,
              target_hex="%064x" % decoded_target, target_bits=decoded_target.bit_length())


def current_job():
    with ctx.job_lock:
        if not ctx.job_id:
            return None
        return {
            "job_id": ctx.job_id,
            "prevhash": ctx.prevhash,
            "coinb1": ctx.coinb1,
            "coinb2": ctx.coinb2,
            "merkle_branch": list(ctx.merkle_branch),
            "version": ctx.version,
            "nbits": ctx.nbits,
            "ntime": ctx.ntime,
            "clean_jobs": ctx.clean_jobs,
            "extranonce1": ctx.upstream_extranonce1,
            "extranonce2_size": ctx.upstream_extranonce2_size,
            "generation": ctx.job_generation,
        }


def connect_upstream():
    debug_log("Connection attempt", host=UPSTREAM_HOST, port=UPSTREAM_PORT,
              wallet=ADDRESS, reconnect_delay=RECONNECT_DELAY)
    sock = socket.create_connection((UPSTREAM_HOST, UPSTREAM_PORT), timeout=20)
    # Pools may accept TCP promptly but take longer to answer the Stratum
    # handshake. Keep recv timeouts short enough for periodic wakeups, while
    # giving subscribe + authorize a bounded 60-second overall deadline.
    sock.settimeout(10)
    ctx.upstream_sock = sock

    print(Fore.GREEN, "[*] Connected to %s:%s" %
          (UPSTREAM_HOST, UPSTREAM_PORT))
    debug_log("Connection established", host=UPSTREAM_HOST, port=UPSTREAM_PORT,
              socket_timeout=10, handshake_timeout=60)
    logg("[*] Connected to upstream %s:%s" % (UPSTREAM_HOST, UPSTREAM_PORT))

    send_json(sock, {
        "id": 1,
        "method": "mining.subscribe",
        "params": ["b_m-cpu/1.1"],
    })

    buffer = b""
    subscribed = False
    authorized = False
    handshake_started = time.monotonic()
    deadline = handshake_started + 60

    while time.monotonic() < deadline and not authorized:
        try:
            chunk = sock.recv(8192)
        except socket.timeout:
            continue

        if not chunk:
            raise ConnectionError("Upstream closed connection")

        buffer += chunk
        messages, buffer = parse_messages(buffer)

        for msg in messages:
            if msg.get("id") == 1:
                result = msg.get("result")
                if not isinstance(result, list) or len(result) != 3:
                    raise RuntimeError("Invalid mining.subscribe response")

                sub_details, extranonce1, extranonce2_size = result
                if not isinstance(sub_details, list):
                    raise RuntimeError("Invalid mining.subscribe subscription details")
                _validate_hex_blob(extranonce1, "subscribe extranonce1")
                if isinstance(extranonce2_size, bool):
                    raise RuntimeError("Invalid mining.subscribe extranonce2_size")
                try:
                    extranonce2_size = int(extranonce2_size)
                except (TypeError, ValueError) as exc:
                    raise RuntimeError("Invalid mining.subscribe extranonce2_size") from exc
                if not 1 <= extranonce2_size <= 32:
                    raise RuntimeError("Invalid mining.subscribe extranonce2_size")
                with ctx.job_lock:
                    ctx.sub_details = sub_details
                    ctx.upstream_extranonce1 = extranonce1
                    ctx.upstream_extranonce2_size = extranonce2_size
                    ctx.job_generation += 1
                subscribed = True
                print(Fore.GREEN, "[*] Stratum subscribe successful")
                logg("[*] Stratum subscribe successful: extranonce2_size=%s" % ctx.upstream_extranonce2_size)

                send_json(sock, {
                    "id": 2,
                    "method": "mining.authorize",
                    "params": [ADDRESS, WORKER_PASSWORD],
                })

            elif msg.get("id") == 2:
                if msg.get("error") is not None or msg.get("result") is not True:
                    raise RuntimeError(
                        "Upstream authorization failed: %s" % msg
                    )
                authorized = True
                print(Fore.GREEN, "[*] Upstream authorization successful")
                logg("[*] Upstream authorization successful")

            elif msg.get("method") == "mining.notify":
                update_job(msg.get("params", []))

            elif msg.get("method") == "mining.set_difficulty":
                params = msg.get("params", [])
                if params:
                    ctx.upstream_difficulty = params[0]

            elif msg.get("method") == "mining.set_extranonce":
                params = msg.get("params", [])
                if len(params) < 2:
                    raise RuntimeError("Invalid mining.set_extranonce during handshake")
                _validate_hex_blob(params[0], "handshake extranonce1")
                if isinstance(params[1], bool):
                    raise RuntimeError("Invalid handshake extranonce2_size")
                try:
                    size = int(params[1])
                except (TypeError, ValueError) as exc:
                    raise RuntimeError("Invalid handshake extranonce2_size") from exc
                if not 1 <= size <= 32:
                    raise RuntimeError("Invalid handshake extranonce2_size")
                with ctx.job_lock:
                    ctx.job_id = None
                    ctx.prevhash = None
                    ctx.coinb1 = None
                    ctx.coinb2 = None
                    ctx.merkle_branch = None
                    ctx.version = None
                    ctx.nbits = None
                    ctx.ntime = None
                    ctx.clean_jobs = False
                    ctx.upstream_extranonce1 = params[0]
                    ctx.upstream_extranonce2_size = size
                    ctx.job_generation += 1

    handshake_elapsed = round(time.monotonic() - handshake_started, 3)
    if not subscribed:
        debug_log("Stratum handshake timeout", phase="subscribe",
                  elapsed_seconds=handshake_elapsed, timeout_seconds=60,
                  host=UPSTREAM_HOST, port=UPSTREAM_PORT)
        raise TimeoutError("Upstream subscribe timed out after 60 seconds")
    if not authorized:
        debug_log("Stratum handshake timeout", phase="authorize",
                  elapsed_seconds=handshake_elapsed, timeout_seconds=60,
                  host=UPSTREAM_HOST, port=UPSTREAM_PORT)
        raise TimeoutError("Upstream authorization timed out after 60 seconds")

    ctx.connected = True
    ctx.upstream_alive = True
    return sock


def miner_loop():
    # Native C is mandatory. Never fall back to Python nonce scanning.
    native_lib = ensure_native()
    if native_lib is None:
        raise RuntimeError(
            "Native C engine unavailable or disabled; Python mining fallback is disabled"
        )
    if native_lib is not None:
        last_report = time.monotonic()
        hashes_since_report = 0

        # Keep the total native thread count bounded by CPU_THREADS while
        # scanning several independent, Stratum-valid header universes.
        try:
            requested_universes = int(os.getenv("BTC_HEADER_UNIVERSES", "4"))
        except (TypeError, ValueError):
            requested_universes = 4
        universe_count = max(1, min(CPU_THREADS, requested_universes, 8))
        base_threads, extra_threads = divmod(CPU_THREADS, universe_count)
        universes = []
        for index in range(universe_count):
            assigned_threads = base_threads + (1 if index < extra_threads else 0)
            universes.append({
                "engine": native_engine_create(b"\x00" * 76, 0, assigned_threads),
                "snapshot": None,
                "last_rotation": time.monotonic(),
            })

        try:
            current_generation = None
            waiting_for_new_job = False
            header_rotate_interval = HEADER_ROTATE_INTERVAL

            def make_universe_snapshot(job_data, universe_index, used_extranonces):
                size = int(job_data["extranonce2_size"])
                while True:
                    candidate_extranonce2 = secrets.token_bytes(size).hex()
                    if candidate_extranonce2 not in used_extranonces:
                        used_extranonces.add(candidate_extranonce2)
                        break

                base_ntime = job_data.get("base_ntime", job_data["ntime"])
                base_time = int(base_ntime, 16)
                now_limit = min(0xFFFFFFFF, int(time.time()))
                if now_limit >= base_time:
                    candidate_time = secrets.randbelow(now_limit - base_time + 1) + base_time
                else:
                    candidate_time = base_time
                candidate_ntime = "%08x" % candidate_time
                prefix = build_header_prefix(
                    job_data, candidate_extranonce2, ntime=candidate_ntime
                )
                return {
                    **dict(job_data),
                    "base_ntime": base_ntime,
                    "extranonce2": candidate_extranonce2,
                    "ntime": candidate_ntime,
                    "header_prefix": prefix,
                    "target": compact_to_target(job_data["nbits"]),
                    "universe_id": universe_index,
                }

            while not ctx.fShutdown and ctx.upstream_alive:
                job = globals()["current_job"]()
                if job is None or not job.get("extranonce1"):
                    time.sleep(0.1)
                    continue

                if job["generation"] != current_generation and not waiting_for_new_job:
                    used_extranonces = set()
                    for index, universe in enumerate(universes):
                        snapshot = make_universe_snapshot(job, index, used_extranonces)
                        if not native_engine_set_job(
                            universe["engine"], snapshot["header_prefix"], snapshot["target"]
                        ):
                            raise RuntimeError(
                                "Failed to set native job for header universe %d" % index
                            )
                        universe["snapshot"] = snapshot
                        universe["last_rotation"] = time.monotonic()

                    current_generation = job["generation"]
                    mining_header_status.update(
                        job_id=job["job_id"],
                        extranonce2=universes[0]["snapshot"]["extranonce2"],
                        ntime=universes[0]["snapshot"]["ntime"],
                        mode="multi-universe + rotational header",
                    )
                    print(
                        Fore.CYAN,
                        "[*] CPU mining job=%s | %d header universes | %d total C threads"
                        % (job["job_id"], universe_count, CPU_THREADS),
                    )
                    logg(
                        "[*] Multi-universe header engine active: job=%s universes=%d threads=%d"
                        % (job["job_id"], universe_count, CPU_THREADS)
                    )
                    debug_log(
                        "Multi-universe headers ready",
                        job_id=job["job_id"],
                        universes=universe_count,
                        threads=CPU_THREADS,
                        nbits=job["nbits"],
                        nonce_space=2**32,
                    )

                new_job = globals()["current_job"]()
                if new_job is None:
                    time.sleep(0.05)
                    continue

                if waiting_for_new_job:
                    if new_job["generation"] != current_generation:
                        waiting_for_new_job = False
                        continue
                    time.sleep(0.05)
                    continue

                found_candidate = None
                for universe in universes:
                    snapshot = universe["snapshot"]
                    hit, found, hashes = native_engine_poll(universe["engine"])
                    sampled_nonce = native_engine_sample_nonce(universe["engine"])
                    if sampled_nonce is not None and snapshot is not None:
                        sampled_digest = native_sha256d(
                            snapshot["header_prefix"], int(sampled_nonce)
                        )
                        record_best_hash(
                            sampled_digest, snapshot["target"], snapshot["job_id"],
                            sampled_nonce, "native-C-universe-%d" % snapshot["universe_id"],
                        )
                    if hashes:
                        hashes_since_report += hashes
                        ctx.total_hashes += hashes
                        metrics.add_hashes(hashes)
                    if hit and snapshot is not None and found_candidate is None:
                        found_candidate = (snapshot, found)

                # A hit always keeps the exact header snapshot that produced it.
                if found_candidate is not None:
                    found_snapshot, found = found_candidate
                    latest = globals()["current_job"]()
                    if latest is None or latest["generation"] != current_generation:
                        logg(
                            "[!] Discarding stale multi-universe hit: job=%s nonce=%08x universe=%s"
                            % (found_snapshot["job_id"], found, found_snapshot["universe_id"])
                        )
                        for universe in universes:
                            native_engine_stop_job(universe["engine"])
                        waiting_for_new_job = True
                        continue

                    print()
                    print(
                        Style.BRIGHT + Fore.WHITE + Back.GREEN,
                        "  POW CANDIDATE DETECTED; VERIFYING | universe=%d | nonce=%08x"
                        % (found_snapshot["universe_id"], found),
                    )
                    print(Style.RESET_ALL)
                    logg(
                        "[!] POW candidate detected: job=%s universe=%d nonce=%08x"
                        % (found_snapshot["job_id"], found_snapshot["universe_id"], found)
                    )
                    record_pow_status("candidate", found_snapshot["job_id"], found, "native-multi-universe")
                    try:
                        if not verify_header_pow(
                            found_snapshot["header_prefix"], found, found_snapshot["target"]
                        ):
                            logg(
                                "[!] Multi-universe candidate failed independent verification; NOT submitting"
                            )
                            record_pow_status(
                                "verification_failed", found_snapshot["job_id"], found,
                                "native-multi-universe",
                            )
                        else:
                            logg(
                                "[+] SHA256d/target verification PASSED: job=%s universe=%d nonce=%08x"
                                % (found_snapshot["job_id"], found_snapshot["universe_id"], found)
                            )
                            record_pow_status(
                                "verified", found_snapshot["job_id"], found, "native-multi-universe"
                            )
                            structured_logger.event(
                                "pow_candidate_verified",
                                engine="native-multi-universe",
                                job_id=found_snapshot["job_id"],
                                universe=found_snapshot["universe_id"],
                                nonce="%08x" % found,
                                wallet=ADDRESS,
                                target_hex="%064x" % found_snapshot["target"],
                            )
                            submit_share(
                                found_snapshot["job_id"],
                                found_snapshot["extranonce2"],
                                found_snapshot["ntime"],
                                found,
                                expected_generation=found_snapshot["generation"],
                            )
                    except Exception as exc:
                        print(Fore.RED, "[!] Share submit failed:", exc)
                        logg("[!] Share submit failed: %s" % exc)

                    for universe in universes:
                        native_engine_stop_job(universe["engine"])
                    current_generation = None
                    waiting_for_new_job = False
                    continue

                # Rotate exhausted or aged universes independently. Other universes
                # continue hashing their own headers while this slot is refreshed.
                used_extranonces = {
                    item["snapshot"]["extranonce2"]
                    for item in universes
                    if item["snapshot"] is not None
                }
                for index, universe in enumerate(universes):
                    exhausted = native_engine_exhausted(universe["engine"])
                    aged = time.monotonic() - universe["last_rotation"] >= header_rotate_interval
                    if not exhausted and not aged:
                        continue

                    previous = universe["snapshot"]
                    if previous is not None:
                        used_extranonces.discard(previous["extranonce2"])
                    snapshot = make_universe_snapshot(job, index, used_extranonces)
                    if not native_engine_set_job(
                        universe["engine"], snapshot["header_prefix"], snapshot["target"]
                    ):
                        raise RuntimeError(
                            "Failed to rotate native header universe %d" % index
                        )
                    universe["snapshot"] = snapshot
                    universe["last_rotation"] = time.monotonic()
                    mining_header_status.update(
                        job_id=snapshot["job_id"],
                        extranonce2=snapshot["extranonce2"],
                        ntime=snapshot["ntime"],
                        mode="multi-universe + rotational header",
                    )
                    debug_log(
                        "Header universe rotated",
                        job_id=snapshot["job_id"],
                        universe=index,
                        reason="nonce_exhausted" if exhausted else "rotation_interval",
                        extranonce2=snapshot["extranonce2"],
                        ntime=snapshot["ntime"],
                        interval_seconds=header_rotate_interval,
                    )

                if new_job["generation"] != current_generation:
                    continue

                now = time.monotonic()
                if now - last_report >= REPORT_INTERVAL:
                    elapsed = max(now - last_report, 0.001)
                    rate = hashes_since_report / elapsed
                    allocated = max(
                        (native_engine_next_nonce(item["engine"]) for item in universes),
                        default=0,
                    )
                    debug_log(
                        "Mining progress",
                        engine="native-multi-universe",
                        job_id=job["job_id"],
                        interval_hashes=hashes_since_report,
                        total_hashes=ctx.total_hashes,
                        elapsed_seconds=round(elapsed, 3),
                        hashrate_hs=round(rate, 3),
                        hashrate_mhs=round(rate / 1_000_000, 6),
                        pool_difficulty=ctx.upstream_difficulty,
                        nonce_allocated_until="%08x" % min(allocated, 0xFFFFFFFF),
                        nonce_space=2**32,
                        universes=universe_count,
                        memory=memory_snapshot(),
                        workers=worker_count_snapshot(CPU_THREADS),
                        elapsed_uptime=metrics.snapshot()["uptime_s"],
                    )
                    render_dashboard(rate, hashes_since_report)
                    hashes_since_report = 0
                    last_report = now

                time.sleep(0.01)

        finally:
            for universe in universes:
                native_engine_destroy(universe["engine"])
        return

    workers = []
    stop_event = None
    last_report = time.monotonic()
    hashes_since_report = 0
    last_header_rotation = time.monotonic()

    while not ctx.fShutdown and ctx.upstream_alive:
        job = globals()["current_job"]()

        if job is None or not job.get("extranonce1"):
            time.sleep(0.2)
            continue

        stop_workers(workers, stop_event) if workers else None
        workers, stop_event, result_queue, extranonce2 = start_workers(job)
        last_header_rotation = time.monotonic()
        mining_header_status.update(
            job_id=job["job_id"], extranonce2=extranonce2,
            ntime=job["ntime"], mode="randomized extranonce2 + ntime",
        )
        debug_log("Python job mining started", job_id=job["job_id"],
                  target_hex="%064x" % compact_to_target(job["nbits"]),
                  target_bits=compact_to_target(job["nbits"]).bit_length(),
                  extranonce2_size=len(extranonce2) // 2, workers=len(workers),
                  nonce_space=2**32)

        print(
            Fore.CYAN,
            "[*] CPU mining job=%s with %d threads (Python engine)" %
            (job["job_id"], CPU_THREADS),
        )

        # A worker sets stop_event before its queued "found" result is handled.
        # Keep draining the queue so a valid hit is not lost when the stop flag flips.
        while not ctx.fShutdown and ctx.upstream_alive:
            new_job = globals()["current_job"]()
            if new_job is None:
                time.sleep(0.2)
                continue

            if new_job["generation"] != job["generation"]:
                stop_workers(workers, stop_event)
                workers = []
                break

            try:
                while True:
                    event = result_queue.get_nowait()

                    if event[0] == "worker_start":
                        _, worker_id, worker_job, target, prefix_len = event
                        debug_log("Worker started", worker_id=worker_id, job_id=worker_job,
                                  target_hex="%064x" % target, header_prefix_bytes=prefix_len,
                                  nonce_start=(nonce_offset + worker_id) & 0xFFFFFFFF, nonce_stride=CPU_THREADS)

                    elif event[0] == "worker_progress":
                        _, worker_id, next_nonce, delta_hashes, elapsed = event
                        debug_log("Nonce range progress", worker_id=worker_id,
                                  job_id=job["job_id"], next_nonce="%08x" % min(next_nonce, 0xFFFFFFFF),
                                  hashes_since_last_report=delta_hashes, elapsed_seconds=elapsed,
                                  hashrate_hs=round(delta_hashes / max(elapsed, 0.001), 3),
                                  nonce_stride=CPU_THREADS)
                        hashes_since_report += delta_hashes
                        ctx.total_hashes += delta_hashes
                        metrics.add_hashes(delta_hashes)

                    elif event[0] == "worker_stop":
                        _, worker_id, worker_hashes, elapsed = event
                        debug_log("Worker stopped", worker_id=worker_id, job_id=job["job_id"],
                                  hashes=worker_hashes, elapsed_seconds=elapsed)

                    elif event[0] == "progress":
                        hashes = event[2]
                        hashes_since_report += hashes
                        ctx.total_hashes += hashes
                        metrics.add_hashes(hashes)

                    elif event[0] == "found":
                        _, nonce, found_job, found_ntime, hashes = event
                        hashes_since_report += hashes
                        ctx.total_hashes += hashes
                        stop_event.set()

                        print()
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "==============================================================")
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "  POW CANDIDATE DETECTED; VERIFYING")
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "  job=%s | nonce=%08x | nbits=%s" %
                              (found_job, nonce, job["nbits"]))
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "==============================================================")
                        print(Style.RESET_ALL)
                        logg("[!] POW candidate detected; independent verification pending: job=%s nonce=%08x nbits=%s" %
                             (found_job, nonce, job["nbits"]))
                        record_pow_status("candidate", found_job, nonce, "python")

                        # A notify can race with result_queue delivery. Never
                        # submit a hit from an obsolete job generation.
                        latest = globals()["current_job"]()
                        if latest is None or latest["generation"] != job["generation"]:
                            logg("[!] Discarding stale Python hit: job=%s nonce=%08x" %
                                 (found_job, nonce))
                            break

                        # Independently verify the exact worker header before submit.
                        try:
                            found_prefix = build_header_prefix(job, extranonce2)
                            found_target = compact_to_target(job["nbits"])
                            if not verify_header_pow(found_prefix, nonce, found_target):
                                print(Fore.RED, "[!] Python-engine hit failed independent SHA256d verification; NOT submitting")
                                logg("[!] Python hit rejected by independent verification: job=%s nonce=%08x" %
                                     (found_job, nonce))
                                record_pow_status("verification_failed", found_job, nonce, "python")
                                debug_log("Target verification failed", engine="python",
                                          job_id=found_job, nonce="%08x" % nonce,
                                          target_hex="%064x" % found_target)
                            else:
                                logg("[+] SHA256d/target verification PASSED: job=%s nonce=%08x wallet=%s" %
                                     (found_job, nonce, ADDRESS))
                                record_pow_status("verified", found_job, nonce, "python")
                                structured_logger.event(
                                    "pow_candidate_verified", engine="python",
                                    job_id=found_job, nonce="%08x" % nonce,
                                    wallet=ADDRESS, target_hex="%064x" % found_target,
                                )
                                debug_log("Target verification passed", engine="python",
                                          job_id=found_job, nonce="%08x" % nonce,
                                          target_hex="%064x" % found_target)
                                submit_share(
                                    found_job, extranonce2, found_ntime, nonce,
                                    expected_generation=job["generation"],
                                )
                        except Exception as exc:
                            print(Fore.RED, "[!] Share submit failed:", exc)
                            logg("[!] Share submit failed: %s" % exc)
                        break

                    elif event[0] == "error":
                        print(Fore.RED, "[!] CPU worker error:", event[2])
                        logg("[!] CPU worker error: %s" % event[2])
                        debug_log("Worker error", worker_id=event[1], job_id=job["job_id"], error=event[2])

            except queue.Empty:
                pass
            except Exception as exc:
                logg("[!] Worker result queue read failed: %s" % exc)
                debug_log("Worker result queue read failed", job_id=job["job_id"], error=repr(exc))

            if stop_event.is_set():
                break

            now = time.monotonic()
            if now - last_header_rotation >= HEADER_ROTATE_INTERVAL:
                # Replace Python workers with a new exact header snapshot.
                # Keep ntime at/after the pool base and never roll into the future.
                base_time = int(job.get("base_ntime", job["ntime"]), 16)
                now_time = min(0xFFFFFFFF, int(time.time()))
                ntime_value = (
                    secrets.randbelow(now_time - base_time + 1) + base_time
                    if now_time >= base_time else base_time
                )
                rotated_job = dict(job)
                rotated_job["base_ntime"] = job.get("base_ntime", job["ntime"])
                rotated_job["ntime"] = "%08x" % ntime_value
                stop_workers(workers, stop_event)
                workers, stop_event, result_queue, extranonce2 = start_workers(rotated_job)
                job = rotated_job
                last_header_rotation = time.monotonic()
                mining_header_status.update(
                    job_id=job["job_id"], extranonce2=extranonce2,
                    ntime=job["ntime"], mode="randomized extranonce2 + ntime",
                )
                debug_log(
                    "Randomized mutable header fields", engine="python",
                    job_id=job["job_id"], extranonce2=extranonce2,
                    ntime=job["ntime"], interval_seconds=HEADER_ROTATE_INTERVAL,
                )
                continue

            if now - last_report >= REPORT_INTERVAL:
                elapsed = max(now - last_report, 0.001)
                rate = hashes_since_report / elapsed
                debug_log(
                    "Mining progress",
                    engine="python",
                    job_id=job["job_id"],
                    interval_hashes=hashes_since_report,
                    total_hashes=ctx.total_hashes,
                    elapsed_seconds=round(elapsed, 3),
                    hashrate_hs=round(rate, 3),
                    hashrate_mhs=round(rate / 1_000_000, 6),
                    pool_difficulty=ctx.upstream_difficulty,
                    memory=memory_snapshot(),
                    workers=worker_count_snapshot(CPU_THREADS),
                    elapsed_uptime=metrics.snapshot()["uptime_s"],
                )
                render_dashboard(rate, hashes_since_report)
                hashes_since_report = 0
                last_report = now

            time.sleep(0.05)

        stop_workers(workers, stop_event)
        workers = []
        stop_event = None

    if workers:
        stop_workers(workers, stop_event)


def run():
    state_machine.reset()
    print(
        Fore.BLUE,
        "--------------~~(",
        Fore.YELLOW,
        "b_m CPU Solo Miner",
        Fore.BLUE,
        ")~~--------------",
    )
    print(Fore.WHITE, "[*] BTC address:", ADDRESS)
    print(Fore.WHITE, "[*] Wallet source:", CONFIG.address_source)
    print(Fore.WHITE, "[*] Upstream:",
          "%s:%s" % (UPSTREAM_HOST, UPSTREAM_PORT))
    print(Fore.WHITE, "[*] CPU threads:", CPU_THREADS)
    print(Fore.WHITE, "[*] Nonce batch:", NONCE_BATCH)
    print(Fore.WHITE, "[*] Reconnect delay:", RECONNECT_DELAY, "s")
    ensure_native()

    if submit_selftest():
        print(Fore.GREEN, "[*] Stratum submit payload self-test: PASS")
        debug_log("Self-test passed", test="stratum_submit_payload")
    else:
        print(Fore.RED, "[!] Stratum submit payload self-test: FAILED")
        debug_log("Self-test failed", test="stratum_submit_payload")
        raise RuntimeError("Submit payload self-test failed")

    while not ctx.fShutdown:
        try:
            state_machine.transition(MinerState.CONNECTING)
            sock = connect_upstream()
            listener = threading.Thread(
                target=upstream_listener,
                args=(sock,),
                daemon=True,
            )
            listener.start()
            state_machine.transition(MinerState.CONNECTED)

            state_machine.transition(MinerState.MINING)
            miner_loop()

            if ctx.fShutdown:
                break

        except Exception as exc:
            if state_machine.state != MinerState.STOPPED:
                try:
                    state_machine.transition(MinerState.RECONNECTING)
                except ValueError:
                    state_machine.reset()
            ctx.connected = False
            ctx.upstream_alive = False
            print(Fore.RED, "[!] Upstream error:", exc)
            logg("[!] Upstream error: %s" % exc)
            debug_log("Connection/session failure", error=repr(exc),
                      host=UPSTREAM_HOST, port=UPSTREAM_PORT,
                      reconnect_delay=RECONNECT_DELAY)

        finally:
            # Stop new submissions before invalidating this session. Any pending
            # response at disconnect is unknown, not a confirmed pool rejection.
            ctx.connected = False
            ctx.upstream_alive = False
            # connect_upstream() may fail after creating a socket but before
            # returning it, leaving local `sock` unset or pointing to an older
            # session. Always close the socket owned by the current context.
            active_sock = ctx.upstream_sock
            try:
                if active_sock is not None:
                    active_sock.close()
            except Exception:
                pass
            if ctx.upstream_sock is active_sock:
                ctx.upstream_sock = None

            with ctx.pending_submits_lock:
                abandoned_submits = list(ctx.pending_submits.items())
                ctx.pending_submits.clear()
            for submit_id, submitted_at in abandoned_submits:
                age = max(0.0, time.monotonic() - submitted_at)
                structured_logger.event(
                    "share_response_unknown", submit_id=submit_id,
                    age_seconds=round(age, 6),
                    reason="connection_closed_before_response",
                )
                debug_log(
                    "Share response unknown after disconnect",
                    submit_id=submit_id, age_seconds=round(age, 6),
                )

            # Do not carry a job or extranonce snapshot across TCP sessions.
            with ctx.job_lock:
                ctx.job_id = None
                ctx.prevhash = None
                ctx.coinb1 = None
                ctx.coinb2 = None
                ctx.merkle_branch = None
                ctx.version = None
                ctx.nbits = None
                ctx.ntime = None
                ctx.clean_jobs = False
                ctx.upstream_extranonce1 = None
                ctx.upstream_extranonce2_size = 4
                ctx.job_generation += 1

            debug_log("Connection closed", host=UPSTREAM_HOST, port=UPSTREAM_PORT,
                      shutdown=ctx.fShutdown,
                      abandoned_submits=len(abandoned_submits))

        if not ctx.fShutdown:
            if state_machine.state != MinerState.RECONNECTING:
                try:
                    state_machine.transition(MinerState.RECONNECTING)
                except ValueError:
                    state_machine.reset()
            print(Fore.YELLOW, "[*] Reconnecting in %.1f seconds..." % RECONNECT_DELAY)
            debug_log("Reconnect scheduled", delay_seconds=RECONNECT_DELAY,
                      host=UPSTREAM_HOST, port=UPSTREAM_PORT)
            time.sleep(RECONNECT_DELAY)
            if state_machine.state == MinerState.RECONNECTING:
                state_machine.transition(MinerState.CONNECTING)


def main():
    signal(SIGINT, handler)
    run()


if __name__ == "__main__":
    main()