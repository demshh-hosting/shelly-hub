#!/usr/bin/env bash
# Installiert Docker (falls nötig) und startet Shelly Hub.
# Ausführen im Projektordner auf dem Proxmox-LXC/VM:  bash install.sh
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "==> Docker wird installiert …"
  apt-get update
  apt-get install -y ca-certificates curl
  curl -fsSL https://get.docker.com | sh
fi

echo "==> Shelly Hub wird gebaut und gestartet …"
mkdir -p data
docker compose up -d --build

IP=$(hostname -I | awk '{print $1}')
echo
echo "Fertig! Dashboard: http://${IP}"
echo "Logs ansehen:      docker compose logs -f"
