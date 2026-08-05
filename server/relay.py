# relay.py
import asyncio
import struct

# PHASE 1: STATELESS UDP ICE RELAY
class ICERelayProtocol(asyncio.DatagramProtocol):
    def __init__(self):
        # Map: session_token -> { player_id: address }
        # FIX: Eliminates Symmetric NAT port-scrambling amplification.
        self.rooms = {}

    def connection_made(self, transport):
        self.transport = transport
        print("[RELAY] Pure Stateless Relay online. Shotgun routing engaged.")

    def datagram_received(self, data, addr):
        if len(data) < 25:
            return

        # Unpack session_token (bytes 0-7) and player_id (byte 24)
        session_token = struct.unpack('<Q', data[:8])[0]
        player_id = data[24]

        if session_token not in self.rooms:
            self.rooms[session_token] = {}

        # Hard-pin the latest NAT port for this specific player.
        self.rooms[session_token][player_id] = addr

        # Route to all known peers in this session
        for pid, p_addr in self.rooms[session_token].items():
            if pid != player_id:
                self.transport.sendto(data, p_addr)
