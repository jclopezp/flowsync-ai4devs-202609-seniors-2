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

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Opus 5 1M xHigh
**Herramienta:** Claude Code

```
/init

```

**Qué salió:** 
 We're setting up your agent harness for the FlowSync exercise; I just wrote CLAUDE.md covering commands, backend architecture, and the exercise deliverables. Next: review it, then decide whether to import your Codex config via /import.

## Prompt 2

crea el archivo AGENTS.md, y copia el contenido de CLAUDE.md a AGENTS.md. Cada vez que el sistema lea CLAUDE.md debe ser redreccionado a AGENTS.md

**Qué salió:** 
Se ejecuto correctamente, sin embargo el redirect es solo texto explicativo, y no agrego el import @AGENTS.md
- AGENTS.md — todo el contenido que estaba en CLAUDE.md (comandos, arquitectura de backend/frontend, el ejercicio). Solo cambié la cabecera: ahora se presenta como la fuente única para cualquier agente, no solo Claude Code.
- CLAUDE.md — reducido a un redirect de 9 líneas que apunta a AGENTS.md y dice explícitamente que no duplica contenido y que las instrucciones nuevas van allí.

Una nota sobre cómo funciona la redirección en la práctica: Claude Code carga CLAUDE.md automáticamente al arrancar, y AGENTS.md también lo lee de forma nativa, así que en la práctica el contenido entra igual. Lo que hace el puntero es garantizar el caso en que un agente solo mire CLAUDE.md: se encuentra la instrucción de leer AGENTS.md y el enlace. No existe un mecanismo de "redirección" real a nivel de harness — es una instrucción, y como tal el agente puede ignorarla; eso es precisamente el tipo de cosa que te interesa anotar en la Parte B del ejercicio ("algo que dejaste escrito en el harness y que el agente no cumplió igualmente").

## Prompt 3
Despues de haber modificado CLAUDE.md revisa el archivo, agregue "@AGENTS.md", a fin de que fuerze a leer AGENTS.md y no sea ignorado.
  Podias haberlos agregado antes?

  **Qué salió:** 
  Si reconocio que no hizo lo correcto y modifico la prosa de CLAUDE.md

## Prompt 3
en el harness, se debe incluir: un procesos de comprobación: algo que se dispare solo cuando el agente termina de editar (formatear, pasar el linter, correr los tests), o un revisor al que le encargues leer con lupa lo que se acaba de escribir.

**Qué salió:** 
Agrego un hook y un revisor

