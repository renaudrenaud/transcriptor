#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <fichier_audio> [langue]"
  echo "  langue par défaut : fr"
  exit 1
fi

FILE="$1"
LANG="${2:-fr}"
BASENAME=$(basename "$FILE" | sed 's/\.[^.]*$//')
OUTPUT_DIR="$(dirname "$FILE")/transcription"

mkdir -p "$OUTPUT_DIR"

curl -s http://127.0.0.1:8080/v1/audio/transcriptions \
  -F "file=@${FILE}" \
  -F "model=whisper-1" \
  -F "language=${LANG}" \
  -F "response_format=text" \
  > "${OUTPUT_DIR}/${BASENAME}.txt"

echo "Transcription : ${OUTPUT_DIR}/${BASENAME}.txt"
