from pydantic import BaseModel
from typing import List
from .task import DBTask, ScheduledTask
from ..core.config import DATABASE_NAME, USER_COLLECTION, TASKS_COLLECTION
from ..db.db import AsyncIOMotorClient


class User(BaseModel):
    username: str
    # add other things like user preferences + password


async def db_create_user(user: User, db: AsyncIOMotorClient) -> bool:
    try:
        await db[DATABASE_NAME][USER_COLLECTION].insert_one(user.dict())
        await db[DATABASE_NAME][TASKS_COLLECTION].insert_one(
            {"username": user.username, "task_list": []}
        )
    except Exception:
        return False

    return True


async def db_get_user(user: User, db: AsyncIOMotorClient) -> bool:
    try:
        return await db[DATABASE_NAME][USER_COLLECTION].find_one(
            {"username": user.username}
        )
    except Exception:
        return False
