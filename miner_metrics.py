"""Thread-safe runtime metrics independent of Stratum state."""

import threading
import time


class MinerMetrics:
    def __init__(self):
        self._lock = threading.Lock()
        self._started = time.monotonic()
        self._hashes = 0
        self._submitted = 0
        self._accepted = 0
        self._rejected = 0

    def add_hashes(self, count):
        with self._lock:
            self._hashes += max(0, int(count))

    def share_submitted(self):
        with self._lock:
            self._submitted += 1

    def share_result(self, accepted):
        with self._lock:
            if accepted:
                self._accepted += 1
            else:
                self._rejected += 1

    def snapshot(self):
        with self._lock:
            return {
                "uptime_s": round(time.monotonic() - self._started, 3),
                "hashes": self._hashes,
                "shares_submitted": self._submitted,
                "shares_accepted": self._accepted,
                "shares_rejected": self._rejected,
            }
