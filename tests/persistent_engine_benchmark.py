#!/usr/bin/env python3
"""Benchmark the persistent engine used by normal mining (offline; no pool).

Uses an all-zero target so no share can be found or submitted. Unlike
native_engine_benchmark.py, this measures b_m_engine_* rather than the
one-shot b_m_mine_parallel helper.
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


def byte_array(data: bytes):
    return (ctypes.c_uint8 * len(data)).from_buffer_copy(data)


def configure(lib):
    u8p = ctypes.POINTER(ctypes.c_uint8)
    lib.b_m_engine_create.argtypes = [ctypes.c_uint32]
    lib.b_m_engine_create.restype = ctypes.c_void_p
    lib.b_m_engine_set_job.argtypes = [ctypes.c_void_p, u8p, u8p]
    lib.b_m_engine_set_job.restype = ctypes.c_int
    lib.b_m_engine_poll.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_uint32),
        ctypes.POINTER(ctypes.c_uint64),
    ]
    lib.b_m_engine_poll.restype = ctypes.c_int
    lib.b_m_engine_stop_job.argtypes = [ctypes.c_void_p]
    lib.b_m_engine_destroy.argtypes = [ctypes.c_void_p]


def run_once(lib, threads: int, seconds: float, run_no: int) -> float:
    prefix = byte_array(bytes((i * 37 + 11) & 0xFF for i in range(76)))
    target = byte_array(bytes(32))  # effectively impossible target
    engine = lib.b_m_engine_create(threads)
    if not engine:
        raise RuntimeError(f"engine create failed for {threads} threads")

    found = ctypes.c_uint32()
    delta = ctypes.c_uint64()
    total = 0
    started = time.perf_counter()
    try:
        if lib.b_m_engine_set_job(engine, prefix, target) != 1:
            raise RuntimeError("engine rejected benchmark job")

        while time.perf_counter() - started < seconds:
            if lib.b_m_engine_poll(engine, ctypes.byref(found), ctypes.byref(delta)):
                raise RuntimeError("impossible target unexpectedly hit")
            total += delta.value
            time.sleep(0.01)

        lib.b_m_engine_stop_job(engine)

        # Let workers finish their current short polling interval and flush
        # per-thread counters before taking the final sample.
        stable_reads = 0
        while stable_reads < 3:
            time.sleep(0.02)
            if lib.b_m_engine_poll(engine, ctypes.byref(found), ctypes.byref(delta)):
                raise RuntimeError("impossible target unexpectedly hit")
            total += delta.value
            if delta.value:
                stable_reads = 0
            else:
                stable_reads += 1

        elapsed = time.perf_counter() - started
        if total <= 0 or elapsed <= 0:
            raise RuntimeError("engine reported no hashes")
        rate = total / elapsed
        print(
            f"Run {run_no}: hashes={total:,} elapsed={elapsed:.3f}s "
            f"rate={rate / 1_000_000:.3f} MH/s"
        )
        return rate
    finally:
        lib.b_m_engine_destroy(engine)


def main_benchmark():
    parser = argparse.ArgumentParser()
    parser.add_argument("--threads", type=int, default=8)
    parser.add_argument("--seconds", type=float, default=10.0)
    parser.add_argument("--repeats", type=int, default=3)
    args = parser.parse_args()
    if args.threads < 1 or args.seconds <= 0 or args.repeats < 1:
        parser.error("threads/repeats must be positive and seconds must be > 0")

    lib = main.ensure_native()
    if lib is None:
        raise SystemExit("Native engine unavailable; refusing Python fallback.")
    configure(lib)
    print(
        f"Architecture: {platform.machine().lower()}; threads={args.threads}; "
        f"seconds/run={args.seconds:g}; repeats={args.repeats}"
    )
    print("Engine: persistent production engine; target: all-zero (offline)")
    rates = [
        run_once(lib, args.threads, args.seconds, run_no)
        for run_no in range(1, args.repeats + 1)
    ]
    print(f"Median: {statistics.median(rates) / 1_000_000:.3f} MH/s")
    print("For comparisons, keep phone temperature, power, screen, and thread count identical.")


if __name__ == "__main__":
    main_benchmark()
