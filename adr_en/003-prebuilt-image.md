# ADR-003 — Pre-built image instead of build from source

**Status:** Accepted  
**Date:** 2026-04-27

## Context

Compiling whisper.cpp from source inside a container is impractical: it requires a git clone from GitHub and downloading many Debian packages, which is slow and dependent on a reliable network connection.

## Decision

Use the pre-built image `ghcr.io/kth8/whisper-server-vulkan:latest` rather than compiling from source.

## Rationale

- **No compilation**: `docker pull` is enough — no git clone or cmake required.
- **Already optimized**: compiled with Vulkan, without AVX requirements (compatible with older hardware).
- **HTTP API**: exposes `/v1/audio/transcriptions` compatible with the OpenAI Whisper API — simplifies future integrations.
- **Delegated maintenance**: whisper.cpp updates are handled by the image maintainer.
- **Bundled model**: no separate download or volume mount needed.

## Rejected alternatives

| Alternative | Reason for rejection |
|---|---|
| Build from source | Slow, fragile, network-dependent at build time |
| Official whisper.cpp image | No pre-compiled Vulkan support available |

## Consequences

- Dependency on a third-party image (`ghcr.io/kth8`) — track updates.
- The interface is an **HTTP API** (port 8080) rather than a direct CLI — `transcribe.sh` wraps the curl call.
- `/dev/kfd` and `/dev/dri` must be passed through to the container for AMD GPU access.
