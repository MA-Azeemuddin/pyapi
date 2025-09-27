# === Stage 1: Builder
ARG PYTHON_VERSION=3.13.5
FROM python:${PYTHON_VERSION}-slim AS build

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Install required system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        curl \
        libffi-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install uv
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir uv

# Copy project files
COPY . .

# === Stage 2: Runtime image
FROM python:${PYTHON_VERSION}-slim AS final

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy installed packages and source code from build stage
COPY --from=build /usr/local /usr/local
COPY --from=build /app /app

EXPOSE 3030

CMD ["uv", "run", "uvicorn", "app.main:app", "--reload", "--port", "3030", "--host", "0.0.0.0"]
