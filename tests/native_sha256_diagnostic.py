#!/usr/bin/env python3
"""Deep diagnostic for the native Bitcoin SHA256d mining paths.

This test is offline: no Stratum connection and no share/block submission.
It separates:
  1) Python hashlib SHA256d reference
  2) b_m_mine() scalar/native path
  3) b_m_mine_parallel() optimized/parallel path
  4) target comparison semantics
  5) persistent native engine path
"""

import ctypes
import hashlib
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import main  # noqa: E402


def ptr(data: bytes):
    return (ctypes.c_uint8 * len(data)).from_buffer_copy(data)


def call_mine(lib, fn_name, prefix, target, nonce, step=1, max_hashes=1):
    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)
    fn = getattr(lib, fn_name)
    hit = fn(
        ptr(prefix),
        ptr(target),
        ctypes.c_uint32(nonce),
        ctypes.c_uint32(step),
        ctypes.c_uint64(max_hashes),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )
    return int(hit), found.value, hashes.value


def report(label, ok, detail):
    print(f"[{'PASS' if ok else 'FAIL'}] {label}: {detail}")
    return ok


def check_one(lib, prefix, nonce):
    header = prefix + nonce.to_bytes(4, "little")
    digest = hashlib.sha256(hashlib.sha256(header).digest()).digest()
    exact_target = int.from_bytes(digest, "little").to_bytes(32, "little")
    lower_int = int.from_bytes(digest, "little") - 1
    lower_target = lower_int.to_bytes(32, "little")

    print()
    print(f"=== nonce 0x{nonce:08x} ===")
    print(f"header      = {header.hex()}")
    print(f"python_hash = {digest.hex()}")
    print(f"target      = {exact_target.hex()}")

    ok = True

    # Scalar path: if this fails, the generic native SHA256d/target path is wrong.
    hit, found, hashes = call_mine(lib, "b_m_mine", prefix, exact_target, nonce)
    ok &= report(
        "scalar exact-target",
        hit == 1 and found == nonce and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    hit, found, hashes = call_mine(lib, "b_m_mine", prefix, lower_target, nonce)
    ok &= report(
        "scalar target-minus-one",
        hit == 0 and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    # Optimized parallel path: on AArch64+SHA2 this exercises the ARM hardware path.
    hit, found, hashes = call_mine(
        lib, "b_m_mine_parallel", prefix, exact_target, nonce
    )
    ok &= report(
        "parallel exact-target",
        hit == 1 and found == nonce and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    hit, found, hashes = call_mine(
        lib, "b_m_mine_parallel", prefix, lower_target, nonce
    )
    ok &= report(
        "parallel target-minus-one",
        hit == 0 and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    # Extreme target checks isolate comparison behavior.
    max_target = bytes([0xFF]) * 32
    zero_target = bytes(32)

    hit, found, hashes = call_mine(
        lib, "b_m_mine", prefix, max_target, nonce
    )
    ok &= report(
        "scalar max-target",
        hit == 1 and found == nonce and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    hit, found, hashes = call_mine(
        lib, "b_m_mine_parallel", prefix, max_target, nonce
    )
    ok &= report(
        "parallel max-target",
        hit == 1 and found == nonce and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    hit, found, hashes = call_mine(
        lib, "b_m_mine", prefix, zero_target, nonce
    )
    ok &= report(
        "scalar zero-target",
        hit == 0 and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    hit, found, hashes = call_mine(
        lib, "b_m_mine_parallel", prefix, zero_target, nonce
    )
    ok &= report(
        "parallel zero-target",
        hit == 0 and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    return ok


def check_engine(lib, prefix, nonce):
    """Exercise the persistent engine API without networking."""
    header = prefix + nonce.to_bytes(4, "little")
    digest = hashlib.sha256(hashlib.sha256(header).digest()).digest()
    target = int.from_bytes(digest, "little").to_bytes(32, "little")

    engine = lib.b_m_engine_create(ctypes.c_uint32(1))
    if not engine:
        return report("persistent-engine-create", False, "returned NULL")

    try:
        rc = lib.b_m_engine_set_job(engine, ptr(prefix), ptr(target))
        # b_m_engine_set_job() returns 1 on success and 0 on failure.
        if rc != 1:
            return report("persistent-engine-set-job", False, f"rc={rc}")

        found = ctypes.c_uint32(0)
        hashes = ctypes.c_uint64(0)

        # poll() starts/observes the engine's worker and returns a found nonce
        # when the target is hit. This is a diagnostic only; no network is involved.
        for _ in range(100):
            rc = lib.b_m_engine_poll(
                engine, ctypes.byref(found), ctypes.byref(hashes)
            )
            if rc != 0:
                break

        ok = rc != 0 and found.value == nonce and hashes.value >= 1
        return report(
            "persistent-engine exact-target",
            ok,
            f"rc={rc} found=0x{found.value:08x} hashes={hashes.value}",
        )
    finally:
        lib.b_m_engine_stop_job(engine)
        lib.b_m_engine_destroy(engine)


def main_test():
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library could not be built/loaded")
        return 2

    # Same deterministic prefix used by the previous cross-check.
    prefix = bytes(range(76))
    nonces = (0, 1, 0x12345678, 0x80000000, 0xFFFFFFFF)

    all_ok = True
    for nonce in nonces:
        all_ok &= check_one(lib, prefix, nonce)

    print()
    print("=== persistent engine ===")
    all_ok &= check_engine(lib, prefix, 0)

    print()
    if all_ok:
        print("NATIVE SHA256D DIAGNOSTIC: PASS")
        return 0

    print("NATIVE SHA256D DIAGNOSTIC: FAIL")
    print("DO NOT START THE REAL MINER until the failing path is fixed.")
    return 1


if __name__ == "__main__":
    raise SystemExit(main_test())
