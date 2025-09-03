#!/usr/bin/env bash
set -euo pipefail
# Connexion Wi‑Fi via NetworkManager (nmcli)
# Usage: ./scripts/wifi_connect.sh "SSID" "MOTDEPASSE"
# Si non fournis, te les demandera.

SSID=${1:-}
PASS=${2:-}

if [[ -z "$SSID" ]]; then
  read -rp "SSID: " SSID
fi
if [[ -z "${PASS:-}" ]]; then
  read -rsp "Mot de passe (laisser vide si réseau ouvert): " PASS; echo
fi

nmcli radio wifi on || true

if [[ -n "${PASS}" ]]; then
  nmcli dev wifi connect "$SSID" password "$PASS" || {
    echo "Échec nmcli. Lancement nmtui…"; nmtui; exit 0; }
else
  nmcli dev wifi connect "$SSID" || {
    echo "Échec nmcli. Lancement nmtui…"; nmtui; exit 0; }
fi

echo "[OK] Connecté (si pas d'erreur). 'nmcli conn show' pour vérifier."
