from pydantic import BaseModel
from .db.db import connect_to_mongo, close_mongo, AsyncIOMotorClient, get_database
from .api.api import router as api_router
from .solver.sentiment import create_analyzer

from fastapi import FastAPI, Depends, applications
from fastapi.middleware.cors import CORSMiddleware

from fastapi.openapi.docs import get_swagger_ui_html


def swagger_monkey_patch(*args, **kwargs):
    """
    Wrap the function which is generating the HTML for the /docs endpoint and
    overwrite the default values for the swagger js and css.
    """
    return get_swagger_ui_html(
        *args,
        **kwargs,
        swagger_js_url="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3.29/swagger-ui-bundle.js",
        swagger_css_url="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3.29/swagger-ui.css"
    )


# Actual monkey patch
applications.get_swagger_ui_html = swagger_monkey_patch


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_event_handler("startup", connect_to_mongo)
app.add_event_handler("startup", create_analyzer)
app.add_event_handler("shutdown", close_mongo)

# class Sched(BaseModel):
#     name: str
#     msg: str


# bad_local = Sched(**{"name": "will", "msg": "hello will"})


# @app.get("/sched/{id}")
# async def get_sched(id: int):
#     return bad_local


# @app.put("/sched/{id}")
# async def put_sched(id: int, sched: Sched):
#     global bad_local
#     bad_local = sched
#     return {"message": f"you requested the schedule for {id}"}
#


# @app.get("/test")
# async def get_test(db: AsyncIOMotorClient = Depends(get_database)):
#     ans = await db["test"]["test"].find_one()
#     return {"res": ans["hello"]}

app.include_router(api_router)
