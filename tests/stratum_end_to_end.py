#!/usr/bin/env python3
"""Deterministic Stratum end-to-end integration test using a local socket pair."""

import json
import os
import socket
import sys
import threading
import time

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

import main
import miner_context as ctx


def send_line(sock, obj):
    sock.sendall((json.dumps(obj, separators=(",", ":")) + "\n").encode())


def recv_line(sock, timeout=5):
    sock.settimeout(timeout)
    buf = b""
    while b"\n" not in buf:
        chunk = sock.recv(4096)
        if not chunk:
            raise ConnectionError("fake Stratum server closed")
        buf += chunk
    line, _ = buf.split(b"\n", 1)
    return json.loads(line.decode())


def main_test():
    client, server = socket.socketpair()
    original_create_connection = main.socket.create_connection
    server_error = []

    def fake_create_connection(address, timeout=20):
        return client

    def fake_server():
        try:
            subscribe = recv_line(server)
            assert subscribe["id"] == 1
            assert subscribe["method"] == "mining.subscribe"
            send_line(server, {"id": 1, "result": [[], "a1b2c3d4", 4], "error": None})

            authorize = recv_line(server)
            assert authorize["id"] == 2
            assert authorize["method"] == "mining.authorize"
            send_line(server, {"id": 2, "result": True, "error": None})

            send_line(server, {"id": None, "method": "mining.set_difficulty", "params": [1.0]})
            send_line(server, {
                "id": None,
                "method": "mining.notify",
                "params": [
                    "integration-job", "00" * 32, "01000000", "00", [],
                    "20000000", "1d00ffff", "65abcdef", True
                ],
            })

            first = recv_line(server)
            assert first["method"] == "mining.submit"
            assert first["params"][1:] == ["integration-job", "01020304", "65abcdef", "12345678"]
            send_line(server, {"id": first["id"], "result": True, "error": None})

            second = recv_line(server)
            assert second["method"] == "mining.submit"
            assert second["params"][-1] == "12345679"
            send_line(server, {
                "id": second["id"], "result": False,
                "error": [21, "stale share", None],
            })
            time.sleep(0.1)
        except Exception as exc:
            server_error.append(exc)
        finally:
            try:
                server.close()
            except OSError:
                pass

    ctx.fShutdown = False
    ctx.connected = False
    ctx.upstream_alive = False
    ctx.upstream_sock = None
    ctx.upstream_extranonce1 = None
    ctx.upstream_extranonce2_size = 4
    ctx.pending_submits.clear()
    ctx.next_submit_id = 1000000
    ctx.shares_submitted = 0
    ctx.shares_accepted = 0
    ctx.shares_rejected = 0
    ctx.job_id = None
    ctx.job_generation = 0

    server_thread = threading.Thread(target=fake_server, daemon=True)
    server_thread.start()
    listener = None

    try:
        main.socket.create_connection = fake_create_connection
        sock = main.connect_upstream()
        assert ctx.connected and ctx.upstream_alive

        listener = threading.Thread(target=main.upstream_listener, args=(sock,), daemon=True)
        listener.start()

        deadline = time.time() + 3
        while time.time() < deadline and ctx.job_id != "integration-job":
            time.sleep(0.01)
        assert ctx.job_id == "integration-job"

        main.submit_share("integration-job", "01020304", "65abcdef", 0x12345678)
        main.submit_share("integration-job", "01020304", "65abcdef", 0x12345679)

        deadline = time.time() + 3
        while time.time() < deadline:
            if ctx.shares_accepted == 1 and ctx.shares_rejected == 1:
                break
            time.sleep(0.01)

        assert ctx.shares_submitted == 2
        assert ctx.shares_accepted == 1
        assert ctx.shares_rejected == 1
        assert not ctx.pending_submits
        assert not server_error

        print("PASS: Stratum subscribe -> authorize -> notify -> submit -> response")
    finally:
        main.socket.create_connection = original_create_connection
        ctx.fShutdown = True
        ctx.upstream_alive = False
        try:
            client.close()
        except OSError:
            pass
        if listener is not None:
            listener.join(timeout=2)
        server_thread.join(timeout=2)
        ctx.fShutdown = False


if __name__ == "__main__":
    main_test()
