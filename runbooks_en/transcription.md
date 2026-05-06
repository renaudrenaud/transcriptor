# Runbook — Transcription

## Prerequisites

The whisper server must be running:

```bash
docker compose up -d
```

## Transcribe a file

```bash
./transcribe.sh ~/Downloads/meeting.mp3
```

The result is generated at `~/Downloads/transcription/meeting.txt`.

## Options

**Change language** (default: `fr`):

```bash
./transcribe.sh ~/Downloads/meeting.mp3 en
```

**Direct API call**:

```bash
curl http://127.0.0.1:8080/v1/audio/transcriptions \
  -F "file=@meeting.mp3" \
  -F "model=whisper-1" \
  -F "language=en" \
  -F "response_format=text"
```

Available response formats: `text`, `json`, `verbose_json`, `srt`, `vtt`.

## Troubleshooting

### Connection error

Check the server is running:

```bash
docker compose ps
docker compose logs whisper
```

### Empty or garbled transcription

- Check the audio quality of the source file (not too noisy, correct level)
- Check that the specified language matches the language spoken in the audio
