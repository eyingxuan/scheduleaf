import os

from dotenv import load_dotenv

load_dotenv(".env")

MONGODB_URI: str = os.getenv("MONGODB_URI")

DATABASE_NAME = "hackathon"
USER_COLLECTION = "users"
TASKS_COLLECTION = "tasks"
