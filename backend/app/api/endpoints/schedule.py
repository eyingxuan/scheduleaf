from fastapi import APIRouter, Depends, HTTPException
from fastapi.concurrency import run_in_threadpool
from ...models.user import db_create_user, db_get_user, User
from ...models.task import db_get_tasks, db_update_tasks, UserTasks, UserSchedule
from ...db.db import AsyncIOMotorClient, get_database
from ...solver.sentiment import SentimentIntensityAnalyzer, get_analyzer
from ...solver.util import plan_schedule

router = APIRouter()


@router.post("/user", response_model=bool)
async def create_user(user: User, db: AsyncIOMotorClient = Depends(get_database)):
    return await db_create_user(user, db)


@router.get("/user", response_model=bool)
async def get_user(user: User, db: AsyncIOMotorClient = Depends(get_database)):
    return await db_get_user(user, db)


@router.get("/tasks/{username}", response_model=UserTasks)
async def retrieve_tasks(username: str, db: AsyncIOMotorClient = Depends(get_database)):
    res = await db_get_tasks(username, db)
    if not res:
        raise HTTPException(status_code=400)
    return res


@router.put("/tasks", response_model=bool)
async def update_tasks(
    user_task: UserTasks, db: AsyncIOMotorClient = Depends(get_database)
):
    return await db_update_tasks(user_task, db)


@router.get("/tasks/generate/{username}", response_model=UserSchedule)
async def generate_plan(
    username: str,
    db: AsyncIOMotorClient = Depends(get_database),
    sentiment: SentimentIntensityAnalyzer = Depends(get_analyzer),
):
    tasks = await db_get_tasks(username, db)
    if not tasks:
        raise HTTPException(status_code=400)
    sched = await run_in_threadpool(plan_schedule, tasks, sentiment)
    if not sched:
        raise HTTPException(status_code=400, detail="task list has conflicts")
    return sched
