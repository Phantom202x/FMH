import base64
import os
from datetime import date, datetime
from typing import Any, Dict, List, Optional
from uuid import uuid4

import requests
from pydantic import BaseModel, TypeAdapter, field_serializer

DEFAULT_API_URL = os.environ.get("DEFAULT_API_URL", "http://127.0.0.1:8000")

USER_1_PHOTO = (
    "https://drive.google.com/uc?export=download&id=1toJFrc4zLEj5M-eUTiBMFcT-tctTrWtb"
)
USER_2_PHOTO = (
    "https://drive.google.com/uc?export=download&id=1A9OTtR61klvnsO-axOFL2Z4OQGR7NXVh"
)
USER_3_PHOTO = (
    "https://drive.google.com/uc?export=download&id=1apYr0PBOX81qyAtPqF-FZgc07gTC14QZ"
)


def download_image(url: str) -> str:
    resp = requests.get(url)
    resp.raise_for_status()
    return base64.b64encode(resp.content).decode()


class User(BaseModel):
    uid: str
    first_name: str
    last_name: str
    dob: date
    nationality: Optional[str] = None
    blood_type: Optional[str] = None
    gender: Optional[str] = None
    photo: Optional[str] = None

    @field_serializer("dob")
    def serialse_dob(self, dob: date) -> str:
        return dob.isoformat()


class SearchUser(BaseModel):
    first_name: str
    last_name: str
    dob: date

    @field_serializer("dob")
    def serialse_dob(self, dob: date) -> str:
        return dob.isoformat()


class NewEmbedding(BaseModel):
    uid: str
    img: str


class RecogniseFace(BaseModel):
    img: str


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


class FindHadjiApi:
    def __init__(self, api_base_url: Optional[str] = None):
        self._url = f"{api_base_url or DEFAULT_API_URL}/v1/fmh"
        self._check_status()

    def _check_status(self):
        requests.get(f"{self._url}/internal/ready").raise_for_status()

    def _post(self, suffix: str, model: Optional[BaseModel] = None) -> Dict[Any, Any]:
        endpoint = f"{self._url}/{suffix}"

        resp = requests.post(
            endpoint,
            json=model.model_dump(),
        )

        resp.raise_for_status()

        return resp.json()

    def user_create(self, user: User):
        endpoint = f"{self._url}/users/"

        resp = requests.post(
            endpoint,
            json=user.model_dump(),
        )

        resp.raise_for_status()

    def user_get(self, uid: str) -> User:
        endpoint = f"{self._url}/users/{uid}"

        resp = requests.get(endpoint)

        resp.raise_for_status()

        return User(**resp.json())

    def user_search(self, query: SearchUser) -> User:
        endpoint = f"{self._url}/users/search"

        resp = requests.post(
            endpoint,
            json=query.model_dump(),
        )

        resp.raise_for_status()

        return User(**resp.json())

    def embeddings_register(self, embd: NewEmbedding):
        endpoint = f"{self._url}/embeddings/"

        resp = requests.post(
            endpoint,
            json=embd.model_dump(),
        )

        resp.raise_for_status()

    def embeddings_recognise(self, face: RecogniseFace) -> str:
        endpoint = f"{self._url}/embeddings/recognise"

        resp = requests.post(
            endpoint,
            json=face.model_dump(),
        )

        resp.raise_for_status()

        return resp.text

    def report_create(self, report: NewReport) -> Report:
        endpoint = f"{self._url}/reports/"

        resp = requests.post(
            endpoint,
            json=report.model_dump(),
        )

        resp.raise_for_status()

        return Report(**resp.json())

    def report_get_all(self) -> List[Report]:
        endpoint = f"{self._url}/reports/"

        resp = requests.get(endpoint)

        resp.raise_for_status()

        return TypeAdapter(List[Report]).validate_python(resp.json())

    def report_get_user(self, uid: str) -> List[Report]:
        endpoint = f"{self._url}/reports/user/{uid}"

        resp = requests.get(endpoint)

        resp.raise_for_status()

        return TypeAdapter(List[Report]).validate_python(resp.json())
        pass

    def report_get(self, rid: str) -> Report:
        endpoint = f"{self._url}/reports/{rid}"

        resp = requests.get(endpoint)

        resp.raise_for_status()

        return Report(**resp.json())

    def report_update(self, rid: str, update: UpdateReport) -> Report:
        endpoint = f"{self._url}/reports/{rid}"

        resp = requests.put(
            endpoint,
            json=update.model_dump(),
        )

        resp.raise_for_status()

    def report_delete(self, rid: str):
        endpoint = f"{self._url}/reports/{rid}"

        resp = requests.delete(endpoint)

        resp.raise_for_status()


if __name__ == "__main__":

    print(f"[-] setting up api...")
    client = FindHadjiApi()

    print(f"[-] setting up users...")

    user_1 = User(
        uid=str(uuid4()),
        first_name="Name-1",
        last_name="Family-1",
        dob=date(2001, 1, 1),
        nationality="dz",
        gender="male",
        photo=download_image(USER_1_PHOTO),
    )

    user_2 = User(
        uid=str(uuid4()),
        first_name="Name-2",
        last_name="Family-2",
        dob=date(2002, 2, 2),
        nationality="dz",
        gender="male",
        photo=download_image(USER_2_PHOTO),
    )

    user_3 = User(
        uid=str(uuid4()),
        first_name="Name-3",
        last_name="Family-3",
        dob=date(2003, 3, 3),
        nationality="dz",
        gender="male",
        photo=download_image(USER_3_PHOTO),
    )

    print(f"[-] creating users...")

    client.user_create(user_1)
    client.user_create(user_2)
    client.user_create(user_3)

    print(f"[-] checking created users...")

    assert client.user_get(user_1.uid) == user_1
    assert client.user_get(user_2.uid) == user_2
    assert client.user_get(user_3.uid) == user_3

    print(f"[-] searching for created users...")

    assert (
        client.user_search(
            SearchUser(
                first_name=user_1.first_name, last_name=user_1.last_name, dob=user_1.dob
            )
        )
        == user_1
    )
    assert (
        client.user_search(
            SearchUser(
                first_name=user_2.first_name, last_name=user_2.last_name, dob=user_2.dob
            )
        )
        == user_2
    )
    assert (
        client.user_search(
            SearchUser(
                first_name=user_3.first_name, last_name=user_3.last_name, dob=user_3.dob
            )
        )
        == user_3
    )

    print(f"[-] registering embeddings for users...")

    client.embeddings_register(NewEmbedding(uid=user_1.uid, img=user_1.photo))
    client.embeddings_register(NewEmbedding(uid=user_2.uid, img=user_2.photo))
    client.embeddings_register(NewEmbedding(uid=user_3.uid, img=user_3.photo))

    print(f"[-] checking embeddings for users...")

    assert client.embeddings_recognise(RecogniseFace(img=user_1.photo)) == user_1.uid
    assert client.embeddings_recognise(RecogniseFace(img=user_2.photo)) == user_2.uid
    assert client.embeddings_recognise(RecogniseFace(img=user_3.photo)) == user_3.uid

    print(f"[-] creating missing reports...")

    report_1 = client.report_create(NewReport(missing=user_1.uid, author=user_2.uid))
    assert len(client.report_get_all()) == 1

    report_2 = client.report_create(NewReport(missing=user_2.uid, author=user_3.uid))
    assert len(client.report_get_all()) == 2

    print(f"[-] checking missing reports...")

    assert client.report_get(report_1.rid) == report_1
    assert client.report_get(report_2.rid) == report_2

    assert len(client.report_get_user(report_1.author)) == 1
    assert len(client.report_get_user(report_2.author)) == 1

    print(f"[-] deleting and resolving missing reports...")

    client.report_delete(report_1.rid)
    assert len(client.report_get_all()) == 1
    assert len(client.report_get_user(report_1.author)) == 0

    client.report_update(report_2.rid, UpdateReport(found=True))
    assert len(client.report_get_all()) == 0
    assert len(client.report_get_user(report_2.author)) == 0

    print(f"[+] all checks passed successfully.")
