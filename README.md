# 🚀 Workspace — dizzi1222

Workspace con proyectos como submódulos y repos independientes.

## 📦 Proyectos

| #   | Proyecto                                  | Descripción                                          |
| --- | ----------------------------------------- | ---------------------------------------------------- |
| 1   | `dizzi1222`                               | — Perfil de GitHub                                   |
| 2   | `Librezam`                                | — Rework de UI/UX de extension de Firefox de Shazam  |
| 3   | `retro-portfolio`                         | — Portfolio retro                                    |
| 4   | `kimu-underground`                        | — Portfolio retro de kimu v2 (inspiracion)           |
| 5   | `portfolio-terminal-dhardi`               | — Portfolio estilo terminal                          |
| 6   | `GLAZE-WM-make-windows-pretty-main-dizzi` | — Windows customización                              |
| 7   | `FCTicService.github.6c-Diego-05`         | — Pagina trucha para Papaleria de Jarabacoa          |
| 8   | `REACT-Diego-Dizzi-Dashboard`             | — Dashboard en React                                 |
| 9   | `Proyecto-App-MCSD`                       | — App MCSD v2.0                                      |
| 10  | `dhardi.dev`                              | — Portfolio Landing page comercial                   |
| 11  | `PCE-Agencia`                             | — App de finanzas y viajes                           |
| 12  | `Just-coding`                             | — Proyectos de práctica y algoritmos                 |
| 13  | `proyeccion-astral`                       | — Carta Apologys, para mi querida amiga-crush Marian |
| 14  | `ptd-talento-back` ⭐                       | — El detras de camara de PTD-Talento (repo independiente) |
| 15  | `ptd-talento-front` ⭐                      | — La cara de Martketplace de Talento (repo independiente) |
| 16  | `portafolio-eric-godtier`                 | — Portfolio de un buen amigo, fuente de inspiracion  |
| 17  | `jscamp`                                  | — Bootcamp Fullstack midudev (JS, React, Node, Docker, CI/CD) |
| 18  | `opencode.nvim` 🐐🗣️                          | — Fork de opencode.nvim (NickvanDyke) con parches nativos: `@buffer`/`@buffers` emiten rutas absolutas |
| 19  | `neocursor.nvim`                           | — Fork de neocursor.nvim (refactor a indentación 2 espacios) |

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

### PTD-Talento Back (NestJS + PostgreSQL)

```bash
cd ptd-talento-back
npm install
npm run start:dev
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

## 🗄️ mongodb (shared dev database)

Instancia de MongoDB compartida para los proyectos MERN del workspace.

```bash
docker compose up -d     # levanta (escucha en 127.0.0.1:27017, solo local)
docker compose down      # bajar (los datos persisten en el volume mongodb-data)
```

- Imagen `mongo:7`, datos en el volume `mongodb-data`.
- GUI: `mongodb-compass` (ver `nixconf/README.md`), conexión `mongodb://localhost:27017`.
- Proyectos: apuntan via `.env` → `MONGO_URI=mongodb://127.0.0.1:27017/<su_db>`.
