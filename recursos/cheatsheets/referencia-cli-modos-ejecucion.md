# Referencia CLI — Modos de ejecucion

> Documentacion exhaustiva de los modos en que se puede invocar Claude Code desde la linea de comandos.

Indice: [referencia-cli-indice.md](./referencia-cli-indice.md)

---

## Vision general

Claude Code soporta varios modos de ejecucion que determinan como interactuas con el modelo, como se gestiona la sesion, y como fluye la entrada y la salida.

| Modo | Comando base | Interactivo | Persistencia | Uso tipico |
|------|-------------|-------------|--------------|------------|
| Interactivo | `claude` | Si | Si | Desarrollo dia a dia |
| One-shot | `claude "query"` | Si (tras respuesta) | Si | Empezar con un contexto inicial |
| Headless / print | `claude -p "query"` | No | Configurable | Scripts, CI/CD, automatizacion |
| Pipe / stdin | `cat file \| claude -p "query"` | No | Configurable | Procesar contenido de ficheros |
| Remoto | `claude --remote "tarea"` | No (crea sesion web) | Si (en claude.ai) | Sesiones de larga duracion en la nube |
| Remote Control | `claude --remote-control` | Si | Si | Control desde claude.ai o app movil |
| Worktree | `claude -w nombre` | Si | Si | Trabajo paralelo en branches aislados |

---

## Modo interactivo

### Descripcion

Inicia una sesion REPL (Read-Eval-Print Loop) conversacional completa. Claude Code mantiene el estado de la sesion, gestiona el contexto acumulado, y ofrece todas las funcionalidades interactivas: slash commands, atajos de teclado, historial de prompts, autocompletado, etc.

### Sintaxis

```bash
claude
claude [flags]
```

### Cuando usarlo

- Desarrollo activo: explorar codigo, implementar features, hacer refactoring
- Tareas complejas que requieren multiples turnos de conversacion
- Cuando necesitas usar slash commands (`/clear`, `/compact`, `/model`, etc.)
- Cuando quieres revision y aprobacion de acciones antes de ejecutarlas

### Ejemplos

```bash
# Sesion interactiva basica
claude

# Sesion interactiva con modelo especifico
claude --model opus

# Sesion interactiva en modo Plan (solo planifica, no ejecuta)
claude --permission-mode plan

# Sesion interactiva con directorio adicional
claude --add-dir ../shared-lib

# Sesion interactiva con nombre para poder reanudar despues
claude --name "refactor-autenticacion"
```

### Compatibilidad con otros flags

Compatible con casi todos los flags de arranque. Los flags `--max-turns`, `--max-budget-usd`, `--output-format` y `--fallback-model` son exclusivos del modo print (`-p`).

---

## Modo one-shot (con query inicial)

### Descripcion

Inicia una sesion interactiva pero con un prompt inicial ya especificado. Claude procesa el prompt inmediatamente al arrancar y luego la sesion continua en modo interactivo. Es util cuando ya sabes exactamente cual es la primera instruccion que quieres dar.

### Sintaxis

```bash
claude "<query>"
claude "<query>" [flags]
```

### Cuando usarlo

- Cuando tienes una tarea clara y concreta con la que empezar
- Para combinar un contexto inicial con la posibilidad de hacer seguimiento
- Cuando quieres que Claude empiece a trabajar inmediatamente sin esperar input

### Ejemplos

```bash
# Iniciar con una pregunta
claude "explica la arquitectura de este proyecto"

# Iniciar con una tarea de implementacion
claude "implementa un endpoint REST para crear usuarios en src/api/users.ts"

# Iniciar en modo plan con una tarea
claude --permission-mode plan "refactoriza el modulo de autenticacion para usar JWT"

# Reanudar sesion con query inicial
claude --resume "refactor-autenticacion" "continua con los tests unitarios"
```

---

## Modo headless / print (`-p`)

### Descripcion

Ejecuta Claude de forma no interactiva: procesa el prompt, emite la respuesta, y termina. No hay sesion REPL, no hay interaccion con el usuario, no hay slash commands. La salida va directamente a stdout, lo que permite integrarlo en scripts, pipelines de CI/CD, y herramientas de automatizacion.

Este modo es equivalente al uso del Agent SDK y es la base para cualquier automatizacion con Claude Code.

### Sintaxis

```bash
claude -p "<query>"
claude --print "<query>"
claude -p "<query>" [flags exclusivos de print]
```

### Cuando usarlo

- Scripts de automatizacion y CI/CD
- Procesamiento en batch de multiples ficheros o queries
- Cuando necesitas capturar la salida de Claude en una variable o fichero
- Integraciones con otras herramientas
- Cuando necesitas output estructurado en JSON

### Ejemplos

```bash
# Query simple, salida en texto
claude -p "cuantos archivos .ts hay en src/"

# Con formato JSON
claude -p "analiza la estructura del proyecto" --output-format json

# Limitando turnos y presupuesto
claude -p "implementa tests para auth.ts" --max-turns 10 --max-budget-usd 2.00

# Guardando la salida en un fichero
claude -p "genera documentacion para la API" > docs/api.md

# En un script bash
RESUMEN=$(claude -p "resume los cambios de este commit: $(git log -1 --format='%s %b')")
echo "Resumen: $RESUMEN"

# Con modelo de fallback
claude -p "query compleja" --fallback-model sonnet

# Sin persistencia de sesion (mas rapido, sin guardar en disco)
claude -p --no-session-persistence "query rapida"
```

### Flags exclusivos del modo print

Estos flags solo funcionan con `-p` / `--print`:

| Flag | Descripcion |
|------|-------------|
| `--max-turns N` | Maximo de turnos antes de terminar |
| `--max-budget-usd N` | Tope de gasto en dolares |
| `--output-format` | Formato de salida: `text`, `json`, `stream-json` |
| `--fallback-model` | Modelo alternativo si el principal esta sobrecargado |
| `--no-session-persistence` | No guardar la sesion en disco |
| `--json-schema` | Validar output contra un JSON Schema |
| `--include-partial-messages` | Incluir eventos de streaming parciales |
| `--input-format` | Formato de entrada: `text`, `stream-json` |
| `--permission-prompt-tool` | Herramienta MCP para gestionar permisos |

---

## Modo pipe / stdin

### Descripcion

Claude Code lee contenido desde stdin cuando se usa en una pipeline de Unix. El contenido del stdin se incorpora al contexto del prompt. Este modo requiere `-p` para funcionar correctamente en scripts.

### Sintaxis

```bash
comando | claude -p "<query sobre el contenido>"
claude -p "<query>" < fichero.txt
```

### Cuando usarlo

- Analizar ficheros de log en tiempo real
- Procesar la salida de otros comandos (git diff, grep, etc.)
- Revisar codigo o configuracion antes de aplicar cambios
- Pipelines de transformacion de datos

### Ejemplos

```bash
# Analizar logs
cat logs/error.log | claude -p "identifica los errores mas frecuentes y sugiere soluciones"

# Revisar cambios staged antes de commit
git diff --staged | claude -p "revisa estos cambios y sugiere un mensaje de commit"

# Review de seguridad de un PR
gh pr diff 123 | claude -p "analiza este PR buscando vulnerabilidades de seguridad"

# Procesar la salida de un comando
npm audit | claude -p "resume las vulnerabilidades criticas y como resolverlas"

# Analizar un fichero de configuracion
cat .env.example | claude -p "explica cada variable de entorno"

# Combinar stdin con formato JSON
git log --oneline -20 | claude -p "categoriza estos commits por tipo de cambio" --output-format json

# Leer desde un fichero
claude -p "revisa este fichero de configuracion y sugiere mejoras" < docker-compose.yml
```

### Notas tecnicas

- El contenido de stdin se concatena antes del prompt cuando se usan pipes
- Claude Code detecta automaticamente si stdin es un terminal o un pipe
- Con stdin interactivo (terminal), el modo funciona normalmente
- Con stdin no-interactivo (pipe o fichero), se comporta como modo headless

---

## Modo remoto (`--remote`)

### Descripcion

Crea una nueva sesion en la infraestructura web de Anthropic (claude.ai) con la tarea especificada. En lugar de ejecutar localmente, la sesion corre en los servidores de Anthropic con acceso a recursos en la nube. La tarea se inicia en la web y puede ejecutarse en segundo plano.

### Sintaxis

```bash
claude --remote "<descripcion de la tarea>"
```

### Cuando usarlo

- Tareas de larga duracion que no quieres dejar corriendo en tu maquina local
- Cuando necesitas recursos de computo en la nube
- Para delegar trabajo mientras tu maquina local esta ocupada
- Tareas que pueden ejecutarse sin supervision

### Ejemplo

```bash
# Crear una sesion remota
claude --remote "analiza todo el codigo en busca de oportunidades de optimizacion y genera un informe"

# La sesion se inicia en claude.ai y puedes monitorearla desde el navegador
```

### Notas

- Requiere cuenta en claude.ai con plan compatible
- La sesion se puede reanudar localmente usando `--teleport`
- La sesion persiste en claude.ai aunque cierres el terminal local
- Configura el entorno remoto por defecto con `/remote-env`

---

## Modo Remote Control (`--remote-control`)

### Descripcion

Inicia una sesion interactiva local que ademas queda accesible para control desde claude.ai o la app movil de Claude. Permite supervisar y controlar la sesion desde otro dispositivo mientras Claude trabaja localmente con acceso completo al sistema de ficheros y herramientas.

### Sintaxis

```bash
claude --remote-control [nombre-sesion]
claude --rc [nombre-sesion]
```

### Cuando usarlo

- Supervisar el trabajo de Claude desde un movil o segundo dispositivo
- Colaboracion remota donde alguien controla Claude en tu maquina
- Monitorizar tareas largas sin estar frente al terminal

### Ejemplo

```bash
# Sesion con Remote Control habilitado
claude --remote-control "implementacion-auth"

# Sin nombre (se auto-genera)
claude --rc
```

---

## Modo teleport (`--teleport`)

### Descripcion

Reanuda una sesion remota que esta corriendo en claude.ai y la trae al terminal local. Permite continuar en el terminal una tarea que fue iniciada con `--remote` o que esta corriendo en la interfaz web.

### Sintaxis

```bash
claude --teleport
```

### Cuando usarlo

- Continuar localmente una sesion que iniciaste con `--remote`
- Traer al terminal una sesion que empezaste en claude.ai
- Cuando necesitas acceso a herramientas locales en una sesion remota

### Ejemplo

```bash
# Teleportar la sesion remota activa al terminal local
claude --teleport

# Se mostrara un selector si hay multiples sesiones activas
```

---

## Modo worktree (`-w`)

### Descripcion

Inicia Claude en un git worktree aislado dentro del repositorio actual. Crea un worktree en `.claude/worktrees/<nombre>` donde Claude puede trabajar sin afectar el worktree principal. Ideal para trabajar en multiples tareas en paralelo sobre el mismo repositorio.

### Sintaxis

```bash
claude -w [nombre]
claude --worktree [nombre]
```

### Cuando usarlo

- Implementar una feature sin afectar el branch principal
- Ejecutar multiples instancias de Claude en paralelo en el mismo repo
- Mantener el worktree principal limpio mientras Claude experimenta
- Flujos de trabajo con branches de vida corta

### Ejemplos

```bash
# Crear worktree con nombre descriptivo
claude -w feature-autenticacion

# Sin nombre (se auto-genera)
claude -w

# Listar worktrees activos
git worktree list
```

---

## Subcomandos de gestion

Ademas de los modos de sesion, Claude Code ofrece subcomandos para gestion:

| Subcomando | Descripcion |
|------------|-------------|
| `claude update` | Actualizar Claude Code a la ultima version |
| `claude auth login` | Iniciar sesion en la cuenta de Anthropic |
| `claude auth login --console` | Iniciar sesion con API key de Anthropic Console |
| `claude auth login --sso` | Iniciar sesion con SSO |
| `claude auth logout` | Cerrar sesion |
| `claude auth status` | Ver estado de autenticacion (JSON) |
| `claude auth status --text` | Ver estado de autenticacion (texto legible) |
| `claude agents` | Listar todos los subagentes configurados |
| `claude mcp` | Gestionar servidores MCP |
| `claude remote-control` | Iniciar servidor de Remote Control (sin sesion local) |

---

## Ver tambien

- [Flags de arranque](./referencia-cli-flags-arranque.md) — Todos los flags disponibles para cada modo
- [Formatos de salida](./referencia-cli-formatos-salida.md) — Como estructurar la salida del modo headless
- [Slash commands](./referencia-cli-slash-commands.md) — Comandos disponibles en el modo interactivo
