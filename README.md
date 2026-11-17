# MLflow tracking server (Docker image)

A single `Dockerfile` that builds a self-contained [MLflow](https://mlflow.org) tracking
server for anyone who wants an experiment-tracking UI on a laptop or small host without
installing Python packages locally. It produces a container that serves the MLflow UI and
REST API on port 5000, storing runs in a SQLite database and artifacts on a mounted volume.

> Status: archived snapshot. This repository contains only the `Dockerfile` — no
> application code, experiments, or data. Nothing here has been verified against a
> live build in this programme.

<!-- how-to-use-with-ai -->
> **New here?** See [How to use this repo with AI (Claude, Gemini, ChatGPT)](HOW_TO_USE_WITH_AI.md).

## What it does
- Builds on `python:3.11-slim` and installs `mlflow>=2.14.0` with `pip`.
- Runs `mlflow server` on `0.0.0.0:5000`.
- Backend store: `sqlite:////mlflow-data/mlflow.db`.
- Default artifact root: `/mlflow-data/artifacts`.
- Declares `/mlflow-data` as a Docker volume so runs and artifacts survive container restarts.
- Runs a gitleaks secret scan on every push and pull request (`.github/workflows/quality-gates.yml`).

## Quick start
```bash
git clone https://github.com/herrrickshaw/mlflow.git
cd mlflow
docker build -t mlflow-server .
docker run -d --name mlflow -p 5000:5000 -v mlflow-data:/mlflow-data mlflow-server
# UI: http://localhost:5000
```

Point a client at it with `MLFLOW_TRACKING_URI=http://localhost:5000`.

## How it works
| Stage | Where | Result |
|---|---|---|
| Base image | `FROM python:3.11-slim` | Minimal Python runtime |
| Install | `pip install --no-cache-dir mlflow>=2.14.0` | MLflow server and UI |
| Storage | `VOLUME ["/mlflow-data"]` | SQLite DB + artifacts persisted outside the container |
| Serve | `CMD ["mlflow", "server", …]` | UI and REST API on port 5000 |

SQLite is used rather than a database server so the image needs no external service;
it is suitable for single-user or small-team use.

## Repository layout
| Path | Purpose |
|---|---|
| `Dockerfile` | The entire deliverable |
| `.github/workflows/quality-gates.yml` | gitleaks secret scan |
| `CLAUDE.md` | Guidance for Claude Code sessions (source-fetching conventions) |
| `HOW_TO_USE_WITH_AI.md` | Plain-language guide for handing the repo to an AI assistant |
| `graphify-out/` | Generated graphify knowledge-graph cache (not hand-written) |

## Configuration
No environment variables or secrets are required. To change the port, store, or
artifact root, edit the `CMD` line in the `Dockerfile`; to persist data on the host,
mount a host directory at `/mlflow-data` instead of a named volume.

## Limitations and known issues
- No pinned MLflow version: `mlflow>=2.14.0` resolves to the newest release at build time, so rebuilds are not reproducible.
- SQLite backend: not suitable for concurrent multi-user logging at scale.
- No authentication: the server is open to anyone who can reach port 5000.
- No tests or CI build of the image; only the secret-scan workflow runs.

## Licence
No licence file yet — all rights reserved. MLflow itself is Apache-2.0 licensed.
