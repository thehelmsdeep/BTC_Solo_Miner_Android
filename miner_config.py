"""Centralized runtime configuration for the solo miner.

The module is intentionally side-effect free: importing it only reads and
validates environment variables.  main.py keeps its historical constants as
aliases so existing callers/tests remain compatible.
"""

import os


def _positive_int(name, default, minimum=1):
    value = int(os.getenv(name, str(default)))
    return max(minimum, value)


def _positive_float(name, default, minimum=0.0):
    value = float(os.getenv(name, str(default)))
    return max(minimum, value)


# No wallet address is embedded in the repository: ownership cannot be inferred
# from a syntactically valid address, so require the operator to configure one.
DEFAULT_BTC_ADDRESS = ""


def _bech32_polymod(values):
    generators = (0x3B6A57B2, 0x26508E6D, 0x1EA119FA, 0x3D4233DD, 0x2A1462B3)
    checksum = 1
    for value in values:
        top = checksum >> 25
        checksum = ((checksum & 0x1FFFFFF) << 5) ^ value
        for bit, generator in enumerate(generators):
            if (top >> bit) & 1:
                checksum ^= generator
    return checksum


def _valid_segwit_address(address):
    if not isinstance(address, str) or not address or len(address) > 90:
        return False
    if address.lower() != address and address.upper() != address:
        return False
    address = address.lower()
    separator = address.rfind("1")
    if separator < 1 or separator + 7 > len(address):
        return False
    hrp = address[:separator]
    if hrp != "bc":
        return False
    alphabet = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
    try:
        data = [alphabet.index(char) for char in address[separator + 1:]]
    except ValueError:
        return False
    expanded_hrp = [ord(char) >> 5 for char in hrp] + [0] + [ord(char) & 31 for char in hrp]
    checksum = _bech32_polymod(expanded_hrp + data)
    if checksum not in (1, 0x2BC830A3):
        return False
    payload = data[:-6]
    if not payload or payload[0] > 16:
        return False
    witness_version = payload[0]
    acc = 0
    bits = 0
    program = []
    for value in payload[1:]:
        acc = (acc << 5) | value
        bits += 5
        while bits >= 8:
            bits -= 8
            program.append((acc >> bits) & 0xFF)
    if bits >= 5 or ((acc << (8 - bits)) & 0xFF):
        return False
    if not 2 <= len(program) <= 40:
        return False
    if witness_version == 0 and (checksum != 1 or len(program) not in (20, 32)):
        return False
    if witness_version != 0 and checksum != 0x2BC830A3:
        return False
    return True


def _valid_base58_address(address):
    alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    if not isinstance(address, str) or not 26 <= len(address) <= 35:
        return False
    number = 0
    try:
        for char in address:
            number = number * 58 + alphabet.index(char)
    except ValueError:
        return False
    raw = number.to_bytes((number.bit_length() + 7) // 8, "big") if number else b""
    raw = bytes(len(address) - len(address.lstrip("1"))) + raw
    if len(raw) != 25 or raw[0] not in (0, 5):
        return False
    import hashlib
    checksum = hashlib.sha256(hashlib.sha256(raw[:-4]).digest()).digest()[:4]
    return checksum == raw[-4:]


def validate_btc_address(address):
    """Accept only checksum-valid Bitcoin mainnet Base58Check or SegWit addresses."""
    if _valid_segwit_address(address) or _valid_base58_address(address):
        return address
    raise ValueError("Invalid Bitcoin mainnet address (format/checksum); check BTC_ADDRESS")


class MinerConfig:
    def __init__(self):
        # Never mine to an unverified hard-coded wallet. A valid address format
        # does not prove ownership; require the operator's explicit BTC_ADDRESS.
        configured_address = os.getenv("BTC_ADDRESS", "").strip()
        if not configured_address:
            raise ValueError(
                "BTC_ADDRESS is required. Set it to a Bitcoin mainnet address "
                "you control; no unverified built-in wallet is used."
            )
        self.address = validate_btc_address(configured_address)
        self.address_source = "BTC_ADDRESS environment variable"
        self.upstream_host = os.getenv("STRATUM_HOST", "stratum.ckpool.org")
        self.upstream_port = _positive_int("STRATUM_PORT", 3333)
        self.worker_password = os.getenv("WORKER_PASSWORD", "x")
        self.cpu_threads = _positive_int(
            "CPU_THREADS", 8
        )
        self.nonce_batch = _positive_int("NONCE_BATCH", 4000000, 10000)
        self.report_interval = _positive_float("REPORT_INTERVAL", 5.0, 1.0)
        self.reconnect_delay = _positive_float("RECONNECT_DELAY", 5.0, 1.0)
        self.submit_timeout = _positive_float("SUBMIT_TIMEOUT", 15.0, 1.0)
        self.native_enabled = os.getenv(
            "BM_NATIVE", "1"
        ).lower() not in {"0", "false", "no"}

    def as_dict(self):
        return {
            "address": self.address,
            "address_source": self.address_source,
            "upstream_host": self.upstream_host,
            "upstream_port": self.upstream_port,
            "worker_password": self.worker_password,
            "cpu_threads": self.cpu_threads,
            "nonce_batch": self.nonce_batch,
            "report_interval": self.report_interval,
            "reconnect_delay": self.reconnect_delay,
            "submit_timeout": self.submit_timeout,
            "native_enabled": self.native_enabled,
        }


CONFIG = MinerConfig()
