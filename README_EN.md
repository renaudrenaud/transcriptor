# transcriptor

Turn your audio recordings into text — **locally**, **fast**, **with full privacy**.

Transcriptor leverages the GPU power of **AMD Strix Halo** machines (GMKTec EVO2, Asus ROG Flow Z13 2025…) to transcribe an hour of audio in under two minutes — without sending a single byte to the cloud. The resulting text can then be fed into an LLM to generate meeting notes, extract decisions, or produce any structured document.

## Why Transcriptor?

- **Total privacy**: audio never leaves the machine. Ideal for sensitive meetings.
- **Fast**: ~2 minutes for 1 hour of audio on Strix Halo machines.
- **Simple**: one command to start, one command to transcribe.
- **Flexible**: the OpenAI-compatible Whisper API fits into any processing pipeline.

## Typical workflow

```
Audio recording  →  Transcription (Transcriptor)  →  LLM  →  Meeting notes
   meeting.mp3            meeting.txt                         notes.md
```

## Quick start

```bash
docker compose up -d
./transcribe.sh ~/Downloads/meeting.mp3
```

See the [runbooks](#runbooks) for full installation and advanced options.

## Performance

On machines equipped with an **AMD AI 395 (Strix Halo)** — such as the GMKTec EVO2 or Asus ROG Flow Z13 2025 — one hour of MP3 audio is transcribed in approximately **2 minutes**.

## Runbooks

- [Installation](runbooks/install.md) — prerequisites, image pull, startup, troubleshooting
- [Recording](runbooks/enregistrement.md) — capturing a meeting (microphone + remote speakers)
- [Transcription](runbooks/transcription.md) — transcribing an audio file

## Structure

```
transcriptor/
├── docker-compose.yml
├── transcribe.sh
├── adr/
│   ├── 001-whisper-cpp.md
│   ├── 002-vulkan-backend.md
│   └── 003-image-pre-compilee.md
└── runbooks/
    ├── install.md
    ├── enregistrement.md
    └── transcription.md
```
