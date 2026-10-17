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

The C engine hashes Bitcoin block headers with double SHA-256. Its nonce scan uses a rotated starting offset and allocates non-overlapping chunks to native threads. When the nonce space is exhausted, the miner rolls Stratum-authorized header fields such as `extranonce2` and `ntime`.

## Configuration

Common environment variables: `BTC_ADDRESS`, `STRATUM_HOST`, `STRATUM_PORT`, `WORKER_PASSWORD`, `CPU_THREADS`, and `REPORT_INTERVAL`.

CPU solo mining on a phone has an extremely low chance of finding a Bitcoin block. Keep the device cool during long sessions.
