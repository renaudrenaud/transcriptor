# ADR-001 — Use of whisper.cpp

**Status:** Accepted  
**Date:** 2026-04-27

## Context

Need for local audio transcription, without dependency on a cloud service, for French-language meeting audio files.

## Decision

Use [whisper.cpp](https://github.com/ggerganov/whisper.cpp), the C++ port of OpenAI's Whisper model.

## Rationale

- **Local-first**: no data leaves the machine.
- **Performance**: optimized C++ implementation with GPU backend support (CUDA, Vulkan, Metal).
- **Quality**: access to the same models as the original Python implementation (base → large-v3).
- **Lightweight**: no Python runtime or heavy dependencies in the final image.

## Rejected alternatives

| Alternative | Reason for rejection |
|---|---|
| OpenAI Whisper API | Data sent to the cloud |
| faster-whisper (Python) | Python + CUDA runtime, less suited to Vulkan/AMD |
| openai/whisper (Python) | Same limitations, slower |

## Consequences

- Compilation is handled by the pre-built image maintainer (see ADR-003) — no local build required.
- whisper.cpp updates depend on new releases of the `ghcr.io/kth8/whisper-server-vulkan` image.
