#!/usr/bin/env bash
# Instala o actualiza el servicio de usuario premid-dev (PreMiD: actividad de Exercism).
# Lo llaman ~/workspace/setup.sh y ~/dotfiles-dizzi/home/bazzite-install.sh.
# Se puede repetir sin riesgo: solo rehace lo que falta o cambió.
set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PREMID_DIR="$WORKSPACE_DIR/premid-activities"
UNIT_SRC="$WORKSPACE_DIR/systemd/premid-dev.service"
UNIT="$HOME/.config/systemd/user/premid-dev.service"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" # node/npm de Homebrew

# Submódulo (fork de PreMiD/Activities) + remote upstream para sincronizar y abrir PRs.
[ -f "$PREMID_DIR/package.json" ] || git -C "$WORKSPACE_DIR" submodule update --init premid-activities
git -C "$PREMID_DIR" remote get-url upstream >/dev/null 2>&1 ||
  git -C "$PREMID_DIR" remote add upstream https://github.com/PreMiD/Activities.git

# `npm ci` (también compila el CLI pmd) solo si faltan las dependencias o cambió el lockfile.
if [ ! -x "$PREMID_DIR/node_modules/.bin/pmd" ] ||
  [ "$PREMID_DIR/package-lock.json" -nt "$PREMID_DIR/node_modules/.package-lock.json" ]; then
  (cd "$PREMID_DIR" && npm ci --no-audit --no-fund)
fi

# Unidad: se copia solo si cambió; si el servicio ya corría, se reinicia con la nueva.
if ! cmp -s "$UNIT_SRC" "$UNIT"; then
  install -Dm644 "$UNIT_SRC" "$UNIT"
  systemctl --user daemon-reload
  systemctl --user try-restart premid-dev.service
fi

# premid-serve.mjs: si cambió desde la última instalación (p. ej. tras un git pull), reinicia el servicio.
STAMP="${XDG_STATE_HOME:-$HOME/.local/state}/premid-dev/serve.sha256"
SUM="$(sha256sum "$WORKSPACE_DIR/systemd/premid-serve.mjs" | cut -d' ' -f1)"
if [ "$(cat "$STAMP" 2>/dev/null)" != "$SUM" ]; then
  systemctl --user try-restart premid-dev.service
  install -Dm644 /dev/null "$STAMP" && echo "$SUM" >"$STAMP"
fi
systemctl --user enable --now premid-dev.service
echo "  ✓ premid-dev.service activo (PreMiD: Exercism, Mimo)"
