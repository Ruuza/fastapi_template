from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from app.config import settings
from app.api.api_v1.api import api_router

app = FastAPI(title=settings.PROJECT_NAME)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix=settings.API_V1_STR)
