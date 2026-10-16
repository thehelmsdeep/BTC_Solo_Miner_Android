"""Structured event logging with rotating human-readable and JSONL logs."""

import json
import logging
import os
import threading
import time
from logging.handlers import RotatingFileHandler


class StructuredLogger:
    def __init__(
        self,
        human_path="miner.log",
        event_path="miner-events.jsonl",
        debug_path="miner-debug.log",
        max_bytes=5 * 1024 * 1024,
        backup_count=3,
    ):
        self.human_path = human_path
        self.event_path = event_path
        self.debug_path = debug_path
        self.max_bytes = max_bytes
        self.backup_count = backup_count
        self._lock = threading.Lock()
        self._error_count = 0
        self._warning_count = 0
        self._mining_started_at = time.monotonic()
        self._last_error_text = "None"
        self._last_warning_text = "None"

        self._human_logger = logging.getLogger("solo_miner.human")
        self._human_logger.setLevel(logging.INFO)
        self._human_logger.propagate = False
        self._debug_logger = logging.getLogger("solo_miner.debug")
        self._debug_logger.setLevel(logging.DEBUG)
        self._debug_logger.propagate = False

        for logger, path, level in (
            (self._human_logger, self.human_path, logging.INFO),
            (self._debug_logger, self.debug_path, logging.DEBUG),
        ):
            logger.setLevel(level)
            logger.propagate = False
            for handler in list(logger.handlers):
                logger.removeHandler(handler)
                handler.close()
            handler = RotatingFileHandler(
                path, maxBytes=max_bytes, backupCount=backup_count,
                encoding="utf-8",
            )
            handler.setFormatter(logging.Formatter(
                "%(asctime)s %(levelname)s %(message)s"
            ))
            logger.addHandler(handler)

    def log(self, message):
        self._human_logger.info("%s", str(message))

    def record_error(self, message, **fields):
        """Record a bug/error for the live dashboard and persistent logs."""
        with self._lock:
            self._error_count += 1
            count = self._error_count
            self._last_error_text = str(message)
        duration = max(0.0, time.monotonic() - self._mining_started_at)
        self._human_logger.error(
            "ERROR_COUNT=%d | ERROR_TEXT=%s | MINING_DURATION=%s",
            count, str(message), self._format_duration(duration),
        )
        self.event("runtime_error", severity="error", error_count=count,
                   error_text=str(message),
                   mining_duration_seconds=round(duration, 3), **fields)
        return count

    def record_warning(self, message, **fields):
        """Record a warning for the live dashboard and persistent logs."""
        with self._lock:
            self._warning_count += 1
            count = self._warning_count
            self._last_warning_text = str(message)
        duration = max(0.0, time.monotonic() - self._mining_started_at)
        self._human_logger.warning(
            "WARNING_COUNT=%d | WARNING_TEXT=%s | MINING_DURATION=%s",
            count, str(message), self._format_duration(duration),
        )
        self.event("runtime_warning", severity="warning", warning_count=count,
                   warning_text=str(message),
                   mining_duration_seconds=round(duration, 3), **fields)
        return count

    @staticmethod
    def classify_issue(message):
        """Return 'error', 'warning', or None for issue-like log messages."""
        text = str(message).lower()
        warning_terms = (
            "warning", "warn:", "[?]", "timeout", "timed out", "rejected",
            "nonce space exhausted", "stale", "unknown", "fallback",
            "unavailable", "reconnect", "disconnected", "connection closed",
            "candidate detected",
        )
        error_terms = (
            "error", "failed", "failure", "exception", "traceback", "invalid",
            "malformed", "unable", "critical", "crash", "not submitting",
            "verification failed", "worker error", "handler error",
            "authorization failed", "self-test: failed", "self-test failed",
            "build failed", "load failed",
        )
        if any(term in text for term in error_terms):
            return "error"
        if any(term in text for term in warning_terms) or "[!]" in text:
            return "warning"
        return None

    def report_issue(self, message, **fields):
        """Classify and count an issue once per explicit reporting call."""
        severity = self.classify_issue(message)
        if severity == "error":
            return self.record_error(message, **fields)
        if severity == "warning":
            return self.record_warning(message, **fields)
        return None

    @staticmethod
    def _format_duration(seconds):
        total = int(seconds)
        hours, remainder = divmod(total, 3600)
        minutes, secs = divmod(remainder, 60)
        return "%02d:%02d:%02d" % (hours, minutes, secs)

    def dashboard_snapshot(self):
        with self._lock:
            count = self._error_count
            last_error = self._last_error_text
            warning_count = self._warning_count
            last_warning = self._last_warning_text
        duration = max(0.0, time.monotonic() - self._mining_started_at)
        return {
            "error_count": count,
            "last_error": last_error,
            "warning_count": warning_count,
            "last_warning": last_warning,
            "mining_duration": self._format_duration(duration),
            "mining_duration_seconds": round(duration, 3),
        }

    def log_mining_status(self, **fields):
        duration = max(0.0, time.monotonic() - self._mining_started_at)
        with self._lock:
            count = self._error_count
        self.event("mining_status", error_count=count,
                   mining_duration=self._format_duration(duration),
                   mining_duration_seconds=round(duration, 3), **fields)

    def debug(self, message, **fields):
        detail = json.dumps(fields, sort_keys=True, default=str) if fields else ""
        self._debug_logger.debug("%s%s", str(message), (" | " + detail) if detail else "")
        self.event("debug", message=str(message), **fields)

    def event(self, name, **fields):
        record = {"ts": time.time(), "event": str(name), **fields}
        with self._lock:
            try:
                if os.path.exists(self.event_path) and os.path.getsize(self.event_path) >= self.max_bytes:
                    oldest = "%s.%d" % (self.event_path, self.backup_count)
                    if os.path.exists(oldest):
                        os.remove(oldest)
                    for index in range(self.backup_count - 1, 0, -1):
                        source = "%s.%d" % (self.event_path, index)
                        target = "%s.%d" % (self.event_path, index + 1)
                        if os.path.exists(source):
                            os.replace(source, target)
                    os.replace(self.event_path, "%s.1" % self.event_path)
            except OSError:
                # Logging must never crash mining if rotation fails.
                pass
            with open(self.event_path, "a", encoding="utf-8") as handle:
                handle.write(json.dumps(
                    record, sort_keys=True, separators=(",", ":"), default=str
                ) + "\n")
        return record
