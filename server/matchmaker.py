# matchmaker.py
import asyncio
import socket
from fastapi import FastAPI

from api import router
from relay import ICERelayProtocol

app = FastAPI()

# Mount the HTTP endpoints
app.include_router(router)

@app.on_event("startup")
async def startup():
    loop = asyncio.get_running_loop()
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 1024 * 1024 * 4)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 1024 * 1024 * 4)
    sock.setblocking(False)
    sock.bind(("0.0.0.0", 49152))

    await loop.create_datagram_endpoint(lambda: ICERelayProtocol(), sock=sock)
    print("[SYSTEM] Headless Orchestrator Online.")
