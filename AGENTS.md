# AGENTS.md

**Versión 1.2.0 · 2026-09-26**

Fuente única de instrucciones para cualquier agente de código que trabaje en este repositorio
(Claude Code, Codex, Cursor, etc.). `CLAUDE.md` solo redirige aquí: todo cambio se hace en este
archivo.

> **Al modificar este archivo, sube la versión y pon la fecha de hoy** en la línea de arriba.
> Versión semántica: parche para retoques de redacción, menor para una regla nueva, mayor para un
> cambio que invalide lo que había. El hook `.claude/hooks/bump-agents-version.sh` sube el parche
> solo cuando un agente edita este archivo; el salto a menor o mayor lo decides tú editando la
> línea a mano.

## Qué es esto

FlowSync: gestión de tareas en equipo. Monorepo sin workspaces — `backend/` y `frontend/` son dos
proyectos npm independientes, cada uno con su `package.json` y su `node_modules`. No hay scripts en
la raíz: todo comando se lanza desde dentro de una de las dos carpetas.

La documentación del repo (README, `prompts.md`) está en español. Escribe commits, PRs y docs en
español salvo que se pida otra cosa; el código y los comentarios en código están en inglés.

## Comandos

### Backend (`backend/`, AdonisJS 7 + Lucid + SQLite)

```bash
npm install
cp .env.example .env && node ace generate:key   # solo la primera vez
node ace migration:run                          # crea tmp/db.sqlite3
npm run dev            # http://localhost:3333, con HMR
npm test               # Japa, ambas suites
npm run lint           # ESLint (@adonisjs/eslint-config)
npm run format         # Prettier (@adonisjs/prettier-config)
npm run typecheck      # tsc --noEmit
npm run build          # node ace build -> build/
```

Tests concretos (Japa vía `node ace test`):

```bash
node ace test unit                       # una suite: unit | functional
node ace test --files="users/*"          # por patrón de fichero
node ace test --tests="creates a user"   # un test por su título
node ace test --watch
```

Ace es el CLI para todo lo demás: `node ace make:controller`, `make:model`, `make:migration`,
`make:validator`, `make:test <nombre> --suite=functional`, `node ace list:routes`, `node ace repl`.
Usa los generadores en vez de crear ficheros a mano — respetan la convención de nombres
`snake_case` que espera el indexador.

### Frontend (`frontend/`, React 19 + Vite 8 + TypeScript)

```bash
npm install
npm run dev      # http://localhost:5173
npm run build    # tsc -b && vite build
npm run lint     # oxlint (no ESLint)
```

No hay runner de tests en el frontend todavía.

## Arquitectura del backend

AdonisJS 7 con varias piezas que no son el AdonisJS clásico. Lo importante:

**Controladores tipados generados, no strings.** `start/routes.ts` no referencia controladores por
ruta de fichero sino por el objeto `controllers` de `#generated/controllers`, que AdonisJS
autogenera al indexar `app/controllers/`. Añadir un controlador = crearlo y referenciarlo; el
índice se regenera solo al arrancar dev/test. `.adonisjs/` es código generado — nunca se edita a
mano (tampoco `database/schema.ts`, ver abajo).

**Esquema derivado de las migraciones, no de los modelos.** `database/schema.ts` se regenera con
`node ace migration:run` a partir del estado real de la base de datos y exporta una clase base por
tabla (`UserSchema`, `AuthAccessTokenSchema`) con sus columnas Lucid ya declaradas. Los modelos
extienden esa clase en lugar de declarar `@column`:

```ts
export default class User extends compose(UserSchema, withAuthFinder(hash)) { … }
```

Para cambiar columnas: escribe la migración, ejecútala, y el modelo hereda los cambios. Añade al
modelo solo lo que no es columna (getters como `initials`, relaciones, mixins). Reglas de
generación en `database/schema_rules.ts`.

**Respuestas envueltas vía `ctx.serialize`.** `providers/api_provider.ts` inyecta un método
`serialize` en todo `HttpContext` usando un `ApiSerializer` que envuelve la salida en `{ data: … }`
y valida la metadata de paginación de Lucid. Los controladores devuelven `serialize(...)`, nunca el
objeto pelado, y nunca serializan el modelo directamente: pasan por un **transformer**
(`app/transformers/`, subclase de `BaseTransformer` con `toObject()` y `this.pick`) que decide qué
campos salen. Ese es el único sitio donde se define la forma pública de una entidad.

**Validación con VineJS en `app/validators/`.** Reglas compartidas extraídas a funciones (`email()`,
`password()`) y reutilizadas entre validadores. Se consumen con
`await request.validateUsing(xValidator)`. `start/validator.ts` registra una transformación global
que convierte toda fecha validada a `DateTime` de Luxon.

**Auth por access tokens.** Guard por defecto `api` (tokens en DB, `config/auth.ts`); el guard
`web` de sesión existe pero no se usa en las rutas. `silent_auth_middleware` corre globalmente en
el router (deja pasar anónimos, rellena `auth` si hay token) y `middleware.auth()` protege los
grupos que lo necesitan. Rutas actuales, todas bajo `/api/v1`:
`POST auth/signup`, `POST auth/login`, y con auth `GET account/profile`, `POST account/logout`.

**Un controlador por acción de recurso, con nombre de recurso.** `AccessTokensController.store` es
el login y `.destroy` el logout; `NewAccountController.store` es el signup. Sigue esa convención al
añadir endpoints en vez de crear un `AuthController` con métodos ad hoc.

**Imports por subpath.** Siempre `#controllers/*`, `#models/*`, `#validators/*`, `#transformers/*`,
`#generated/*`, etc. (mapa completo en `backend/package.json`), nunca rutas relativas largas. Los
imports apuntan a `.js` aunque el fichero sea `.ts`.

Tests: `tests/unit/**/*.spec.ts` (timeout 2s) y `tests/functional/**/*.spec.ts` (timeout 30s,
levanta servidor HTTP). `tests/bootstrap.ts` registra `apiClient`, `authApiClient` y `dbAssertions`,
y tipa el api client con el registry de rutas de Tuyau — las llamadas HTTP en tests están tipadas
contra las rutas reales. `.env.test` ya existe; los tests corren con `NODE_ENV=test`.

SQLite en `backend/tmp/db.sqlite3` (gitignorado). `config/database.ts` trae comentadas las
conexiones de Postgres/MySQL/MSSQL/libSQL por si hace falta cambiar.

CORS: en dev acepta cualquier origen; en producción la allowlist está vacía a propósito y hay que
configurarla (`CORS_ORIGIN` en `.env`).

## Arquitectura del frontend

Todavía es la plantilla de Vite: `src/main.tsx` monta `App.tsx` y no hay router, estado global ni
cliente de API. Al construir contra el backend, ten en cuenta que las respuestas vienen envueltas
en `{ data: … }` y que el token de acceso llega en el body de signup/login (`token`), no en cookie.

El backend expone el registry de rutas tipado de Tuyau (`backend/.adonisjs/client/registry`), y
`backend/package.json` lo publica como export `./registry` — es la vía prevista para un cliente de
API con tipos compartidos si se acaba necesitando.

## El ejercicio del curso

Este repo es el material de un ejercicio: montar un harness de agente y comparar su salida contra
una copia sin harness. El enunciado completo y las condiciones de entrega están en `README.md`; no
los reinterpretes ni los des por hechos. Dos cosas que afectan a cómo trabajas aquí:

- Los entregables son `docs/harness/comparacion.md` (el directorio hay que crearlo) y `prompts.md`
  en la raíz, que registra **todos** los prompts lanzados, verbatim, con su modelo y herramienta,
  incluidos los que fallaron. Si el usuario está haciendo el ejercicio, recuérdale anotarlos.
- Se trabaja sobre un fork: `origin` = fork del usuario, `upstream` = repo del curso. Los PRs van
  contra `upstream`.

MCP de Atlassian configurado en `.mcp.json` (el proyecto Jira del ejercicio es `FLOW` / FlowSync en
cathedral-cloud.atlassian.net).


## Reglas de proceso

Cómo se trabaja aquí. Lo de arriba describe el repo; esto describe el turno.

### El ciclo

1. **Ticket.** `/priority-ticket` coge el siguiente del tablero FLOW y entrega un plan.
2. **Aprobación.** El plan no se aplica hasta que el usuario dice que sí. Es un punto de parada
   real, no una fórmula de cortesía: si no hay respuesta, no se implementa.
3. **Implementación.** Solo lo que cubre el ticket.
4. **Revisión.** El subagente `adversarial-reviewer` lee el diff antes de dar nada por terminado.
5. **Cierre.** `/commit`. No uses `git commit` a mano: la skill verifica antes de commitear y el
   comando pelado no.

Si el usuario entra por el medio del ciclo ("arregla esto", "añade aquello"), no le hagas empezar
por el paso 1. Pero los pasos 4 y 5 siguen valiendo igual.

### Dónde se pregunta en vez de decidir

Para y pregunta antes de:

- Cambiar el esquema de la base de datos. Implica migración, y la migración regenera
  `database/schema.ts`.
- Añadir una dependencia. Ni al backend ni al frontend sin decirlo.
- Cambiar el contrato de un endpoint que ya existe: ruta, forma de la respuesta, códigos de error.
- Hacer algo que el ticket no cubre. Si te lo encuentras a medias, termina lo que sí cubre,
  dilo, y deja lo otro fuera.

No preguntes por lo que ya está decidido en este archivo. Si la convención está escrita arriba,
aplícala.

### Lo que no se hace

- **No edites archivos generados**: `backend/.adonisjs/**` ni `backend/database/schema.ts`. El
  cambio va en la migración o en el código fuente que los genera.
- **No commitees en `main` ni en `s1/start`.** Crea rama antes.
- **No hagas push ni abras un pull request** por iniciativa propia. En este repo los PR van contra
  el repositorio del curso.
- **No amplíes el alcance.** Refactor oportunista, renombrados de paso y "ya que estaba aquí" van
  en otro ticket.

### Del ejercicio

Cada prompt que se lanza se anota en `prompts.md`, literal, con su modelo y su herramienta,
incluidos los que no funcionaron. Si el usuario está trabajando el ejercicio y no lo ha anotado,
recuérdaselo al cerrar el turno.
