#!/usr/bin/env python3
"""Regression test for finite parallel nonce-space coverage boundaries.

Offline only. Target=0 guarantees no PoW hit, so the public parallel scanner
must process exactly the requested number of candidates. Its production
scheduler uses atomic fetch-add BM_CHUNK allocations, which are disjoint.
"""

import ctypes
import pathlib
import sys

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
    start = 12345
    requested = 100003

    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)
    hit = lib.b_m_mine_parallel(
        ptr(prefix),
        ptr(target),
        ctypes.c_uint32(start),
        ctypes.c_uint32(8),
        ctypes.c_uint64(requested),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )

    assert hit == 0, f"unexpected hit nonce=0x{found.value:08x}"
    assert hashes.value == requested, (
        f"coverage mismatch: requested={requested} actual={hashes.value}"
    )
    assert start + requested - 1 < 0x100000000

    print(
        f"PASS: parallel nonce coverage start={start} "
        f"count={requested} last={start + requested - 1} hashes={hashes.value}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main_test())
