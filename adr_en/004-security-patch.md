# ADR-004 — Security patching of the upstream image

**Status:** Accepted  
**Date:** 2026-05-06

## Context

A Harbor scan of the `ghcr.io/kth8/whisper-server-vulkan` image reveals medium and low severity CVEs. Several of these have fixes available in the Ubuntu repositories:

| Package | CVE(s) | Fixed version |
|---|---|---|
| `libssl3t64` | CVE-2026-31790, CVE-2026-28387/88/89/90, CVE-2026-31789 | `3.0.13-0ubuntu3.9` |
| `libgnutls30t64` | CVE-2025-14831, CVE-2025-9820 | `3.8.3-1.1ubuntu3.5` |
| `libsystemd0` + `libudev1` | CVE-2026-29111 | `255.4-1ubuntu8.14` |
| `libcap2` | CVE-2026-4878 | `1:2.66-5ubuntu2.4` |
| `sed` | CVE-2026-5958 | `4.9-2ubuntu0.24.04.1` |

## Decision

Introduce a minimal `Dockerfile` that inherits from the upstream image and applies a targeted `apt-get upgrade` on the affected packages. The `docker-compose.yml` switches from `image:` to `build: .`.

## Rationale

- **Fixes are available**: these CVEs have a published fixed version — not applying them would be negligent.
- **Minimal impact**: only the vulnerable packages are updated, no recompilation of whisper.cpp.
- **Upstream image preserved**: the pre-built image (ADR-003) is not abandoned, just patched.

## Rejected alternatives

| Alternative | Reason for rejection |
|---|---|
| Wait for an upstream image update | Unknown timeline, CVEs left unaddressed in production |
| Rebuild from source | Abandoned in ADR-003 (GitHub blocked inside containers) |

## Consequences

- `docker compose build` is required after each `Dockerfile` update.
- CVEs without an available fix (`tar`, `libc6`, `dpkg`, `util-linux`…) remain in the image — to be monitored.
- When a new upstream image version is released, re-evaluate whether the patches are still needed.
