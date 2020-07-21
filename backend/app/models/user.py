from pydantic import BaseModel
from typing import List
from .task import DBTask


class User(BaseModel):
    username: str
    task_list: List[DBTask]
