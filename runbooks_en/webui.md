# Runbook — Web interface

Browser-based transcription interface, shared over the local network.

## Prerequisites

The whisper server and frontend must be running:

```bash
docker compose up -d
```

## Access

Open in a browser from any machine on the local network:

```
http://<host-ip>:8765
```

From the host machine:

```
http://localhost:8765
```

## Usage

1. Drag and drop an audio file (or click to browse)
2. Select the language (default: `fr`)
3. Click **Transcrire**
4. Wait — approximately 2 minutes per hour of audio
5. Copy the text or download as `.txt`

## Privacy

The audio file is processed in memory inside the whisper container. No trace remains server-side after transcription — neither the audio file nor the text.

## Troubleshooting

### Page not accessible

```bash
docker compose ps
# Both containers must be "Up": whisper and frontend
```

### 504 Gateway Time-out error

The audio file is too long for the configured timeout (600s). Check the file duration — beyond ~4 hours of audio, increase `proxy_read_timeout` in `frontend/nginx.conf`.

### Find the host machine IP

```bash
ip route get 1 | awk '{print $7; exit}'
```
