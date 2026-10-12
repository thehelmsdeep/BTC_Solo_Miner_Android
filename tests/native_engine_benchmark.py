#!/usr/bin/env python3
"""Compare native SHA256d throughput with ARM64 assembly enabled/disabled.

Run from the repository root, once with BTC_MINER_ARM64_ASM=1 and once with =0.
Uses an impossible all-zero target and a fixed hash budget, so no real mining
shares are submitted and both variants perform the same amount of work.
"""
import argparse
import ctypes
import pathlib
import platform
import statistics
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import main  # noqa: E402


def byte_array(data):
    return (ctypes.c_uint8 * len(data)).from_buffer_copy(data)


def main_benchmark():
    parser = argparse.ArgumentParser()
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--seconds", type=float, default=5.0,
                        help="minimum duration per run; repeated until time budget is met")
    parser.add_argument("--repeats", type=int, default=3)
    parser.add_argument("--hashes", type=int, default=2_000_000,
                        help="hash budget per run (default: 2,000,000)")
    args = parser.parse_args()
    if args.threads < 1 or args.repeats < 1 or args.hashes < 1:
        parser.error("threads, repeats, and hashes must be positive")

    lib = main.ensure_native()
    if lib is None:
        raise SystemExit("Native engine unavailable; benchmark aborted (no Python fallback benchmark).")
    lib.b_m_mine_parallel.argtypes = [
        ctypes.POINTER(ctypes.c_uint8), ctypes.POINTER(ctypes.c_uint8),
        ctypes.c_uint32, ctypes.c_uint32, ctypes.c_uint64,
        ctypes.POINTER(ctypes.c_uint32), ctypes.POINTER(ctypes.c_uint64)
    ]
    lib.b_m_mine_parallel.restype = ctypes.c_int

    # Deterministic 76-byte header prefix; all-zero target is effectively impossible.
    prefix = byte_array(bytes((i * 37 + 11) & 0xff for i in range(76)))
    target = byte_array(bytes(32))
    rates = []
    asm = __import__("os").environ.get("BTC_MINER_ARM64_ASM", "auto")
    print(f"Architecture: {platform.machine().lower()}")
    print(f"ARM64 assembly setting: {asm}; threads={args.threads}; repeats={args.repeats}; hash budget/run={args.hashes:,}")

    for run_no in range(1, args.repeats + 1):
        found = ctypes.c_uint32(0)
        hashes = ctypes.c_uint64(0)
        start_nonce = (run_no - 1) * args.hashes
        start = time.perf_counter()
        rc = lib.b_m_mine_parallel(
            prefix, target, ctypes.c_uint32(start_nonce),
            ctypes.c_uint32(args.threads), ctypes.c_uint64(args.hashes),
            ctypes.byref(found), ctypes.byref(hashes)
        )
        elapsed = time.perf_counter() - start
        if rc != 0:
            raise SystemExit(f"Unexpected target hit / native error in run {run_no}: rc={rc}")
        if hashes.value == 0:
            raise SystemExit(f"Native engine reported zero hashes in run {run_no}")
        rate = hashes.value / elapsed
        rates.append(rate)
        print(f"Run {run_no}: hashes={hashes.value:,} elapsed={elapsed:.3f}s rate={rate / 1e6:.3f} MH/s")

    print(f"Median: {statistics.median(rates) / 1e6:.3f} MH/s")
    print("Note: compare medians from separate assembly=1 and assembly=0 processes; keep phone cool and screen/power conditions identical.")


if __name__ == "__main__":
    main_benchmark()
