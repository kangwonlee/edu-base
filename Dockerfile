# Copyright (c) 2025 Kangwon Lee
# Source repository: https://github.com/kangwonlee/edu-base

# Builder stage
# Install tools and build dependencies
FROM python:3.11.11-slim AS builder

# install build tools & libs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a normal user
RUN useradd -u 1001 -m runner

# Switch to the normal user
USER runner

WORKDIR /app

COPY requirements.txt /requirements.txt

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install --no-cache-dir --requirement /requirements.txt \
    && find /home/runner/.local -name "*.pyc" -delete \
    && find /home/runner/.local -name "*.egg-info" -exec rm -rf {} +

# Final stage
# Copy only the runtime essentials
FROM python:3.11.11-slim

LABEL maintainer="kangwon@gmail.com" \
    org.opencontainers.image.description="A Docker image with Python and pytest" \
    org.opencontainers.image.authors="Kangwon Lee, kangwon@gmail.com, https://github.com/kangwonlee" \
    org.opencontainers.image.source="https://github.com/kangwonlee/edu-base" \
    org.opencontainers.image.title="edu-base"

USER runner

WORKDIR /app

# Copy installed Python packages from builder
COPY --from=builder /home/runner/.local/lib/python3.11/site-packages /home/runner/.local/lib/python3.11/site-packages
COPY --from=builder /home/runner/.local/bin /home/runner/.local/bin

# Ensure Python can find the user-installed packages
ENV PATH=/home/runner/.local/bin:$PATH

# Optional: Copy requirements.txt if needed for reference
COPY requirements.txt /requirements.txt
