from pydantic import BaseModel
from typing import Optional, List

from ..db.db import AsyncIOMotorClient
from ..core.config import DATABASE_NAME, TASKS_COLLECTION


class DBTask(BaseModel):
    task_id: int
    title: str
    duration: int
    deadline: int
    start_time: Optional[int]
    concurrent: bool
    precedes: List[int]
    description: str


class ScheduledTask(DBTask):
    scheduled_start: int


class UserTasks(BaseModel):
    username: str
    task_list: List[DBTask]


class UserSchedule(BaseModel):
    username: str
    task_list: List[ScheduledTask]


async def db_get_tasks(username: str, db: AsyncIOMotorClient) -> Optional[UserTasks]:
    try:
        row = await db[DATABASE_NAME][TASKS_COLLECTION].find_one({"username": username})
        user_task = UserTasks(**row)
    except Exception:
        user_task = None

    return user_task


async def db_update_tasks(user_task: UserTasks, db: AsyncIOMotorClient) -> bool:
    try:
        res = await db[DATABASE_NAME][TASKS_COLLECTION].replace_one(
            {"username": user_task.username}, user_task.dict()
        )
        return res.modified_count == 1
    except Exception:
        return False
