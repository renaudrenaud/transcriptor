# Runbook — Installation

## Prerequisites

### 1. Docker + Docker Compose

```bash
docker --version
docker compose version
```

If missing: https://docs.docker.com/engine/install/

### 2. AMD GPU + Vulkan

```bash
vulkaninfo --summary
```

The output should mention your AMD GPU. If `vulkaninfo` is missing:

```bash
sudo apt-get install vulkan-tools mesa-vulkan-drivers
```

### 3. /dev/kfd and /dev/dri access

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

## Installation

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

### Step 3 — Start the server

```bash
docker compose up -d
```

### Step 4 — Verify Vulkan is active

```bash
docker compose logs whisper | grep -i vulkan
```

### Step 5 — Test

```bash
mkdir -p ~/Downloads/transcription
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
