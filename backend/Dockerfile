FROM python:3.11-slim

RUN apt update &&   \
    apt install -y  \
        build-essential \
        curl \
        postgresql-client \
        unzip

RUN pip install --upgrade pip

WORKDIR /app

RUN mkdir -p ~/.insightface/models/buffalo_l && \
    cd ~/.insightface/models/buffalo_l && \
    curl -OL https://github.com/deepinsight/insightface/releases/download/v0.7/buffalo_l.zip && \
    unzip buffalo_l.zip && \
    rm buffalo_l.zip

COPY ./backend/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY ./backend .

ENV PYTHONUNBUFFERED=1

EXPOSE 8000

CMD ["uvicorn", "app:api", "--host", "0.0.0.0", "--port", "8000"]

