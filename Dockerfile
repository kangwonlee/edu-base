# Copyright (c) 2025 Kangwon Lee
# Source repository: https://github.com/kangwonlee/edu-base

FROM ghcr.io/astral-sh/uv:python3.13-alpine

LABEL maintainer="kangwon@gmail.com" \
    org.opencontainers.image.description="A Docker image with Python and pytest" \
    org.opencontainers.image.authors="Kangwon Lee, kangwon@gmail.com, https://github.com/kangwonlee" \
    org.opencontainers.image.source="https://github.com/kangwonlee/edu-base" \
    org.opencontainers.image.title="edu-base"

RUN apk add --no-cache git

WORKDIR /app

COPY pyproject.toml /app/pyproject.toml

RUN git clone --depth=1 --branch v0.3.13 https://github.com/kangwonlee/gemini-python-tutor /app/temp/

RUN uv pip install --no-cache-dir --system /app/ \
    && uv pip install --no-cache-dir --system --requirement /app/temp/requirements.txt \
    && mkdir -p /app/ai_tutor/ \
    && mv /app/temp/*.py /app/ai_tutor || true \
    && mv /app/temp/locale/ /app/ai_tutor/locale/ \
    && rm -rf /app/temp

RUN adduser runner --uid 1001 --disabled-password

# Switch to the non-root user
USER runner

CMD ["python3", "-m", "pytest", "--version"]
