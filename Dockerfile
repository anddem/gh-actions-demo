FROM python:3.10-slim-buster

LABEL org.opencontainers.image.source=https://github.com/anddem/gh-actions-demo
LABEL org.opencontainers.image.description="Demo image for STD"
LABEL org.opencontainers.image.licenses=MIT

ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    APP_DIR="/opt/app/" \
    # python
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip:
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_ROOT_USER_ACTION=ignore \
    # poetry:
    POETRY_VERSION=1.5.0 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

RUN pip install -U pip setuptools wheel "poetry==$POETRY_VERSION"\
    && poetry --version

# Copy only requirements to cache them in docker layer
WORKDIR "$APP_DIR"
COPY poetry.lock pyproject.toml README.md "$APP_DIR"

# Project initialization:
RUN --mount=type=cache,target="$POETRY_CACHE_DIR" \
    poetry version \
  # Install deps:
  && poetry run pip install -U pip setuptools wheel \
  && poetry install --no-interaction --no-ansi --no-root --no-directory

# Creating folders, and files for a project:
COPY ./src "$APP_DIR/src"
RUN poetry install --no-interaction --no-ansi --only main

RUN ls

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]