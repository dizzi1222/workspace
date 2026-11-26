#!/usr/bin/env node
// premid-serve: versión ligera de `pmd dev` para la extensión PreMiD, con varias actividades.
// Envía cada actividad compilada (dist/) por ws://localhost:3021 con el mismo mensaje que
// `pmd dev` (uno por actividad). Solo compila (`pmd build`) al arrancar si dist/ está
// desactualizado y al guardar cambios, en lugar de dejar el compilador de TypeScript vigilando.
// Antepone a presence.js un shim para PreMiD <=2.11 (la versión de Firefox/Zen), que en modo
// desarrollador ignora <Servicio>.json: sin él, getStrings devuelve las claves tal cual
// ("exercism.viewExercise"). Con PREMID_STRINGS_SHIM=0 el mensaje es idéntico al de `pmd dev`.
// Uso (cwd = clon de PreMiD/Activities): node premid-serve.mjs <Actividad> [<Actividad>...]
import { execFile } from 'node:child_process'
import { existsSync, readdirSync, readFileSync, statSync, watch } from 'node:fs'
import { createRequire } from 'node:module'
import { extname, join } from 'node:path'
import process from 'node:process'
import { promisify } from 'node:util'

//Setup

const names = process.argv.length > 2 ? process.argv.slice(2) : ['Exercism']
const repo = process.cwd()
const port = Number(process.env.PREMID_PORT ?? 3021)
const { WebSocketServer } = createRequire(join(repo, 'package.json'))('ws')
const pmd = join(repo, 'node_modules', '.bin', 'pmd')
const runFile = promisify(execFile)
const wait = ms => new Promise(resolve => setTimeout(resolve, ms))

/** Pause between activities on a new connection: the extension stores each one asynchronously. */
const SEND_GAP_MS = 1000

//Activities

/**
 * Locates an activity folder (`websites/<letter>/<name>`).
 * @param {string} name Activity (service) name.
 * @returns {{ name: string, dir: string, dist: string, built: string, message?: string } | null} Activity paths, or `null` if it doesn't exist.
 */
function locate(name) {
  const letter = readdirSync(join(repo, 'websites'))
    .find(dir => existsSync(join(repo, 'websites', dir, name, 'metadata.json')))
  if (!letter) {
    console.error(`${name}: no existe websites/*/${name}/metadata.json en ${repo}; se omite`)
    return null
  }
  const dir = join(repo, 'websites', letter, name)
  return { name, dir, dist: join(dir, 'dist'), built: join(dir, 'dist', 'presence.js') }
}

// Una actividad que falta (p. ej. submódulo desactualizado) no impide servir las demás.
const activities = names.map(locate).filter(Boolean)

//Build

/**
 * Whether a file of an activity folder is a build source (not dist/ nor the
 * tsconfig.json that pmd generates).
 * @param {string} file File name.
 * @returns {boolean} True for .ts/.json sources.
 */
const isSource = file => ['.ts', '.json'].includes(extname(file)) && file !== 'tsconfig.json'

/**
 * Whether dist/ is missing or older than any source file.
 * @param {{ dir: string, built: string }} activity Activity paths.
 * @returns {boolean} True when a rebuild is needed.
 */
function isStale({ dir, built }) {
  if (!existsSync(built))
    return true
  const builtAt = statSync(built).mtimeMs
  return readdirSync(dir).filter(isSource).some(file => statSync(join(dir, file)).mtimeMs > builtAt)
}

/**
 * Compiles an activity with `pmd build` (type check + esbuild, same output as `pmd dev`).
 * @param {{ name: string }} activity Activity to build.
 * @returns {Promise<boolean>} Whether it compiled.
 */
async function build({ name }) {
  console.log(`Compilando ${name} (pmd build)...`)
  try {
    await runFile(pmd, ['build', name], { cwd: repo, maxBuffer: 16 * 1024 * 1024 })
    console.log(`${name} compilada`)
    return true
  }
  catch (error) {
    console.error(`pmd build ${name} falló; se sigue enviando la última versión buena:\n${error.stdout ?? ''}${error.stderr ?? error.message}`)
    return false
  }
}

/** Prepend the devStrings shim to presence.js (PREMID_STRINGS_SHIM=0 disables it). */
const STRINGS_SHIM = process.env.PREMID_STRINGS_SHIM !== '0'

/**
 * Shim run before the activity: wraps `Presence#getStrings` so keys that come back unresolved
 * (PreMiD <=2.11 returns the key itself for strings that only exist in <Service>.json) get the
 * message from that file. On >=2.14 those keys already arrive translated, so it changes nothing.
 * @param {Record<string, { message: string }>} strings Contents of <Service>.json.
 * @returns {string} JavaScript to prepend to presence.js.
 */
function stringsShim(strings) {
  const messages = Object.fromEntries(Object.entries(strings).map(([key, { message }]) => [key, message]))
  return `/* premid-serve: devStrings shim for PreMiD <=2.11 */;(() => {
  if (typeof Presence !== 'function' || typeof Presence.prototype.getStrings !== 'function') return
  const messages = ${JSON.stringify(messages)}
  const getStrings = Presence.prototype.getStrings
  Presence.prototype.getStrings = async function (keys, ...rest) {
    const result = (await getStrings.call(this, keys, ...rest)) ?? {}
    for (const [name, key] of Object.entries(keys ?? {})) {
      const value = result[name]
      if (key in messages && (value === undefined || value === key || String(value).endsWith(':' + key)))
        result[name] = messages[key]
    }
    return result
  }
})();
`
}

/**
 * Same `localPresence` message as `pmd dev`: every .js/.json in dist/, JSON already parsed,
 * plus the devStrings shim in presence.js when the activity has a <Service>.json.
 * @param {{ dist: string }} activity Activity paths.
 * @returns {string} Serialized message.
 */
function buildMessage({ dist }) {
  const files = readdirSync(dist)
    .filter(file => ['.json', '.js'].includes(extname(file)))
    .map((file) => {
      const text = readFileSync(join(dist, file), 'utf8')
      return { file, contents: extname(file) === '.json' ? JSON.parse(text || '{}') : text }
    })
  const service = files.find(({ file }) => file === 'metadata.json')?.contents?.service
  const strings = files.find(({ file }) => file === `${service}.json`)?.contents
  const presence = files.find(({ file }) => file === 'presence.js')
  if (STRINGS_SHIM && strings && presence)
    presence.contents = stringsShim(strings) + presence.contents
  return JSON.stringify({ type: 'localPresence', files })
}

for (const activity of activities) {
  if (isStale(activity))
    await build(activity)
  if (existsSync(activity.built))
    activity.message = buildMessage(activity)
  else
    console.error(`${activity.name}: no hay ninguna versión compilada que enviar`)
}
if (!activities.some(activity => activity.message))
  process.exit(1)

//Server

const server = new WebSocketServer({ port })
server.on('error', (error) => {
  console.error(`No se pudo abrir el puerto ${port}: ${error.message} (¿hay un \`pmd dev\` corriendo?)`)
  process.exit(1)
})
server.on('listening', () => console.log(`Esperando a la extensión en ws://localhost:${port} (${activities.map(activity => activity.name).join(', ')})`))
server.on('connection', async (socket) => {
  socket.on('error', () => {})
  console.log('Connected to the extension')
  for (const [index, activity] of activities.entries()) {
    if (index > 0)
      await wait(SEND_GAP_MS)
    if (socket.readyState !== 1 || !activity.message)
      continue
    socket.send(activity.message)
    console.log(`Activity sent to the extension: ${activity.name}`)
  }
})

//Watch

/**
 * Rebuilds an activity after a source change and resends it to every open connection.
 * Keeps the previous message if the build or the new dist/ fails.
 * @param {{ name: string, message?: string }} activity Changed activity.
 */
async function rebuild(activity) {
  try {
    if (!isStale(activity) || !(await build(activity)))
      return
    activity.message = buildMessage(activity)
    const open = [...server.clients].filter(client => client.readyState === 1)
    open.forEach(client => client.send(activity.message))
    console.log(`Activity sent to the extension: ${activity.name} (${open.length} conexión/es)`)
  }
  catch (error) {
    console.error(`No se pudo recargar ${activity.name}: ${error.message}`)
  }
}

// Builds en cola y con debounce por actividad: guardar varias veces seguidas compila una sola vez.
let queue = Promise.resolve()
for (const activity of activities) {
  let debounce
  watch(activity.dir, (_event, file) => {
    if (!file || !isSource(file))
      return
    clearTimeout(debounce)
    debounce = setTimeout(() => {
      queue = queue.then(() => rebuild(activity))
    }, 500)
  })
}
