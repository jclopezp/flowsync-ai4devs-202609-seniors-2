# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

---

## Prompt 1

**Modelo:** Opus 5 1M xHigh
**Herramienta:** Claude Code

```
which space you can see in jire?
```

**Qué salió:**
Listó los proyectos de **cloud-america** (COA, REK, SCRUM). Sitio equivocado: el del ejercicio
es cathedral-cloud, pero ese servidor MCP aún no estaba conectado. Avisó de que en Jira son
*proyectos*, no *spaces*.

## Prompt 2

**Modelo:** Opus 5 1M xHigh
**Herramienta:** Claude Code

```
which spaces do you see in jira
```

**Qué salió:**
Tras conectar el servidor `atlassian`, apareció **cathedral-cloud** con el proyecto **FLOW**.
Quedó claro que los dos servidores MCP apuntan a sitios distintos.

## Prompt 3

**Modelo:** Opus 5 1M xHigh
**Herramienta:** Claude Code

```
/init

```

**Qué salió:**
 We're setting up your agent harness for the FlowSync exercise; I just wrote CLAUDE.md covering commands, backend architecture, and the exercise deliverables. Next: review it, then decide whether to import your Codex config via /import.

## Prompt 4

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
crea el archivo AGENTS.MD, y copia el contenido de CLAUDE.md a AGENTS.md. Cada vez que el sistema lea CLAUDE.md debe ser redreccionado a AGENTS.md
```

**Qué salió:**
Se ejecuto correctamente, sin embargo el redirect es solo texto explicativo, y no agrego el import @AGENTS.md
- AGENTS.md — todo el contenido que estaba en CLAUDE.md (comandos, arquitectura de backend/frontend, el ejercicio). Solo cambié la cabecera: ahora se presenta como la fuente única para cualquier agente, no solo Claude Code.
- CLAUDE.md — reducido a un redirect de 9 líneas que apunta a AGENTS.md y dice explícitamente que no duplica contenido y que las instrucciones nuevas van allí.

Una nota sobre cómo funciona la redirección en la práctica: Claude Code carga CLAUDE.md automáticamente al arrancar, y AGENTS.md también lo lee de forma nativa, así que en la práctica el contenido entra igual. Lo que hace el puntero es garantizar el caso en que un agente solo mire CLAUDE.md: se encuentra la instrucción de leer AGENTS.md y el enlace. No existe un mecanismo de "redirección" real a nivel de harness — es una instrucción, y como tal el agente puede ignorarla; eso es precisamente el tipo de cosa que te interesa anotar en la Parte B del ejercicio ("algo que dejaste escrito en el harness y que el agente no cumplió igualmente").

## Prompt 5

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
en el archivo CLAUDE.md agregue "@AGENTS.md", a fin de que fuerze a leer AGENTS.md y no sea ignorado.
Podias haberlos agregado antes?
```

**Qué salió:**
Si reconocio que no hizo lo correcto y modifico la prosa de CLAUDE.md

## Prompt 6

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
corrige CLAUDE.md
```

**Qué salió:**
Dejó `CLAUDE.md` en cinco líneas: el import `@AGENTS.md` más un puntero de una frase para agentes
que no entienden esa sintaxis.

## Prompt 7

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
en el harness, se debe incluir: un procesos de comprobación: algo que se dispare solo cuando el agente termina de editar (formatear, pasar el linter, correr los tests), o un revisor al que le encargues leer con lupa lo que se acaba de escribir.
```

**Qué salió:**
Agrego un hook y un revisor

## Prompt 8

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
guarda lo que se anotaria en la memoria (reporte de comparacion)
```

**Qué salió:**
Escribió cuatro memorias más `MEMORY.md`: estado del ejercicio, notas para la comparación, la
corrección del `@AGENTS.md` y los dos sitios de Atlassian.

## Prompt 9

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
escrbe el tcket de jira, muestramelo antes de colocarlo en JIRA.
```

**Qué salió:**
Enseñó el borrador sin crearlo. Avisó de que el texto no es el de la lección del Módulo 1, y de
que dejó fuera las convenciones del repo a propósito para no regalárselas a la copia pelada.

## Prompt 10

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
utiliza el ticket FLOW-1, y reemplaza el texto de esta tarea en ese ticket
```

**Qué salió:**
Miró FLOW-1 antes de sobrescribir (era `Task 1`, descripción vacía) y lo actualizó: título,
descripción, asignado. Ya estaba en «Por hacer».

## Prompt 11

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
ok, cambialo a Story
```

**Qué salió:**
Cambió el tipo de Task a Story, sin tocar el resto.

## Prompt 12

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
Incluye version y fecha en AGENTS.md, y la directiva cada vez que se modificque, actualice version y fecha.
```

**Qué salió:**
Puso la línea de versión y la directiva **y además** el hook `bump-agents-version.sh` que la
ejecuta, en vez de dejarlo en prosa. Probado en vivo: una edición real subió 1.0.1 → 1.0.2.

## Prompt 13

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
install skills /priority-ticket /commit
```

**Qué salió:**
Creó las dos skills en `.claude/skills/`. Dijo que harían falta reiniciar para cargarlas —
incorrecto: aparecieron en la misma sesión.

## Prompt 14

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
que necesitamos hacer para la pieza 6?
```

**Qué salió:**
Explicó qué son las reglas de proceso y propuso el contenido, separando las reglas que se pueden
mecanizar de las que se quedan en prosa. Avisó de que no conoce el texto de la lección.

## Prompt 15

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
ok, procede
```

**Qué salió:**
Escribió las reglas de proceso (versión a 1.2.0), el hook `guard-branch.sh` y las reglas
`permissions.deny` sobre archivos generados. Las dos probadas en vivo.

## Prompt 16

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
/priority-ticket
```

**Qué salió:**
**Interrumpido por el usuario** antes de que buscase el ticket. Relanzado con el argumento.

## Prompt 17

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
/priority-ticket FLOW-1
```

**Qué salió:**
Entregó el plan. Verificó contra la API real las formas de error (422 con `field`, 401, CORS) y
encontró que `better-sqlite3` no compila, así que la base de datos no funciona. La skill no
contempla recibir una clave como argumento: funcionó por interpretación, no por diseño.

## Prompt 18

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
cual son las instrucciones del skill /priority-ticket ?
```

**Qué salió:**
Mostró el archivo y señaló la laguna: la skill no define qué hacer si le pasan una clave.

## Prompt 19

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
que owrkspaces ves en jira?
```

**Qué salió:**
Solo cloud-america. El servidor `atlassian` pedía reautenticación y `.mcp.json` se había quedado
vacío, con lo que la pieza 2 del harness estaba desmontada.

## Prompt 20

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
que workspaces ves en jira?
```

**Qué salió:**
Igual que el anterior: reintentó y seguía sin acceso a cathedral-cloud.

## Prompt 21

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
que workspaces ves en jira?
```

**Qué salió:**
Tras `/mcp` y reautenticar, volvieron los dos sitios: cathedral-cloud (FLOW) y cloud-america.
Avisó de que `.mcp.json` seguía vacío y de que eso rompe la pieza 2 en la próxima sesión.

## Prompt 22

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
create a .md file with the plan
```

**Qué salió:**
Escribió `docs/harness/plan-con-harness.md` con cabecera de metadatos (modelo, invocación,
inventario del harness activo). Avisó de que el enunciado pide entregar solo dos archivos.

## Prompt 23

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
ya esta el @docs/harness/plan-FLOW-sinHarness.md, escribe la comparación
```

**Qué salió:**
Antes de escribir, verificó una por una las afirmaciones del plan sin harness contra el repo:
todas ciertas, cero invenciones. Escribió `comparacion.md` con las cuatro casillas y la Parte B.
Resultado desfavorable al harness: gana en verificación, pierde en exploración.

## Prompt 24

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
en la tabla de "Veces que hubo que intervenir" se invoco sin Harness 1 vez, y no se hizo correcciones a la mitad.
Coregir en el archivo de comparacion.md
```

**Qué salió:**
Rellenó la columna. Respetó el `1` de correcciones que el usuario había puesto a mano en la
columna con harness, y ajustó el resumen: de cuatro casillas, el harness gana una.

## Prompt 25

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
does the prompts.md is included?
```

**Qué salió:**
Sí, rastreado y commiteado, pero con cuatro problemas: contenido incompleto, dos apartados
numerados «Prompt 3», un mensaje de commit que promete prompts que no entraron, y los enlaces
rotos en `comparacion.md` tras borrar los planes.

## Prompt 26

**Modelo:** Opus 5, esfuerzo alto
**Herramienta:** Claude Code

```
quita los enlaces y deja la referenci aen texto
Reconstruye los prompts faltantes, en el mismo formato que se han hecho los otros
```

**Qué salió:**
Quitó los enlaces de `comparacion.md` y reconstruyó este archivo con los 26 prompts en orden.
