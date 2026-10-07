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
    """Independent byte-for-byte cross-check against Python hashlib."""
    header = prefix + nonce.to_bytes(4, "little")
    python_digest = hashlib.sha256(hashlib.sha256(header).digest()).digest()

    # Stable cross-architecture regression vector.
    if prefix == bytes(range(76)) and nonce == 0x12345678:
        golden = "b95e5a66205cb3427c2ab6400bf8bb52bc9f0c8611093385313f7c2d1ad8d079"
        report("golden SHA256d vector", python_digest.hex() == golden,
               "MATCH" if python_digest.hex() == golden else
               "MISMATCH got=" + python_digest.hex())

    scalar_buf = (ctypes.c_uint8 * 32)()
    scalar_base_buf = (ctypes.c_uint8 * 32)()
    optimized_buf = (ctypes.c_uint8 * 32)()
    lib.b_m_debug_sha256d_scalar(ptr(prefix), ctypes.c_uint32(nonce), scalar_buf)
    lib.b_m_debug_sha256d_scalar_base(ptr(prefix), ctypes.c_uint32(nonce), scalar_base_buf)
    lib.b_m_debug_sha256d_optimized(ptr(prefix), ctypes.c_uint32(nonce), optimized_buf)
    scalar_digest = bytes(scalar_buf)
    scalar_base_digest = bytes(scalar_base_buf)
    optimized_digest = bytes(optimized_buf)

    print()
    print(f"=== nonce 0x{nonce:08x} ===")
    print(f"header                 = {header.hex()}")
    print(f"python_hash            = {python_digest.hex()}")
    print(f"native_scalar_full     = {scalar_digest.hex()}")
    print(f"native_scalar_base     = {scalar_base_digest.hex()}")
    print(f"native_optimized       = {optimized_digest.hex()}")

    ok = report("scalar full-header vs Python", scalar_digest == python_digest, "MATCH" if scalar_digest == python_digest else "MISMATCH")
    ok &= report("scalar base-prefix vs Python", scalar_base_digest == python_digest, "MATCH" if scalar_base_digest == python_digest else "MISMATCH")
    ok &= report("scalar full vs base-prefix", scalar_digest == scalar_base_digest, "MATCH" if scalar_digest == scalar_base_digest else "MISMATCH")
    ok &= report("optimized vs Python", optimized_digest == python_digest, "MATCH" if optimized_digest == python_digest else "MISMATCH")
    ok &= report("optimized vs scalar-base", optimized_digest == scalar_base_digest, "MATCH" if optimized_digest == scalar_base_digest else "MISMATCH")

    # Boundary semantics are tested independently of the digest cross-check.
    exact_target = python_digest
    lower_target = (int.from_bytes(python_digest, "little") - 1).to_bytes(32, "little")

    hit, found, hashes = call_mine(
        lib, "b_mine" if False else "b_m_mine",
        prefix, exact_target, nonce
    )
    ok &= report(
        "scalar exact-target",
        hit == 1 and found == nonce and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

    hit, found, hashes = call_mine(
        lib, "b_m_mine", prefix, lower_target, nonce
    )
    ok &= report(
        "scalar target-minus-one",
        hit == 0 and hashes == 1,
        f"hit={hit} found=0x{found:08x} hashes={hashes}",
    )

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

        if rc != 0:
            found_header = prefix + found.value.to_bytes(4, "little")
            found_digest = hashlib.sha256(hashlib.sha256(found_header).digest()).digest()
            target_int = int.from_bytes(target, "little")
            found_int = int.from_bytes(found_digest, "little")
            ok = hashes.value >= 1 and found_int <= target_int
        else:
            ok = False
        return report(
            "persistent-engine valid-target",
            ok,
            f"rc={rc} found=0x{found.value:08x} hashes={hashes.value}",
        )
    finally:
        lib.b_m_engine_stop_job(engine)
        lib.b_m_engine_destroy(engine)


def check_compact_target():
    """Verify the Python nBits decoder against canonical Bitcoin values."""
    ok = True
    expected = 0x00000000FFFF0000000000000000000000000000000000000000000000000000
    try:
        got = main.compact_to_target("1d00ffff")
        ok &= report("compact nBits 1d00ffff", got == expected,
                     "target=0x%064x" % got)
    except Exception as exc:
        ok &= report("compact nBits 1d00ffff", False, str(exc))

    for bad in ("00000000", "01003456", "1d80ffff", "zzzzzzzz", "1"):
        try:
            main.compact_to_target(bad)
            ok &= report("compact invalid %s" % bad, False,
                         "accepted invalid nBits")
        except ValueError:
            ok &= report("compact invalid %s" % bad, True, "rejected")
    return ok


def main_test():
    all_ok = check_compact_target()
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library could not be built/loaded")
        return 2

    # Same deterministic prefix used by the previous cross-check.
    prefix = bytes(range(76))
    nonces = (0, 1, 0x12345678, 0x80000000, 0xFFFFFFFF)

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
