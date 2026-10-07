#!/usr/bin/env python3
"""Independent Python-vs-native SHA256d cross-check.

This test never contacts Stratum and never submits anything.
It asks the exact native mining entry point to test one nonce and
independently computes SHA256(SHA256(header)) with Python hashlib.
"""

import ctypes
import hashlib
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import main  # noqa: E402


def ptr(data: bytes, size: int):
    if len(data) != size:
        raise AssertionError(f"expected {size} bytes, got {len(data)}")
    return (ctypes.c_uint8 * size).from_buffer_copy(data)


def check_nonce(lib, prefix: bytes, nonce: int) -> None:
    header = prefix + nonce.to_bytes(4, "little")
    digest = hashlib.sha256(hashlib.sha256(header).digest()).digest()
    target = int.from_bytes(digest, "little")

    native_prefix = ptr(prefix, 76)
    native_target = ptr(target.to_bytes(32, "little"), 32)
    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)

    hit = lib.b_m_mine_parallel(
        native_prefix,
        native_target,
        ctypes.c_uint32(nonce),
        ctypes.c_uint32(1),
        ctypes.c_uint64(1),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )

    if hit != 1 or found.value != nonce or hashes.value != 1:
        raise AssertionError(
            f"native mismatch: hit={hit}, found=0x{found.value:08x}, "
            f"hashes={hashes.value}, expected nonce=0x{nonce:08x}"
        )

    # Make the target one unit smaller. The same single hash must now fail.
    lower = target - 1 if target else 0
    lower_target = ptr(lower.to_bytes(32, "little"), 32)
    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)

    hit = lib.b_m_mine_parallel(
        native_prefix,
        lower_target,
        ctypes.c_uint32(nonce),
        ctypes.c_uint32(1),
        ctypes.c_uint64(1),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )

    if hit != 0 or hashes.value != 1:
        raise AssertionError(
            f"target comparison mismatch: hit={hit}, hashes={hashes.value}"
        )

    print(
        f"PASS nonce=0x{nonce:08x} "
        f"digest={digest.hex()} "
        f"native_hashes={hashes.value}"
    )


def main_test() -> int:
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library could not be built/loaded")
        return 2

    # Deterministic 76-byte Bitcoin-header prefix.
    prefix = bytes(range(76))

    # Check several lanes, including a non-zero nonce and a high-bit nonce.
    for nonce in (0, 1, 0x12345678, 0x80000000, 0xFFFFFFFF):
        check_nonce(lib, prefix, nonce)

    print("NATIVE SHA256D CROSS-CHECK: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main_test())
