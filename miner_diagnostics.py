"""Optional, low-overhead diagnostics for the CPU solo miner.

The module has no third-party dependencies. Memory usage is best-effort and
uses psutil when installed, /proc on Linux/Android, or resource on Unix.
"""
import os
import resource
import threading
import time


def memory_snapshot():
    result = {
        "pid": os.getpid(),
        "thread_count": threading.active_count(),
    }
    try:
        import psutil  # Optional dependency only; miner works without it.
        process = psutil.Process()
        result["rss_bytes"] = process.memory_info().rss
        result["process_count"] = len(psutil.Process().children(recursive=True)) + 1
        result["memory_source"] = "psutil"
        return result
    except (ImportError, OSError, RuntimeError):
        pass

    try:
        with open("/proc/self/status", "r", encoding="utf-8") as handle:
            for line in handle:
                if line.startswith("VmRSS:"):
                    result["rss_bytes"] = int(line.split()[1]) * 1024
                    result["memory_source"] = "/proc/self/status"
                    break
    except (OSError, ValueError, IndexError):
        pass

    try:
        # ru_maxrss is KiB on Linux, bytes on macOS.
        peak = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
        result["peak_rss_bytes"] = int(peak if os.sys.platform == "darwin" else peak * 1024)
    except (AttributeError, OSError, ValueError):
        pass
    return result


def worker_count_snapshot():
    try:
        import multiprocessing
        return {
            "active_children": len(multiprocessing.active_children()),
            "configured_threads": os.getenv("CPU_THREADS", "auto"),
        }
    except (ImportError, RuntimeError):
        return {"configured_threads": os.getenv("CPU_THREADS", "auto")}
