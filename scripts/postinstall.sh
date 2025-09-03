#!/usr/bin/env bash
set -euo pipefail

# Post-install Arch Linux (profil perso)
# - Met à jour le système
# - Installe les paquets de base (i3 + picom + feh + outils)
# - Active NetworkManager
# À exécuter en root: sudo ./scripts/postinstall.sh

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "[ERREUR] Lance ce script en root (sudo)." >&2
  exit 1
fi

# Sync base and refresh keys/mirrors if needed
pacman -Syu --noconfirm || true

pkgs=(
  vim ttf-proggy-clean ttf-font-awesome neofetch \
  kitty rxvt-unicode \
  i3-gaps i3blocks dmenu \
  picom feh unzip \
  networkmanager network-manager-applet \
  git gcc firefox xorg-xrandr \
  pulseaudio pasystray volumeicon \
  light ttf-jetbrains-mono
)

pacman -S --needed --noconfirm "${pkgs[@]}"

# Réseau
systemctl enable --now NetworkManager || true

# Fonts cache (au cas où)
fc-cache -fv || true

cat <<'MSG'
[OK] Post-install terminé.
- Session i3 disponible (config exemple dans configs/i3/config)
- Picom basique dans configs/picom/picom.conf
- NetworkManager actif (nmcli / nmtui pour le Wi‑Fi)

Pense à copier les configs:
  mkdir -p ~/.config/i3 ~/.config/picom
  cp configs/i3/config ~/.config/i3/config
  cp configs/picom/picom.conf ~/.config/picom/picom.conf
MSG
