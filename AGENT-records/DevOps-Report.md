# DevOps Report — PTD-Talento (QA / PROD)

Fecha: 2026-09-11 · Autor: Diego

Resumen de hallazgos de ambiente y la migración de perfil `dev → qa → prod`.
Solo documentación: **no se tocó código** (las correcciones quedan para el equipo).

## Hallazgos QA

Ticket de seguimiento: [#190 [INV] QA/PROD: 401 en login-reclutador y auditoría; 500 en solicitudes y reset-password](https://github.com/Cincinnatus-Institute-of-Craftsmanship/ptd-talento-back/issues/190) ✅

### 1. Login de reclutador devuelve 401 — ✅ RESUELTO

- **Comportamiento:** al iniciar sesión con un reclutador existente en QA, el backend responde `401`.
- **Causa raíz:** el correo del reclutador no existía en la tabla `user` de `talento-qa`
  (los reclutadores fueron creados en dev y prod, no en QA). La autenticación fallaba por
  usuario inexistente, no por credenciales.
- **Estado:** ✅ **resuelto** — se creó el reclutador `reclutador10@gmail.com` en
  `talento-qa` (`src/scripts/createUser.ts`, password `Reclutador123!`, rol `Reclutador`)
  y se verificó con `psql`. Queda solo la re-validación manual del login por QA.

### 2. Auditoría de acciones devuelve 401

- **Comportamiento:** `GET /history/me` y flujos de auditoría responden `401` en QA.
- **Causa raíz:** la petición llega sin `Authorization`/token válida (misma sesión/flow
  del 401 anterior, o token expirado). No hay un bug de código en el endpoint.
- **Estado:** diagnóstico cerrado (ruido de consola en el front — `OEMBED content.js`,
  `longtask`, `"Security Error: ... file"` — es de extensiones/build, no del sistema).

### 3. 500 al crear / rechazar / aprobar solicitudes de acceso

- **Comportamiento:** `POST/…/solicitud-acceso`, `rechazar` y `aprobar` devuelven `500`.
  En el front aparece mensaje de error genérico.
- **Evidencia (rama QA):**
  - `src/controllers/recruiterRequest.controller.ts` — `createRequest` (INSERT l.60)
    persiste la fila y luego llama `sendAdminNotification` (l.66) y
    `sendConfirmationToApplicant` (l.69) **dentro del mismo `try`** → si el envío de
    correo falla, el catch devuelve `500` l.74.
  - `rejectRequest` (UPDATE l.175) y `approve` también llaman
    `sendRejectionEmail`/mails dentro del `try` → `500` (l.189, idem).
  - `request.controller.ts` (flujo solicitante) **sí** envuelve los mails en
    `try/catch` interno (best-effort) y responde `200`.
- **Causa raíz:** el servidor de QA en Cloud Run **no tiene `EMAIL_USER` / `EMAIL_PASS`**
  en las variables de entorno (se confirmó vía `gcloud run services describe`).
  `src/libs/mailer.ts` lanza porque esos valores son `undefined`/`!`, y al estar los mails
  dentro del `try` del controlador, el flujo entero revienta.
- **Nota:** PROD (`ptd-talento-back-prod`) tampoco tiene variables `EMAIL_*` →
  **bug latente en PROD**: el día que haya una solicitud en producción, fallará igual.
- **Acción requerida (equipo/CIC):** definir `EMAIL_USER`/`EMAIL_PASS` en QA y PROD, y
  enlistar en el plan los puntos de falla (ideal: volver los mails best-effort).

### 4. Reset password: "Error al enviar el código" (misma causa que el punto 3)

- **Comportamiento:** `GET/POST /reset-password` en QA muestra *"Error al enviar el
  código"*; no llega ningún correo.
- **Evidencia:** `src/controllers/auth.controller.ts` `forgotPassword` (l.162-189) —
  actualiza `reset_code` (l.182-185) y luego `await sendResetCode` (l.187) dentro del
  `try` → sin `EMAIL_USER`/`EMAIL_PASS` el mailer lanza → `catch` → `500` → el front
  muestra el error.
- **Conclusión:** misma causa raíz que el punto 3 (variables de correo ausentes). Se
  agrupa en el mismo fix.

## Migración de perfil Diego (dev → qa → prod)

Perfil: talent `f74035c0-c721-4100-aba4-f000eef6c603` (usuario `dhardi@cincinnatus.edu.do`).

- **Script:** `ptd-talento-back/src/scripts/migrateDhardi.ts` (transaccional, con
  verificación previa y posterior). Lint (eslint) y typecheck (tsconfig) OK.
- **Ejecución / migraciones:** las migraciones de esquema (`npm run migration:run` /
  `npx typeorm-ts-node-commonjs migration:run -d src/config/database.ts`) **ya se habían
  aplicado en su momento** en QA y PROD (los 3 entornos comparten el mismo esquema), por
  lo que el sync de datos corrió sobre esquemas ya migrados, sin aplicar migraciones
  nuevas. El script de datos se corrió con
  `DB_NAME=talento-qa|talento-prod npx ts-node --transpile-only src/scripts/migrateDhardi.ts`.
- **QA (`talento-qa`):** catálogos replicados 100/9/7/5 (antes vacíos), talent
  `246355b6…` actualizado, `level_skill_talent` 55 (39 activos / 16 soft), `course` 7
  (4 activos / 3 soft), `user.picture` sincronizado.
- **PROD (`talento-prod`):** catálogos intactos (100/9/7/5), talent `f74035c0…`
  actualizado, nst 55, courses 7, `user.picture` = foto de dev. Verificación
  independiente con `psql` conforme.
- **Assets GCS:** foto `ptd-talento/profile-pictures/f2ee0388-….png` **existe** en
  bucket `ptd-dev` (HTTP 200). Los CV (`public/cv/*.pdf`) se sirven desde GCS
  (`ptd-talento/cv/…`); de los 7 de Diego, 2 existen en el bucket. Los otros 5 son
  **referencias dangling preexistentes en dev-origen**: viven solo como archivos locales
  gitignored (`public/` en `.gitignore`) y nunca llegaron a GCS → en dev-deploy, QA y
  PROD ya daban 404 **antes** de la migración. La migración replicó fielmente el estado
  de dev; no es una regresión.
- **Pendiente (opcional):** re-subir los 5 CVs faltantes al bucket o limpiar los cursos
  sin archivo.
