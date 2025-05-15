from datetime import date
from typing import Optional

from app.db import db_get
from fastapi import APIRouter, Depends, HTTPException, status
from psycopg_pool import AsyncConnectionPool
from pydantic import BaseModel

router = APIRouter(prefix="/users", tags=["users"])


class User(BaseModel):
    uid: str
    first_name: str
    last_name: str
    dob: date
    nationality: Optional[str] = None
    blood_type: Optional[str] = None
    gender: Optional[str] = None
    photo: Optional[str] = None


class SearchUser(BaseModel):
    first_name: str
    last_name: str
    dob: date


async def get_db_user(uid: str, db: AsyncConnectionPool) -> Optional[User]:
    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT first_name, last_name, dob, nationality, gender, blood_type, photo
                FROM users
                WHERE uid = %s
                """,
                (uid,),
            )

            rec = await cur.fetchone()

            if rec is None:
                return None

            return User(
                uid=uid,
                first_name=rec[0],
                last_name=rec[1],
                dob=rec[2],
                nationality=rec[3],
                gender=rec[4],
                blood_type=rec[5],
                photo=rec[6],
            )


@router.post("/", response_model=None)
async def create_user(user: User, db: AsyncConnectionPool = Depends(db_get)):

    rec = await get_db_user(user.uid, db)
    if rec is not None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="user already exists",
        )

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                INSERT INTO users (uid, first_name, last_name, dob, nationality, gender, blood_type, photo)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (
                    user.uid,
                    user.first_name,
                    user.last_name,
                    user.dob,
                    user.nationality,
                    user.gender,
                    user.blood_type,
                    user.photo,
                ),
            )


@router.get("/{uid}", response_model=User)
async def get_user(uid: str, db: AsyncConnectionPool = Depends(db_get)):
    user = await get_db_user(uid, db)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="user not found"
        )

    return user


@router.post("/search", response_model=User)
async def serach_user(query: SearchUser, db: AsyncConnectionPool = Depends(db_get)):

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT uid, first_name, last_name, dob, nationality, gender, blood_type, photo
                FROM users
                WHERE first_name = %s AND last_name = %s AND dob = %s
                """,
                (query.first_name, query.last_name, query.dob),
            )

            rec = await cur.fetchone()
            if rec is None:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND, detail="user not found"
                )

            return User(
                uid=rec[0],
                first_name=rec[1],
                last_name=rec[2],
                dob=rec[3],
                nationality=rec[4],
                gender=rec[5],
                blood_type=rec[6],
                photo=rec[7],
            )


@router.delete("/{uid}", response_model=None)
async def delete_user(uid: str, db: AsyncConnectionPool = Depends(db_get)):
    user = await get_db_user(uid, db)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="user not found"
        )

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                DELETE FROM users
                WHERE uid = %s
                """,
                (uid,),
            )
