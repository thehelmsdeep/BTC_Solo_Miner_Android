"""Offline regression test for the exact nonce -> PoW -> submit path.

This test never opens a socket and never starts the miner.
"""

import hashlib

from main import submit_payload, verify_header_pow


# Bitcoin mainnet genesis block header, serialized exactly as hashed.
GENESIS_HEADER_PREFIX = bytes.fromhex(
    "01000000"
    + "00" * 32
    + "4a5e1e4baa8b9fa323518a88c31bc87f618f76773e6c372acb27127afdeda33b3"
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
