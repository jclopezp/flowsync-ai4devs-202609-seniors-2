#!/usr/bin/env bash
#
# Hook PreToolUse (Bash): impide commitear en las ramas protegidas.
#
# Inspecciona el comando en vez de filtrar por patrón, para que también caiga
# un `cd x && git commit ...`. Devuelve una decisión de permiso "deny" con el
# motivo, que es lo que el agente lee.

set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
protegidas="main s1/start"

cmd="$(jq -r '.tool_input.command // empty')"
[ -n "$cmd" ] || exit 0

# Solo nos interesan los commits reales.
case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac
case "$cmd" in
  *--dry-run*) exit 0 ;;
esac

branch="$(git -C "$root" rev-parse --abbrev-ref HEAD 2>/dev/null)" || exit 0
[ -n "$branch" ] || exit 0

for p in $protegidas; do
  if [ "$branch" = "$p" ]; then
    motivo="Estás en la rama protegida '$branch' y AGENTS.md prohíbe commitear aquí. Crea una rama antes (para el ejercicio del harness: harness-<iniciales>) y vuelve a intentarlo."
    jq -n --arg r "$motivo" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
      }
    }'
    exit 0
  fi
done
exit 0
