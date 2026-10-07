#!/usr/bin/env python3
"""Stage 4: reproducible offline native SHA256d performance benchmark.

Measures the persistent native engine at multiple thread counts.  No network
access is used and the target is deliberately impossible, so the benchmark
runs for a fixed duration rather than stopping on a PoW hit.

Examples:
  python tests/performance_benchmark.py
  python tests/performance_benchmark.py --duration 3 --repeats 3
  python tests/performance_benchmark.py --duration 5 --repeats 2 --sustained 60
  python tests/performance_benchmark.py --threads 1,2,4,8 --json results.json
"""

import argparse
import ctypes
import json
import os
import pathlib
import platform
import statistics
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import main


def read_text(path):
    try:
        return pathlib.Path(path).read_text(errors="replace").strip()
    except (OSError, ValueError):
        return None


def cpu_snapshot():
    info = {
        "machine": platform.machine(),
        "system": platform.system(),
        "release": platform.release(),
        "python": platform.python_version(),
        "logical_cpus": os.cpu_count() or 1,
    }

    model = None
    cpuinfo = read_text("/proc/cpuinfo")
    if cpuinfo:
        for line in cpuinfo.splitlines():
            low = line.lower()
            if low.startswith("model name") or low.startswith("hardware") or low.startswith("model"):
                model = line.split(":", 1)[-1].strip()
                if model:
                    break
    if model:
        info["cpu_model"] = model

    freq = read_text("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq")
    if freq and freq.isdigit():
        info["cpu0_freq_khz"] = int(freq)

    governors = []
    for p in pathlib.Path("/sys/devices/system/cpu").glob("cpu[0-9]*/cpufreq/scaling_governor"):
        value = read_text(p)
        if value:
            governors.append(value)
    if governors:
        info["governors"] = sorted(set(governors))

    return info


def thermal_snapshot():
    zones = []
    root = pathlib.Path("/sys/class/thermal")
    for temp_file in sorted(root.glob("thermal_zone*/temp")):
        value = read_text(temp_file)
        if not value:
            continue
        try:
            raw = int(value)
        except ValueError:
            continue
        zone_dir = temp_file.parent
        zone_type = read_text(zone_dir / "type")
        temp_c = raw / 1000.0 if abs(raw) > 1000 else float(raw)
        zones.append({
            "zone": zone_dir.name,
            "type": zone_type or "unknown",
            "temp_c": round(temp_c, 2),
        })
    return zones


def parse_threads(value, maximum):
    if value == "auto":
        counts = []
        n = 1
        while n <= maximum:
            counts.append(n)
            n *= 2
        if counts[-1] != maximum:
            counts.append(maximum)
        return counts

    counts = []
    for item in value.split(","):
        n = int(item.strip())
        if n < 1 or n > 64:
            raise ValueError("thread count must be between 1 and 64")
        if n not in counts:
            counts.append(n)
    return counts


def native_engine(lib, threads, duration):
    prefix = (ctypes.c_uint8 * 76).from_buffer_copy(
        bytes(range(76))
    )
    # Zero is below every valid SHA256d integer, so no nonce can ever hit it.
    target = (ctypes.c_uint8 * 32).from_buffer_copy(bytes(32))

    lib.b_m_engine_create.argtypes = [ctypes.c_uint32]
    lib.b_m_engine_create.restype = ctypes.c_void_p
    lib.b_m_engine_set_job.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint8), ctypes.POINTER(ctypes.c_uint8)]
    lib.b_m_engine_set_job.restype = ctypes.c_int
    lib.b_m_engine_poll.argtypes = [
        ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32),
        ctypes.POINTER(ctypes.c_uint64)
    ]
    lib.b_m_engine_poll.restype = ctypes.c_int
    lib.b_m_engine_stop_job.argtypes = [ctypes.c_void_p]
    lib.b_m_engine_stop_job.restype = None
    lib.b_m_engine_destroy.argtypes = [ctypes.c_void_p]
    lib.b_m_engine_destroy.restype = None

    engine = lib.b_m_engine_create(ctypes.c_uint32(threads))
    if not engine:
        raise RuntimeError("native engine creation failed")

    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)
    total = 0
    started = time.perf_counter()
    try:
        if not lib.b_m_engine_set_job(engine, prefix, target):
            raise RuntimeError("native engine set_job failed")

        # Let worker threads reach steady state before timing.
        warmup_end = time.perf_counter() + min(0.20, max(0.05, duration * 0.10))
        while time.perf_counter() < warmup_end:
            lib.b_m_engine_poll(engine, ctypes.byref(found), ctypes.byref(hashes))

        total = 0
        started = time.perf_counter()
        deadline = started + duration
        while time.perf_counter() < deadline:
            lib.b_m_engine_poll(engine, ctypes.byref(found), ctypes.byref(hashes))
            total += hashes.value
            time.sleep(0.005)

        lib.b_m_engine_stop_job(engine)
        # Workers may still be finishing their current nonce after stop_job.
        # Require several consecutive empty polls before declaring the counter
        # drained, rather than stopping on the first transient zero.
        empty_polls = 0
        for _ in range(250):
            lib.b_m_engine_poll(engine, ctypes.byref(found), ctypes.byref(hashes))
            total += hashes.value
            if hashes.value == 0:
                empty_polls += 1
                if empty_polls >= 5:
                    break
            else:
                empty_polls = 0
            time.sleep(0.002)

        elapsed = time.perf_counter() - started
        return total, elapsed
    finally:
        lib.b_m_engine_destroy(engine)


def one_run(lib, threads, duration):
    before_thermal = thermal_snapshot()
    before_cpu = cpu_snapshot()
    hashes, elapsed = native_engine(lib, threads, duration)
    after_thermal = thermal_snapshot()
    after_cpu = cpu_snapshot()
    return {
        "threads": threads,
        "hashes": hashes,
        "elapsed_s": round(elapsed, 6),
        "hashrate_hps": hashes / max(elapsed, 1e-9),
        "cpu_before": before_cpu,
        "cpu_after": after_cpu,
        "thermal_before": before_thermal,
        "thermal_after": after_thermal,
    }


def summarize(runs):
    rates = [r["hashrate_hps"] for r in runs]
    return {
        "threads": runs[0]["threads"],
        "repeats": len(runs),
        "median_hps": statistics.median(rates),
        "min_hps": min(rates),
        "max_hps": max(rates),
        "runs": runs,
    }


def sustained(lib, threads, duration):
    before = thermal_snapshot()
    cpu_before = cpu_snapshot()
    hashes, elapsed = native_engine(lib, threads, duration)
    after = thermal_snapshot()
    cpu_after = cpu_snapshot()
    return {
        "threads": threads,
        "duration_s": round(elapsed, 6),
        "hashes": hashes,
        "hashrate_hps": hashes / max(elapsed, 1e-9),
        "cpu_before": cpu_before,
        "cpu_after": cpu_after,
        "thermal_before": before,
        "thermal_after": after,
    }


def main_test():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--threads", default="auto",
                        help="comma-separated counts or auto (default: powers of two + CPU count)")
    parser.add_argument("--duration", type=float, default=2.0,
                        help="seconds per measured run (default: 2)")
    parser.add_argument("--repeats", type=int, default=2,
                        help="measured runs per thread count (default: 2)")
    parser.add_argument("--sustained", type=float, default=0.0,
                        help="optional final sustained run in seconds; 0 disables it")
    parser.add_argument("--json", dest="json_path",
                        help="write complete machine-readable results to this path")
    args = parser.parse_args()

    if args.duration <= 0 or args.repeats < 1 or args.sustained < 0:
        parser.error("duration > 0, repeats >= 1, sustained >= 0 required")

    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library unavailable")
        return 2

    maximum = min(64, max(1, os.cpu_count() or 1))
    try:
        threads = parse_threads(args.threads, maximum)
    except ValueError as exc:
        parser.error(str(exc))

    print("STAGE 4 PERFORMANCE RESEARCH")
    print("Architecture: %s | logical CPUs: %d" % (platform.machine(), maximum))
    print("Target: 00...00 (impossible PoW target; no early hit)")
    print("Threads: %s | duration: %.2fs | repeats: %d" %
          (",".join(map(str, threads)), args.duration, args.repeats))

    summaries = []
    for count in threads:
        runs = []
        for rep in range(args.repeats):
            run = one_run(lib, count, args.duration)
            runs.append(run)
            print("  %2dT run %d/%d: %,.2f H/s (%d hashes)" %
                  (count, rep + 1, args.repeats, run["hashrate_hps"], run["hashes"]))
        summary = summarize(runs)
        summaries.append(summary)

    baseline = summaries[0]["median_hps"]
    print("")
    print("THREAD SCALING")
    print("%-8s %-16s %-14s %-14s" % ("Threads", "Median H/s", "Speedup", "Efficiency"))
    for item in summaries:
        speedup = item["median_hps"] / max(baseline, 1e-9)
        efficiency = speedup / item["threads"] * 100.0
        item["speedup_vs_1t"] = speedup
        item["scaling_efficiency_pct"] = efficiency
        print("%-8d %,-16.2f %-14.3fx %-14.1f%%" %
              (item["threads"], item["median_hps"], speedup, efficiency))

    sustained_result = None
    if args.sustained:
        count = threads[-1]
        print("")
        print("SUSTAINED RUN: %d threads for %.1fs" % (count, args.sustained))
        sustained_result = sustained(lib, count, args.sustained)
        print("  %dT: %,.2f H/s | %d hashes" %
              (count, sustained_result["hashrate_hps"], sustained_result["hashes"]))
        if sustained_result["thermal_before"] or sustained_result["thermal_after"]:
            print("  thermal before:", sustained_result["thermal_before"])
            print("  thermal after: ", sustained_result["thermal_after"])
        else:
            print("  thermal sensors: unavailable")

    result = {
        "schema": "stage4-performance-v1",
        "timestamp_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "benchmark": {
            "duration_s": args.duration,
            "repeats": args.repeats,
            "threads": threads,
            "target": "00" * 32,
            "sustained_s": args.sustained,
        },
        "system": cpu_snapshot(),
        "thermal": thermal_snapshot(),
        "results": summaries,
        "sustained": sustained_result,
    }

    if args.json_path:
        path = pathlib.Path(args.json_path)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(result, indent=2) + "\n")
        print("JSON: %s" % path)

    return 0


if __name__ == "__main__":
    raise SystemExit(main_test())
