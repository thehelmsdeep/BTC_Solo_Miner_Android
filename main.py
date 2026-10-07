import ctypes
import hashlib
import json
import logging
import multiprocessing as mp
import os
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


ADDRESS = os.getenv("BTC_ADDRESS", "bc1qz9vpf26p0l43dyypcjnaws24hfyu2gz978kzh4")
UPSTREAM_HOST = os.getenv("STRATUM_HOST", "solo.ckpool.org")
UPSTREAM_PORT = int(os.getenv("STRATUM_PORT", "3333"))
WORKER_PASSWORD = os.getenv("WORKER_PASSWORD", "x")
CPU_THREADS = max(1, int(os.getenv("CPU_THREADS", str(max(1, os.cpu_count() or 1)))))
NONCE_BATCH = max(10000, int(os.getenv("NONCE_BATCH", "4000000")))
REPORT_INTERVAL = max(1.0, float(os.getenv("REPORT_INTERVAL", "5")))
RECONNECT_DELAY = max(1.0, float(os.getenv("RECONNECT_DELAY", "5")))
SUBMIT_TIMEOUT = max(1.0, float(os.getenv("SUBMIT_TIMEOUT", "15")))
NATIVE_DIR = pathlib.Path(__file__).resolve().parent / "native"
NATIVE_LIB = NATIVE_DIR / ("b_m_sha256.dll" if os.name == "nt" else "libb_m_sha256.so")
NATIVE_ENABLED = os.getenv("BM_NATIVE", "1").lower() not in {"0", "false", "no"}
_native = None
_native_engine = None


def timer():
    return datetime.now().time()


def logg(msg):
    logging.basicConfig(
        level=logging.INFO,
        filename="miner.log",
        format="%(asctime)s %(message)s",
    )
    logging.info(str(msg))


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
    needs_build = (
        not NATIVE_LIB.exists()
        or source_file.stat().st_mtime > NATIVE_LIB.stat().st_mtime
    )
    if needs_build:
        compiler = shutil.which("gcc") or shutil.which("clang") or shutil.which("cc")
        if not compiler:
            print(Fore.YELLOW, "[!] No C compiler found; using Python SHA256 fallback")
            return None
        NATIVE_DIR.mkdir(exist_ok=True)
        if os.name == "nt":
            cmd = [compiler, "-O3", "-march=native", "-mtune=native", "-flto", "-funroll-loops", "-fomit-frame-pointer", "-DNDEBUG", "-shared", "-o", str(NATIVE_LIB), str(source_file)]
        else:
            machine = platform.machine().lower()
            march = "armv8-a+crypto" if machine in ("aarch64", "arm64") else "native"
            cmd = [compiler, "-O3", f"-march={march}", "-mtune=native", "-flto", "-funroll-loops", "-fomit-frame-pointer", "-DNDEBUG", "-fPIC", "-shared", "-o", str(NATIVE_LIB), str(NATIVE_DIR / "sha256_engine.c")]
        try:
            subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            print(Fore.GREEN, "[*] Native SHA256 engine built")
        except (OSError, subprocess.CalledProcessError) as exc:
            print(Fore.YELLOW, "[!] Native build unavailable; using Python fallback:", exc)
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
            print(Fore.RED, "[!] Native SHA256 self-test FAILED (code=%d); using Python SHA256 fallback" % selftest)
            return None
        print(Fore.GREEN, "[*] Native SHA256 self-test: PASS")

        engine_test = lib.b_m_engine_selftest()
        if engine_test != 0:
            print(Fore.RED, "[!] Native engine integration self-test FAILED (code=%d)" % engine_test)
            return None
        print(Fore.GREEN, "[*] Native engine integration self-test: PASS")
        _native=lib
        return lib
    except OSError as exc:
        print(Fore.YELLOW, "[!] Native engine load failed; using Python fallback:", exc)
        return None


def native_engine_create(header_prefix, target):
    global _native_engine
    lib = ensure_native()
    if lib is None:
        return None

    prefix = (ctypes.c_uint8 * 76).from_buffer_copy(header_prefix)
    target_bytes = (ctypes.c_uint8 * 32).from_buffer_copy(
        target.to_bytes(32, "little")
    )
    engine = lib.b_m_engine_create(ctypes.c_uint32(CPU_THREADS))
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


def native_engine_exhausted(engine):
    lib = ensure_native()
    return bool(lib and engine and lib.b_m_engine_exhausted(engine))


def native_engine_stop_job(engine):
    lib = ensure_native()
    if lib is not None and engine:
        lib.b_m_engine_stop_job(engine)


def verify_header_pow(header_prefix, nonce, target):
    """Independently verify the exact 80-byte header before submission."""
    if len(header_prefix) != 76:
        raise ValueError("Invalid header prefix length")
    if not 0 <= nonce <= 0xFFFFFFFF:
        raise ValueError("Invalid nonce")
    header = header_prefix + nonce.to_bytes(4, "little")
    digest = double_sha256(header)
    return int.from_bytes(digest, "little") <= target


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


def build_header_prefix(job, extranonce2):
    coinbase = bytes.fromhex(
        job["coinb1"] + (job.get("extranonce1") or ctx.upstream_extranonce1) +
        extranonce2 + job["coinb2"]
    )

    coinbase_hash = double_sha256(coinbase)
    merkle_root = coinbase_hash

    for branch in job["merkle_branch"]:
        merkle_root = double_sha256(
            merkle_root + bytes.fromhex(branch)
        )

    header = (
        bytes.fromhex(job["version"])[::-1]
        + bytes.fromhex(job["prevhash"])[::-1]
        + merkle_root[::-1]
        + bytes.fromhex(job["ntime"])[::-1]
        + bytes.fromhex(job["nbits"])[::-1]
    )

    if len(header) != 76:
        raise ValueError("Invalid block header prefix length")

    return header


def cpu_worker(worker_id, job, extranonce2, stop_event, result_queue):
    try:
        header_prefix = build_header_prefix(job, extranonce2)
        target = compact_to_target(job["nbits"])

        sha256 = hashlib.sha256
        base = sha256(header_prefix[:64])
        tail = header_prefix[64:]
        nonce = worker_id
        hashes = 0

        while not stop_event.is_set() and nonce <= 0xFFFFFFFF:
            end_nonce = min(
                nonce + NONCE_BATCH * CPU_THREADS,
                0x100000000
            )
            while nonce < end_nonce and not stop_event.is_set():
                first = base.copy()
                first.update(tail)
                first.update(nonce.to_bytes(4, "little"))
                digest = sha256(first.digest()).digest()
                hashes += 1

                if int.from_bytes(digest, "little") <= target:
                    result_queue.put((
                        "found", nonce, job["job_id"], job["ntime"], hashes
                    ))
                    stop_event.set()
                    return
                nonce += CPU_THREADS

        if hashes:
            result_queue.put(("progress", worker_id, hashes))
    except Exception as exc:
        result_queue.put(("error", worker_id, str(exc)))


def stop_workers(workers, stop_event):
    if not workers:
        return
    stop_event.set()
    for process in workers:
        process.join(timeout=1)
    for process in workers:
        if process.is_alive():
            process.terminate()
            process.join(timeout=1)


def start_workers(job):
    stop_event = mp.Event()
    result_queue = mp.Queue()
    workers = []

    extranonce2_size = int(ctx.upstream_extranonce2_size)
    if extranonce2_size <= 0:
        raise RuntimeError("Invalid upstream extranonce2_size")

    mask = (1 << (8 * extranonce2_size)) - 1
    extranonce2 = (time.time_ns() & mask).to_bytes(
        extranonce2_size, "big"
    ).hex()

    worker_count = 1 if ensure_native() is not None else CPU_THREADS

    for worker_id in range(worker_count):
        process = mp.Process(
            target=cpu_worker,
            args=(worker_id, job, extranonce2, stop_event, result_queue),
            daemon=True,
        )
        process.start()
        workers.append(process)

    return workers, stop_event, result_queue, extranonce2


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


def submit_share(job_id, extranonce2, ntime, nonce):
    with ctx.pending_submits_lock:
        submit_id = ctx.next_submit_id
        ctx.next_submit_id += 1
        ctx.pending_submits[submit_id] = time.monotonic()

    payload = submit_payload(
        job_id, extranonce2, ntime, nonce, submit_id
    )

    try:
        with ctx.upstream_send_lock:
            send_json(ctx.upstream_sock, payload)
    except Exception:
        with ctx.pending_submits_lock:
            ctx.pending_submits.pop(submit_id, None)
        raise

    ctx.shares_submitted += 1
    logg("[*] Share submitted: id=%s job=%s nonce=%08x" %
         (submit_id, job_id, nonce))
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
                        ctx.upstream_extranonce1 = params[0]
                        ctx.upstream_extranonce2_size = size
                        ctx.job_generation += 1
                    print(Fore.CYAN, "[*] Pool extranonce updated")

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
                        else:
                            ctx.shares_rejected += 1

                        elapsed = time.monotonic() - submitted_at
                        if accepted:
                            print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                                  "[+] SHARE ACCEPTED | id=%s | latency=%.3fs" % (msg_id, elapsed), Style.RESET_ALL)
                        else:
                            print(Style.BRIGHT + Fore.WHITE + Back.RED,
                                  "[-] SHARE REJECTED | id=%s | latency=%.3fs | error=%s" % (msg_id, elapsed, msg.get("error") or ""), Style.RESET_ALL)
                        logg("[*] Share %s: id=%s latency=%.3fs error=%s" %
                             ("ACCEPTED" if accepted else "REJECTED",
                              msg_id, elapsed, msg.get("error") or ""))
                    else:
                        logg("[*] Upstream response: %s" % msg)

            expire_pending_submits()

    except (ConnectionError, OSError) as exc:
        if not ctx.fShutdown:
            print(Fore.RED, "[!] Upstream listener stopped:", exc)
            logg("[!] Upstream listener stopped: %s" % exc)
    finally:
        ctx.upstream_alive = False
        expire_pending_submits(force=True)


def expire_pending_submits(force=False):
    now = time.monotonic()
    expired = []

    with ctx.pending_submits_lock:
        for submit_id, submitted_at in list(ctx.pending_submits.items()):
            if force or now - submitted_at > SUBMIT_TIMEOUT:
                expired.append(submit_id)
                del ctx.pending_submits[submit_id]

    for submit_id in expired:
        ctx.shares_rejected += 1
        print(Fore.RED, "[!] Share response timeout:", submit_id)


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

    with ctx.job_lock:
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
            "generation": ctx.job_generation,
        }


def connect_upstream():
    sock = socket.create_connection((UPSTREAM_HOST, UPSTREAM_PORT), timeout=20)
    sock.settimeout(5)
    ctx.upstream_sock = sock

    print(Fore.GREEN, "[*] Connected to %s:%s" %
          (UPSTREAM_HOST, UPSTREAM_PORT))

    send_json(sock, {
        "id": 1,
        "method": "mining.subscribe",
        "params": ["b_m-cpu/1.1"],
    })

    buffer = b""
    subscribed = False
    authorized = False
    deadline = time.time() + 30

    while time.time() < deadline and not authorized:
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

                (
                    ctx.sub_details,
                    ctx.upstream_extranonce1,
                    ctx.upstream_extranonce2_size,
                ) = result
                subscribed = True
                print(Fore.GREEN, "[*] Stratum subscribe successful")

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

            elif msg.get("method") == "mining.notify":
                update_job(msg.get("params", []))

            elif msg.get("method") == "mining.set_difficulty":
                params = msg.get("params", [])
                if params:
                    ctx.upstream_difficulty = params[0]

    if not subscribed:
        raise TimeoutError("Upstream subscribe timed out")
    if not authorized:
        raise TimeoutError("Upstream authorization timed out")

    ctx.connected = True
    ctx.upstream_alive = True
    return sock


def miner_loop():
    if ensure_native() is not None:
        last_report = time.monotonic()
        hashes_since_report = 0
        engine = native_engine_create(b"\x00" * 76, 0)

        try:
            current_generation = None
            current_job = None
            extranonce2 = None
            waiting_for_new_job = False

            while not ctx.fShutdown and ctx.upstream_alive:
                job = globals()["current_job"]()
                if job is None or not job.get("extranonce1"):
                    time.sleep(0.1)
                    continue

                if job["generation"] != current_generation and not waiting_for_new_job:
                    extranonce2_size = int(ctx.upstream_extranonce2_size)
                    mask = (1 << (8 * extranonce2_size)) - 1
                    extranonce2 = (time.time_ns() & mask).to_bytes(
                        extranonce2_size, "big"
                    ).hex()

                    header_prefix = build_header_prefix(job, extranonce2)
                    target = compact_to_target(job["nbits"])

                    if not native_engine_set_job(engine, header_prefix, target):
                        raise RuntimeError("Failed to update native mining job")

                    # Freeze the exact job/extranonce/header used by native hashing.
                    # A later mining.notify must never mix metadata into a found nonce.
                    current_job = dict(job)
                    current_job["extranonce2"] = extranonce2
                    current_job["header_prefix"] = header_prefix
                    current_job["target"] = target
                    current_generation = job["generation"]

                    print(
                        Fore.CYAN,
                        "[*] CPU mining job=%s with %d persistent C threads"
                        % (job["job_id"], CPU_THREADS),
                    )
                    print(
                        Fore.WHITE,
                        "[*] Job details: nbits=%s | target=%064x | ntime=%s | clean_jobs=%s"
                        % (job["nbits"], target, job["ntime"], job["clean_jobs"]),
                    )
                    logg(
                        "[*] New job: id=%s nbits=%s target=%064x ntime=%s clean_jobs=%s"
                        % (job["job_id"], job["nbits"], target, job["ntime"], job["clean_jobs"])
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

                hit, found, hashes = native_engine_poll(engine)
                if native_engine_exhausted(engine):
                    extranonce2_size = int(ctx.upstream_extranonce2_size)
                    mask = (1 << (8 * extranonce2_size)) - 1
                    extranonce2 = (time.time_ns() & mask).to_bytes(
                        extranonce2_size, "big"
                    ).hex()
                    header_prefix = build_header_prefix(current_job, extranonce2)
                    target = compact_to_target(current_job["nbits"])
                    if not native_engine_set_job(engine, header_prefix, target):
                        raise RuntimeError("Failed to restart native engine after nonce exhaustion")

                    # Refresh the frozen submission snapshot so it exactly matches
                    # the header now being hashed by the native engine.
                    current_job["extranonce2"] = extranonce2
                    current_job["header_prefix"] = header_prefix
                    current_job["target"] = target

                    print(Fore.YELLOW, "[!] Nonce space exhausted; rotated extranonce2 and resumed the same job")
                    continue
                if hashes:
                    hashes_since_report += hashes
                    ctx.total_hashes += hashes

                if hit:
                    # A notify/set_extranonce can arrive while the native engine is
                    # finishing a polling interval. Never submit a hit from an old
                    # generation under the new job metadata.
                    latest = globals()["current_job"]()
                    if latest is None or latest["generation"] != current_generation:
                        logg("[!] Discarding stale native hit: job=%s nonce=%08x" %
                             (current_job["job_id"], found))
                        native_engine_stop_job(engine)
                        waiting_for_new_job = True
                        continue
                    print()
                    print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                          "==============================================================")
                    print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                          "  !!! VALID BLOCK HEADER FOUND !!!")
                    print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                          "  job=%s | nonce=%08x | nbits=%s" %
                          (current_job["job_id"], found, current_job["nbits"]))
                    print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                          "==============================================================")
                    print(Style.RESET_ALL)
                    logg("[!!!] VALID BLOCK HEADER FOUND: job=%s nonce=%08x nbits=%s" %
                         (current_job["job_id"], found, current_job["nbits"]))
                    # Re-hash the exact header used by native before any network submit.
                    found_snapshot = dict(current_job)
                    try:
                        if not verify_header_pow(
                            found_snapshot["header_prefix"],
                            found,
                            found_snapshot["target"],
                        ):
                            print(Fore.RED, "[!] Native hit failed independent SHA256d verification; NOT submitting")
                            logg("[!] Native hit rejected by independent verification: job=%s nonce=%08x" %
                                 (found_snapshot["job_id"], found))
                        else:
                            submit_share(
                                found_snapshot["job_id"],
                                found_snapshot["extranonce2"],
                                found_snapshot["ntime"],
                                found,
                            )
                    except Exception as exc:
                        print(Fore.RED, "[!] Share submit failed:", exc)

                    native_engine_stop_job(engine)
                    waiting_for_new_job = True
                    continue

                if new_job["generation"] != current_generation:
                    continue

                now = time.monotonic()
                if now - last_report >= REPORT_INTERVAL:
                    rate = hashes_since_report / max(now - last_report, 0.001)
                    print(
                        Fore.CYAN,
                        "[*] Hashrate: %.2f H/s | interval_hashes=%d | total_hashes=%d | submitted=%d accepted=%d rejected=%d"
                        % (rate, hashes_since_report, ctx.total_hashes, ctx.shares_submitted, ctx.shares_accepted, ctx.shares_rejected),
                    )
                    hashes_since_report = 0
                    last_report = now

                time.sleep(0.01)

        finally:
            native_engine_destroy(engine)
        return

    workers = []
    stop_event = None
    last_report = time.monotonic()
    hashes_since_report = 0

    while not ctx.fShutdown and ctx.upstream_alive:
        job = globals()["current_job"]()

        if job is None or not job.get("extranonce1"):
            time.sleep(0.2)
            continue

        stop_workers(workers, stop_event) if workers else None
        workers, stop_event, result_queue, extranonce2 = start_workers(job)

        print(
            Fore.CYAN,
            "[*] CPU mining job=%s with %d threads (Python engine)" %
            (job["job_id"], CPU_THREADS),
        )

        while (not ctx.fShutdown and ctx.upstream_alive
               and not stop_event.is_set()):
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

                    if event[0] == "progress":
                        hashes = event[2]
                        hashes_since_report += hashes
                        ctx.total_hashes += hashes

                    elif event[0] == "found":
                        _, nonce, found_job, found_ntime, hashes = event
                        hashes_since_report += hashes
                        ctx.total_hashes += hashes
                        stop_event.set()

                        print()
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "==============================================================")
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "  !!! VALID BLOCK HEADER FOUND !!!")
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "  job=%s | nonce=%08x | nbits=%s" %
                              (found_job, nonce, job["nbits"]))
                        print(Style.BRIGHT + Fore.WHITE + Back.GREEN,
                              "==============================================================")
                        print(Style.RESET_ALL)
                        logg("[!!!] VALID BLOCK HEADER FOUND: job=%s nonce=%08x nbits=%s" %
                             (found_job, nonce, job["nbits"]))

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
                            else:
                                submit_share(found_job, extranonce2, found_ntime, nonce)
                        except Exception as exc:
                            print(Fore.RED, "[!] Share submit failed:", exc)
                        break

                    elif event[0] == "error":
                        print(Fore.RED, "[!] CPU worker error:", event[2])

            except Exception:
                pass

            now = time.monotonic()
            if now - last_report >= REPORT_INTERVAL:
                rate = hashes_since_report / max(now - last_report, 0.001)
                print(
                    Fore.CYAN,
                    "[*] Hashrate: %.2f H/s | submitted=%d accepted=%d rejected=%d"
                    % (rate, ctx.shares_submitted, ctx.shares_accepted, ctx.shares_rejected),
                )
                hashes_since_report = 0
                last_report = now

            time.sleep(0.05)

        stop_workers(workers, stop_event)
        workers = []
        stop_event = None

    if workers:
        stop_workers(workers, stop_event)


def run():
    print(
        Fore.BLUE,
        "--------------~~(",
        Fore.YELLOW,
        "b_m CPU Solo Miner",
        Fore.BLUE,
        ")~~--------------",
    )
    print(Fore.WHITE, "[*] BTC address:", ADDRESS)
    print(Fore.WHITE, "[*] Upstream:",
          "%s:%s" % (UPSTREAM_HOST, UPSTREAM_PORT))
    print(Fore.WHITE, "[*] CPU threads:", CPU_THREADS)
    print(Fore.WHITE, "[*] Nonce batch:", NONCE_BATCH)
    print(Fore.WHITE, "[*] Reconnect delay:", RECONNECT_DELAY, "s")
    ensure_native()

    if submit_selftest():
        print(Fore.GREEN, "[*] Stratum submit payload self-test: PASS")
    else:
        print(Fore.RED, "[!] Stratum submit payload self-test: FAILED")
        raise RuntimeError("Submit payload self-test failed")

    while not ctx.fShutdown:
        try:
            sock = connect_upstream()
            listener = threading.Thread(
                target=upstream_listener,
                args=(sock,),
                daemon=True,
            )
            listener.start()

            miner_loop()

            if ctx.fShutdown:
                break

        except Exception as exc:
            ctx.connected = False
            ctx.upstream_alive = False
            print(Fore.RED, "[!] Upstream error:", exc)
            logg("[!] Upstream error: %s" % exc)

        finally:
            ctx.connected = False
            ctx.upstream_alive = False
            try:
                sock.close()
            except Exception:
                pass
            ctx.upstream_sock = None

        if not ctx.fShutdown:
            print(Fore.YELLOW, "[*] Reconnecting in %.1f seconds..." % RECONNECT_DELAY)
            time.sleep(RECONNECT_DELAY)


def main():
    signal(SIGINT, handler)
    run()


if __name__ == "__main__":
    mp.freeze_support()
    main()
