from motor.motor_asyncio import AsyncIOMotorClient
from ..core.config import MONGODB_URI


class Database:
    client: AsyncIOMotorClient = None


db = Database()


async def get_database() -> AsyncIOMotorClient:
    return db.client


async def connect_to_mongo():
    db.client = AsyncIOMotorClient(MONGODB_URI)


async def close_mongo():
    db.client.close()
