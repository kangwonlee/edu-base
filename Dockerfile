# Copyright (c) 2025 Kangwon Lee
# Source repository: https://github.com/kangwonlee/edu-base

FROM python:3.11.11-slim

LABEL maintainer="kangwon@gmail.com" \
    org.opencontainers.image.description="A Docker image with Python, pytest, and scipy modules" \
    org.opencontainers.image.authors="Kangwon Lee, kangwon@gmail.com, https://github.com/kangwonlee" \
    org.opencontainers.image.source="https://github.com/kangwonlee/edu-base" \
    org.opencontainers.image.title="edu-base" 

RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update && apt-get build-dep numpy=1.26

RUN useradd -m educator

# Switch to the non-root user
USER educator

COPY requirements.txt /requirements.txt

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir --requirement /requirements.txt
