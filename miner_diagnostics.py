"""Optional, low-overhead diagnostics for the CPU solo miner.

The module has no third-party dependencies. Memory usage is best-effort and
uses psutil when installed, /proc on Linux/Android, or resource on Unix.
"""
import os
try:
    import resource
except ImportError:  # Windows
    resource = None
import threading


def memory_snapshot():
    result = {"pid": os.getpid()}
    try:
        import psutil  # Optional dependency only; miner works without it.
        process = psutil.Process()
        result["rss_bytes"] = process.memory_info().rss
        result["process_count"] = len(process.children(recursive=True)) + 1
        # Count OS threads, including native pthreads created by the C miner.
        result["thread_count"] = process.num_threads()
        result["memory_source"] = "psutil"
        return result
    except Exception:
        # Diagnostics must never interrupt mining if an optional provider fails.
        pass

    try:
        with open("/proc/self/status", "r", encoding="utf-8") as handle:
            for line in handle:
                if line.startswith("VmRSS:"):
                    result["rss_bytes"] = int(line.split()[1]) * 1024
                    result["memory_source"] = "/proc/self/status"
                elif line.startswith("Threads:"):
                    # /proc reports all process threads, not just Python threads.
                    result["thread_count"] = int(line.split()[1])
    except (OSError, ValueError, IndexError):
        pass

    # Last-resort fallback for platforms without psutil or /proc.
    result.setdefault("thread_count", threading.active_count())

    try:
        if resource is not None:
            # ru_maxrss is KiB on Linux, bytes on macOS.
            peak = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
            result["peak_rss_bytes"] = int(
                peak if os.sys.platform == "darwin" else peak * 1024
            )
    except (AttributeError, OSError, ValueError):
        pass
    return result


def worker_count_snapshot(configured_threads=None):
    try:
        import multiprocessing
        return {
            "active_children": len(multiprocessing.active_children()),
            "configured_threads": configured_threads or os.getenv("CPU_THREADS", "auto"),
        }
    except (ImportError, RuntimeError):
        return {"configured_threads": os.getenv("CPU_THREADS", "auto")}
