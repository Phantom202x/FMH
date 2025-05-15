from app.db import db_get
from fastapi import APIRouter, Depends, HTTPException, status
from psycopg_pool import AsyncConnectionPool

router = APIRouter(prefix="/internal", tags=["internal"])


@router.get("/ready")
async def readiness_probe(db: AsyncConnectionPool = Depends(db_get)):
    async with db.connection() as conn:
        async with conn.cursor() as cur:
            try:
                await cur.execute("SELECT 1")
                return {}
            except Exception:
                pass

    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="not ready")
