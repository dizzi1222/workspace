# AGENT-records — Registro de aprendizaje de Diego

Sesión `vim-learn` · Profesor de Diego

## ¿Qué es esto?

Archivo de **registro y razonamiento** de lo aprendido en sesiones de estudio.
No es código de proyecto: son notas de aprendizaje que Diego va construyendo.
Cada nota replica la ruta del archivo real del proyecto al que se refiere,
así Diego sabe "dónde vive" cada concepto sin contaminar los repos.

## Estructura

```text
AGENT-records/
  AGENT-records.md            <- este índice + registro principal
  <proyecto>/                 <- espejo de la estructura del proyecto real
    .../                      <- mismas carpetas hasta llegar al archivo
```

Proyectos configurados:

- `PCE-Agencia/` (server + client)
- `ptd-talento-back/`
- `ptd-talento-front/`

## Cómo se usa

1. Al estudiar un archivo, replico su ruta en AGENT-records (ej. `ptd-talento-front/src/store/slices/authSlice.ts`).
2. Guardo ahí la nota de aprendizaje (razonamiento + mini-ejercicios + Feynman de Diego).
3. Los snippets van en la nota como referencia; **nunca escribo código en los repos reales**.

## Convención de nombres de sesiones

Cada registro de sesión lleva **fecha inicial** al frente, para alinear la evidencia cronológicamente:

- Formato: `YYYY-MM-DD-nombre.md` (ej. `2026-08-30-session-redux.md`).
- Así queda alineado todo el historial de aprendizaje en un solo lugar.

## Lo que NO hago (regla Profesor)

- NO escribir código en los repos de proyecto (ptd-talento-*, PCE-Agencia, etc.).
- NO contaminar esos repos con commits de estudio. Aquí es donde va el aprendizaje.

---

## Índice de registros (convención fecha)

- `2026-08-30-helix-vs-neovim.md` — desmitificando ventajas de Helix vs LazyVim
- `ptd-talento-front/src/store/slices/2026-08-30-session-redux.md` — sesión Redux Toolkit
- `ptd-talento-front/src/store/slices/2026-08-31-ejercicio-contador-redux.md` — ejercicio contador con Redux Toolkit (createSlice + hooks)
- `ptd-talento-front/src/contexts/2026-08-30-AuthContext.tsx.md` — React.FC + Context ↔ Redux
- `ptd-talento-front/src/hooks/2026-08-30-useStore.ts.md` — useAppDispatch / useAppSelector
- `ptd-talento-back/src/routes/2026-08-30-express-rutas.md` — Express: patrón de rutas
- `PCE-Agencia/server/2026-08-31-PLAN-mongodb-migracion.md` — plan: volver a MongoDB aprendiendo la "M" (ejercicio post-contador)
- `vim-motions.md` — chuleta vim transversal (sin fecha: es referencia continua, no una sesión)
- `vim-basics.md` — fundamentos y trucos de comandos `:` (compilado del prepack LazyVim + docs nvim)
- `vim-ui.md` — mapa de todas las UIs/paneles que se abren en Neovim (Space+u toggles, Space+x quickfix, LazyGit, DAP)
- `vim-mason.md` — Mason: atajo `Space+cm`, por qué el `ensure_installed` de DAP no autoinstala al abrir nvim, adapters por lenguaje y paquetes LSP/DAP/linters recomendados según el roadmap
- `vim-dap-debug.md` — cómo usar el debugger nvim-dap (flujo completo + errores comunes + configuración real)
- `vim-dap-fix-plan.md` — PLAN pendiente: arreglar nvim-dap multi-lenguaje (C++/Rust/Go/C#/Java/PHP) tras restaurar el archivo. Incluye diagnóstico de cada fallo + fixes a aplicar gradualmente. La UI (layout con títulos por sección) YA quedó corregida.
- `cursor-tab.md` — cursortab.nvim: los 9 providers (inline/fim/sweep/zeta-* con llama-server local :8000 vs mercury/copilot/windsurf cloud), comandos de arranque del GGUF, keymaps, benchmarks y comparativa con nextedit/sweep-nvim/blink-edit/tabtab/neocursor. Incluye síntoma de disco lleno (`common_pull_file: error writing to file`).

### Referencias externas (fuera de AGENT-records/)

- `../motivational.md` — resumen de la sesión del 31-08 (lazygit, vim motions, Redux Toolkit, Docker MongoDB, links de setup). Reflexión final "Desconociendo lazygit...". En `workspace/`.
- `../theme-neonforge.css` — preset de tokens **NeonForge** (proyecto del hermano de Diego, https://github.com/ghaerdi/neonforge · https://neonforge.ghaerdi.dev/). Candidato de esquema de color para el proyecto MongoDB/PCE-Agencia. En `workspace/`. ⚠️ No es tema standalone: es *override* a **appender al final** del `theme.css` completo (con `@theme inline`, `@utility` glass-panel/neon-glow/grid-bg).

---

## Registro por sesiones

Cada sesión agrega una sección abajo.
