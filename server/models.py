# models.py
from pydantic import BaseModel

class NodePayload(BaseModel):
    public_ip: str
    public_port: int
    local_ip: str
    local_port: int
    target_size: int = 8
