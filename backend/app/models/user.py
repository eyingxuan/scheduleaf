from pydantic import BaseModel
from typing import List
from .task import DBTask, ScheduledTask


class User(BaseModel):
    username: str
    task_list: List[DBTask]


class ScheduledUser(BaseModel):
    username: str
    task_list: List[ScheduledTask]
