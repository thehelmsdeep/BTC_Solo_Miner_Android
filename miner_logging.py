"""Structured event logging with a human-readable compatibility log."""

import json
import logging
import threading
import time


class StructuredLogger:
    def __init__(self, human_path="miner.log", event_path="miner-events.jsonl"):
        self.human_path = human_path
        self.event_path = event_path
        self._lock = threading.Lock()
        logging.basicConfig(
            level=logging.INFO,
            filename=self.human_path,
            format="%(asctime)s %(message)s",
        )

    def log(self, message):
        logging.info(str(message))

    def event(self, name, **fields):
        record = {
            "ts": time.time(),
            "event": str(name),
            **fields,
        }
        with self._lock:
            with open(self.event_path, "a", encoding="utf-8") as handle:
                handle.write(json.dumps(
                    record, sort_keys=True, separators=(",", ":")
                ) + "\n")
        return record
