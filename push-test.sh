#!/usr/bin/env bash
set -euo pipefail

# Charger les variables d'environnement
set -a; source .env; set +a

VERSION=$(cat VERSION)
HARBOR="${TEST_HARBOR_URL#https://}/${TEST_HARBOR_PROJECT}"
WHISPER_SOURCE="ghcr.io/kth8/whisper-server-vulkan:${WHISPER_IMAGE_TAG:-latest}"
WHISPER_TARGET="${HARBOR}/whisper-server-vulkan:${VERSION}"
FRONTEND_TARGET="${HARBOR}/frontend:${VERSION}"

echo "→ Login Harbor test..."
echo "${TEST_HARBOR_PASSWORD}" | docker login "${TEST_HARBOR_URL}" \
  --username "${TEST_HARBOR_USER}" \
  --password-stdin

echo ""
echo "── whisper ──────────────────────────────"
echo "Source  : ${WHISPER_SOURCE}"
echo "Cible   : ${WHISPER_TARGET}"
docker pull "${WHISPER_SOURCE}"
docker tag  "${WHISPER_SOURCE}" "${WHISPER_TARGET}"
docker push "${WHISPER_TARGET}"
echo "Publié  : ${WHISPER_TARGET}"

echo ""
echo "── frontend ─────────────────────────────"
echo "Source  : frontend:${VERSION} (local)"
echo "Cible   : ${FRONTEND_TARGET}"
docker tag  "frontend:${VERSION}" "${FRONTEND_TARGET}"
docker push "${FRONTEND_TARGET}"
echo "Publié  : ${FRONTEND_TARGET}"
