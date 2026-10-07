#!/usr/bin/env python3
"""Short offline native SHA256d throughput benchmark."""

import ctypes
import pathlib
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import main


def ptr(data):
    return (ctypes.c_uint8 * len(data)).from_buffer_copy(data)


def main_test():
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library unavailable")
        return 2

    prefix = bytes(range(76))
    target = bytes(32)
    requested = 1_000_000
    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)

    start_time = time.perf_counter()
    hit = lib.b_m_mine_parallel(
        ptr(prefix),
        ptr(target),
        ctypes.c_uint32(0),
        ctypes.c_uint32(max(1, main.CPU_THREADS)),
        ctypes.c_uint64(requested),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )
    elapsed = time.perf_counter() - start_time

    assert hit == 0
    assert hashes.value == requested

    rate = hashes.value / max(elapsed, 1e-9)
    print(
        f"NATIVE BENCHMARK: {rate:,.2f} H/s | hashes={hashes.value} "
        f"| elapsed={elapsed:.3f}s | threads={max(1, main.CPU_THREADS)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main_test())
