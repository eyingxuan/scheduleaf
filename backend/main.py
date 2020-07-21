from typing import Optional
from pydantic import BaseModel

from fastapi import FastAPI

app = FastAPI()

class Sched(BaseModel):
    name: str
    msg: str

bad_local = Sched(**{"name": "will", "msg": "hello will"})


@app.get("/sched/{id}")
async def get_sched(id: int):
    return bad_local

@app.put("/sched/{id}")
async def get_sched(id: int, sched: Sched):
    global bad_local
    bad_local = sched
    return {"message": f"you requested the schedule for {id}"}
