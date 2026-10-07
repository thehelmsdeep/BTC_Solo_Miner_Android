#!/usr/bin/env python3
"""Regression test for the production reconnect loop.

Offline only. It forces one upstream failure, verifies that run() retries,
then makes the second mining-loop entry request shutdown.
"""

import main
import miner_context as ctx


def main_test():
    original_connect = main.connect_upstream
    original_miner = main.miner_loop
    original_delay = main.RECONNECT_DELAY

    attempts = {"connect": 0, "mine": 0}

    def fake_connect():
        attempts["connect"] += 1
        if attempts["connect"] == 1:
            raise ConnectionError("intentional test disconnect")
        ctx.connected = True
        ctx.upstream_alive = True
        return object()

    def fake_miner():
        attempts["mine"] += 1
        ctx.fShutdown = True

    main.connect_upstream = fake_connect
    main.miner_loop = fake_miner
    main.RECONNECT_DELAY = 0.01
    ctx.fShutdown = False
    ctx.connected = False
    ctx.upstream_alive = False

    try:
        main.run()
        assert attempts["connect"] == 2, attempts
        assert attempts["mine"] == 1, attempts
        print("PASS: upstream failure -> automatic reconnect -> mining resumes")
        return 0
    finally:
        main.connect_upstream = original_connect
        main.miner_loop = original_miner
        main.RECONNECT_DELAY = original_delay
        ctx.fShutdown = False
        ctx.connected = False
        ctx.upstream_alive = False


if __name__ == "__main__":
    raise SystemExit(main_test())
