# syntax=docker/dockerfile:1

###
### Builder stage produces a ipc_frontier wheel plus a pip-compatible requirements.lock file based on the poetry.lock
###
FROM python:3.13-slim AS builder

# Minimal system dependencies for building a wheel
RUN apt-get update \
    && apt-get install -y --no-install-recommends git curl ca-certificates build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry in order to export a requirements.txt that mirrors poetry.lock
# This will let us avoid including the large Poetry stack in the final runtime image
RUN python -m pip install --upgrade pip build "poetry>=2.0" "poetry-plugin-export>=1.8"

# Rely on .dockerignore to limit the build context
WORKDIR /build
COPY . .

# Build wheel to /build/dist
RUN python -m build --wheel --outdir /build/dist

# Export locked runtime requirements from poetry.lock with hashes
RUN poetry export --without-urls --only main -f requirements.txt -o /build/requirements.lock

###
### Runtime stage contains just installed wheel plus dependencies without a Poetry runtime
###
FROM python:3.13-slim AS runtime

# Avoid surprises from numeric libs, keep image small
ENV PYTHONUNBUFFERED=1 \
    OMP_NUM_THREADS=1 \
    MKL_NUM_THREADS=1 \
    OPENBLAS_NUM_THREADS=1 \
    PIP_NO_CACHE_DIR=1

# Create a non-root user for safer defaults
ARG APP_USER=app
ARG APP_UID=1000
RUN useradd --create-home --uid ${APP_UID} ${APP_USER}

# Install package from built wheel and dependencies from exported lock file.
WORKDIR /app
COPY --from=builder /build/dist/*.whl /tmp/
COPY --from=builder /build/requirements.lock /tmp/requirements.lock
RUN python -m pip install --upgrade pip \
    && python -m pip install --require-hashes -r /tmp/requirements.lock \
    && python -m pip install /tmp/*.whl \
    && rm -rf /root/.cache/pip /tmp/*

# Specify working directory
WORKDIR /workspace
RUN chown ${APP_UID}:${APP_UID} /workspace
USER ${APP_USER}

ENTRYPOINT ["ipc-frontier"]
CMD ["--help"]
