#!/bin/zsh
# Toma la miniatura de un proyecto con Brave sin ventana.
# Uso: tools/capturar.sh <nombre> <url>   →  thumbs/<nombre>.jpg (800 px de ancho)
# Si la página tarda en cargar (sale "Loading…"), dale tiempo extra: ESPERA_MS=20000 tools/capturar.sh ...
# No uses ESPERA_MS en páginas con animación continua (la ruleta): Brave se queda esperando y se corta a los 60 s.
# Usa un perfil fijo de Brave en ~/Library/Caches/capturar-brave. Con un perfil recién creado, Brave
# headless a veces no guarda la captura; si falla en una Mac nueva, corre el script otra vez.
set -e
[ $# -eq 2 ] || { echo "Uso: $0 <nombre> <url>"; exit 1; }
cd "${0:A:h}/.."
BRAVE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
TMP=$(mktemp -d)
ESPERA=()
[ -n "$ESPERA_MS" ] && ESPERA=(--virtual-time-budget="$ESPERA_MS")
# Brave a veces guarda la captura y no se cierra: se espera al archivo y luego se cierra a mano.
"$BRAVE" --headless=new --no-first-run --disable-gpu --hide-scrollbars \
  --window-size=1280,800 "${ESPERA[@]}" --user-data-dir="$HOME/Library/Caches/capturar-brave" \
  --screenshot="$TMP/shot.png" "$2" >/dev/null 2>&1 &
PID=$!
for i in {1..120}; do
  [ -s "$TMP/shot.png" ] && break
  kill -0 $PID 2>/dev/null || break
  sleep 0.5
done
sleep 0.5
kill $PID 2>/dev/null || true
wait $PID 2>/dev/null || true
[ -s "$TMP/shot.png" ] || { echo "Brave no terminó la captura"; rm -rf "$TMP"; exit 1; }
ffmpeg -loglevel error -y -i "$TMP/shot.png" -vf scale=800:-1 -q:v 4 "thumbs/$1.jpg"
rm -rf "$TMP"
echo "thumbs/$1.jpg"
