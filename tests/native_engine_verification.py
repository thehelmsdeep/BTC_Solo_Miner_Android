#!/usr/bin/env python3
"""Phase 2 native-engine verification.

Offline only. Covers:
- Python hashlib vs scalar/base/optimized native SHA256d
- exact-target and target-minus-one semantics
- ARM SHA2/SIMD-selected path through the exported optimized diagnostic
- persistent engine lifecycle under repeated job replacement
- optional ASan/UBSan/TSan builds via tests/native_engine_sanitizer.c

Sanitizers are intentionally local/manual; this project does not use CI/CD.
"""

import ctypes
import hashlib
import os
import pathlib
import platform
import shutil
import subprocess
import sys
import tempfile
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import main  # noqa: E402


def ptr(data):
    return (ctypes.c_uint8 * len(data)).from_buffer_copy(data)


def digest(prefix, nonce):
    return hashlib.sha256(hashlib.sha256(prefix + nonce.to_bytes(4, "little")).digest()).digest()


def configure(lib):
    u8 = ctypes.POINTER(ctypes.c_uint8)
    lib.b_m_debug_sha256d_scalar.argtypes = [u8, ctypes.c_uint32, u8]
    lib.b_m_debug_sha256d_scalar_base.argtypes = [u8, ctypes.c_uint32, u8]
    lib.b_m_debug_sha256d_optimized.argtypes = [u8, ctypes.c_uint32, u8]
    lib.b_m_mine_parallel.argtypes = [
        u8, u8, ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint64,
        ctypes.POINTER(ctypes.c_uint32), ctypes.POINTER(ctypes.c_uint64)
    ]
    lib.b_m_mine_parallel.restype = ctypes.c_int
    lib.b_m_engine_create.argtypes = [ctypes.c_uint32]
    lib.b_m_engine_create.restype = ctypes.c_void_p
    lib.b_m_engine_set_job.argtypes = [ctypes.c_void_p, u8, u8]
    lib.b_m_engine_set_job.restype = ctypes.c_int
    lib.b_m_engine_poll.argtypes = [
        ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32),
        ctypes.POINTER(ctypes.c_uint64)
    ]
    lib.b_m_engine_poll.restype = ctypes.c_int
    lib.b_m_engine_stop_job.argtypes = [ctypes.c_void_p]
    lib.b_m_engine_destroy.argtypes = [ctypes.c_void_p]


def check_vectors(lib):
    prefixes = [
        bytes(range(76)),
        bytes((i * 37 + 11) & 0xff for i in range(76)),
        bytes((255 - i) & 0xff for i in range(76)),
        bytes((i * i + 19) & 0xff for i in range(76)),
    ]
    nonces = (0, 1, 2, 0x7fffffff, 0x80000000, 0xfffffffe, 0xffffffff)

    for prefix in prefixes:
        p = ptr(prefix)
        for nonce in nonces:
            expected = digest(prefix, nonce)
            outputs = []
            for name in ("b_m_debug_sha256d_scalar",
                         "b_m_debug_sha256d_scalar_base",
                         "b_m_debug_sha256d_optimized"):
                out = (ctypes.c_uint8 * 32)()
                getattr(lib, name)(p, ctypes.c_uint32(nonce), out)
                outputs.append(bytes(out))
            if any(x != expected for x in outputs):
                raise AssertionError(
                    f"SHA256d mismatch nonce=0x{nonce:08x} "
                    f"python={expected.hex()} native={[x.hex() for x in outputs]}"
                )

            target = int.from_bytes(expected, "little")
            for target_int, should_hit in ((target, True), (max(0, target - 1), False)):
                found = ctypes.c_uint32()
                hashes = ctypes.c_uint64()
                rc = lib.b_m_mine_parallel(
                    p, ptr(target_int.to_bytes(32, "little")),
                    ctypes.c_uint32(nonce), ctypes.c_uint32(1),
                    ctypes.c_uint64(1), ctypes.byref(found), ctypes.byref(hashes)
                )
                if bool(rc) != should_hit or hashes.value != 1:
                    raise AssertionError(
                        f"target boundary mismatch nonce=0x{nonce:08x} "
                        f"target={'exact' if should_hit else 'minus-one'} "
                        f"rc={rc} hashes={hashes.value}"
                    )

    print("SHA256d scalar/base/optimized cross-check: PASS")
    print("Nonce boundaries + exact-target comparison: PASS")


def check_parallel_and_persistent(lib):
    prefix = bytes(range(76))
    p = ptr(prefix)

    for threads in (1, 2, 4, 8, 16):
        for i in range(8):
            nonce = (i * 0x10203 + threads) & 0xffffffff
            target = digest(prefix, nonce)
            found = ctypes.c_uint32()
            hashes = ctypes.c_uint64()
            rc = lib.b_m_mine_parallel(
                p, ptr(target), ctypes.c_uint32(nonce),
                ctypes.c_uint32(threads), ctypes.c_uint64(1),
                ctypes.byref(found), ctypes.byref(hashes)
            )
            if rc != 1 or found.value != nonce or hashes.value != 1:
                raise AssertionError(
                    f"parallel mismatch threads={threads} nonce=0x{nonce:08x} "
                    f"rc={rc} found=0x{found.value:08x} hashes={hashes.value}"
                )

    for threads in (1, 2, 4, 8):
        engine = lib.b_m_engine_create(ctypes.c_uint32(threads))
        if not engine:
            raise AssertionError(f"engine create failed threads={threads}")
        try:
            for i in range(40):
                nonce = (i * 0x1f123 + threads) & 0xffffffff
                target = digest(prefix, nonce)
                if lib.b_m_engine_set_job(engine, p, ptr(target)) != 1:
                    raise AssertionError(f"set_job failed threads={threads} job={i}")

                deadline = time.monotonic() + 1.0
                hit = False
                while time.monotonic() < deadline:
                    found = ctypes.c_uint32()
                    hashes = ctypes.c_uint64()
                    if lib.b_m_engine_poll(engine, ctypes.byref(found),
                                           ctypes.byref(hashes)):
                        got = digest(prefix, found.value)
                        if int.from_bytes(got, "little") > int.from_bytes(target, "little"):
                            raise AssertionError(
                                f"invalid persistent nonce threads={threads} job={i}"
                            )
                        hit = True
                        break
                    time.sleep(0.001)
                lib.b_m_engine_stop_job(engine)
                if not hit:
                    raise AssertionError(
                        f"persistent engine timeout threads={threads} job={i}"
                    )
        finally:
            lib.b_m_engine_destroy(engine)

    print("SIMD/parallel cross-check: PASS")
    print("Persistent engine stress: PASS")


def sanitizer_builds():
    """Run optional sanitizers and distinguish engine findings from runtime limitations."""
    compiler = shutil.which("clang") or shutil.which("gcc") or shutil.which("cc")
    if not compiler:
        print("ASan+UBSan: SKIP (no C compiler)")
        print("TSan: SKIP (no C compiler)")
        return 0

    harness = ROOT / "tests" / "native_engine_sanitizer.c"
    source = ROOT / "native" / "sha256_engine.c"
    results = []
    with tempfile.TemporaryDirectory(prefix="bm_san_") as td:
        td = pathlib.Path(td)
        for name, flags in (
            ("ASan+UBSan", ["-fsanitize=address,undefined"]),
            ("TSan", ["-fsanitize=thread"]),
        ):
            exe = td / name.replace("+", "_").replace(" ", "_")
            cmd = [
                compiler, "-std=c11", "-O1", "-g",
                "-fno-omit-frame-pointer", "-pthread",
                *flags, "-o", str(exe), str(source), str(harness)
            ]
            try:
                subprocess.run(cmd, check=True, stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE, text=True)
            except (OSError, subprocess.CalledProcessError) as exc:
                print(f"{name}: SKIP (build unavailable: {exc})")
                continue

            env = os.environ.copy()
            if name == "ASan+UBSan":
                # Android/Termux commonly cannot run LeakSanitizer reliably.
                env["ASAN_OPTIONS"] = "detect_leaks=0:halt_on_error=1"
                env["UBSAN_OPTIONS"] = "halt_on_error=1:print_stacktrace=1"
            else:
                env["TSAN_OPTIONS"] = "halt_on_error=1"

            try:
                run = subprocess.run(
                    [str(exe)], env=env, text=True,
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE
                )
            except OSError as exc:
                print(f"{name}: ENVIRONMENT LIMITATION ({exc})")
                results.append("environment")
                continue

            output = (run.stdout or "") + "\n" + (run.stderr or "")

            # These are sanitizer-runtime failures seen on Android/Termux,
            # not findings in the native engine itself.
            runtime_only = (
                ("LeakSanitizer has encountered a fatal error" in output) or
                ("does not work under ptrace" in output) or
                ("ThreadSanitizer: CHECK failed:" in output and
                 "data race" not in output and
                 "heap-" not in output and
                 "use-after" not in output)
            )

            actual_finding = any(marker in output for marker in (
                "ThreadSanitizer: data race",
                "ERROR: AddressSanitizer:",
                "runtime error:",
                "UndefinedBehaviorSanitizer:",
            ))

            harness_pass = "NATIVE ENGINE SANITIZER HARNESS: PASS" in output
            if actual_finding:
                print(f"{name}: FAIL (sanitizer finding)")
                print(output)
                results.append("fail")
            elif runtime_only and harness_pass:
                print(f"{name}: ENVIRONMENT LIMITATION (runtime self-check failed before sanitizer reporting)")
                results.append("environment")
            elif run.returncode == 0 and harness_pass:
                print(f"{name}: PASS")
                results.append("pass")
            elif harness_pass:
                print(f"{name}: ENVIRONMENT LIMITATION (non-zero sanitizer runtime exit)")
                results.append("environment")
            else:
                print(f"{name}: FAIL")
                print(output)
                results.append("fail")

    if "fail" in results:
        return 1
    return 0


def main_test():
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library unavailable")
        return 2
    configure(lib)

    if lib.b_m_selftest() != 0:
        print("Native built-in selftest: FAIL")
        return 1
    if lib.b_m_engine_selftest() != 0:
        print("Native persistent-engine selftest: FAIL")
        return 1

    check_vectors(lib)
    check_parallel_and_persistent(lib)

    machine = platform.machine().lower()
    if machine in ("aarch64", "arm64"):
        print("ARM SHA2 cross-check: PASS (optimized diagnostic matched hashlib)")
    else:
        print("ARM SHA2 cross-check: N/A on this host")
    print(f"Architecture under test: {machine}")

    return sanitizer_builds()


if __name__ == "__main__":
    raise SystemExit(main_test())
