from pydantic import BaseModel

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)


class Sched(BaseModel):
    name: str
    msg: str


bad_local = Sched(**{"name": "will", "msg": "hello will"})


@app.get("/sched/{id}")
async def get_sched(id: int):
    return bad_local


@app.put("/sched/{id}")
async def put_sched(id: int, sched: Sched):
    global bad_local
    bad_local = sched
    return {"message": f"you requested the schedule for {id}"}
