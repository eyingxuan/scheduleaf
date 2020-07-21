import os

from dotenv import load_dotenv

load_dotenv(".env")

MONGODB_URI: str = os.getenv("MONGODB_URI")

DATABASE_NAME = "hackathon"
COLLECTION_NAME = "tasks"
