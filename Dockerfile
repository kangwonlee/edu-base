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

RUN git clone https://github.com/kangwonlee/gemini-python-tutor/ /app/temp/

RUN python3 -m pip install --upgrade pip &&\
    python3 -m pip install --no-cache-dir --user --requirement /requirements.txt &&\
    python3 -m pip install --no-cache-dir --user --requirement /app/temp/requirements.txt &&\
    mkdir -p /app/ai_tutor/ &&\
    mv /app/temp/*.py /app/ai_tutor || true &&\
    mv /app/temp/locale/ /app/ai_tutor/locale/ &&\
    rm -rf /app/temp

CMD ["python3", "-m", "pytest", "--version"]
