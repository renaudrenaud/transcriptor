# Runbook — Recording a meeting

Simultaneous capture of outgoing audio (remote speakers) and local microphone via PulseAudio/ffmpeg.

## Prerequisites

```bash
sudo apt install ffmpeg pulseaudio-utils
```

## Record a meeting

```bash
ffmpeg \
  -f pulse -i $(pactl get-default-sink).monitor \
  -f pulse -i $(pactl get-default-source) \
  -filter_complex "[1]volume=3.0[mic];[0][mic]amix=inputs=2" \
  ~/Downloads/meeting.mp3
```

- `.monitor` : captures what comes out of the speakers/headset (remote participants)
- `get-default-source` : active microphone by default
- `volume=3.0` : amplifies the mic ×3 (adjust based on actual level)

Stop recording: **Ctrl+C** — the file is saved at that point.

## Adjusting microphone level

**Option 1 — in the command**: change `volume=3.0` (try 2.0, 4.0…)

**Option 2 — via GUI**: open `pavucontrol`, go to the "Input Devices" tab, adjust the gain in real time before starting the recording.

Check which microphone is selected by default:

```bash
pactl get-default-source
```
