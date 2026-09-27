# FlowSync · Comparación con harness / sin harness

| | |
|---|---|
| Ticket | [FLOW-1](https://cathedral-cloud.atlassian.net/browse/FLOW-1) · Implementar login en el frontend |
| Fecha | 2026-09-26 |
| Modelo | Opus 5, esfuerzo alto · Claude Code |
| Con harness | `/priority-ticket FLOW-1` → plan en `plan-con-harness.md` |
| Sin harness | misma instrucción a mano → plan en `plan-FLOW-sinHarness.md` |

Ninguno de los dos planes se aplicó. Se comparan los planes, no el código.

Los dos archivos de plan no se entregan: la entrega son este documento y `prompts.md`, y nada más.
Lo relevante de cada plan está citado aquí dentro.

---

## Parte A · La comparación

### Archivos que propone tocar (contados)

| | Con harness | Sin harness |
|---|---|---|
| **Total** | **7** (4 nuevos, 3 modificados) | **9** (6 nuevos, 3 modificados) |
| Cliente de API | `lib/api.ts` | `lib/api.ts` |
| Contexto de auth | `auth/AuthContext.tsx` | `auth/AuthProvider.tsx` |
| Hook | `auth/useAuth.ts` | `auth/useAuth.ts` |
| Pantallas | `auth/LoginForm.tsx` (una) | `pages/LoginPage.tsx` + `pages/HomePage.tsx` (dos) |
| Variables de entorno | — (solo fallback en código) | `.env.example` |
| Modificados | `main.tsx`, `App.tsx`, `App.css` | `main.tsx`, `App.tsx`, `App.css` |

Los dos llegan a la misma arquitectura —contexto + hook separado + envoltorio de `fetch`, sin
dependencias nuevas— y coinciden hasta en el nombre de los archivos compartidos. La diferencia de
dos es real, no cosmética: el plan sin harness separa la pantalla de sesión iniciada y documenta
la variable de entorno en un `.env.example`, que el de harness deja sin documentar pese a usar
`VITE_API_URL`.

### Convenciones: cuáles respetó cada uno

| Convención | Con harness | Sin harness |
|---|---|---|
| Envoltorio `{ data: … }` desenvuelto una sola vez | ✅ | ✅ |
| Token en body, `Authorization: Bearer` | ✅ | ✅ |
| `react/only-export-components` → hook en archivo aparte | ✅ | ✅ |
| No añadir dependencias sin preguntar | ✅ | ✅ |
| No tocar el backend | ✅ | ✅ |
| Registry de Tuyau: existe, no se usa, y se justifica | ✅ | ✅ |
| `verbatimModuleSyntax` → `import type` | ❌ no lo menciona | ✅ |
| `erasableSyntaxOnly` → sin `enum` | ❌ no lo menciona | ✅ |
| `noUnusedLocals` / `noUnusedParameters` | ❌ no lo menciona | ✅ |
| `allowImportingTsExtensions` → imports con `.tsx` | ❌ no lo menciona | ✅ |
| `fullName` es `string \| null`, `initials` siempre tiene valor | ❌ lo usa sin notar que es nullable | ✅ explícito |
| Reutilizar variables CSS de `index.css` | ❌ nunca abrió `index.css` | ✅ nombra `--accent`, `--border`, `--text-h` |
| Prettier (`semi: false`, `singleQuote: true`) | ✅ | n/a — esa copia no tiene Prettier |

**Verifiqué una por una las afirmaciones del plan sin harness sobre el repo.** Todas ciertas: las
tres variables CSS existen en `index.css`, `backend/config/auth.ts:10` es exactamente
`default: 'api'`, los cuatro flags de tsconfig están activos y `fullName` es `string | null` en
`database/schema.ts`. **Cero invenciones.** El harness no evitó alucinaciones porque no hubo
ninguna que evitar.

### Veces que hubo que intervenir

| | Con harness | Sin harness |
|---|---|---|
| Invocaciones | 1 (`/priority-ticket FLOW-1`) | 1 (la misma instrucción a mano) |
| Correcciones a mitad | **1** | **0** |

**Esta casilla la pierde el harness, y la pierde por culpa del propio harness.**

Las dos copias necesitaron una sola invocación. La diferencia es la corrección: el primer
`/priority-ticket` se lanzó sin argumento, hubo que interrumpirlo y relanzarlo como
`/priority-ticket FLOW-1`. El motivo es un defecto de la skill: está escrita asumiendo que ella
busca el ticket por JQL y **no contempla recibir una clave como argumento**. La copia pelada, que
recibió la instrucción escrita a mano con el ticket dentro, no tuvo ese problema.

O sea: la pieza que existe para ahorrar trabajo introdujo el único trabajo extra de toda la
comparación. Una skill mal especificada es peor que no tener skill, porque además obliga a
descubrir dónde falla.

(Dato de la columna derecha aportado por el usuario; el de la izquierda es observación directa de
esta sesión.)

### Qué habría que arreglar a mano antes de enseñárselo a alguien

**Al plan con harness** — seis cosas, todas presentes en el otro:

1. Las cuatro restricciones de `tsconfig.app.json`. Sin ellas, el código propuesto puede no
   compilar (un `import` de tipo sin `import type` falla con `verbatimModuleSyntax`).
2. El estado `checking` mientras se rehidrata la sesión. Sin él, al recargar parpadea la pantalla
   de login antes de mostrar al usuario: **un bug de UX que este plan habría enviado.**
3. Accesibilidad: `<label>` asociados, `aria-describedby` en los errores de campo, `aria-busy`.
   El plan con harness no menciona accesibilidad ni una vez.
4. El caso de `fetch` fallando sin código de estado (backend caído) → «No se pudo conectar».
5. Los mensajes del backend vienen en inglés («Invalid user credentials») y la interfaz es en
   español.
6. `.env.example` documentando `VITE_API_URL`.

**Al plan sin harness** — dos, ambas consecuencia de no haber tocado la API:

1. Su sección de verificación **no funciona hoy**. El paso 2 manda crear un usuario con `curl` al
   signup; esa llamada devuelve **500** porque los bindings nativos de `better-sqlite3` no están
   compilados para el Node en uso. Su plan de pruebas está roto y no lo sabe.
2. Deja la forma real de los errores como riesgo R1 «a confirmar antes de empezar», en vez de
   confirmarla. El plan con harness ya la trae medida: 422 con `field` por campo, 401
   `Unauthorized access`, y preflight CORS correcto desde `:5173`.

---

## El resultado, sin maquillar

**De las cuatro casillas, el harness gana una.** Gana en verificación. Pierde en exploración
(convenciones y archivos) y pierde en intervenciones.

Ganó donde tenía herramientas: el MCP de Atlassian y una skill que ordena «verifica lo que el
ticket da por hecho en vez de creértelo». Eso produjo tres formas de error medidas y el
descubrimiento de que la base de datos no funciona — un bloqueante real que el otro plan pisa sin
verlo.

Perdió donde tenía documentación. Y la causa es medible:

| Sección de `AGENTS.md` | Líneas |
|---|---|
| Arquitectura del backend | 60 |
| Arquitectura del frontend | **10** |

Este ticket es **enteramente de frontend**. El harness le dio al agente diez líneas que dicen poco
más que «sigue siendo la plantilla de Vite», y el agente se conformó con eso en vez de abrir
`tsconfig.app.json` y `index.css`. La copia pelada, sin ningún documento que la orientase, no tuvo
más remedio que leer los archivos de configuración — y encontró seis cosas más.

**Un harness no solo transmite conocimiento: transmite los huecos de quien lo escribió.** Y actúa
como sustituto de la exploración, no como añadido. Escribí yo ese `AGENTS.md` y mi desequilibrio
backend/frontend se propagó intacto al plan.

Y en la tercera casilla se ve el otro modo de fallo: una pieza del harness, la skill
`/priority-ticket`, fue **la única fuente de trabajo manual** de toda la comparación, por no
contemplar que le pasaran una clave de ticket. El coste de un harness no es solo escribirlo: es
que cada pieza mal especificada añade un modo de fallo que sin ella no existía.

### Aviso metodológico

Las dos copias **no partían de repos idénticos**. Montar la pieza 5 del harness obligó a instalar
Prettier en `frontend/` con su configuración, que la copia pelada no tiene (verificado:
`../flowsync-sin-harness/frontend/.prettierrc.json` no existe). Por eso esa fila de la tabla de
convenciones está marcada «n/a» en vez de con una cruz. Es un sesgo pequeño y a favor del harness;
conviene tenerlo en cuenta al leer el resto.

---

## Parte B · Las tres líneas

**1. Hasta qué pieza llegué, y cuál costó más de lo esperado.**
Las ocho, más dos mecanismos extra (guard de rama y `permissions.deny` sobre generados). La que
costó más no fue ninguna de las complicadas, sino el hook de Prettier del frontend: el proyecto no
lo tenía instalado, y la configuración hubo que deducirla del código existente —`semi: false`,
`singleQuote: true`— porque con los valores por defecto el hook habría reformateado entero
`App.tsx` en la primera edición. Una pieza descrita en media línea del enunciado que resultó ser
instalar una dependencia y adivinar un estilo.

**2. La primera diferencia que vi, y en qué me fijé para verla.**
El número de archivos: 9 contra 7. Me fijé en eso porque es la única casilla del enunciado que da
un número, y puestos los dos planes al lado salta sin leer nada más. Pero el número era la pista,
no el hallazgo: al ir a ver *qué* archivos sobraban aparecieron `.env.example` y la separación de
`HomePage`, y de ahí, bajando a la sección de convenciones, los cuatro flags de tsconfig que mi
plan no menciona. La diferencia de cantidad delataba una diferencia de profundidad.

**3. Algo que dejé escrito en el harness y que el agente no cumplió igualmente.**
`AGENTS.md` dice, en «El ejercicio del curso»: *«Si el usuario está haciendo el ejercicio,
recuérdale anotarlos»*, refiriéndose a los prompts de `prompts.md`. En la mayoría de los turnos de
esta sesión no lo recordé ni una vez. La regla estaba escrita, cargada en contexto vía
`@AGENTS.md` y era inequívoca; simplemente no se cumplió, porque nada la ejecutaba. Es el mismo
patrón que ya había aparecido antes montando el harness: cuando pedí que `CLAUDE.md` redirigiese a
`AGENTS.md`, escribí una instrucción en prosa —«lee AGENTS.md antes de tocar nada»— en vez del
import `@AGENTS.md`, que es el mecanismo que el harness sí ejecuta. Tuvo que corregírmelo el
usuario. De las cuatro reglas de proceso de la pieza 6, solo dos se pudieron convertir en
mecanismo; las otras dos —parar a pedir aprobación del plan y pasar el revisor antes de
commitear— siguen siendo prosa, y por tanto siguen siendo opcionales.
