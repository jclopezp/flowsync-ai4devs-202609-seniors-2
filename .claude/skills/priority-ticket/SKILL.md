---
name: priority-ticket
description: Coge el ticket prioritario asignado al usuario en el tablero Jira de FlowSync, lo lee entero y entrega un plan de implementación ajustado a las convenciones del repo. Planifica, no implementa. Úsala cuando el usuario diga "el siguiente ticket", "qué toca ahora" o invoque /priority-ticket.
---

# Ticket prioritario

Coges el siguiente ticket del tablero y entregas un **plan**, no código. Terminas pidiendo
aprobación. No edites ningún archivo del producto durante esta skill.

## 1. Encuentra el ticket

Tablero: proyecto `FLOW` (FlowSync) en `cathedral-cloud.atlassian.net`, cloudId
`7f6dcaf9-30df-459d-b29c-ba4ddfb6a6df`. Usa las herramientas del servidor MCP `atlassian`.

Identifica primero al usuario con `atlassianUserInfo` y busca sus tickets pendientes:

```
project = FLOW AND assignee = currentUser() AND statusCategory = "To Do"
ORDER BY priority DESC, created ASC
```

Coge el primero. **Di en voz alta cuál has cogido y por qué** (clave, título, prioridad). Si hay
empate porque ninguno tiene prioridad asignada —es el caso hoy en este tablero—, dilo
explícitamente y explica con qué criterio desempataste, en vez de fingir que había un orden.

Si no hay ninguno, dilo y para. No te inventes trabajo ni cojas uno de otro.

Lee el ticket completo con `getJiraIssue`: descripción y comentarios. Los criterios de aceptación
del ticket son el contrato; no los amplíes ni los recortes por tu cuenta.

## 2. Carga las convenciones antes de planificar

Lee `AGENTS.md` entero. No planifiques de memoria ni por analogía con otros proyectos de Adonis o
React: este repo tiene esquema generado desde migraciones, serializador propio que envuelve en
`{ data: … }`, transformers, imports por subpath e indexado de controladores. Un plan que ignore
eso es exactamente el plan que este harness existe para evitar.

Después mira el código real de la zona que toca el ticket. Rutas en `backend/start/routes.ts`,
controladores en `backend/app/controllers/`, y el estado actual del frontend en `frontend/src/`.
Verifica lo que el ticket da por hecho en vez de creértelo.

## 3. Entrega el plan

En este formato, sin relleno:

**Ticket.** Clave, título y, en una frase, qué hay que conseguir.

**Archivos que tocarías.** Lista con rutas exactas, marcando cuáles son nuevos y cuáles se
modifican, y **el total contado**. Si no sabes el nombre exacto de un archivo nuevo, propónlo
siguiendo la convención del repo en vez de dejarlo vago.

**Convenciones que aplican**, nombradas una por una, con lo que obligan a hacer en este ticket
concreto. No copies la lista entera de `AGENTS.md`: solo las que muerden aquí.

**Cómo se cubre cada criterio de aceptación.** Uno por uno, con lo que lo satisface. Si alguno no
se puede cumplir con lo que hay, dilo aquí, no al final.

**Verificación.** Qué comandos concretos demuestran que funciona (`npm run build`, `npm run lint`,
`node ace test --files=…`). Si el área no tiene tests y debería tenerlos, di cuáles añadirías.

**Riesgos y decisiones abiertas.** Lo que harías por defecto y lo que necesita que el usuario
decida. Sé concreto: "¿el token en `localStorage` o en memoria?" vale; "hay que decidir la
estrategia de estado" no.

## 4. Para

No implementes. Termina preguntando si seguir adelante con el plan. Si el usuario dice que sí, el
siguiente paso es el trabajo normal, y al terminar se cierra con `/commit`.
