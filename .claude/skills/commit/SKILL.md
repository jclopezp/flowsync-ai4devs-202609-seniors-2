---
name: commit
description: Revisa los cambios, verifica que pasan lint y typecheck, y crea un commit con el formato de este repo. Úsala cuando el usuario pida commitear, guardar el trabajo, o invoque /commit.
---

# Commit

Cierras un trozo de trabajo: lo revisas, compruebas que no rompe nada y lo commiteas con el
formato del repo.

## 1. Mira qué hay

```bash
git status --porcelain
git diff            # sin indexar
git diff --staged   # indexado
git log --oneline -8
```

Lee el diff entero antes de escribir nada. El mensaje se escribe desde lo que cambió de verdad, no
desde lo que recuerdas de la conversación.

**Si el usuario ya tenía cosas indexadas, respeta su selección**: commitea eso y nada más. Si no
hay nada indexado, indexa lo que corresponda al trabajo hecho — y nunca `git add -A` a ciegas:
mira archivo por archivo si pertenece a este commit. Lo que no pertenezca, déjalo fuera y dilo.

Nunca indexes `.env`, `backend/tmp/db.sqlite3` ni nada que el `.gitignore` excluya a propósito.

## 2. No commitees en la rama equivocada

Si estás en `main` o en `s1/start` (la rama de partida del curso), **crea una rama antes**. Para el
ejercicio del harness el nombre es `harness-<iniciales-del-usuario>`; para trabajo normal,
`<tipo>/<descripción-corta>`. Pregunta el nombre si no es evidente.

## 3. Verifica antes de commitear

Solo lo que toca el diff, no todo:

```bash
cd backend  && npm run typecheck && npm run lint    # si cambió backend/
cd frontend && npm run build     && npm run lint    # si cambió frontend/
cd backend  && node ace test --files="<área tocada>" # si hay tests de la zona
```

**Si algo falla, no commitees.** Enseña la salida del fallo y pregunta si arreglarlo o commitear
igualmente. Un commit que no compila es peor que no tener commit.

## 4. Escribe el mensaje

Conventional commits, **en español**, como el resto del repo:

```
docs(s1): enunciado del ejercicio y plantilla de prompts en la rama de partida
docs: quita mención de repo privado, ahora que es público
```

- Tipo: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`. Ámbito opcional entre paréntesis
  (`backend`, `frontend`, `harness`, `s1`).
- Asunto en minúscula, sin punto final, ~70 caracteres, describiendo **qué cambia**, no qué
  archivos se tocaron. "añade pantalla de login" sí; "modifica App.tsx y crea Login.tsx" no.
- Cuerpo solo si hace falta explicar el **porqué** de algo no obvio. Si el asunto se basta, no
  inventes cuerpo.
- Si el trabajo viene de un ticket de Jira, nombra la clave en el cuerpo (`Refs FLOW-1`).

Cierra siempre con la línea de atribución:

```
Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
```

## 5. Commitea y enseña el resultado

Usa un heredoc para que el mensaje multilínea no se rompa:

```bash
git commit -m "$(cat <<'MSG'
feat(frontend): añade pantalla de login contra la API de auth

Refs FLOW-1

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
MSG
)"
```

Después enseña `git log --oneline -1` y `git status --porcelain` para que se vea qué entró y qué
quedó fuera.

**No hagas push salvo que te lo pidan.** Y no abras un pull request por iniciativa propia: en este
repo los PR van contra el repositorio del curso (`upstream`), y eso lo decide el usuario.
