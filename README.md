# 🚀 Workspace — dizzi1222

Workspace con proyectos como submódulos y repos independientes.

## 📦 Proyectos

| #   | Proyecto                                  | Descripción                                                               |
| --- | ----------------------------------------- | ------------------------------------------------------------------------- |
| 1   | `dizzi1222`                               | — Perfil de GitHub                                                        |
| 2   | `Librezam`                                | — Rework de UI/UX de extension de Firefox de Shazam                       |
| 3   | `retro-portfolio`                         | — Portfolio retro                                                         |
| 4   | `kimu-underground`                        | — Portfolio retro de kimu v2 (inspiracion)                                |
| 5   | `portfolio-terminal-dhardi`               | — Portfolio estilo terminal                                               |
| 6   | `GLAZE-WM-make-windows-pretty-main-dizzi` | — Windows customización                                                   |
| 7   | `FCTicService.github.6c-Diego-05`         | — Pagina trucha para Papaleria de Jarabacoa                               |
| 8   | `REACT-Diego-Dizzi-Dashboard`             | — Dashboard en React                                                      |
| 9   | `Proyecto-App-MCSD`                       | — App MCSD v2.0                                                           |
| 10  | `dhardi.dev`                              | — Portfolio Landing page comercial                                        |
| 11  | `PCE-Agencia`                             | — App de finanzas y viajes                                                |
| 12  | `Just-coding`                             | — Proyectos de práctica y algoritmos                                      |
| 13  | `proyeccion-astral`                       | — Carta Apologys, para mi querida amiga-crush Marian                      |
| 14  | `ptd-talento-back` ⭐                     | — El detras de camara de PTD-Talento (repo independiente)                 |
| 15  | `ptd-talento-front` ⭐                    | — La cara de Martketplace de Talento (repo independiente)                 |
| 16  | `portafolio-eric-godtier`                 | — Portfolio de un buen amigo, fuente de inspiracion                       |
| 17  | `jscamp`                                  | — Bootcamp Fullstack midudev (JS, React, Node, Docker, CI/CD)             |
| 18  | `dataimpulse-mcp`                         | — MCP de proxy multi-proveedor (DataI+Webshare) para Opencode (Scrapping) |
| 19  | `dhardi-laravel`                          | — Portfolio Laravel 13 + Inertia 3 + React 19 trilingüe (DE/ES/EN)         |
| 20  | `codex-discord-presence`                  | — Discord Rich Presence para Codex vía hooks locales (plugin)             |
| 21  | `MultiPresence`                           | — Discord Rich Presence para juegos sin soporte nativo (fork, Windows)    |
| 22  | `dbtui.nvim`                              | — Launcher TUI de PostgreSQL/MongoDB para Neovim (LazySQL + mongosh)      |
| 23  | `neocursor.nvim`                          | — Predicciones next-edit estilo Cursor para Neovim (ghost text)           |
| 24  | `opencode.nvim`                           | — Integración de OpenCode dentro de Neovim                                |
| 25  | `premid-activities`                       | — Fork de PreMiD/Activities: actividades de Discord para Exercism y Mimo (systemd) |

> ⭐ `dhardi-laravel` es un **submódulo** de `dizzi1222/dhardi-laravel` (repo público propio).
> Es el portfolio en Laravel 13/Inertia 3/React 19 con i18n en DE/ES/EN, un gateway LLM con
> retry, circuit breaker, fallback, caché, guardrails y golden dataset, y multi-tenancy por
> instancia. Desplegado en Vercel como contenedor (FrankenPHP): `dhardi-laravel.vercel.app`.

## 🔧 Restaurar todos los proyectos

```bash
# 1. Clonar el workspace con submódulos
git clone --recurse-submodules https://github.com/dizzi1222/workspace

# O si ya lo clonaste sin submódulos:
git submodule update --init --recursive

# 2. Ejecutar setup (clona, limpia y deja en main/ dev)
chmod +x setup.sh
./setup.sh
```

> ⭐ Los proyectos `ptd-talento-back` y `ptd-talento-front` son **repos independientes** (no submódulos). Usan `origin` → CIC y `dizzi1222` → fork personal.

> 🔁 **Pusheo simultáneo en `workspace`:** `remote.origin` tiene **dos pushurls** (`dizzi1222/workspace` + `dhardi007/workspace`). Un simple `git push` sube a ambos a la vez; `git fetch` sigue viniendo de `dizzi1222`. El `setup.sh` lo re-configura (Paso 6) por si se pierde al recrear el repo.

> ⭐ `dataimpulse-mcp` es el **fork** `dizzi1222/dataimpulse-mcp` con host/puerto parametrizable por env (`DI_PROXY_HOST`/`DI_PROXY_PORT`) para soportar Webshare además de DataImpulse. Los MCP de OpenCode apuntan a este path (`opencode.json` → `mcp.dataimpulse`, `webshare-uk`, `webshare-us`). Seteala en `main` con sus deps instaladas.

> 🎮 `codex-discord-presence` es el plugin de **Discord Rich Presence para Codex** (el equivalente Codex de `opencode-discord-rpc`). Node.js 20+, **sin dependencias ni build**: el `setup.sh` solo lo clona y lo deja en `main`. Se registra a mano con `codex plugin marketplace add .` + `codex plugin add codex-discord-presence@codex-presence` desde su carpeta.

> 🪟 `MultiPresence` es un **fork** de MultiPresence (Discord Rich Presence para juegos sin soporte nativo) con Sekiro/Bloodborne y updater propio apuntando a `dizzi1222/MultiPresence`. Es **.NET 9 / Windows x64**: no se compila en Linux, el `setup.sh` solo lo clona y lo deja en `main`.

> 🗄️ `dbtui.nvim` es el plugin de **Neovim** que detecta conexiones PostgreSQL/MongoDB por proyecto y las abre en un terminal flotante (LazySQL / `mongosh`). Neovim 0.10+, sin build.

> 🧩 `neocursor.nvim` y `opencode.nvim` son plugins de **Neovim** (sin build): predicciones next-edit tipo Cursor (ghost text) e integración de OpenCode en el editor.

> 🎮 `premid-activities` es el **fork** `dizzi1222/premid-activities` de [PreMiD/Activities](https://github.com/PreMiD/Activities) con las actividades **Exercism** (`websites/E/Exercism`, App ID de Discord `1574465540955701381`) y **Mimo** (`websites/M/Mimo`, App ID de Discord `1575302343379918969`). El instalador [`systemd/premid-dev-install.sh`](systemd/premid-dev-install.sh) (lo llaman `setup.sh` y `~/bazzite-install.sh`) corre `npm ci` si faltan las dependencias (también compila el CLI `pmd`) e instala el servicio de usuario `premid-dev` ([`systemd/premid-dev.service`](systemd/premid-dev.service)), que deja [`premid-serve.mjs`](systemd/premid-serve.mjs) siempre sirviendo ambas actividades a la extensión. Remote `upstream` → PreMiD/Activities para sincronizar y abrir el PR al store.

## 📐 Breakpoints móviles (convención)

Umbral móvil XS: **`≤ 480px`** (antes `450px`, luego `468px`) en todos los proyectos.

> ⚠️ **Nunca usar valores knife-edge medidos de un dispositivo real.** El mismo hardware reporta anchos CSS distintos por motor: Firefox Android usa DSF 2.3077 → viewport ~468.x px; Chromium usa ~2.62 → ~412px. Además el ancho real es fraccional (Eruda lo redondea al mostrarlo), así que `(max-width: 468px)` no matcheaba aunque la consola dijera "468". Con 480 ambos motores caen en el bucket móvil.

- `dhardi.dev` — sin breakpoints móviles propios (los únicos "450" son coordenadas SVG) → sin cambios.
- `portfolio-terminal-dhardi` — `@media (max-width: 480px)` en CSS + `innerWidth > 480` en Svelte; toggle nav oculto con `@media (min-width: 481px)`.
- `ptd-talento-front` — MUI con breakpoints custom (`src/themes/main.ts`): xs `0` · sm `768` · md `1024` · lg `1440` · xl `1920`; el sub-rango ≤ 480px va con `useMediaQuery("(max-width:480px)")` y `window.innerWidth <= 480`.

> ⚠️ No tocar números "450"/"468" dentro de paths SVG — son geometría, no breakpoints.

## ▶️ Iniciar proyectos localmente

### Portfolio Terminal (HTML estático)

```bash
cd portfolio-terminal-dhardi
python3 -m http.server 8080
# → http://localhost:8080
```

### Retro Portfolio (HTML estático)

```bash
cd retro-portfolio
python3 -m http.server 8081
# → http://localhost:8081
```

### REACT-Diego-Dizzi-Dashboard (React)

```bash
cd REACT-Diego-Dizzi-Dashboard
npm install
npm run dev
# → http://localhost:5173
```

### Proyecto-App-MCSD (Vite + Tailwind)

```bash
cd Proyecto-App-MCSD
npm install
npm run dev
# → http://localhost:5173
```

### dhardi.dev (Landing page comercial)

```bash
cd dhardi.dev
python3 -m http.server 8082
# → http://localhost:8082
```

### PTD-Talento Back (Express + TypeORM + PostgreSQL)

```bash
cd ptd-talento-back
npm install
npm run dev
# → http://localhost:3000/api
```

### PTD-Talento Front (React + Vite)

```bash
cd ptd-talento-front
npm install
npm run dev
# → http://localhost:5173
```

### JSCamp (Bootcamp midudev - HTML/CSS/JS vanilla)

```bash
cd jscamp/01-javascript
# Abre empleos.html directo en navegador
# O sirve con python:
python3 -m http.server 8083
# → http://localhost:8083/empleos.html
```

### dhardi-laravel (Laravel 13 + Inertia 3 + React 19)

```bash
cd dhardi-laravel
composer install
npm install
cp .env.example .env
php artisan key:generate
touch database/database.sqlite
php artisan migrate --seed
composer run dev
# → http://localhost:8000 (alemán por defecto; ?lang=es / ?lang=en)
```

Tests y evals:

```bash
php artisan test        # 79 tests
php artisan evals:run   # golden dataset del asistente (12 casos)
vendor/bin/pint         # formatear PHP
npx tsc --noEmit        # typecheck TypeScript
```

Sin credenciales de IA el asistente responde igual por la cadena determinista,
así que la demo funciona sin configurar nada.

### codex-discord-presence (plugin de Codex, sin build)

```bash
cd codex-discord-presence
codex plugin marketplace add .
codex plugin add codex-discord-presence@codex-presence
node src/cli.mjs doctor   # verificar Discord + hooks
```

⚙️ **La config real NO vive en el repo ni en el workspace**, sino en el home:

```bash
nvim /home/diego/.config/codex-discord-presence/config.json
```

Requiere Discord de escritorio abierto y Node.js 20+. No tiene dependencias ni
paso de compilación.

### MultiPresence (Discord RPC para juegos, .NET 9 / Windows)

```bash
cd MultiPresence
dotnet publish MultiPresence/MultiPresence.csproj -c Release -r win-x64 --self-contained false
./build-and-deploy.ps1 -Target "<carpeta de instalación>"
```

Requiere .NET 9 SDK y **Windows 10/11 x64**; en Linux/NixOS solo se versiona el
código (el `setup.sh` no lo compila).

### dbtui.nvim (plugin de Neovim)

```lua
-- lazy.nvim
{ "dizzi1222/dbtui.nvim", opts = { keymap = "<leader>gz" } }
```

Requiere Neovim 0.10+, `lazysql` (PostgreSQL) y/o `mongosh` (MongoDB); solo el
binario de la conexión que uses. Para desarrollo local se carga por `dir`
(p. ej. `dir = "~/workspace/dbtui.nvim"`) en el spec de lazy.nvim.

### neocursor.nvim / opencode.nvim (plugins de Neovim)

```lua
{ "dizzi1222/neocursor.nvim" }
{ "dizzi1222/opencode.nvim" }
```

Sin build ni dependencias de sistema; se cargan con lazy.nvim (o por `dir` para
desarrollo local).

### premid-activities (actividades de PreMiD: Exercism y Mimo)

```bash
systemctl --user status premid-dev     # premid-serve: Exercism + Mimo (lo instala setup.sh)
journalctl --user -u premid-dev -f     # "Activity sent to the extension: <Actividad>" = cargada
```

En la extensión PreMiD: **Ajustes → Activity Developer** activado. Después de **cada reinicio
del navegador**, PreMiD lo apaga y borra las actividades Dev (lo hace el código de la extensión).
Vuelve a activarlo y el servicio reenvía las actividades solas: la extensión reintenta la conexión
a `ws://localhost:3021` cada 5 s. Cada actividad se activa sola al abrir exercism.org o mimo.org.

Desde el menú (`Super+Z` → Apps → **PreMiD Exercism** / **PreMiD Mimo**) se lanza
`~/scripts/premid-activity.sh <Actividad>` (dotfiles-dizzi): arranca el servicio si está parado
(o `premid-serve.mjs` si no hay unidad), abre la web y avisa si hay que activar Activity Developer.

El servicio ejecuta [`systemd/premid-serve.mjs`](systemd/premid-serve.mjs), una versión ligera de
`pmd dev` (~30 MiB frente a ~240 MiB): envía el `dist/` de cada actividad con el mismo mensaje que
`pmd dev` y solo compila (`pmd build`) al arrancar si hace falta o al guardar cambios en
`websites/<letra>/<Actividad>/`, que se recargan solos. Otra actividad: añádela al `ExecStart`
de [`systemd/premid-dev.service`](systemd/premid-dev.service) y vuelve a ejecutar el instalador.

Además antepone a `presence.js` un *shim* para PreMiD ≤2.11, la versión de Zen/Firefox (PreMiD no
publica otra para Firefox): en modo desarrollador ignora `<Actividad>.json` y Discord mostraría las
claves tal cual (`exercism.viewExercise`). El shim las rellena con los textos de ese archivo; en
2.14+ (Brave) y en el store no cambia nada. Con `PREMID_STRINGS_SHIM=0` el mensaje es idéntico al de
`pmd dev`.

```bash
cd premid-activities
npx pmd build Exercism --validate --zip   # zip para "Load built zip" (Brave): websites/E/Exercism/dist/
npx eslint websites/E/Exercism websites/M/Mimo   # lint del repo (lo exige el PR al store)
git fetch upstream && git merge upstream/main   # sincronizar con PreMiD
```

PRs al store: [PreMiD/Activities#11527](https://github.com/PreMiD/Activities/pull/11527) (Exercism) y
[PreMiD/Activities#11541](https://github.com/PreMiD/Activities/pull/11541) (Mimo).
Las imágenes de `metadata.json` viven en la rama `premid-assets` del fork.

### PTD-Talento Back (Express + TypeORM + PostgreSQL)

## 🗄️ mongodb (shared dev database)

Instancia de MongoDB compartida para los proyectos MERN del workspace.

```bash
docker compose up -d     # levanta (escucha en 127.0.0.1:27017, solo local)
docker compose down      # bajar (los datos persisten en el volume mongodb-data)
```

- Imagen `mongo:7`, datos en el volume `mongodb-data`.
- GUI: `mongodb-compass` (ver `nixconf/README.md`), conexión `mongodb://localhost:27017`.
- Proyectos: apuntan via `.env` → `MONGO_URI=mongodb://127.0.0.1:27017/<su_db>`.
