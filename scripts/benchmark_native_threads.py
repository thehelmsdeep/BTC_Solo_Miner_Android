#!/usr/bin/env python3
"""Benchmark the persistent native mining engine without connecting to a pool.

Uses a synthetic header and an all-zero target, so a valid hit is practically
impossible. Results are hashes/second for the exact engine path used by mining.
"""
from __future__ import annotations

import argparse
import ctypes
import os
import pathlib
import platform
import shutil
import subprocess
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
NATIVE = ROOT / "native"
SOURCE = NATIVE / "sha256_engine.c"
LIBRARY = NATIVE / "libb_m_bench.so"


def build_library() -> None:
    compiler = shutil.which("clang") or shutil.which("gcc") or shutil.which("cc")
    if not compiler:
        raise RuntimeError("No C compiler found. Install clang in Termux: pkg install clang")

    machine = platform.machine().lower()
    march = "armv8-a+crypto" if machine in ("aarch64", "arm64") else "native"
    command = [
        compiler, "-O3", f"-march={march}", "-mtune=native",
        "-flto", "-funroll-loops", "-fomit-frame-pointer", "-DNDEBUG",
        "-fPIC", "-shared", "-pthread", "-o", str(LIBRARY), str(SOURCE),
    ]
    print("Building benchmark library...")
    subprocess.run(command, check=True)


def load_library() -> ctypes.CDLL:
    lib = ctypes.CDLL(str(LIBRARY))
    byte_ptr = ctypes.POINTER(ctypes.c_uint8)
    lib.b_m_engine_create.argtypes = [ctypes.c_uint32]
    lib.b_m_engine_create.restype = ctypes.c_void_p
    lib.b_m_engine_set_job.argtypes = [ctypes.c_void_p, byte_ptr, byte_ptr]
    lib.b_m_engine_set_job.restype = ctypes.c_int
    lib.b_m_engine_poll.argtypes = [
        ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32),
        ctypes.POINTER(ctypes.c_uint64),
    ]
    lib.b_m_engine_poll.restype = ctypes.c_int
    lib.b_m_engine_stop_job.argtypes = [ctypes.c_void_p]
    lib.b_m_engine_stop_job.restype = None
    lib.b_m_engine_destroy.argtypes = [ctypes.c_void_p]
    lib.b_m_engine_destroy.restype = None
    return lib


def poll_hashes(lib: ctypes.CDLL, engine: int) -> int:
    found = ctypes.c_uint32()
    hashes = ctypes.c_uint64()
    lib.b_m_engine_poll(engine, ctypes.byref(found), ctypes.byref(hashes))
    if found.value:
        raise RuntimeError("Synthetic zero-target benchmark unexpectedly found a nonce")
    return hashes.value


def benchmark(lib: ctypes.CDLL, threads: int, warmup: float, seconds: float) -> float:
    prefix = (ctypes.c_uint8 * 76)(*[(i * 37 + 11) & 0xFF for i in range(76)])
    target = (ctypes.c_uint8 * 32)(*([0] * 32))
    engine = lib.b_m_engine_create(threads)
    if not engine:
        raise RuntimeError(f"Could not create engine with {threads} threads")
    try:
        if not lib.b_m_engine_set_job(engine, prefix, target):
            raise RuntimeError("Could not set synthetic benchmark job")

        warmup_end = time.monotonic() + warmup
        while time.monotonic() < warmup_end:
            poll_hashes(lib, engine)
            time.sleep(0.1)
        poll_hashes(lib, engine)

        hashes = 0
        start = time.monotonic()
        deadline = start + seconds
        while time.monotonic() < deadline:
            time.sleep(0.2)
            hashes += poll_hashes(lib, engine)
        elapsed = time.monotonic() - start
        hashes += poll_hashes(lib, engine)
        return hashes / elapsed
    finally:
        lib.b_m_engine_stop_job(engine)
        lib.b_m_engine_destroy(engine)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--threads", default="1,2,4,6,8",
                        help="comma-separated thread counts (default: 1,2,4,6,8)")
    parser.add_argument("--warmup", type=float, default=1.0,
                        help="warm-up seconds per setting (default: 1)")
    parser.add_argument("--seconds", type=float, default=3.0,
                        help="measurement seconds per setting (default: 3)")
    args = parser.parse_args()

    try:
        counts = sorted({int(item.strip()) for item in args.threads.split(",")})
        if not counts or any(count < 1 or count > 64 for count in counts):
            raise ValueError("Thread counts must be between 1 and 64")
        if args.warmup < 0.0 or args.seconds < 1.0:
            raise ValueError("--warmup must be >= 0 and --seconds must be >= 1")
        build_library()
        lib = load_library()
        print("Native engine benchmark (no pool connection; synthetic zero target)")
        print(f"CPU: {platform.machine()} | warmup={args.warmup:.1f}s | test={args.seconds:.1f}s")
        results = []
        for count in counts:
            rate = benchmark(lib, count, args.warmup, args.seconds)
            results.append((count, rate))
            print(f"threads={count:2d}  {rate / 1_000_000:8.3f} MH/s")
        best = max(results, key=lambda item: item[1])
        print(f"BEST: {best[0]} threads at {best[1] / 1_000_000:.3f} MH/s")
        print("Tip: repeat once while cool and once after several minutes to detect thermal throttling.")
        return 0
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        print(f"Benchmark failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
