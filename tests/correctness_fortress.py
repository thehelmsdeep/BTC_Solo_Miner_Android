#!/usr/bin/env python3
"""Stage 1: Correctness Fortress.

Offline consensus-oriented regression suite. It never opens a network socket
and never submits a share. The suite covers:
  * real Bitcoin mainnet golden vectors (genesis block)
  * a real block-100000 Merkle-root vector
  * compact nBits edge/overflow/sign semantics
  * exact/equality PoW comparison and nonce endian boundaries
  * complete 76-byte header field serialization/endian order
  * native nonce scanning at the 0xffffffff boundary
"""

import ctypes
import hashlib
import os
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import main  # noqa: E402


def dsha256(data: bytes) -> bytes:
    return hashlib.sha256(hashlib.sha256(data).digest()).digest()


def check(name, condition, detail=""):
    if not condition:
        raise AssertionError(f"FAIL: {name}" + (f" | {detail}" if detail else ""))
    print(f"PASS: {name}" + (f" | {detail}" if detail else ""))


# Bitcoin mainnet genesis block, serialized exactly as hashed.
GENESIS_HEADER = bytes.fromhex(
    "01000000"
    + "00" * 32
    + "3ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a"
    + "29ab5f49"
    + "ffff001d"
    + "1dac2b7c"
)
GENESIS_HASH_DISPLAY = (
    "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
)
GENESIS_TARGET = int(
    "00000000ffff0000000000000000000000000000000000000000000000000000", 16
)


# Block 100,000: four transaction IDs and the independently published Merkle root.
# Source: mempool.space block 100000.
BLOCK100000_TXIDS = [
    "8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87",
    "fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4",
    "6359f0868171b1d194cbee1af2f16ea598ae8fad666d9b012c8ed2b79a236ec4",
    "e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d",
]
BLOCK100000_MERKLE_ROOT = (
    "f3e94742aca4b5ef85488dc37c06c3282295ffec960994b2c0d5ac2a25a95766"
)


def test_genesis():
    digest = dsha256(GENESIS_HEADER)
    check("genesis header length", len(GENESIS_HEADER) == 80)
    check("genesis SHA256d", digest[::-1].hex() == GENESIS_HASH_DISPLAY,
          digest[::-1].hex())
    check(
        "genesis target equality semantics",
        int.from_bytes(digest, "little") <= GENESIS_TARGET,
    )

    prefix = GENESIS_HEADER[:76]
    nonce = int.from_bytes(GENESIS_HEADER[76:], "little")
    check("verify known genesis nonce", main.verify_header_pow(
        prefix, nonce, GENESIS_TARGET
    ))
    check("reject genesis nonce-1", not main.verify_header_pow(
        prefix, nonce - 1, GENESIS_TARGET
    ))


def test_merkle():
    root = main.compute_merkle_root(BLOCK100000_TXIDS)
    check("block 100000 Merkle root", root == BLOCK100000_MERKLE_ROOT, root)

    # Bitcoin duplicates the final node when a level has odd cardinality.
    odd = BLOCK100000_TXIDS[:3]
    level = [bytes.fromhex(x)[::-1] for x in odd]
    level.append(level[-1])
    expected = dsha256(
        dsha256(level[0] + level[1]) + dsha256(level[2] + level[2])
    )[::-1].hex()
    check("odd-width Merkle duplication", main.compute_merkle_root(odd) == expected)

    for bad in ("", "00", "zz" * 32, "0" * 65):
        try:
            main.compute_merkle_root([bad])
        except ValueError:
            pass
        else:
            raise AssertionError(f"FAIL: invalid Merkle txid accepted: {bad!r}")
    print("PASS: Merkle input validation")


def test_nbits():
    cases = {
        # Mainnet genesis / difficulty-1 target.
        "1d00ffff": GENESIS_TARGET,
        # Real block 100000 nBits.
        "1b04864c": int("04864c", 16) << (8 * (0x1b - 3)),
        # Small targets exercising exponents <= 3.
        "01010000": 1,
        "02008000": 0x80,
        "03009234": 0x9234,
        # Highest 256-bit compact target used by regtest.
        "207fffff": 0x7FFFFF << (8 * (0x20 - 3)),
        # Exponent 0x21 still fits in 256 bits.
        "2100ffff": 0xFFFF << (8 * (0x21 - 3)),
    }
    for bits, expected in cases.items():
        check(f"nBits {bits}", main.compact_to_target(bits) == expected)

    # Core's SetCompact semantics: non-canonical positive encodings are still
    # valid targets; the consensus rejection is for zero, negative and overflow.
    check("non-canonical positive nBits accepted", main.compact_to_target("02000100") == 1)

    invalid = (
        "00000000",  # zero
        "01003456",  # shifts to zero
        "1d80ffff",  # negative sign bit
        "01800001",  # negative sign bit
        "22010000",  # >256-bit overflow
        "ff123456",  # >256-bit overflow
        "zzzzzzzz",  # malformed
        "1",         # malformed length
    )
    for bits in invalid:
        try:
            main.compact_to_target(bits)
        except ValueError:
            print(f"PASS: nBits {bits} rejected")
        else:
            raise AssertionError(f"FAIL: invalid nBits accepted: {bits}")


def test_header_endian_serialization():
    # Use deterministic synthetic Stratum fields so every header component can
    # be checked independently. No network access is involved.
    job = {
        "coinb1": "01020304",
        "extranonce1": "aabb",
        "coinb2": "05060708",
        "merkle_branch": [],
        "version": "20000001",
        "prevhash": "00112233445566778899aabbccddeeff" * 2,
        "ntime": "65abcdef",
        "nbits": "1d00ffff",
    }
    prefix = main.build_header_prefix(job, "ccdd")
    coinbase = bytes.fromhex("01020304aabbccdd05060708")
    expected = (
        bytes.fromhex("20000001")[::-1]
        + bytes.fromhex(job["prevhash"])[::-1]
        + dsha256(coinbase)[::-1]
        + bytes.fromhex("65abcdef")[::-1]
        + bytes.fromhex("1d00ffff")[::-1]
    )
    check("76-byte header prefix length", len(prefix) == 76)
    check("header version little-endian", prefix[:4] == bytes.fromhex("01000020"))
    check("header prevhash byte order", prefix[4:36] == bytes.fromhex(job["prevhash"])[::-1])
    check("header merkle byte order", prefix[36:68] == dsha256(coinbase)[::-1])
    check("header nTime little-endian", prefix[68:72] == bytes.fromhex("efcdab65"))
    check("header nBits little-endian", prefix[72:76] == bytes.fromhex("ffff001d"))
    check("complete header serialization", prefix == expected)


def test_nonce_boundaries():
    prefix = bytes(range(76))
    for nonce in (0, 1, 0xFFFFFFFE, 0xFFFFFFFF):
        header = prefix + nonce.to_bytes(4, "little")
        digest = dsha256(header)
        target = int.from_bytes(digest, "little")
        check(
            f"exact-target nonce 0x{nonce:08x}",
            main.verify_header_pow(prefix, nonce, target),
        )
        if target > 0:
            check(
                f"target-minus-one rejects 0x{nonce:08x}",
                not main.verify_header_pow(
                    prefix, nonce, target - 1
                ),
            )

    # Explicit serialization guard for the terminal nonce: it must never wrap.
    check(
        "nonce ffffffff serializes without wrap",
        (0xFFFFFFFF).to_bytes(4, "little") == bytes.fromhex("ffffffff"),
    )


def test_native_terminal_nonce():
    lib = main.ensure_native()
    if lib is None:
        print("SKIP: native library unavailable for terminal-nonce test")
        return

    prefix = bytes(range(76))
    nonce = 0xFFFFFFFF
    digest = dsha256(prefix + nonce.to_bytes(4, "little"))
    target = (ctypes.c_uint8 * 32).from_buffer_copy(
        int.from_bytes(digest, "little").to_bytes(32, "little")
    )
    prefix_buf = (ctypes.c_uint8 * 76).from_buffer_copy(prefix)
    found = ctypes.c_uint32(0)
    hashes = ctypes.c_uint64(0)

    hit = lib.b_m_mine_parallel(
        prefix_buf,
        target,
        ctypes.c_uint32(nonce),
        ctypes.c_uint32(1),
        ctypes.c_uint64(1),
        ctypes.byref(found),
        ctypes.byref(hashes),
    )
    check(
        "native terminal nonce 0xffffffff",
        hit == 1 and found.value == nonce and hashes.value == 1,
        f"hit={hit} found=0x{found.value:08x} hashes={hashes.value}",
    )


def main_test():
    test_genesis()
    test_merkle()
    test_nbits()
    test_header_endian_serialization()
    test_nonce_boundaries()
    test_native_terminal_nonce()
    print("CORRECTNESS FORTRESS: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main_test())
