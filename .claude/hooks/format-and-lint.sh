#!/usr/bin/env bash
#
# Hook PostToolUse: se dispara cuando el agente termina de escribir un archivo.
# Formatea con Prettier (silencioso, arregla en el sitio) y pasa el linter del
# subproyecto correspondiente. Si el linter falla, sale con código 2 para que el
# error vuelva al agente en vez de quedarse en el diff.
#
# Recibe por stdin el JSON del hook. Sin argumentos.

set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

file="$(jq -r '.tool_response.filePath // .tool_input.file_path // empty')"
[ -n "$file" ] || exit 0

# El path puede llegar relativo al proyecto.
case "$file" in
  /*) ;;
  *) file="$root/$file" ;;
esac
[ -f "$file" ] || exit 0

run_pair() {
  # $1 = subproyecto (frontend|backend), $2 = comando de lint
  local project="$1" linter="$2"
  local dir="$root/$project"
  local rel="${file#"$dir"/}"
  local out status=0

  [ -x "$dir/node_modules/.bin/prettier" ] || exit 0

  out="$(cd "$dir" && node_modules/.bin/prettier --write --ignore-unknown "$rel" 2>&1)" || status=$?
  if [ "$status" -ne 0 ]; then
    echo "Prettier falló en $project/$rel:" >&2
    echo "$out" >&2
    exit 2
  fi

  [ -x "$dir/node_modules/.bin/$linter" ] || exit 0
  out="$(cd "$dir" && "node_modules/.bin/$linter" "$rel" 2>&1)" || status=$?
  if [ "$status" -ne 0 ]; then
    echo "$linter encontró problemas en $project/$rel. Arréglalos antes de seguir:" >&2
    echo "$out" >&2
    exit 2
  fi
  exit 0
}

case "$file" in
  "$root"/frontend/node_modules/*|"$root"/backend/node_modules/*) exit 0 ;;
  "$root"/backend/.adonisjs/*) exit 0 ;;
  "$root"/frontend/*) run_pair frontend oxlint ;;
  "$root"/backend/*)  run_pair backend eslint ;;
  *) exit 0 ;;
esac
