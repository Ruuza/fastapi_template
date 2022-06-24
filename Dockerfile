# start from basic alpine python
FROM python:3.10.4-alpine3.15

# Docker is able to use stack of layers form previous builds.
# So lets place commands which does always same thing first
EXPOSE 8009
RUN mkdir -p /opt/app && mkdir -p /etc/app
VOLUME ["/etc/app"]
WORKDIR /opt/app

# Dependecies could change or get upgraded occasionally.
COPY requirements.txt /opt/app

# Install dependencies
# gcc libc-dev linux-headers are libs and tools for uwsgi building
# clear not required data at the end to reduce image size
RUN set -e; \
    apk update && apk add --no-cache --virtual .build-deps \
    build-base \
    gcc \
    libc-dev \
    musl-dev \
    linux-headers \
    bash \
    vim \
    python3-dev \
    libffi-dev \
    openssl-dev \
    tzdata \
    ; \
    pip install --ignore-installed --no-cache-dir -r requirements.txt;

# Your code is changing frequently, place it as last to prevent creation of new layer stack
COPY [".", "/opt/app"]

RUN alembic upgrade head

CMD ["gunicorn", "run:app", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8009"]
