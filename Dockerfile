# Copyright (c) 2025 Kangwon Lee
# Source repository: https://github.com/kangwonlee/edu-base

FROM python:3.11.11-slim

LABEL maintainer="kangwon@gmail.com" \
    org.opencontainers.image.description="A Docker image with Python, pytest, and scipy modules" \
    org.opencontainers.image.authors="Kangwon Lee, kangwon@gmail.com, https://github.com/kangwonlee" \
    org.opencontainers.image.source="https://github.com/kangwonlee/edu-base" \
    org.opencontainers.image.title="edu-base" 

RUN apt-get update && apt-get install -y build-essential gfortran pkg-config

# Ensure deb-src lines are present in sources.list
RUN if [ -f /etc/apt/sources.list ]; then \
        sed -i 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
        apt-get update; \
    else \
        echo "deb http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
        apt-get update; \
    fi

RUN apt-get update && apt-get build-dep -y numpy cmake scipy

RUN useradd -m educator

# Switch to the non-root user
USER educator

COPY requirements.txt /requirements.txt

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir --requirement /requirements.txt
