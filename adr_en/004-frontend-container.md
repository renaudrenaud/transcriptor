# ADR-004 — Separate frontend container (nginx)

**Status:** Accepted  
**Date:** 2026-05-14

## Context

The `whisper` container exposes a raw HTTP API on port 8080. To provide a browser-accessible user interface, an additional component is needed to serve static files and proxy calls to the API.

## Decision

Add a second `frontend` container based on `nginx:alpine`, which:
- serves the web interface (HTML/JS/CSS) on port 8765
- proxies `/api/*` requests to `whisper:8080`
- does not expose the `whisper` container's port 8080 directly to the network

## Justification

- **Separation of concerns**: `whisper` handles transcription, `frontend` handles presentation and HTTP routing. Each container has a clear scope.
- **Security**: port 8080 of `whisper` is not exposed externally — only nginx is reachable from the network.
- **Unmodifiable third-party image**: `ghcr.io/kth8/whisper-server-vulkan` cannot serve static files. Changing its behavior would require forking the image, which contradicts ADR-003.
- **Lightweight**: `nginx:alpine` (~27 MB) is negligible compared to the whisper image.
- **Optional for CLI use**: the `frontend` container can be omitted for command-line-only usage (`docker compose up -d whisper`).

## Rejected alternatives

| Alternative | Reason for rejection |
|---|---|
| Expose whisper port 8080 directly | No web UI, unprotected API accessible from the network |
| Embed a web server in the whisper image | Third-party image, not modifiable (ADR-003) |
| External web application (outside container) | Deployment complexity, breaks the "one command to start" approach |

## Consequences

- `docker compose up -d` starts two containers: `whisper` and `frontend`.
- For CLI-only usage: `docker compose up -d whisper` is sufficient.
- Transcription timeout is configured in `frontend/nginx.conf` (`proxy_read_timeout`), not in `whisper`.
- The `frontend` image is published to Harbor (see `push-*.sh` scripts) with the same version as the overall release.
