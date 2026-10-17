# BTC Solo Miner (Android)

CPU-based Bitcoin solo miner for Android/Termux, using a native C SHA-256d engine.

## Requirements

- Android device with 64-bit ARM (ARM64/AArch64) recommended
- Termux, Python, Clang, and Git

## Run

```sh
pkg update
pkg install python clang git
git clone https://github.com/thehelmsdeep/BTC_Solo_Miner_Android.git
cd BTC_Solo_Miner_Android
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt
export BTC_ADDRESS="your_bitcoin_address"
python main.py
```

The native C engine is required. Python mining fallback is disabled; if C cannot be built or loaded, mining stops with an error.

## Mining

The C engine hashes Bitcoin block headers with double SHA-256. It scans several independent, Stratum-valid header universes in parallel while retaining the rotated nonce scan. Each universe has its own `extranonce2`/`ntime` header and nonce space. Set `BTC_HEADER_UNIVERSES` to control the universe count (default 4; bounded by `CPU_THREADS`, maximum 8).

## Live Monitoring Dashboard

The terminal dashboard groups live miner metrics into six sections:

1. **Mining / Hash Engine** — mining time, hashrate, total hashes, best hash quality, and target status.
2. **Pool Connection / Job** — connection state, pool difficulty, and current job.
3. **Shares / Submissions** — submitted, accepted, rejected, and pending shares; acceptance/rejection rates; last submission/result; submit rate and latency.
4. **Proof of Work** — candidate count, verification results, failures, and last PoW event.
5. **Header Management** — header source, job, header fields, variable being scanned, rotation interval, active `extranonce2`, and `ntime`.
6. **Diagnostics** — bug/warning counts and debug/event log locations.

### Example dashboard

The following is an illustrative snapshot. Hashrate, counters, job details, timestamps, and other runtime values will vary between sessions.

```text
============== CPU Solo Miner ==============
Wallet       : bc1qz9vpf26p0l43dyypcjnaws24hfyu2gz978kzh4
Status       : Mining...
Hashrate     : 52.891113 MH/s
Total Hashes : 6,588,530,688

=== 1. MINING / HASH ENGINE ===
Mining Time       : 00:02:02
Hashrate          : 52.891113 MH/s
Total Hashes      : 6,588,530,688
Best Hash Quality : 8.09439968609e-19%
Target Status     : above target

=== 2. POOL CONNECTION / JOB ===
Connection        : connected
Pool Difficulty   : 10000
Last Job          : 6ac5908f00008043

=== 3. SHARES / SUBMISSIONS ===
Submitted         : 0
Accepted          : 0
Rejected          : 0
Pending           : 0
Acceptance        : N/A (no resolved shares)
Rejection         : N/A (no resolved shares)
Last Submit       : never
Last Result       : none
Result Age        : never
Submit Rate       : 0.00/min
Submit Latency    : avg 0.000s | max 0.000s | samples 0

=== 4. PROOF OF WORK ===
PoW Candidates    : 0
PoW Verified      : 0
PoW Verify Fail   : 0
Last PoW Hit      : never
Last PoW State    : none

=== 5. HEADER MANAGEMENT ===
Header Source     : multi-universe + rotational header
Header Job        : 6ac5908f00008043
Header Fields     : Prev Hash + Merkle Root(extranonce2) + ntime + nBits + nonce
Variable Now      : Nonce (changes on every hash)
Header Rotate     : every 5s (extranonce2 + ntime)
Active Extra2     : 08ee53cf04ece633
Active ntime      : 6ad3d6ed

=== 6. DIAGNOSTICS ===
Bugs (total 0):
  None
Warnings (total 0):
  None
Debug Log         : miner-debug.log
Event Log         : miner-events.jsonl
================================================
```

**Reading share statistics:** Acceptance and rejection percentages are shown as `N/A (no resolved shares)` until at least one submitted share has a result. This avoids presenting an unmeasured rate as 0%.

## Configuration

Common environment variables: `BTC_ADDRESS`, `STRATUM_HOST`, `STRATUM_PORT`, `WORKER_PASSWORD`, `CPU_THREADS`, and `REPORT_INTERVAL`.

CPU solo mining on a phone has an extremely low chance of finding a Bitcoin block. Keep the device cool during long sessions.
