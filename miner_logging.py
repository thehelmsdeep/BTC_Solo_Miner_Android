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
