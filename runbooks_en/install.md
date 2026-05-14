# Runbook — Installation

Two installation paths depending on available access:

| Path | Image source | Access required |
|------|--------------|-----------------|
| [A — Git clone](#path-a--git-clone-public-source) | `ghcr.io/kth8/whisper-server-vulkan` | Public |
| [B — Harbor](#path-b--harbor-private-registry) | Internal Harbor registry | Harbor access required |

---

## Common prerequisites

### Docker + Docker Compose

```bash
docker --version
docker compose version
```

If missing: https://docs.docker.com/engine/install/

### AMD GPU + Vulkan

```bash
vulkaninfo --summary
```

The output should mention your AMD GPU. If `vulkaninfo` is missing:

```bash
sudo apt-get install vulkan-tools mesa-vulkan-drivers
```

### /dev/kfd and /dev/dri access

```bash
ls -la /dev/kfd /dev/dri/renderD128
```

If permission denied:

```bash
sudo usermod -aG render,video $USER
# Then log out and back in
```

If `/dev/kfd` is missing, the `amdgpu` module is not loaded:

```bash
lsmod | grep amdgpu
```

---

## Path A — Git clone (public source)

This path pulls the image directly from `ghcr.io`. No account required.

### Step 1 — Clone the project

```bash
git clone <repo-url> transcriptor
cd transcriptor
```

### Step 2 — Pull the image

```bash
docker compose pull
```

The model is bundled in the image — no separate download needed.

### Step 3 — Start

```bash
docker compose up -d
```

### Step 4 — Verify Vulkan is active

```bash
docker compose logs whisper | grep -i vulkan
```

### Step 5 — Test

```bash
./transcribe.sh ~/Downloads/meeting.mp3
```

---

## Path B — Harbor (private registry)

> **Restricted access.** This path is for people with credentials to our internal Harbor registry. If you don't have a Harbor account, use [Path A](#path-a--git-clone-public-source).

Harbor hosts both application images (`whisper` and `frontend`), audited and scanned. No git clone required — everything comes from the registry.

### Step 1 — Log in to the Harbor registry

```bash
docker login harbor-prod.atlog.io \
  --username <your-login>
```

### Step 2 — Create a working directory

```bash
mkdir transcriptor && cd transcriptor
```

### Step 3 — Create the `docker-compose.yml` file

```yaml
services:
  whisper:
    image: harbor-prod.atlog.io/ia_tools/whisper-server-vulkan:1.4.0
    init: true
    devices:
      - /dev/kfd
      - /dev/dri
    read_only: true
    tmpfs:
      - /root/.cache/mesa_shader_cache
    volumes:
      - ~/models:/models:ro
    restart: unless-stopped

  frontend:
    image: harbor-prod.atlog.io/ia_tools/frontend:1.4.0
    ports:
      - "8765:80"
    volumes:
      - ./config.json:/usr/share/nginx/html/config.json:ro
    depends_on:
      - whisper
    restart: unless-stopped
```

### Step 4 — Create the `config.json` file

This file tells the frontend which Ollama server to use for report generation:

```json
{
  "ollamaHost": "http://localhost:11434"
}
```

Replace `localhost` with the hostname or IP of your Ollama machine if it is remote (e.g. `http://evo-x2:11434`).

### Step 5 — Start

```bash
docker compose up -d
```

### Step 6 — Verify Vulkan is active

```bash
docker compose logs whisper | grep -i vulkan
```

### Step 7 — Test

```bash
# Web interface
open http://localhost:8765

# CLI (requires transcribe.sh — available from the git repo)
./transcribe.sh ~/Downloads/meeting.mp3
```

---

## Troubleshooting

### Server won't start (`/dev/kfd` permission denied)

```bash
sudo usermod -aG render,video $USER
# Log out and back in — mandatory
```

### `No Vulkan devices found` in logs

```bash
# Check from the host
vulkaninfo --summary

# Check permissions
stat /dev/dri/renderD128
stat /dev/kfd
```

### Port 8080 already in use

Edit `docker-compose.yml`:

```yaml
ports:
  - "8181:8080"
```

### Harbor authentication fails

Check that your credentials are correct and that your account has `pull` rights on the Harbor project.
