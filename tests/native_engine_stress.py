#!/usr/bin/env python3
"""Persistent native-engine stress test.

Offline only: repeatedly replaces jobs while workers are active, stops jobs,
restarts them, and validates every reported nonce independently with hashlib.
"""

import ctypes
import hashlib
import pathlib
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import main  # noqa: E402


def ptr(data):
    return (ctypes.c_uint8 * len(data)).from_buffer_copy(data)


def digest(prefix, nonce):
    h = prefix + nonce.to_bytes(4, "little")
    return hashlib.sha256(hashlib.sha256(h).digest()).digest()


def run():
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library unavailable")
        return 2

    prefix = bytes(range(76))
    engine = lib.b_m_engine_create(ctypes.c_uint32(8))
    if not engine:
        print("FAIL: engine create")
        return 1

    found = ctypes.c_uint32()
    hashes = ctypes.c_uint64()
    jobs = 0
    hits = 0
    total = 0

    try:
        for i in range(200):
            # Make nonce 0 valid for every job by using its exact digest as target.
            nonce = (i * 0x10203) & 0xffffffff
            target = digest(prefix, nonce)

            if lib.b_m_engine_set_job(engine, ptr(prefix), ptr(target)) != 1:
                print(f"FAIL: set_job iteration={i}")
                return 1
            jobs += 1

            deadline = time.monotonic() + 1.0
            hit = 0
            while time.monotonic() < deadline:
                h = ctypes.c_uint64()
                f = ctypes.c_uint32()
                rc = lib.b_m_engine_poll(engine, ctypes.byref(f), ctypes.byref(h))
                total += h.value
                if rc:
                    got = digest(prefix, f.value)
                    if int.from_bytes(got, "little") > int.from_bytes(target, "little"):
                        print(f"FAIL: invalid nonce iteration={i} nonce=0x{f.value:08x}")
                        return 1
                    hits += 1
                    hit = 1
                    break
                time.sleep(0.001)

            lib.b_m_engine_stop_job(engine)

            if not hit:
                print(f"FAIL: no result iteration={i}")
                return 1

        print(f"PERSISTENT ENGINE STRESS: PASS jobs={jobs} hits={hits} hashes={total}")
        return 0
    finally:
        lib.b_m_engine_destroy(engine)


if __name__ == "__main__":
    raise SystemExit(run())
