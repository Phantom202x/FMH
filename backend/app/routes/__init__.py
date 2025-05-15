from fastapi import APIRouter

from . import embeddings, internal, reports, users

router = APIRouter(prefix="/v1/fmh")
router.include_router(internal.router)
router.include_router(embeddings.router)
router.include_router(users.router)
router.include_router(reports.router)
