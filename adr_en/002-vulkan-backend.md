# ADR-002 — GPU Backend: Vulkan

**Status:** Accepted  
**Date:** 2026-04-27

## Context

The host machine has an AMD GPU. whisper.cpp supports several GPU backends: CUDA, Vulkan, Metal, ROCm.

## Decision

Use the Vulkan backend for AMD GPU acceleration. In practice, the pre-built image `ghcr.io/kth8/whisper-server-vulkan` is compiled with `-DGGML_VULKAN=1` (see ADR-003).

## Rationale

- **AMD compatibility**: CUDA is NVIDIA-exclusive. Vulkan is the generic GPU backend natively supported by AMD GPUs via standard `amdgpu` drivers.
- **Standard drivers**: Vulkan works with the Mesa/AMDGPU drivers present in most Linux distributions, with no additional proprietary packages.
- **Stability**: ROCm (AMD alternative) requires a complex specific installation and precise kernel versions.
- **Simple Docker passthrough**: `--device /dev/dri` is sufficient to expose the AMD GPU to the container.

## Rejected alternatives

| Alternative | Reason for rejection |
|---|---|
| CUDA | NVIDIA-only GPU |
| ROCm | Complex installation, heavy dependencies, constrained kernel versions |
| CPU only | Too slow for large-v3, not acceptable for long files |

## Consequences

- The host must have a working Vulkan setup (`vulkaninfo` must return an AMD GPU).
- `/dev/kfd` and `/dev/dri` must be passed through to the container.
- Performance is lower than CUDA on NVIDIA GPUs, but excellent on AMD — e.g. ~2 min for 1h of audio on AMD AI 395 (Strix Halo).
