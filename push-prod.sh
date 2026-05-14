#!/usr/bin/env bash
set -euo pipefail

# Charger les variables d'environnement
set -a; source .env; set +a

VERSION=$(cat VERSION)
HARBOR="${PROD_HARBOR_URL#https://}/${PROD_HARBOR_PROJECT}"
WHISPER_SOURCE="ghcr.io/kth8/whisper-server-vulkan:${WHISPER_IMAGE_TAG:-latest}"
WHISPER_TARGET="${HARBOR}/whisper-server-vulkan:${VERSION}"
FRONTEND_TARGET="${HARBOR}/frontend:${VERSION}"

echo "Images à publier en PROD (v${VERSION}) :"
echo "  whisper  : ${WHISPER_TARGET}"
echo "  frontend : ${FRONTEND_TARGET}"
echo ""

read -rp "Confirmer ? [oui/NON] " confirm
[[ "${confirm}" == "oui" ]] || { echo "Annulé."; exit 0; }

echo "→ Login Harbor prod..."
echo "${PROD_HARBOR_PASSWORD}" | docker login "${PROD_HARBOR_URL}" \
  --username "${PROD_HARBOR_USER}" \
  --password-stdin

echo ""
echo "── whisper ──────────────────────────────"
docker pull "${WHISPER_SOURCE}"
docker tag  "${WHISPER_SOURCE}" "${WHISPER_TARGET}"
docker push "${WHISPER_TARGET}"
echo "Publié  : ${WHISPER_TARGET}"

echo ""
echo "── frontend ─────────────────────────────"
docker tag  "frontend:${VERSION}" "${FRONTEND_TARGET}"
docker push "${FRONTEND_TARGET}"
echo "Publié  : ${FRONTEND_TARGET}"
