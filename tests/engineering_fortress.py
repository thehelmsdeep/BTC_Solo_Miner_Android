#!/usr/bin/env python3
"""Stage 5 offline engineering regression suite."""

import os
import sys
import threading
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)

from miner_logging import StructuredLogger
from miner_config import MinerConfig
from miner_metrics import MinerMetrics
from miner_state import MinerState, MinerStateMachine


def check(name, condition, detail=""):
    if not condition:
        raise AssertionError(
            "FAIL: %s%s" % (name, (" | " + detail) if detail else "")
        )
    print("PASS: %s%s" % (name, (" | " + detail) if detail else ""))


def test_config():
    original = dict(os.environ)
    try:
        os.environ["CPU_THREADS"] = "8"
        os.environ["NONCE_BATCH"] = "50000"
        os.environ["BM_NATIVE"] = "false"
        config = MinerConfig()
        check("configuration parsing", config.cpu_threads == 8)
        check("configuration minimums", config.nonce_batch == 50000)
        check("configuration native toggle", config.native_enabled is False)
        check("configuration serialization",
              config.as_dict()["upstream_host"] == "solo.ckpool.org")
    finally:
        os.environ.clear()
        os.environ.update(original)


def test_state_machine():
    sm = MinerStateMachine()
    expected = [
        MinerState.CONNECTING,
        MinerState.CONNECTED,
        MinerState.MINING,
        MinerState.RECONNECTING,
        MinerState.CONNECTING,
        MinerState.STOPPED,
    ]
    for state in expected:
        sm.transition(state)
    check("state machine lifecycle", sm.state == MinerState.STOPPED)

    failed = False
    try:
        sm.transition(MinerState.MINING)
    except ValueError:
        failed = True
    check("state machine rejects invalid transition", failed)


def test_metrics():
    metrics = MinerMetrics()
    threads = []

    def worker():
        for _ in range(1000):
            metrics.add_hashes(8)
            metrics.share_submitted()
            metrics.share_result(True)

    for _ in range(4):
        thread = threading.Thread(target=worker)
        threads.append(thread)
        thread.start()
    for thread in threads:
        thread.join()

    snapshot = metrics.snapshot()
    check("metrics concurrent hashes", snapshot["hashes"] == 32000)
    check("metrics concurrent submissions", snapshot["shares_submitted"] == 4000)
    check("metrics concurrent accepts", snapshot["shares_accepted"] == 4000)
    check("metrics rejected baseline", snapshot["shares_rejected"] == 0)


def test_structured_logging():
    with tempfile.NamedTemporaryFile() as handle:
        logger = StructuredLogger(
            human_path=handle.name,
            event_path=handle.name + ".jsonl",
        )
        record = logger.event("test_event", threads=8, hashes=123)
        check("structured logging event", record["event"] == "test_event")
        with open(handle.name + ".jsonl", "r", encoding="utf-8") as stream:
            line = stream.readline()
        check("structured logging JSONL", '"event":"test_event"' in line)


def main():
    test_config()
    test_state_machine()
    test_metrics()
    test_structured_logging()
    print("ENGINEERING FORTRESS: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
