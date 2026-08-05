# api.py
import time
import uuid
import random
from fastapi import APIRouter, HTTPException

from models import NodePayload
from state import lobbies

router = APIRouter()

@router.post("/host")
async def host_game(node: NodePayload):
    lobby_id = str(uuid.uuid4()).upper()[:4]
    lobbies[lobby_id] = {
        "session_token": random.getrandbits(63),
        "status": "holding",
        "start_time": 0.0,
        "target_size": node.target_size,
        "players": [node.dict()]
    }
    return {"lobby_id": lobby_id}

@router.post("/join/{lobby_id}")
async def join_game(lobby_id: str, node: NodePayload):
    if lobby_id not in lobbies:
        raise HTTPException(404)

    lobby = lobbies[lobby_id]

    if len(lobby["players"]) >= lobby["target_size"]:
        raise HTTPException(403)

    lobby["players"].append(node.dict())

    # FIX: 3-Second Atomic Clock Enforced
    if len(lobby["players"]) == lobby["target_size"]:
        lobby["status"] = "locked"
        lobby["start_time"] = time.time() + 3.0
        print(f"[LOBBY] {lobby_id} Consensus Reached. 3.0s Ignition sequence started.")

    return {"status": "ok"}

@router.get("/status/{lobby_id}")
async def check_status(lobby_id: str):
    if lobby_id not in lobbies:
        raise HTTPException(404)

    lobby = lobbies[lobby_id]
    return {
        "status": lobby["status"],
        "players": lobby["players"],
        "session_token": lobby["session_token"],
        "start_time": lobby["start_time"],
        "server_time": time.time()
    }
