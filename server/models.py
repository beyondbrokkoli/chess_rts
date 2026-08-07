# models.py
from pydantic import BaseModel, Field

class NodePayload(BaseModel):
    # IPs must be strings of at least 7 chars (e.g. "1.1.1.1") and max 15 (e.g. "255.255.255.255")
    public_ip: str = Field(..., min_length=7, max_length=15)
    local_ip: str = Field(..., min_length=7, max_length=15)

    # Ports must be valid UDP ranges
    public_port: int = Field(..., ge=1, le=65535)
    local_port: int = Field(..., ge=1, le=65535)

    # THE SABOTAGE BLOCKER: Must be exactly between 2 and 8.
    target_size: int = Field(default=2, ge=2, le=8)
