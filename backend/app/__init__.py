from contextlib import asynccontextmanager

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from .db import db_close, db_init
from .routes import router


@asynccontextmanager
async def lifespan(api: FastAPI):
    await db_init()
    yield
    await db_close()


api = FastAPI(description="Find My Hadji mobile app backend", lifespan=lifespan)
api.include_router(router)

# disable CORS
api.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
