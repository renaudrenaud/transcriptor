# Security

## General posture

Transcriptor is a local service: the whisper server listens on `localhost:8080` and is not exposed on the network. Audio never leaves the machine. This constraint significantly reduces the attack surface.

---

## Scan history

| Date | Image | Severity | CVE | Action |
|------|-------|----------|-----|--------|
| 2026-05-15 | `frontend:1.4.0` | High | CVE-2026-27135 (nghttp2-libs) | ✅ Fixed — nginx:alpine rebuild |
| 2026-05-15 | `frontend:1.4.0` | Medium | CVE-2026-4367 (libxpm) | ✅ Fixed — nginx:alpine rebuild |
| 2026-05-15 | `frontend:1.4.0` | Medium | CVE-2026-34743 (xz-libs) | ✅ Fixed — nginx:alpine rebuild |
| 2026-05-06 | `whisper-server-vulkan` | Medium | CVE-2026-4878, CVE-2025-14831, CVE-2025-9820, CVE-2026-31790, CVE-2026-29111, CVE-2026-5958 | ⏸ Not patched — local service, acceptable risk |
| 2026-05-06 | `whisper-server-vulkan` | Low | CVE-2025-9820, CVE-2026-28387/88/89/90, CVE-2026-31789 | ⏸ Not patched — local service, acceptable risk |

---

## Current status by image

### `frontend` (nginx:alpine)

Scan of **2026-05-15** — rebuilt on latest `nginx:alpine`:

- **Critical / High**: none
- **Medium / Low**: to be re-scanned after the rebuild

The 3 CVEs identified in the initial scan (CVE-2026-27135, CVE-2026-4367, CVE-2026-34743) were resolved by rebuilding the image on the latest `nginx:alpine`. Validated via local Harbor scan before pushing to test/prod.

### `whisper-server-vulkan` (ghcr.io/kth8)

Scan of **2026-05-06**:

- **Critical / High**: none
- **Medium**: 23 CVEs — 5 with an available fix, 18 without (upstream unpatched)
- **Low**: 11 CVEs — 5 with an available fix, 6 without

#### CVEs with available fix (Medium)

| CVE | Package | Fixed version |
|---|---|---|
| CVE-2026-4878 | `libcap2` | `1:2.66-5ubuntu2.4` |
| CVE-2025-14831, CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-31790 | `libssl3t64` | `3.0.13-0ubuntu3.9` |
| CVE-2026-29111 | `libsystemd0`, `libudev1` | `255.4-1ubuntu8.14` |
| CVE-2026-5958 | `sed` | `4.9-2ubuntu0.24.04.1` |

#### CVEs with available fix (Low)

| CVE | Package | Fixed version |
|---|---|---|
| CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-28387/88/89/90, CVE-2026-31789 | `libssl3t64` | `3.0.13-0ubuntu3.9` |

---

## Patching policy

**`whisper-server-vulkan`** — CVEs not actively patched:

- All Medium or Low severity — no Critical or High.
- The service is strictly local (`localhost`) — network exploitation vectors are blocked by design.
- Patching via a `Dockerfile` wrapper introduces a maintenance cost disproportionate to the risk.

**`frontend`** — CVEs patched systematically:

- The `nginx:alpine` image is rebuilt whenever a High or Critical CVE is detected.
- Process: rebuild → local Harbor scan → validation → push to test/prod.

**If the service were ever exposed on the network** (e.g. deployment on a shared server), the whisper patching policy should be reconsidered and patches applied via a dedicated `Dockerfile`.

---

## Updating images

```bash
# whisper — track new upstream releases
docker compose pull
docker compose up -d

# frontend — rebuild on updated nginx:alpine
docker pull nginx:alpine
docker build --no-cache --build-arg VERSION=$(cat VERSION) -t frontend:$(cat VERSION) ./frontend/
bash push-test.sh   # validate Harbor scan
bash push-prod.sh
```
