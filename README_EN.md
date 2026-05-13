# transcriptor

Turn your audio recordings into text — **locally**, **fast**, **with full privacy**.

Transcriptor leverages the GPU power of **AMD Strix Halo** machines (GMKTec EVO2, Asus ROG Flow Z13 2025…) to transcribe an hour of audio in under two minutes — without sending a single byte to the cloud. The resulting text can then be fed into an LLM to generate meeting notes, extract decisions, or produce any structured document.

## Why Transcriptor?

- **Total privacy**: audio never leaves the machine. Files are processed in memory inside the container — no trace remains server-side after transcription. Ideal for sensitive meetings.
- **Fast**: ~2 minutes for 1 hour of audio on Strix Halo machines.
- **Simple**: one command to start, one command to transcribe.
- **Flexible**: the OpenAI-compatible Whisper API fits into any processing pipeline.

## Typical workflow

```
Audio recording  →  Transcription (Transcriptor)  →  LLM  →  Meeting notes
   meeting.mp3            meeting.txt                         notes.md
```

![Transcriptor web interface](docs/images/main.png)

## Built-in web interface

Transcriptor includes a web interface accessible at `http://localhost:8765` that lets you transcribe and generate reports in a few clicks.

### Transcription

- **Drag-and-drop** MP3 files
- **Audio language** selection (French, English, auto-detect)
- **Copy** the text or **download** it as `.txt`

### Report generation (Ollama)

After transcription, submit the text to a local LLM via Ollama to automatically generate a structured document :

- **Summary** — short version with key points, decisions and action items
- **Report** — structured synthesis by topic
- **Minutes** — faithful and exhaustive transcription
- **Free** — custom prompt

The response is displayed in **real-time streaming** and can be copied or downloaded as `.md`. The interface is available in **French and English**.

Models that have delivered good results: `gpt-oss:20b`, `gpt-oss:120b`, `qwen3.6:27b`.

## Quick start

```bash
docker compose up -d
```

- **Web interface**: `http://localhost:8765`
- **CLI**: `./transcribe.sh ~/Downloads/meeting.mp3`

See the [runbooks](#runbooks) for full installation and advanced options.

## Performance

On machines equipped with an **AMD AI 395 (Strix Halo)** — such as the GMKTec EVO2 or Asus ROG Flow Z13 2025 — one hour of MP3 audio is transcribed in approximately **2 minutes**.

## Runbooks

- [Installation](runbooks_en/install.md) — prerequisites, image pull, startup, troubleshooting
- [Web interface](runbooks_en/webui.md) — access from local network (port 8765), usage, troubleshooting
- [Recording](runbooks_en/recording.md) — capturing a meeting (microphone + remote speakers)
- [Transcription](runbooks_en/transcription.md) — transcribing an audio file (CLI)

## Architecture decisions

- [ADR-001 — Use of whisper.cpp](adr_en/001-whisper-cpp.md)
- [ADR-002 — GPU Backend: Vulkan](adr_en/002-vulkan-backend.md)
- [ADR-003 — Pre-built image instead of build from source](adr_en/003-prebuilt-image.md)

## Structure

```
transcriptor/
├── docker-compose.yml
├── transcribe.sh
├── frontend/
│   ├── Dockerfile
│   ├── index.html
│   ├── config.json
│   ├── prompts.json
│   └── nginx.conf
├── adr/
│   ├── 001-whisper-cpp.md
│   ├── 002-vulkan-backend.md
│   └── 003-image-pre-compilee.md
├── adr_en/
│   ├── 001-whisper-cpp.md
│   ├── 002-vulkan-backend.md
│   └── 003-prebuilt-image.md
├── runbooks/
│   ├── install.md
│   ├── enregistrement.md
│   └── transcription.md
└── runbooks_en/
    ├── install.md
    ├── recording.md
    └── transcription.md
```
