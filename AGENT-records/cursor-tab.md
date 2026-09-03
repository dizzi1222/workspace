# cursor-tab.nvim — next-edit con 9 providers (por qué el llama-server Qwen sirve para muchos)

Sesión `vim-learn` · Profesor de Diego · 2026-09-03
Fuente: <https://github.com/cursortab/cursortab.nvim>

## Qué es

Plugin de Neovim para **edit completions y cursor predictions** (líneas verdes / ghost text tipo Cursor Tab en modo NORMAL).
Daemon en **Go** = cerebro; frontend en Lua.

**Requisitos:** Go 1.25+ (build del server) + Neovim 0.8+.

## Punto clave (corrección importante)

`cursortab.nvim` NO es solo cloud: tiene **9 providers**. El `setup()` elige backend con `provider.type`.
Mi spec lo tenía fijado en `mercuryapi`, pero el mismo plugin aprovecha el **llama-server local** que ya corre con Qwen3.5-0.8B.

## Instalación lazy.nvim (con provider a elegir)

```lua
{
  "cursortab/cursortab.nvim",
  lazy = false,               -- el server ya es lazy
  build = "cd server && go build",
  config = function()
    require("cursortab").setup({
      provider = {
        -- elige UNO:
        --  Mercury API (hosted, no GPU):
        --   type = "mercuryapi", api_key_env = "MERCURY_AI_TOKEN"
        --  Zeta-2.1 (mejor local):
        --   type = "zeta-2.1", url = "http://localhost:8000"
        --  Qwen3.5-0.8B (más rápido local, default "inline"):
        --   type = "inline", url = "http://localhost:8000"
        --  sweep-next-edit 0.5B/1.5B:
        --   type = "sweep", url = "http://localhost:8000"
      },
    })
  end,
}
```

## Cómo arrancar el servidor local (llama.cpp) — qué hace cada comando

```sh
# Qwen3.5-0.8B — el más rápido local (bench p50 137ms), ideal para "inline" y "fim"
llama-server -hf unsloth/Qwen3.5-0.8B-GGUF:Q8_0 --port 8000

# Zeta-2.1 — mejor calidad next-edit local (SeedCoder-8B), ctx grande
llama-server -hf mradermacher/zeta-2.1-GGUF --ctx-size 16384 --port 8000

# Sweep next-edit (familia específica para provider "sweep")
llama-server -hf sweepai/sweep-next-edit-0.5b --port 8000
# llama-server -hf sweepai/sweep-next-edit-1.5b --port 8000
```

Todos exponen API OpenAI-compatible en `http://localhost:8000`.

⚠️ **Los tres disparan descarga automática de GGUF a `~/.cache/huggingface/hub/`.**
Si el disco está lleno, la descarga falla con
`common_pull_file: error writing to file ... No space left on device`. Liberar
espacio (`nix-collect-garbage`) o descargar el GGUF aparte con `hf download`.

# O Eliminar TODOS los modelos cacheados

rm -rf ~/.cache/huggingface/hub/models--*

## Tabla de providers

| Provider     | Tipo   | Usa llama-server :8000 | Modelo                        |
| ------------ | ------ | ---------------------- | ----------------------------- |
| `mercuryapi` | Hosted | ❌ No (solo token)     | mercury-edit-2                |
| `inline`     | Local  | ✅ Sí                  | Cualquier base (Qwen3.5-0.8B) |
| `fim`        | Local  | ✅ Sí                  | Cualquier FIM-capable         |
| `sweep`      | Local  | 📝 Sí, otro GGUF       | sweep-next-edit 0.5B/1.5B/7B  |
| `zeta-2.1`   | Local  | ✅ Sí                  | zeta-2.1 (SeedCoder-8B)       |
| `zeta-2`     | Local  | ✅ Sí                  | zeta-2 (SeedCoder-8B)         |
| `zeta`       | Local  | ✅ Sí                  | zeta (Qwen2.5-Coder)          |
| `copilot`    | Hosted | ❌ No                  | GitHub Copilot                |
| `windsurf`   | Hosted | ❌ No                  | Windsurf AI                   |

## Properties por provider

| Property          | inline | fim | sweep | zeta-2.1 | zeta-2 | copilot | windsurf |
| ----------------- | ------ | --- | ----- | -------- | ------ | ------- | -------- |
| Multi-line        | ✅     | ✅  | ✅    | ✅       | ✅     | ✅      |          |
| Multi-edit        |        | ✓   | ✅    | ✅       | ✅     | ✅      |          |
| Cursor prediction |        |     | ✅    | ✅       | ✅     | ✅      |          |
| Streaming         |        |     |       | ✅       | ✅     | ✅      | ✅       |

Todos usan buffer context; la mayoría: edit history, LSP diagnostics, treesitter, git diff, recent files (excepto inline).

## Benchmarks (eval 50 escenarios; score = deltaChrF × gateScore / 100)

| Target           | Score | deltaChrF | Show | Quiet | p50 | p90 |
| ---------------- | ----- | --------- | ---- | ----- | --- | --- |
| zeta-2           | 0.61  | 65.4      | 92%  | 96%   | 551 | 833 |
| zeta             | 0.56  | 62.4      | 88%  | 92%   | 413 | 662 |
| mercuryapi       | 0.49  | 61.8      | 92%  | 69%   | 332 | 393 |
| qwen3.6-27B fim  | 0.23  | 32.0      | 60%  | 92%   | 214 | 455 |
| sweep-7B         | 0.23  | 46.0      | 64%  | 40%   | 270 | 515 |
| qwen3.5-0.8B fim | 0.21  | 37.3      | 80%  | 44%   | 137 | 226 |
| sweep-1.5B       | 0.21  | 43.7      | 68%  | 36%   | 157 | 258 |

**Interpretación:** zeta-2/zeta son los mejores en calidad (>0.5) pero piden
modelos grandes. Qwen3.5-0.8B es el más rápido (p50 137ms) y accesible en este hardware.

## Keymaps (sin pisar Supermaven en INSERT)

Set NES unificado (`<S-Tab>` = Rechazar en los 6 plugins):

- `<M-CR>` / `<C-CR>` — aceptar (principal)
- `<S-Tab>` — **rechazar** (consistente con copilot/nextedit/tabtab/blink/sweep)
- `<Esc>` — rechazar (built-in del plugin, vía hook `vim.on_key`)
- `<Tab>` en NORMAL/VISUAL: aceptar o fallback `<C-i>`
- `<Tab>` en INSERT desactivado (`trigger = false`) — lo captura Supermaven

> ⚠️ `partial_accept` de cursortab está DESACTIVADO (`false`). Antes usaba
> `<S-Tab>` para aceptar parcial, lo que era inconsistente con los demás plugins
> donde `<S-Tab>` = rechazar. Se alineó a rechazar.

## Comandos

- `:CursortabToggle` — on/off
- `:CursortabStatus` — estado plugin + daemon
- `:CursortabRestart` — reiniciar daemon Go (usar tras cambiar `MERCURY_AI_TOKEN`)
- `:CursortabShowLog` / `:CursortabClearLog`

## Highlight groups

`CursorTabDeletion`, `CursorTabAddition`, `CursorTabModification`, `CursorTabCompletion`,
`CursorTabJumpSymbol`, `CursorTabJumpText`. Se sobreescriben con `nvim_set_hl(0, ...)`.

## Estado real de mi config (plugins/cursortab.lua)

- `lazy = false` + `build = "cd server && go build"`.
- Provider `inline` (local, sin API key): `url = http://localhost:8000`, apunta a llama-server Qwen3.5-0.8B.
- Highlights NES configurados: `CursorTabAddition` (verde #238636), `CursorTabDeletion` (rojo #391a1a) + autocmd ColorScheme.
- Keymaps: `<M-CR>`/`<C-CR>` aceptar, `<S-Tab>` aceptar parcial, `<Tab>` en N/V aceptar o fallback C-i, `<Esc>` rechazar.
- `behavior.enabled_modes = { "normal" }` → predice en NORMAL sin pisar INSERT de Supermaven.
- 9 providers documentados en el archivo de config (comments).

## Comparativa plugins next-edit (qué usa cada uno)

| Plugin                 | Provider                              | Usa llama-server :8000                | API key                 | Estado            |
| ---------------------- | ------------------------------------- | ------------------------------------- | ----------------------- | ----------------- |
| cursortab (inline)     | Local Qwen3.5                         | ✅                                    | —                       | ACTIVO            |
| cursortab (mercuryapi) | Hosted                                | ❌                                    | `MERCURY_AI_TOKEN`      | alternativa cloud |
| cursortab (zeta-2.1)   | Local                                 | ✅ zeta GGUF                          | —                       | alternativa local |
| NextEdit               | OpenRouter cloud                      | ❌                                    | `OPEN_ROUTER_API_KEY` ✓ | disabled          |
| Sweep-nvim             | proxy propio `llama-cpp-python :5555` | ❌ (incompatible)                     | —                       | disabled          |
| BlinkEdit              | Local OpenAI-compat :8000             | ⚠️ técnica pero NO útil con Qwen base | —                       | disabled          |
| TabTab                 | OpenRouter cloud                      | ❌                                    | `OPEN_ROUTER_API_KEY` ✓ | disabled          |
| NeoCursor              | App Cursor real (sesión)              | ❌                                    | ninguna                 | disabled          |

## Descubrimientos clave (corrección)

1. **cursortab soporta sweep/zeta/mercury/Qwen** — no es solo cloud. El mismo
   llama-server Qwen3.5-0.8B sirve para el provider `inline`.
2. **Sweep-nvim** (c0r73x) es DISTINTO: usa su propio proxy Python
   (llama-cpp-python) en `127.0.0.1:5555` con API FIM de sweep — **NO** se conecta
   al `llama-server :8000`.
3. **BlinkEdit** sí conectaría a `:8000` (OpenAI-compatible) pero NO vale con Qwen
   base: sus providers `sweep`/`zeta` construyen prompts con formatos propietarios
   (`<|file_sep|>` / `### Goal:`) que requieren un modelo **fine-tuneado** en ese
   formato (sweep-next-edit, zed-industries/zeta). Con Qwen base las predicciones
   serían malas. Solo sirve si cargas un GGUF de la familia sweep/zeta en `:8000`.
4. **NeoCursor** no es llama.cpp: usa la app Cursor instalada (hosted real), sin API keys.
5. **Síntoma disco lleno:** `common_pull_file: error writing to file` al descargar
   GGUF del modelo local → `nix-collect-garbage -d` para liberar.

## Set NES consistente (keymaps + colores) aplicado a los 5 plugins

Referencia: `copilot.lua` (set NES). Colores GitHub: verde `#ffffff/#238636`
(add), rojo `#ffa198/#391a1a` (delete). Todos con autocmd `ColorScheme`.

**Unificación clave:** `<S-Tab>` = **Rechazar** en TODOS los plugins. (Antes
cursortab lo usaba para `partial_accept`, inconsistente → desactivado.)

| Plugin         | Colores (grupos)                             | Aceptar                                            | Rechazar                                                                  |
| -------------- | -------------------------------------------- | -------------------------------------------------- | ------------------------------------------------------------------------- |
| copilot.lua    | `CopilotLspNesAdd/Delete`                    | `<Tab>`(N/V), `<M-CR>`, `<C-CR>`                   | `<S-Tab>`, `<Esc>`                                                        |
| nextedit.lua   | `NextEditNew/Old/Sign`                       | `<Tab>`,`<M-CR>`,`<C-CR>`                          | `<S-Tab>`(dismiss_key), `<Esc>`                                           |
| cursortab.lua  | `CursorTabAddition/Deletion`                 | `<M-CR>`(nativo), `<Tab>`(N/V→C-i), `<C-CR>`       | `<S-Tab>`(vía `daemon send esc`), `<Esc>`(nativo). `partial_accept=false` |
| blink-edit.lua | `BlinkEdit*` vía `highlight` config          | `<M-CR>`(nativo), `<Tab>`(N/V→C-i), `<C-CR>`       | `<S-Tab>`, `<C-]>`(clear)                                                 |
| sweep-nvim.lua | `SweepAddition/Deletion/Modification`        | `<M-CR>`(accept/sweep), `<Tab>`(N/V→C-i), `<C-CR>` | `<S-Tab>`(vía `_G.sweep:reject()`)                                        |
| tabtab.lua     | usa `Comment`/`DiffStrikeThrough` (estándar) | `<M-CR>`(accept_or_jump nativo)                    | `<S-Tab>`(reject nativo, buffer-local)                                    |

**Hallazgo importante:** TabTab NO expone API pública `accept()/reject()` — acepta/rechaza vía
keymaps buffer-locales que el plugin registra al mostrar un hunk (`ui.lua:497-500`). No se puede
enlazar `<C-CR>` adicional sin tocar el plugin. Sus grupos de diff son `Comment`/`DiffStrikeThrough`.

**Hallazgo:** sweep expone `_G.sweep` con `accept()`, `reject()`, `trigger_completion()`.
**Hallazgo:** cursortab registra accept/partial_accept/trigger en **N e I** (`events.lua:145-146`) y
rechaza `<Esc>` con un hook `vim.on_key` (`events.lua:167-171`), no con un keymap.
**Hallazgo:** blink-edit expone `M.accept()`, `M.accept_line()`, `M.reject()`, `M.clear()`.

## Cache de modelos (huggingface hub)

```sh
# Listar modelos en cache
llama-server --cache-list
# → number of models in cache: 1
#    1. unsloth/Qwen3.5-0.8B-GGUF:Q8_0

# Eliminar UN modelo específico
rm -rf ~/.cache/huggingface/hub/models--unsloth--Qwen3.5-0.8B-GGUF

# Eliminar TODOS los modelos cacheados
rm -rf ~/.cache/huggingface/hub/models--*

# Ver tamaño en disco de la cache
du -sh ~/.cache/huggingface/hub/
```

> Cada modelo ocupa ~973M (Q8_0). Al eliminarlo, `llama-server` lo re-descarga
> la próxima vez que arranques con `-hf`.
