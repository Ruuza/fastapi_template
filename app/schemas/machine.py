from pydantic import BaseModel


class Machine(BaseModel):
    id: int
    sn: str
    mac: str
    location: str
    multigame: str | None
    location_id: int


class MachineStats(Machine):
    bk_in: int
    bk_out: int
    netto: int
    payout: float | None
    rtp: float | None
