from typing import Any, Dict, Optional

import numpy as np
from insightface.app import FaceAnalysis
from PIL import Image

analyser = FaceAnalysis(name="buffalo_l", providers=["CPUExecutionProvider"])
analyser.prepare(ctx_id=0)


# Define process_image correctly
def extract_face(img: Image) -> Optional[Dict[Any, Any]]:

    img_np = np.array(img)
    faces = analyser.get(img_np)

    if not faces:
        print("❌ No face detected")
        return None

    return faces[0].normed_embedding.tolist()


def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))
