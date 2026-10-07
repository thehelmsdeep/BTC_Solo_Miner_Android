"""Offline regression test for the exact nonce -> PoW -> submit path.

This test never opens a socket and never starts the miner.
"""

import hashlib
import os
import sys

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from main import submit_payload, verify_header_pow


# Bitcoin mainnet genesis block header, serialized exactly as hashed.
GENESIS_HEADER_PREFIX = bytes.fromhex(
    "01000000"
    + "00" * 32
    + "3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a"
    + "29ab5f49"
    + "ffff001d"
)
GENESIS_NONCE = 0x1DAC2B7C
GENESIS_TARGET = 0x00000000FFFF0000000000000000000000000000000000000000000000000000


def main():
    assert len(GENESIS_HEADER_PREFIX) == 76
    header = GENESIS_HEADER_PREFIX + GENESIS_NONCE.to_bytes(4, "little")
    digest = hashlib.sha256(hashlib.sha256(header).digest()).digest()

    # Independent reference calculation must satisfy the genesis target.
    assert int.from_bytes(digest, "little") <= GENESIS_TARGET
    assert verify_header_pow(GENESIS_HEADER_PREFIX, GENESIS_NONCE, GENESIS_TARGET)
    assert not verify_header_pow(GENESIS_HEADER_PREFIX, GENESIS_NONCE - 1, GENESIS_TARGET)

    payload = submit_payload(
        "genesis-test-job", "01020304", "29ab5f49", GENESIS_NONCE, 9001
    )
    assert payload == {
        "id": 9001,
        "method": "mining.submit",
        "params": [
            "bc1qz9vpf26p0l43dyypcjnaws24hfyu2gz978kzh4",
            "genesis-test-job",
            "01020304",
            "29ab5f49",
            "1dac2b7c",
        ],
    }

    print("PASS: exact nonce -> SHA256d -> target -> mining.submit payload")


if __name__ == "__main__":
    main()
