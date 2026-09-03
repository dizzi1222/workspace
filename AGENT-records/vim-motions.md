# Vim motions — chuleta rápida (transversal)

Se usa en TODAS las sesiones. Diego quiere que
SIEMPRE le recuerde la clave vim del momento.

## En terminal (CLI)

| Comando             | Qué hace                     |
| ------------------- | ---------------------------- |
| `rg "palabra"`      | buscar en archivos (ripgrep) |
| `rg "palabra" src/` | buscar acotado a una carpeta |
| `grep -rn "p" src/` | alternativa clásica          |

## En Neovim / LazyVim

| Key             | Qué hace                              |
| --------------- | ------------------------------------- |
| `Space + /`     | **Live Grep** (búsqueda global)       |
| `Space + s + w` | buscar la palabra bajo el cursor      |
| `Space + f + f` | buscar archivo por nombre             |
| `*`             | buscar palabra bajo cursor en archivo |
| `/`             | buscar en el archivo actual           |
| `n` / `N`       | siguiente / anterior coincidencia     |
| `Space + g + g` | ir al inicio del archivo              |
| `viw`           | **seleccionar** la palabra (visual)   |
| `Space + s + r` | Snacks **Rename** (reemplazo)         |

## ⚠️ `*` NO selecciona la palabra

**Confusión frecuente de Diego:** en Vim/Neovim,
`*` puesto sobre una palabra la **busca** (la resalta
en todo el archivo), pero **NO la deja "seleccionada"**
como un objeto que un reemplazo pueda tomar.
Por eso, al pulsar luego `Space + s + r`, el campo
Search/Replace del selector aparece **vacío**.

### Cómo se comporta cada editor

| Acción              | Helix                         | Neovim (Vim)                  |
| ------------------- | ----------------------------- | ----------------------------- |
| Poner cursor        | El cursor es la selección     | El cursor es un punto         |
| "Marcar" la palabra | La selección es objeto nativo | `*` = busca, NO selecciona    |
| Ejecutar reemplazo  | Afecta la selección directo   | Necesitás seleccionar primero |

**Conclusión:** en este punto Helix es más directo
(selección nativa). Lo reconozco. La ventaja de
Neovim es que esa "selección explícita" te da
control total cuando la dominás.

### Cómo seleccionar la palabra en Neovim

- `viw` (o `viW`) → **selecciona** la palabra bajo
  el cursor (visual). `v`=visual, `iw`=inner word.
- Luego ya podés: `d` (borrar), `c` (cambiar),
  `y` (copiar), `r letra` (reemplazar), etc.
- Para renombrar toda la palabra en el archivo:
  con `viw`, luego el flujo de rename.

### Flujo correcto para "renombrar una interface"

```vim
viw            " selecciona la palabra (visual)
y              " (opcional) copiarla
:grep "authUser" %  " o usar Space+/ para buscar
```

Y para reemplazo controlado (ver sección de
reemplazo):

```vim
:%s/PalabraVieja/PalabraNueva/g
```

### Resumen anti-confusión

> `*` = **buscar** (resalta matches).
> Para **seleccionar** la palabra usá `viw`.
> Son conceptos distintos. En Helix la selección
> es nativa; en Neovim se hace con `viw`.

## Grug-Far / Snacks Rename (`Space + s + r`)

`Space + s + r` abre el selector con los campos
y, dentro, este HUD de acciones.

### Campos (navegás con Tab / Shift+Tab)

```text
Search → Replace → Files Filter → Flags → Paths
```

### Acciones del HUD

| Tecla     | Acción      | Qué hace                                  |
| --------- | ----------- | ----------------------------------------- |
| `\r`      | **Replace** | Aplica el reemplazo en el buffer          |
| `g?`      | **Help**    | Abre la ventana de ayuda del HUD          |
| `\s`      | Sync All    | Guarda TODAS las líneas editadas          |
| `\l`      | Sync Line   | Guarda solo la línea actual               |
| `\n`      | Sync Next   | Guarda la línea actual y pasa a siguiente |
| `\p`      | Sync Prev   | Guarda la línea actual y pasa a anterior  |
| `\v`      | Sync File   | Guarda todos los cambios del archivo      |
| `\j`      | Apply Next  | Aplica línea actual, va a siguiente       |
| `\k`      | Apply Prev  | Aplica línea actual, va a anterior        |
| `<Tab>`   | Next Input  | Salta al siguiente campo (cicla)          |
| `<S-Tab>` | Prev Input  | Salta al campo anterior                   |

### Flujo completo de reemplazo

Para reemplazar **todos** de una pasada:

```text
1. Space + s + r
2. Escribís Search + Replace
3. \r        ← APLICA el cambio en el buffer
4. \s        ← Sync All: guarda en los archivos
```

Para reemplazar **uno por uno**:

```text
1. Space + s + r
2. Search + Replace
3. \r         ← modifica las líneas del buffer
4. borrá con `dd` las líneas que NO querés
5. \l  o  \n  o  \v   ← sync solo lo que dejaste
```

> `\j` / `\k` (Apply Next/Prev) = aplicar caso
> por caso avanzando.
>
> ⚠️ **Antes de usar Grug-Far, asegurate de que
> Paths apunte a un solo proyecto** (o haz
> `:lcd`/`:cd` primero). Si no, ripgrep barre
> todo `~/` y tocás repos que no querés.

## Combo mágico: reemplazo selectivo

Para reemplazar **eligiendo cada caso** (sin barrer
todo el archivo, sin riesgo de `:cfdo`):

```text
1. cursor sobre la palabra
2. *            → busca la palabra
3. cgn          → cambia el próximo match
4. {texto}      → escribís el reemplazo
5. <Esc>
6. .            → repite el cambio en siguiente
7. n            → (opcional) salteás uno
8. .            → seguís reemplazando
```

Ventajas: elegís cada uno, no borra de más,
no toca archivos que no querés.

## Remplazo PRO: Truco del `*` + `:%s //`

```vim
cursor sobre la palabra → * → :%s //reemplazo/g
// vacío = usa la palabra que marcaste con *
```

`*` busca la palabra bajo el cursor;
`:%s//texto/g` reemplaza con `//` vacío
aprovechando ese patrón de búsqueda.

> ⚠️ **Peligro (lección del 2026-08-31):** el `//` vacío usa el **último patrón buscado**
> (`@/`), NO la palabra bajo el cursor. Si no hiciste `*` justo antes (o la búsqueda previa
> era otra/heredada), termina reemplazando lo que coincida con ESE patrón viejo, y puede
> romper código real (ej. explotó "Error while decoding suggestions" en tsserver al tocar
> un buffer que quedó inconsistente). → **Siempre hacé `*` primero** y revisá con `gc`
> (confirmación) antes de un `:%s//`. Probá en un archivo de prueba, nunca sobre código vivo.

### `viw` NO alimenta el `//` (diferencia con `*`)

- `*` **fija el patrón de búsqueda** `@/` → el `//` lo usa. ✅
- `viw` **solo selecciona** visualmente la palabra; **NO toca `@/`**. Por eso `viw` + `:%s//`
  **NO** reemplaza lo que seleccionaste — usa el último patrón buscado (¡riesgo de romper código!).

**Para reemplazar exactamente lo que seleccionaste con `viw`, pegá el registro visual en el `:s`:**
```
viw
: s / <C-r>" / nueva / g
```
`<C-r>"` pega el texto que `viw` dejó en el registro `"` (el yank visual). Así no dependés de `@/`.

**¿Cuándo usar cuál?**

| Querés                                  | Uso                          |
| --------------------------------------- | ---------------------------- |
| La palabra en **todo el archivo**       | `*` → `:%s//nueva/g` (o `gc`) |
| **Solo una ocurrencia puntual** (manúa) | `viw` → `c` / `d` (cambiar/borrar el text-object) |
| Selección visual → reemplazar ese texto | `viw` → `:s/<C-r>"/nueva/`    |

> Regla: para **reemplazos masivos** de archivo usá `*` (fija patrón) + `gc` de confirmación.
> Para **tocar un solo text-object** usá `viw` + `c`/`d`. (`Space + s + r` de Snacks sigue
> siendo el camino para reemplazos con UI de búsqueda/reemplazo.)

## 🚀 `Space + f + s` — rip-substitute (la vía MÁS fácil al reemplazo)

> Plugin: **nvim-rip-substitute** (`chrisgrieser/nvim-rip-substitute`).
> Config: `nvim/.config/nvim/lua/plugins/rip.lua:11-21` (`<leader>fs`).
> Comando subyacente: `:RipSubstitute`.

**`Space + f + s` = reemplazo con ripgrep SOLO en el archivo actual**, usando
automáticamente la palabra/valor que tengas bajo el cursor (modo normal) o la
selección (modo visual).

### Por qué es la vía más fácil (vs `*` + `:%s//`)

- En **modo normal**, ponés el cursor sobre la palabra y `Space+f+s` la **carga
  automáticamente** como el patrón a buscar — NO necesitás `*` ni escribir nada.
- Se abre un mini-buffer que **previsualiza en vivo** cada coincidencia del
  archivo actual, con paneo entre ellas.
- Aplicás el reemplazo y ripgrep lo escribe **solo en ese archivo** (no barre
  otras carpetas, a diferencia de Grug-Far con Paths mal apuntado).

### Cómo se usa

```text
1. cursor sobre la palabra  (o seleccionás con viw en modo visual)
2. Space + f + s
3. Confirmás el patrón (search) y escribís el reemplazo (replace)
4. Paneás entre coincidencias y aceptás el cambio → solo este archivo
```

| Situación                          | Herramienta recomendada              |
| ---------------------------------- | ------------------------------------ |
| Reemplazo en **solo 1 archivo**    | **`Space+f+s`** (rip-substitute) ⭐   |
| Reemplazo con UI search/replace    | `Space + s + r` (Grug-Far)           |
| Reemplazo masivo multi-archivo     | `Space + s + r` cuidando **Paths**   |
| Sustitución clásica `:s`           | `:%s/old/new/gc` (con confirmación)  |

> Diferencia clave con `*`+`:%s//`: `Space+f+s` usa el **valor bajo el cursor**
> directamente (o la selección visual), NO el último patrón `@/` — así evitás el
> peligro de reemplazar con un patrón heredado/viejo documentado más arriba.

## Mover líneas / bloques (plugin `move.nvim`) — el "O" que buscás

> ⚠️ **Distinguir tres usos de `O`/teclas visuales:**
>
> - Modo normal `O` / `Shift+O` = insertar línea en blanco arriba.
> - **En modo VISUAL `O` = alternar la dirección/ancla de la selección** (salta el cursor al
>   otro extremo: fila superior ↔ inferior; en visual-block también alterna esquinas). Sirve
>   para seguir extendiendo la selección hacia el lado opuesto sin perder lo ya marcado.
> - Para **mover físicamente** (reordenar) líneas/bloques se usa el plugin **`move.nvim`**
>   (config en `nvim/.config/nvim/lua/plugins/move.lua`), con `Alt + h/j/k/l`:

| Modo       | Tecla                | Acción                                               |
| ---------- | -------------------- | ---------------------------------------------------- |
| normal     | `<A-j>` / `<A-Down>` | Mover la línea hacia **abajo**                       |
| normal     | `<A-k>` / `<A-Up>`   | Mover la línea hacia **arriba**                      |
| normal     | `<A-h>`              | Mover carácter hacia **izquierda**                   |
| normal     | `<A-l>`              | Mover carácter hacia **derecha**                     |
| visual (V) | `<A-j>` / `<A-Down>` | Mover el **bloque** seleccionado **abajo**           |
| visual (V) | `<A-k>` / `<A-Up>`   | Mover el **bloque** seleccionado **arriba**          |
| visual (V) | `<A-h>`              | Mover **bloque** hacia la **izquierda**              |
| visual (V) | `<A-l>`              | Mover **bloque** hacia la **derecha**                |
| normal     | `<F2>` / `<F3>`      | Mover línea abajo / arriba (alternativa confirmada)  |
| visual (V) | `<F2>` / `<F3>`      | Mover bloque abajo / arriba (alternativa confirmada) |

**En modo VISUAL, alternar la dirección con `O`:**

1. Entrás en visual (ej. `V` para líneas, o `v`/`Ctrl+V`).
2. Marcás un rango (`j`/`k`).
3. Apretás `O` → el cursor salta al **otro extremo** de la selección; ahora `j`/`k` extienden
   hacia el lado contrario. (En `Ctrl+V` alterna entre las 4 esquinas.)

## Regla de oro

> **Siempre buscar con `rg` / `Space+/`,
> nunca escanear con el ojo.**
> Esto evitó 10 min perdidos en la entrevista.

## Cómo se busca "Background"

```bash
rg -n "Background" workspace/ptd-talento-front/src
```

```markdown
# Luego Space + / en nvim, escribir Background,

# Enter, y navegar con n/N
```

## Folds: plegar / desplegar código

Los **folds** (pliegues) ocultan/expanden bloques de código (funciones, clases, `if`, etc.)
para navegar un archivo largo sin distracciones. El cursor debe estar **dentro** del pliegue.

| Comando | Qué hace                                                   |
| ------- | ---------------------------------------------------------- |
| `zc`    | **Cerrar** el pliegue bajo el cursor (1 nivel)             |
| `zo`    | **Abrir** el pliegue bajo el cursor (1 nivel)              |
| `zC`    | **Cerrar todos** los pliegues **anidados** bajo el cursor  |
| `zO`    | **Abrir todos** los pliegues **anidados** bajo el cursor   |
| `za`    | Alternar abrir/cerrar el pliegue bajo el cursor            |
| `zM`    | **Cerrar todos** los pliegues del archivo                  |
| `zR`    | **Abrir todos** los pliegues del archivo                   |

> ⚠️ Error típico `E490: No fold found` → el cursor NO está sobre un bloque plegable
> (o los folds están desactivados para ese filetype). Movete a la línea de la
> **definición de función/clase** (la de apertura) y probá de nuevo.
> En LazyVim los folds suelen ir con `Space + space` (fold) o `:norm zR` para abrir todo.

### Mnemotécnica

- **c** = **c**lose → `zc` / `zC` (mayúscula = todo lo anidado).
- **o** = **o**pen → `zo` / `zO` (mayúscula = todo lo anidado).
- **a** = **a**lternate → `za`.
- **M** = todas cerradas (`M` de "minimizado") / **R** = todas abiertas (`R` de "reducido/revelado").

## Sesiones (persistence.nvim) — guardar / restaurar layout

Plugin **`persistence.nvim`** (viene con LazyVim). Guarda/restaura el estado
de ventanas + buffers de un proyecto (layout de splits, archivos abiertos).

| Key            | Acción                                  | Comando                                  |
| -------------- | --------------------------------------- | ---------------------------------------- |
| `<leader>qg`   | **Guardar** sesión (manual) ⭐          | `require("persistence").save()`          |
| `<leader>qs`   | Restore session (del cwd actual)        | `require("persistence").load()`          |
| `<leader>qS`   | Select session (elegir una)             | `require("persistence").select()`        |
| `<leader>ql`   | **Restore Last** session ⭐             | `require("persistence").load({last=true})` |
| `<leader>qd`   | No guardar la sesión actual             | `require("persistence").stop()`          |
| `<leader>qq`   | Salir de todo (quit all)                | `:qa`                                    |

> **`<leader>qg` es el atajo NUEVO de Diego** (config en
> `nvim/.config/nvim/lua/config/keymaps.lua`) — LazyVim no trae el "guardar manual",
> así que se agregó. `g` de **g**uardar.
>
> Diferencia clave:
>
> - `<leader>qs` restaura la sesión del **proyecto actual** (`load()`).
> - `<leader>ql` restaura la **última** sesión que hubo abierta,
>   sin importar el directorio (`load({last=true})`).
>
> El botón **`s` del dashboard** ("Restore Last Session") ahora hace
> `require("persistence").load({last=true})` (config en
> `nvim/.config/nvim/lua/plugins/ui.lua:473`), igual que `<leader>ql`.
> ⚠️ Debe ser una **función**, no un string `"lua …"`, o snacks lo
> interpreta como un picker de `scratch` y rompe (error E5108 de lazy.nvim).
