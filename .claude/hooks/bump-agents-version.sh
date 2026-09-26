#!/usr/bin/env bash
#
# Hook PostToolUse: mantiene al día la línea de versión de AGENTS.md.
#
# Regla: si la versión del árbol de trabajo ya difiere de la commiteada, alguien
# la subió a mano en este ciclo y solo se refresca la fecha. Si coincide (o el
# archivo aún no está en git), sube el parche. Así varias ediciones seguidas
# antes de un commit no inflan el número.
#
# El salto a versión menor o mayor es decisión humana: este hook nunca lo hace.

set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
target="$root/AGENTS.md"

file="$(jq -r '.tool_response.filePath // .tool_input.file_path // empty')"
[ -n "$file" ] || exit 0
case "$file" in /*) ;; *) file="$root/$file" ;; esac
[ "$file" = "$target" ] || exit 0
[ -f "$target" ] || exit 0

pattern='^\*\*Versión [0-9]+\.[0-9]+\.[0-9]+ · [0-9]{4}-[0-9]{2}-[0-9]{2}\*\*$'
extract() { grep -m1 -E "$pattern" | sed -E 's/^\*\*Versión ([0-9]+\.[0-9]+\.[0-9]+) .*/\1/'; }

cur="$(extract < "$target")"
if [ -z "$cur" ]; then
  echo "AGENTS.md no tiene línea de versión con el formato '**Versión X.Y.Z · AAAA-MM-DD**'. Añádela." >&2
  exit 2
fi

head_ver="$(git -C "$root" show HEAD:AGENTS.md 2>/dev/null | extract)"

if [ -n "$head_ver" ] && [ "$head_ver" != "$cur" ]; then
  new="$cur"                       # ya subida en este ciclo: solo la fecha
else
  IFS=. read -r ma mi pa <<< "$cur"
  new="$ma.$mi.$((pa + 1))"
fi

today="$(date +%F)"
tmp="$(mktemp)"
awk -v new="$new" -v today="$today" '
  !bumped && /^\*\*Versión [0-9]+\.[0-9]+\.[0-9]+ · [0-9]{4}-[0-9]{2}-[0-9]{2}\*\*$/ {
    print "**Versión " new " · " today "**"; bumped = 1; next
  }
  { print }
' "$target" > "$tmp" && mv "$tmp" "$target"

[ "$new" = "$cur" ] || echo "AGENTS.md: versión $cur -> $new ($today)"
exit 0
