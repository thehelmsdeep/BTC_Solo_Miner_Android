# solo_miner_android

Android/Termux build of the solo Bitcoin CPU miner.

This repository is kept separate from `solo_miner`. The mining logic and native engine are copied from the working desktop version; Android uses the existing non-Windows `.so` build path.

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
