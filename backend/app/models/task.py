from pydantic import BaseModel
from typing import Optional, List


class DBTask(BaseModel):
    task_id: int
    title: str
    duration: int
    start_time: Optional[int]
    concurrent: bool
    precedes: List[int]
    description: str


class ScheduledTask(DBTask):
    scheduled_start: int
