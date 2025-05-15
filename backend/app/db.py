from typing import Optional

from psycopg_pool import AsyncConnectionPool

pool: Optional[AsyncConnectionPool] = None


async def db_init():
    global pool
    if pool is None:
        p = AsyncConnectionPool(min_size=4, open=False)
        await p.open(wait=30, timeout=30)
        pool = p


async def db_get():
    global pool

    if pool is None:
        raise RuntimeError("database was not initialised")

    return pool


async def db_close():
    global pool
    if pool:
        await pool.close()
        pool = None
