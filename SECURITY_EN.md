# Security

## General posture

Transcriptor is a local service: the whisper server listens on `localhost:8080` and is not exposed on the network. Audio never leaves the machine. This constraint significantly reduces the attack surface.

## Vulnerability scan

The `ghcr.io/kth8/whisper-server-vulkan` image is scanned via Harbor. Scan results as of 2026-05-06:

- **Critical / High**: none
- **Medium**: 23 CVEs — 5 with an available fix, 18 without (upstream unpatched)
- **Low**: 11 CVEs — 5 with an available fix, 6 without

### CVEs with available fix (Medium)

| CVE | Package | Fixed version |
|---|---|---|
| CVE-2026-4878 | `libcap2` | `1:2.66-5ubuntu2.4` |
| CVE-2025-14831, CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-31790 | `libssl3t64` | `3.0.13-0ubuntu3.9` |
| CVE-2026-29111 | `libsystemd0`, `libudev1` | `255.4-1ubuntu8.14` |
| CVE-2026-5958 | `sed` | `4.9-2ubuntu0.24.04.1` |

### CVEs with available fix (Low)

| CVE | Package | Fixed version |
|---|---|---|
| CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-28387/88/89/90, CVE-2026-31789 | `libssl3t64` | `3.0.13-0ubuntu3.9` |

## Decision

**These CVEs are not actively patched** for the following reasons:

- All Medium or Low severity — no Critical or High.
- The service is strictly local (`localhost`) — network exploitation vectors are blocked by design.
- Patching via a `Dockerfile` wrapper introduces a maintenance cost (rebuild on every upstream update) disproportionate to the risk.

**If the service were ever exposed on the network** (e.g. deployment on a shared server), this decision should be reconsidered and patches applied via a dedicated `Dockerfile`.

## Updating the image

Track new releases of `ghcr.io/kth8/whisper-server-vulkan` — they generally include upstream security updates:

```bash
docker compose pull
docker compose up -d
```
