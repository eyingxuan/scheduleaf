from fastapi import APIRouter, Depends, HTTPException
from ...models.user import User
from ...db.db import AsyncIOMotorClient, get_database
from ...core.config import DATABASE_NAME, COLLECTION_NAME

router = APIRouter()


@router.get("/tasks/{username}", response_model=User)
async def retrieve_tasks(username: str, db: AsyncIOMotorClient = Depends(get_database)):
    row = await db[DATABASE_NAME][COLLECTION_NAME].find_one({"username": username})
    if not row:
        raise HTTPException(status_code=404, detail="user not found")
    user = User(**row)
    return user


@router.post("/tasks/{username}", response_model=bool)
async def create_tasks(username: str, db: AsyncIOMotorClient = Depends(get_database)):
    try:
        result = await db[DATABASE_NAME][COLLECTION_NAME].insert_one(
            {"username": username, "task_list": []}
        )
    except Exception:
        result = None
    return not result is None


@router.put("/tasks", response_model=bool)
async def update_tasks(body: User, db: AsyncIOMotorClient = Depends(get_database)):
    result = await db[DATABASE_NAME][COLLECTION_NAME].replace_one(
        {"username": body.username}, body.dict(), upsert=True
    )
    return result.upserted_id or result.modified_count == 1
