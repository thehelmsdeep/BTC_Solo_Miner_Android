

Android/Termux build of the solo Bitcoin CPU miner.

This repository is kept separate from `solo_miner`. The mining logic and native engine are copied from the working desktop version; Android uses the existing non-Windows `.so` build path.



## CPU Architecture

The Android native mining engine is **optimized for 64-bit ARM (ARM64/AArch64)** devices.

### Primary Android target

- **Architecture:** ARM64 / AArch64
- **ISA:** ARMv8-A
- **SHA-256 acceleration:** ARMv8 Crypto Extensions
- **Native build flags include:** `-march=armv8-a+crypto`, `-mtune=native`, LTO, loop unrolling, and frame-pointer omission.
- **Recommended devices:** modern Android phones/tablets with 64-bit ARM CPUs and ARMv8 Crypto Extensions.

The Android native build path is intentionally ARM64-oriented. **32-bit ARM (armeabi-v7a) is not the target for the native engine.** x86/x86-64 Android is also not the current native optimization target.

If the native library cannot be built or loaded, the miner can fall back to the Python SHA-256 implementation. The native self-tests are run before the native engine is used.

For the best performance, use a 64-bit ARM Android device where the CPU exposes ARMv8 Crypto Extensions.

## Run on Android

Install **Termux** and then:

```sh
pkg update
pkg install python clang git
git clone https://github.com/thehelmsdeep/solo_miner_android.git
cd solo_miner_android

python -m venv venv
. venv/bin/activate
pip install -r requirements.txt

python main.py
```

The first run should compile:

```
native/libb_m_sha256.so
```

The program runs its SHA256 and native-engine self-tests before mining.

## Configuration

Environment variables:

- `BTC_ADDRESS`
- `STRATUM_HOST`
- `STRATUM_PORT`
- `WORKER_PASSWORD`
- `CPU_THREADS`
- `NONCE_BATCH`
- `REPORT_INTERVAL`
- `RECONNECT_DELAY`
- `SUBMIT_TIMEOUT`
- `BM_NATIVE`

Example:

```sh
export BTC_ADDRESS="your_btc_address"
export CPU_THREADS="4"
python main.py
```

Keep the phone cool and plugged in during long runs. Mobile CPUs can throttle under sustained load.

## Important

This is CPU solo mining. Finding a Bitcoin block is extremely unlikely at mobile/CPU hash rates; this project is primarily for experimentation and learning.


## Example Mining Dashboard

The following is an example of the live dashboard shown while the miner is running:

```text
============== CPU Solo Miner ==============
Wallet       : bc1qz9vpf26p0l43dyypcjnaws24hfyu2gz978kzh4
Status       : Mining...
Hashrate     : 47.533725 MH/s
Interval Hash: 237764608
Total Hashes : 1523466240
Submitted    : 0
Accepted     : 0
Rejected     : 0
Pool Diff    : 10000
Last Job     : 6ac58e0100001b0b
Debug Log    : miner-debug.log
Event Log    : miner-events.jsonl
================================================
```

> **Note:** These are example values copied from one runtime snapshot, not guaranteed or live values. `Submitted: 0`, `Accepted: 0`, and `Rejected: 0` mean no shares are shown as submitted or resolved in this snapshot; check the runtime logs to diagnose the reason.

## Diagnostics

All diagnostics are offline except the normal miner run:

```sh
python tests/native_sha256_crosscheck.py
python tests/native_sha256_diagnostic.py
python tests/nonce_submit_integrity.py
python tests/nonce_partition.py
python tests/native_benchmark.py
python tests/native_engine_verification.py
python tests/stratum_end_to_end.py
python tests/reconnect_regression.py
python tests/network_fortress.py
```

The Stratum end-to-end test uses a local socket pair and a fake server. It
exercises the production subscribe/authorize/notify/submit/response path
without contacting a real pool.

The miner also independently re-verifies every native PoW hit with Python
SHA256d before submission, rejects stale job-generation hits, expires timed-out
submit responses, and automatically reconnects after an upstream failure.

## Correctness Fortress (Stage 1)

The project includes an offline consensus-oriented regression suite:

```bash
python tests/correctness_fortress.py
```

It covers the Bitcoin mainnet genesis block SHA256d vector, a real block-100000 Merkle-root vector, compact `nBits` zero/sign/overflow semantics, exact-target comparison, full 76-byte header endian serialization, nonce boundary `0xffffffff`, and a native terminal-nonce scan. The suite never opens a network connection or submits a share.


### Native Engine Verification (Stage 2)

Run the complete offline native verification suite manually:

```bash
python tests/native_engine_verification.py
```

It cross-checks Python hashlib against the scalar, 64-byte-prefix, and optimized
native SHA256d paths; exercises nonce boundaries and exact-target semantics;
checks the SIMD/parallel path; repeatedly replaces persistent-engine jobs across
multiple thread counts; and builds/runs local ASan+UBSan and TSan harnesses when
the installed compiler/runtime supports them.

Sanitizers are deliberately manual and local. This repository does **not** use
GitHub Actions or CI/CD.


## Network Fortress (Stage 3)

Run the complete offline Stratum/network regression suite manually:

```bash
python tests/network_fortress.py
```

It fuzzes the JSON-line Stratum parser with malformed and binary frames,
checks fragmented/coalesced TCP framing, validates malformed `mining.notify`
and `mining.set_extranonce` inputs before shared-state mutation, exercises a
reconnect matrix with forced upstream failures, races concurrent
`mining.submit` requests against responses, and stress-tests concurrent job
replacement/readers for generation consistency.

The suite is fully offline: it uses local socket pairs and deterministic fake
upstream behavior. It never contacts a real pool and never submits a real
share.

### Engineering Layer (Stage 5)

Stage 5 keeps the mining behavior intact while separating engineering concerns:

- `miner_config.py` owns environment parsing and runtime configuration.
- `miner_state.py` defines explicit lifecycle states and rejects invalid transitions.
- `miner_metrics.py` provides thread-safe runtime counters independent of Stratum state.
- `miner_logging.py` keeps the human-readable `miner.log` while emitting structured JSONL events to `miner-events.jsonl` (or `MINER_EVENT_LOG`).
- `main.py` keeps backward-compatible configuration aliases while using the new state, metrics, and logging layers.

Run the offline Stage 5 regression suite manually:

```bash
python tests/engineering_fortress.py
```

The suite covers configuration parsing/minimums, lifecycle transition rules, concurrent metrics updates, and structured event serialization. Stage 5 does not add GitHub Actions or CI/CD.

### Performance Research (Stage 4)

Run the reproducible offline performance benchmark manually:

```bash
python tests/performance_benchmark.py
```

By default it measures the persistent native engine at 1, 2, 4, ... threads
up to the available logical CPU count, with two 2-second runs per setting. It
reports median/min/max H/s, speedup versus one thread, and scaling efficiency.

For a longer, thermal/throttling-oriented run:

```bash
python tests/performance_benchmark.py --duration 5 --repeats 3 --sustained 60 --json results/stage4.json
```

Or select exact thread counts:

```bash
python tests/performance_benchmark.py --threads 1,2,4,8
```

The benchmark uses a deterministic 76-byte header prefix and an impossible
all-zero target, so it cannot stop early on a valid PoW. It measures the
persistent native engine directly, does not contact a pool, and never submits
shares. When Linux/Termux exposes CPU frequency/governor or thermal-zone
telemetry, those snapshots are included in the report; unavailable sensors
are simply omitted. JSON output is intended for reproducible comparisons
across devices, compiler/runtime versions, and thermal conditions.

