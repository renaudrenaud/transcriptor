#!/usr/bin/env bash
set -euo pipefail

# Charger les variables d'environnement
set -a; source .env; set +a

VERSION=$(cat VERSION)
SOURCE_IMAGE="ghcr.io/kth8/whisper-server-vulkan:${WHISPER_IMAGE_TAG:-latest}"
TARGET_IMAGE="${PROD_HARBOR_URL#https://}/${PROD_HARBOR_PROJECT}/whisper-server-vulkan:${VERSION}"

echo "Source  : ${SOURCE_IMAGE}"
echo "Cible   : ${TARGET_IMAGE}"
echo ""

read -rp "Pousser en PROD la version ${VERSION} ? [oui/NON] " confirm
[[ "${confirm}" == "oui" ]] || { echo "Annulé."; exit 0; }

echo "→ Login Harbor prod..."
echo "${PROD_HARBOR_PASSWORD}" | docker login "${PROD_HARBOR_URL}" \
  --username "${PROD_HARBOR_USER}" \
  --password-stdin

echo "→ Pull de l'image source..."
docker pull "${SOURCE_IMAGE}"

echo "→ Tag..."
docker tag "${SOURCE_IMAGE}" "${TARGET_IMAGE}"

echo "→ Push vers Harbor prod..."
docker push "${TARGET_IMAGE}"

echo ""
echo "Publié : ${TARGET_IMAGE}"
