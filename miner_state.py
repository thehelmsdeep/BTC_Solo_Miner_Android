"""Small explicit state machine for the upstream/mining lifecycle."""

from enum import Enum


class MinerState(str, Enum):
    STOPPED = "stopped"
    CONNECTING = "connecting"
    CONNECTED = "connected"
    MINING = "mining"
    RECONNECTING = "reconnecting"


class MinerStateMachine:
    _ALLOWED = {
        MinerState.STOPPED: {MinerState.CONNECTING},
        MinerState.CONNECTING: {MinerState.CONNECTED, MinerState.RECONNECTING, MinerState.STOPPED},
        MinerState.CONNECTED: {MinerState.MINING, MinerState.RECONNECTING, MinerState.STOPPED},
        MinerState.MINING: {MinerState.RECONNECTING, MinerState.STOPPED, MinerState.MINING},
        MinerState.RECONNECTING: {MinerState.CONNECTING, MinerState.STOPPED},
    }

    def __init__(self):
        self.state = MinerState.STOPPED

    def transition(self, new_state):
        if new_state == self.state:
            return self.state
        if new_state not in self._ALLOWED[self.state]:
            raise ValueError(
                "invalid miner state transition: %s -> %s"
                % (self.state.value, new_state.value)
            )
        self.state = new_state
        return self.state

    def reset(self):
        self.state = MinerState.STOPPED

    def __str__(self):
        return self.state.value
