from pydantic import BaseModel
from .db.db import connect_to_mongo, close_mongo, AsyncIOMotorClient, get_database
from .api.api import router as api_router

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_event_handler("startup", connect_to_mongo)
app.add_event_handler("shutdown", close_mongo)

# class Sched(BaseModel):
#     name: str
#     msg: str


# bad_local = Sched(**{"name": "will", "msg": "hello will"})


# @app.get("/sched/{id}")
# async def get_sched(id: int):
#     return bad_local


# @app.put("/sched/{id}")
# async def put_sched(id: int, sched: Sched):
#     global bad_local
#     bad_local = sched
#     return {"message": f"you requested the schedule for {id}"}
#


# @app.get("/test")
# async def get_test(db: AsyncIOMotorClient = Depends(get_database)):
#     ans = await db["test"]["test"].find_one()
#     return {"res": ans["hello"]}

app.include_router(api_router)
