# Copyright (c) 2025 Kangwon Lee
# Source repository: https://github.com/kangwonlee/edu-base

FROM python:3.11.11-slim

LABEL maintainer="kangwon@gmail.com" \
    org.opencontainers.image.description="A Docker image with Python and pytest" \
    org.opencontainers.image.authors="Kangwon Lee, kangwon@gmail.com, https://github.com/kangwonlee" \
    org.opencontainers.image.source="https://github.com/kangwonlee/edu-base" \
    org.opencontainers.image.title="edu-base" 

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -u 1001 -m runner

# Switch to the non-root user
USER runner

WORKDIR /app

COPY requirements.txt /requirements.txt

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir --user --requirement /requirements.txt

RUN git clone https://github.com/kangwonlee/gemini-python-tutor/ /app/temp/ &&\
    python3 -m pip install --no-cache-dir --user --requirement /app/temp/requirements.txt

COPY /app/temp/*.py /app/ai_tutor/*.py

RUN rm -rf /app/temp/*
