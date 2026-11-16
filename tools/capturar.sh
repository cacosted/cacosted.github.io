#!/bin/zsh
# Toma la miniatura de un proyecto con Brave sin ventana.
# Uso: tools/capturar.sh <nombre> <url>   →  thumbs/<nombre>.jpg (800 px de ancho)
# Si la página tarda en cargar (sale "Loading…"), sube ESPERA_MS: ESPERA_MS=20000 tools/capturar.sh ...
set -e
[ $# -eq 2 ] || { echo "Uso: $0 <nombre> <url>"; exit 1; }
cd "${0:A:h}/.."
BRAVE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
TMP=$(mktemp -d)
perl -e 'alarm 60; exec @ARGV' "$BRAVE" --headless=new --no-first-run --disable-gpu --hide-scrollbars \
  --window-size=1280,800 --virtual-time-budget="${ESPERA_MS:-6000}" --user-data-dir="$TMP/perfil" \
  --screenshot="$TMP/shot.png" "$2" >/dev/null 2>&1
ffmpeg -loglevel error -y -i "$TMP/shot.png" -vf scale=800:-1 -q:v 4 "thumbs/$1.jpg"
rm -rf "$TMP"
echo "thumbs/$1.jpg"
