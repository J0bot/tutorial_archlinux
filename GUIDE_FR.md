# Arch Linux — Guide 

Ce guide va te guider, par contre,  y a plein de trucs qui ne te serviront pas si t'es pas suisse romand.

> Objectif: pouvoir installer Arch sur n’importe quelle machine à l’identique, le plus simplement possible. Et avec un poil de rice

---

## 0) Démarrer l’ISO et préparer la console

- Charger le clavier français suisse:

```bash
loadkeys fr_CH
```

- Liste des polices:

```bash
ls /usr/share/kbd/consolefonts | less
```

- exemple d’application:

```bash
setfont ter-v18b
```

---

## 1) Installation avec archinstall (mode noob)

L’ISO Arch fournit `archinstall`. Lance l’assistant:

```bash
archinstall guided
```

Recommandations :

- Disque: utiliser le disque entier (ex: `/dev/sda`).
- Partitionnement: simple en `ext4`.
- Bootloader: `grub`.
- Kernel: `linux`.
- Locale système: `en_US.UTF-8` , encodage `UTF-8`.
- Keymap: `fr_CH`.
- Timezone: `UTC` ou `Europe/Zurich` selon préférence.
- Miroirs: région Suisse 
- Hostname: `j0bot` (ou ton choix).
- Utilisateur: crée un user non‑root et définis un mot de passe. Conserve root activé.
- Réseau: NetworkManager.

Quand l’install se termine, redémarre sans l’ISO.

---

## 2) Premier démarrage: base système

Connecte‑toi avec ton utilisateur. Mets à jour et active le réseau:

```bash
sudo pacman -Syu
sudo systemctl enable --now NetworkManager
```

Donne les droits sudo au groupe `wheel` si nécessaire:

```bash
sudo pacman -S sudo
sudo usermod -aG wheel "$USER"
sudo EDITOR=vim visudo  # décommenter la ligne %wheel ALL=(ALL:ALL) ALL
```

Astuce: si un fichier de config n’existe pas, crée‑le. (Bienvenue sur Arch)

---

## 2.b) Connexion Wi‑Fi

Deux contextes:

1) Depuis l’ISO d’installation (avant d’installer Arch) — utiliser `iwctl` (iwd)

```bash
# entrer dans l'outil
iwctl

# lister les interfaces (repère ta carte, souvent wlan0)
[iwd]# device list

# scanner et voir les réseaux
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks

# se connecter (demande le mot de passe si nécessaire)
[iwd]# station wlan0 connect "SSID"

# quitter
[iwd]# exit

# tester la connectivité
ping -c 3 archlinux.org
```

1) Sur le système installé (avec NetworkManager) — `nmcli` ou `nmtui`

```bash
# activer le Wi‑Fi
nmcli radio wifi on

# lister les réseaux
nmcli dev wifi list

# se connecter
nmcli dev wifi connect "SSID" password "MOTDEPASSE"

# alternative TUI conviviale
nmtui  # puis "Activer une connexion" et choisir le réseau
```

Astuce: la connexion est mémorisée et se reconnectera automatiquement au prochain démarrage. Comme sur debian.

---

## 3) Paquets principaux (bureau i3 minimal)

Installe le lot de base (adapte au besoin):

```bash
sudo pacman -S \
  vim ttf-proggy-clean ttf-font-awesome neofetch \
  kitty rxvt-unicode \
  i3-gaps i3blocks dmenu \
  picom feh unzip \
  networkmanager network-manager-applet \
  git gcc firefox xorg-xrandr \
  pulseaudio pasystray volumeicon \
  light
```

Notes:
- Si `i3-gaps` n’est pas disponible, utilise `i3-wm` (les gaps peuvent être intégrés selon versions).
- Pour JetBrains Mono: `sudo pacman -S ttf-jetbrains-mono` (ou copie manuelle des fontes dans `/usr/share/fonts/JetBrainsMono` puis `fc-cache -fv`).
- Extras (optionnels): `browsh`, `cava`, `ani-cli`.

---

## 4) Session X et i3

Sans display manager, tu peux démarrer via `startx`:

```bash
echo 'exec i3' >> ~/.xinitrc
startx
```

Sinon, garde ton DM préféré et sélectionne la session i3.

---

## 5) Configuration i3 minimale pour du rice sa mère

Crée `~/.config/i3/config` si absent, et ajoute au minimum:

```conf
# terminal par défaut
set $term kitty

# résolution (adapte la sortie à ta machine: Virtual1/Virtual-1/eDP-1/HDMI-1, etc.)
exec --no-startup-id xrandr --output Virtual1 --mode 1920x1080

# compositeur + fond d’écran
exec --no-startup-id picom --experimental-backends
exec --no-startup-id feh --bg-scale --bg-fill ~/Images/wallpaper.jpg

# gaps et bordures
gaps inner 10
gaps outer 5

default_border pixel 1
default_floating_border pixel 1

# un raccourci utile
bindsym $mod+Return exec $term
```

- Remplace `Virtual1` par la sortie correcte (`xrandr` pour lister).
- Remplace le chemin du wallpaper.

---

## 6) Picom (minimal) (pour la transparence)

Fichier `~/.config/picom/picom.conf` (crée le dossier si besoin):

```conf
# exemple très simple
backend = "glx";
vsync = true;
```

Le flag `--experimental-backends` est lancé depuis i3 comme ci‑dessus.

---

## 7) Audio et tray

- Audio: `pulseaudio` 
- Icônes volume: `pasystray` ou `volumeicon`. Lance‑le au démarrage (via i3):

```conf
exec --no-startup-id pasystray
# ou
exec --no-startup-id volumeicon
```

---

## 8) Luminosité

`light` 

Exemple:

```bash
sudo light -A 5   # +5%
sudo light -U 5   # -5%
```


---

## 9) Quelques commandes utiles

- Installer un paquet:

```bash
sudo pacman -S <paquet>
```

- Si un fichier de config manque: crée‑le 
- Pour zgegland: `neofetch`.

---
