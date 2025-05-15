from datetime import datetime, timezone
from typing import List, Optional
from uuid import uuid4

from app.db import db_get
from fastapi import APIRouter, Depends, HTTPException, status
from psycopg_pool import AsyncConnectionPool
from pydantic import BaseModel

router = APIRouter(prefix="/reports", tags=["reports"])


class NewReport(BaseModel):
    missing: str
    author: str


class Report(BaseModel):
    rid: str
    author: str
    missing: str
    created_at: datetime
    found: bool


class UpdateReport(BaseModel):
    found: bool


async def get_db_report(rid: str, db: AsyncConnectionPool) -> Optional[Report]:
    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT author, missing, created_at, found
                FROM reports
                WHERE rid = %s
                """,
                (rid,),
            )

            rec = await cur.fetchone()

            if rec is None:
                return None

            return Report(
                rid=rid,
                author=rec[0],
                missing=rec[1],
                created_at=rec[2],
                found=rec[3],
            )


@router.post("/", response_model=Report)
async def create_report(report: NewReport, db: AsyncConnectionPool = Depends(db_get)):

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT rid
                FROM reports
                WHERE missing = %s 
                """,
                (report.missing,),
            )

            rec = await cur.fetchone()
            if rec is not None:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="missing user already reported",
                )

            rid = str(uuid4())
            create_at = datetime.now(timezone.utc)

            await cur.execute(
                """
                INSERT INTO reports (rid, author, missing, created_at)
                VALUES (%s, %s, %s, %s)
                """,
                (
                    rid,
                    report.author,
                    report.missing,
                    create_at,
                ),
            )

            return Report(
                rid=rid,
                author=report.author,
                missing=report.missing,
                created_at=create_at,
                found=False,
            )


@router.get("/", response_model=List[Report])
async def get_all_ative_report(db: AsyncConnectionPool = Depends(db_get)):

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT rid, author, missing, created_at
                FROM reports
                WHERE found = false
                ORDER BY created_at DESC
                """
            )

            reports = []
            async for rid, author, missing, created_at in cur:
                reports.append(
                    Report(
                        rid=rid,
                        author=author,
                        missing=missing,
                        created_at=created_at,
                        found=False,
                    )
                )

            return reports


@router.get("/user/{uid}", response_model=List[Report])
async def get_all_user_ative_report(
    uid: str, db: AsyncConnectionPool = Depends(db_get)
):

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT rid, author, missing, created_at
                FROM reports
                WHERE author = %s AND found = false
                ORDER BY created_at DESC
                """,
                (uid,),
            )

            reports = []
            async for rid, author, missing, created_at in cur:
                reports.append(
                    Report(
                        rid=rid,
                        author=author,
                        missing=missing,
                        created_at=created_at,
                        found=False,
                    )
                )

            return reports


@router.get("/{rid}", response_model=Report)
async def get_report(rid: str, db: AsyncConnectionPool = Depends(db_get)):
    report = await get_db_report(rid, db)
    if report is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="report not found"
        )

    return report


@router.put("/{rid}", response_model=None)
async def update_report(
    rid: str, update: UpdateReport, db: AsyncConnectionPool = Depends(db_get)
):
    report = await get_db_report(rid, db)
    if report is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="report not found"
        )

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                UPDATE reports
                SET found = %s
                WHERE rid = %s
                """,
                (update.found, rid),
            )


@router.delete("/{rid}", response_model=None)
async def delete_report(rid: str, db: AsyncConnectionPool = Depends(db_get)):
    report = await get_db_report(rid, db)
    if report is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="report not found"
        )

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                DELETE FROM reports
                WHERE rid = %s
                """,
                (rid,),
            )
