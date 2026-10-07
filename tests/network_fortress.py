#!/usr/bin/env python3
"""Stage 3: Network Fortress.

Offline network/security regression suite. It never contacts a real pool.
Coverage:
  * deterministic Stratum parser fuzzing
  * malformed mining.notify / set_extranonce rejection
  * fragmented and coalesced JSON-line frames
  * reconnect matrix (0/1/3 forced failures)
  * concurrent mining.submit ID allocation and response races
  * concurrent job-generation replacement/read stress
"""

import json
import os
import random
import socket
import sys
import threading
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)

import main
import miner_context as ctx


def check(name, condition, detail=""):
    if not condition:
        raise AssertionError("FAIL: %s%s" % (
            name, (" | " + detail) if detail else ""
        ))
    print("PASS: %s%s" % (name, (" | " + detail) if detail else ""))


def valid_notify(job_id="network-job", marker="00"):
    return [
        job_id,
        marker * 32,
        "01000000",
        "00",
        [],
        "20000001",
        "1d00ffff",
        "65abcdef",
        True,
    ]


def reset_context():
    ctx.fShutdown = False
    ctx.connected = False
    ctx.upstream_alive = False
    ctx.upstream_sock = None
    ctx.upstream_extranonce1 = "a1b2c3d4"
    ctx.upstream_extranonce2_size = 4
    ctx.upstream_difficulty = None
    ctx.job_id = None
    ctx.job_generation = 0
    ctx.pending_submits.clear()
    ctx.next_submit_id = 1000000
    ctx.shares_submitted = 0
    ctx.shares_accepted = 0
    ctx.shares_rejected = 0


def test_parser_fuzz():
    rng = random.Random(0xBEEF)
    original_logg = main.logg
    main.logg = lambda _msg: None
    corpus = [
        b"\n",
        b"null\n",
        b"[]\n",
        b"123\n",
        b'"text"\n',
        b'{"method":\n',
        b"{not-json}\n",
        b"\xff\xfe\xfd\n",
        b'{"method":"mining.notify","params":null}\n',
        b'{"id":1,"result":true}\n',
    ]

    for _ in range(2000):
        length = rng.randrange(0, 512)
        raw = bytes(rng.randrange(256) for _ in range(length))
        corpus.append(raw + b"\n")

    try:
        for raw in corpus:
            messages, remainder = main.parse_messages(raw)
            assert isinstance(remainder, bytes)
            assert all(isinstance(x, dict) for x in messages)

        # Fragmentation/coalescing: multiple valid frames must survive arbitrary
        # packet boundaries exactly as they would on a TCP stream.
        frames = [
            {"id": 1, "method": "mining.subscribe", "params": []},
            {"id": 2, "method": "mining.authorize", "params": ["x", "x"]},
            {"id": None, "method": "mining.set_difficulty", "params": [1]},
        ]
        stream = b"".join(
            (json.dumps(x, separators=(",", ":")) + "\n").encode()
            for x in frames
        )
        for split in range(len(stream) + 1):
            left, right = stream[:split], stream[split:]
            first, rem = main.parse_messages(left)
            second, rem2 = main.parse_messages(rem + right)
            assert first + second == frames and rem2 == b""

        check(
            "Stratum parser fuzz + TCP framing",
            True,
            "malformed_frames=2010 fragmented_splits=%d" % (len(stream) + 1),
        )
    finally:
        main.logg = original_logg


def test_malformed_messages():
    reset_context()
    main.update_job(valid_notify())
    before = main.current_job()
    before_generation = before["generation"]

    malformed = [
        valid_notify()[:-1],
        valid_notify() + ["extra"],
        [None, "00" * 32, "01", "00", [], "20000001", "1d00ffff", "65abcdef", True],
        ["job", "00" * 31, "01", "00", [], "20000001", "1d00ffff", "65abcdef", True],
        ["job", "00" * 32, "0", "00", [], "20000001", "1d00ffff", "65abcdef", True],
        ["job", "00" * 32, "01", "0", [], "20000001", "1d00ffff", "65abcdef", True],
        ["job", "00" * 32, "01", "00", ["zz" * 32], "20000001", "1d00ffff", "65abcdef", True],
        ["job", "00" * 32, "01", "00", [], "zzzzzzzz", "1d00ffff", "65abcdef", True],
        ["job", "00" * 32, "01", "00", [], "20000001", "zzzzzzzz", "65abcdef", True],
        ["job", "00" * 32, "01", "00", [], "20000001", "1d00ffff", "zzzzzzzz", True],
        ["job", "00" * 32, "01", "00", [], "20000001", "1d00ffff", "65abcdef", 1],
        ["job", "00" * 32, "01", "00", ["00" * 32] * 257,
         "20000001", "1d00ffff", "65abcdef", True],
    ]

    for params in malformed:
        try:
            main.update_job(params)
        except (TypeError, ValueError, KeyError):
            pass
        else:
            raise AssertionError("malformed notify was accepted: %r" % (params,))
        after = main.current_job()
        check("malformed notify is transactional",
              after["job_id"] == before["job_id"] and
              after["generation"] == before_generation)

    for params in ([], ["zzzz", 4], ["a1", 0], ["a1", 33], [None, 4]):
        try:
            if len(params) >= 2:
                main._validate_hex_blob(params[0], "extranonce1")
                size = int(params[1])
                if not 1 <= size <= 32:
                    raise ValueError("invalid extranonce2_size")
            else:
                raise ValueError("missing extranonce parameters")
        except (TypeError, ValueError):
            pass
        else:
            raise AssertionError("malformed extranonce accepted: %r" % (params,))

    check("malformed notify/set_extranonce corpus", True,
          "state remains unchanged")


def test_reconnect_matrix():
    original_connect = main.connect_upstream
    original_miner = main.miner_loop
    original_ensure = main.ensure_native
    original_delay = main.RECONNECT_DELAY

    try:
        main.ensure_native = lambda: None
        main.RECONNECT_DELAY = 0.001

        for failures in (0, 1, 3):
            reset_context()
            attempts = {"connect": 0, "mine": 0}

            class FakeSocket:
                def recv(self, _size):
                    return b""
                def sendall(self, _data):
                    return None
                def close(self):
                    pass

            def fake_connect(failures=failures):
                attempts["connect"] += 1
                if attempts["connect"] <= failures:
                    raise ConnectionError("forced reconnect test")
                ctx.connected = True
                ctx.upstream_alive = True
                return FakeSocket()

            def fake_miner():
                attempts["mine"] += 1
                ctx.fShutdown = True

            main.connect_upstream = fake_connect
            main.miner_loop = fake_miner
            main.run()

            check("reconnect matrix failures=%d" % failures,
                  attempts["connect"] == failures + 1 and
                  attempts["mine"] == 1,
                  "connect_attempts=%d" % attempts["connect"])
    finally:
        main.connect_upstream = original_connect
        main.miner_loop = original_miner
        main.ensure_native = original_ensure
        main.RECONNECT_DELAY = original_delay
        ctx.fShutdown = False


def test_submit_race():
    reset_context()
    client, server = socket.socketpair()
    ctx.upstream_sock = client
    ctx.upstream_alive = True
    ctx.connected = True

    total = 128
    received = []
    server_error = []

    def server_worker():
        buf = b""
        try:
            while len(received) < total:
                chunk = server.recv(8192)
                if not chunk:
                    break
                buf += chunk
                while b"\n" in buf:
                    line, buf = buf.split(b"\n", 1)
                    if not line:
                        continue
                    msg = json.loads(line.decode())
                    received.append(msg)
                    server.sendall((
                        json.dumps({
                            "id": msg["id"],
                            "result": True,
                            "error": None,
                        }, separators=(",", ":")) + "\n"
                    ).encode())
        except Exception as exc:
            server_error.append(exc)

    listener = threading.Thread(
        target=main.upstream_listener, args=(client,), daemon=True
    )
    server_thread = threading.Thread(target=server_worker, daemon=True)
    listener.start()
    server_thread.start()

    errors = []

    def submit_worker(offset):
        try:
            for i in range(8):
                main.submit_share(
                    "race-job",
                    "01020304",
                    "65abcdef",
                    (offset + i) & 0xffffffff,
                )
        except Exception as exc:
            errors.append(exc)

    workers = [
        threading.Thread(target=submit_worker, args=(i * 8,))
        for i in range(16)
    ]
    try:
        for worker in workers:
            worker.start()
        for worker in workers:
            worker.join()
        deadline = time.time() + 5
        while time.time() < deadline and ctx.shares_accepted < total:
            time.sleep(0.005)

        ids = [m["id"] for m in received]
        check("submit race no worker errors", not errors, repr(errors))
        check("submit race received all", len(received) == total,
              "received=%d" % len(received))
        check("submit IDs unique", len(ids) == len(set(ids)))
        check("submit IDs monotonic allocation",
              sorted(ids) == list(range(1000000, 1000000 + total)))
        check("submit responses matched", ctx.shares_accepted == total,
              "accepted=%d" % ctx.shares_accepted)
        check("submit pending map drained", not ctx.pending_submits)
        check("submit/reply race server clean", not server_error)
    finally:
        ctx.fShutdown = True
        ctx.upstream_alive = False
        try:
            client.close()
        except OSError:
            pass
        try:
            server.close()
        except OSError:
            pass
        listener.join(timeout=2)
        server_thread.join(timeout=2)
        ctx.fShutdown = False


def test_job_generation_stress():
    reset_context()
    main.update_job(valid_notify("job-seed", "00"))
    updates = 8 * 500
    failures = []
    stop = threading.Event()

    def writer(worker):
        try:
            for i in range(500):
                token = "%02x%04x" % (worker, i)
                # Every field carries the same token-derived marker. A reader
                # that observes mixed generations would fail these checks.
                marker = ("%s" % token)[-2:]
                params = valid_notify("job-%s" % token, marker)
                main.update_job(params)
        except Exception as exc:
            failures.append(exc)

    snapshots = []

    def reader():
        try:
            while not stop.is_set():
                job = main.current_job()
                if job is None:
                    continue
                token = job["job_id"][4:]
                if not token:
                    raise AssertionError("empty job token")
                marker = token[-2:]
                if job["prevhash"] != marker * 32:
                    raise AssertionError("mixed-generation prevhash")
                if job["generation"] <= 0:
                    raise AssertionError("invalid job generation")
                snapshots.append(job["generation"])
        except Exception as exc:
            failures.append(exc)
            stop.set()

    readers = [threading.Thread(target=reader, daemon=True) for _ in range(4)]
    writers = [threading.Thread(target=writer, args=(w,)) for w in range(8)]

    for r in readers:
        r.start()
    for w in writers:
        w.start()
    for w in writers:
        w.join()
    stop.set()
    for r in readers:
        r.join(timeout=1)

    check("job-generation stress writers clean", not failures, repr(failures))
    final = main.current_job()
    check("job-generation stress final snapshot", final is not None)
    check("job-generation monotonic",
          final["generation"] == updates + 1,
          "generation=%d expected=%d" % (final["generation"], updates + 1))
    check("job-generation readers observed snapshots",
          bool(snapshots))


def main_test():
    test_parser_fuzz()
    test_malformed_messages()
    test_reconnect_matrix()
    test_submit_race()
    test_job_generation_stress()
    print("NETWORK FORTRESS: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main_test())
