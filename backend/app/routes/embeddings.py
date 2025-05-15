import base64
import io
import json
from typing import Any, Dict, List, Optional, Tuple

import numpy as np
from app.config import SIMILARITY_THRESHOLD
from app.db import db_get
from app.ml import cosine_similarity
from app.ml import extract_face as _extract_face
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import PlainTextResponse
from PIL import Image
from psycopg_pool import AsyncConnectionPool
from pydantic import BaseModel

router = APIRouter(prefix="/embeddings", tags=["embeddings"])


class NewEmbedding(BaseModel):
    uid: str
    img: str


class RecogniseFace(BaseModel):
    img: str


def extract_face(img_b64: str) -> Optional[Dict[Any, Any]]:
    return _extract_face(
        Image.open(io.BytesIO(base64.b64decode(img_b64))).convert("RGB")
    )


async def get_all_embeddings(
    db: AsyncConnectionPool,
) -> List[Tuple[str, Dict[Any, Any]]]:
    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                SELECT uid, face
                FROM embeddings
                """
            )

            embeddings = []
            async for embd in cur:
                embeddings.append(embd)

            return embeddings


@router.post("/", response_model=None)
async def register_user_embedding(
    face: NewEmbedding, db: AsyncConnectionPool = Depends(db_get)
):
    embedding = extract_face(face.img)
    if embedding is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="malformed image"
        )

    async with db.connection() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                INSERT INTO embeddings (uid, face)
                VALUES (%s, %s)
                ON CONFLICT (uid) DO UPDATE
                SET face = EXCLUDED.face
                """,
                (face.uid, json.dumps(embedding)),
            )


@router.post("/recognise", response_class=PlainTextResponse)
async def recognize_face(
    face: RecogniseFace, db: AsyncConnectionPool = Depends(db_get)
):

    test_embedding = extract_face(face.img)
    if test_embedding is None:
        return {"message": "No face detected"}

    embeddings = await get_all_embeddings(db)
    max_similarity = -1
    best_match = None

    for record in embeddings:
        embedding = np.array(record[1], dtype=np.float32)
        similarity = cosine_similarity(test_embedding, embedding)
        if similarity > max_similarity:
            max_similarity = similarity
            best_match = record

    if max_similarity > SIMILARITY_THRESHOLD:
        return best_match[0]

    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="no match")
