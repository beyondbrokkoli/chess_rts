# relay.py
import asyncio
import struct

class ICERelayProtocol(asyncio.DatagramProtocol):
    def __init__(self):
        self.rooms = {}

    def connection_made(self, transport):
        self.transport = transport
        print("[RELAY] Pure Stateless Relay online. Shotgun routing engaged.")

    def datagram_received(self, data, addr):
        # The Universal Header is exactly 10 bytes (8 + 1 + 1)
        if len(data) < 10:
            return

        # Session Token is always bytes 0-7
        session_token = struct.unpack('<Q', data[:8])[0]

        # Player ID is always locked at byte 8
        player_id = data[8]

        if session_token not in self.rooms:
            self.rooms[session_token] = {}

        self.rooms[session_token][player_id] = addr

        for pid, p_addr in self.rooms[session_token].items():
            if pid != player_id:
                self.transport.sendto(data, p_addr)
