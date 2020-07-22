from pydantic import BaseModel
from .db.db import connect_to_mongo, close_mongo, AsyncIOMotorClient, get_database
from .api.api import router as api_router
from .solver.sentiment import create_analyzer

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
app.add_event_handler("startup", create_analyzer)
app.add_event_handler("shutdown", close_mongo)

app.include_router(api_router)
