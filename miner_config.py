"""Centralized runtime configuration for the solo miner.

The module is intentionally side-effect free: importing it only reads and
validates environment variables.  main.py keeps its historical constants as
aliases so existing callers/tests remain compatible.
"""

import os


def _positive_int(name, default, minimum=1):
    value = int(os.getenv(name, str(default)))
    return max(minimum, value)


def _positive_float(name, default, minimum=0.0):
    value = float(os.getenv(name, str(default)))
    return max(minimum, value)


DEFAULT_BTC_ADDRESS = "bc1qz9vpf26p0l43dyypcjnaws24hfyu2gz978kzh4"


class MinerConfig:
    def __init__(self):
        # An unset OR blank BTC_ADDRESS must never become the Stratum username.
        # Keep the repository's built-in mainnet wallet as the reliable default.
        configured_address = os.getenv("BTC_ADDRESS", "").strip()
        self.address = configured_address or DEFAULT_BTC_ADDRESS
        self.address_source = "BTC_ADDRESS environment variable" if configured_address else "built-in default"
        self.upstream_host = os.getenv("STRATUM_HOST", "solo.ckpool.org")
        self.upstream_port = _positive_int("STRATUM_PORT", 3333)
        self.worker_password = os.getenv("WORKER_PASSWORD", "x")
        self.cpu_threads = _positive_int(
            "CPU_THREADS", 8
        )
        self.nonce_batch = _positive_int("NONCE_BATCH", 4000000, 10000)
        self.report_interval = _positive_float("REPORT_INTERVAL", 5.0, 1.0)
        self.reconnect_delay = _positive_float("RECONNECT_DELAY", 5.0, 1.0)
        self.submit_timeout = _positive_float("SUBMIT_TIMEOUT", 15.0, 1.0)
        self.native_enabled = os.getenv(
            "BM_NATIVE", "1"
        ).lower() not in {"0", "false", "no"}

    def as_dict(self):
        return {
            "address": self.address,
            "address_source": self.address_source,
            "upstream_host": self.upstream_host,
            "upstream_port": self.upstream_port,
            "worker_password": self.worker_password,
            "cpu_threads": self.cpu_threads,
            "nonce_batch": self.nonce_batch,
            "report_interval": self.report_interval,
            "reconnect_delay": self.reconnect_delay,
            "submit_timeout": self.submit_timeout,
            "native_enabled": self.native_enabled,
        }


CONFIG = MinerConfig()
