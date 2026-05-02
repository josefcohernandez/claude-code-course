# Referencia CLI — Slash Commands

> Documentación exhaustiva de todos los slash commands disponibles en el modo interactivo de Claude Code.

Índice: [referencia-cli-indice.md](./referencia-cli-indice.md)

---

## Cómo funcionan los slash commands

Los slash commands se invocan escribiendo `/` seguido del nombre del comando en el prompt interactivo. Al escribir `/` aparece un menú con todos los comandos disponibles y las skills del proyecto. Puedes filtrar escribiendo letras adicionales.

```
/                      → abre el menú de comandos
/cl                    → filtra y muestra /clear, /color, /compact, /copy, /cost, /context...
/clear                 → ejecuta el comando directamente
```

**Nota:** No todos los comandos son visibles para todos los usuarios. Algunos dependen de la plataforma, el plan, o el entorno. Por ejemplo, `/desktop` solo aparece en macOS y Windows, `/upgrade` solo en planes Pro y Max, y `/terminal-setup` se oculta cuando el terminal ya soporta sus keybindings de forma nativa.

---

## Referencia completa de comandos integrados

### Gestión de sesión y contexto

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/clear` | `/clear` | Limpia el historial de conversación y libera el contexto. **El hábito más importante para controlar costes** | Alias: `/reset`, `/new` |
| `/compact` | `/compact [instrucciones]` | Compacta la conversación con instrucciones de foco opcionales. Claude resume el contexto anterior preservando lo indicado | Sin instrucciones compacta con criterio propio; con instrucciones preserva lo especificado |
| `/recap` | `/recap` | Muestra un resumen del estado de la conversación actual. Útil al retomar sesiones después de una pausa. Claude también genera este resumen automáticamente al detectar inactividad prolongada. Configurable en `/config`. Relacionado con `CLAUDE_CODE_ENABLE_AWAY_SUMMARY` | v2.1.108 |
| `/resume` | `/resume [sesión]` | Reanuda una conversación por ID o nombre, o abre el selector de sesiones. El picker muestra por defecto las sesiones del directorio actual; `Ctrl+A` para mostrar todas. Ofrece resumir sesiones muy grandes antes de releerlas | Alias: `/continue`. Mejorado en v2.1.108 y v2.1.117 |
| `/undo` | `/undo` | Deshace el último turno de conversación | Alias de `/rewind`. v2.1.108 |
| `/rename` | `/rename [nombre]` | Renombra la sesión actual y muestra el nombre en la barra del prompt. Sin nombre, auto-genera uno a partir del historial | El nombre aparece en `/resume` y en el título del terminal |
| `/rewind` | `/rewind` | Retrocede la conversación y/o el código a un punto anterior, o resume desde un mensaje seleccionado | Alias: `/checkpoint`. Ver [checkpointing](https://code.claude.com/docs/en/checkpointing) |
| `/branch` | `/branch [nombre]` | Crea una rama de la conversación actual en este punto | Alias: `/fork` |
| `/export` | `/export [nombre-fichero]` | Exporta la conversación actual como texto plano. Con nombre, escribe al fichero. Sin nombre, ofrece copiar al portapapeles o guardar | — |

### Modelos y rendimiento

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/model` | `/model [modelo]` | Selecciona o cambia el modelo de IA. Con flechas izquierda/derecha, ajusta el nivel de esfuerzo para modelos que lo soportan. El cambio es inmediato | — |
| `/effort` | `/effort [low\|medium\|high\|xhigh\|max]` | Establece el nivel de esfuerzo del modelo. `low`, `medium`, `high` persisten entre sesiones. `max` solo para la sesión actual (requiere Opus 4.6). Nuevo nivel `xhigh` disponible para Opus 4.7. Sin argumento abre un selector interactivo | Mejorado en v2.1.111 |
| `/fast` | `/fast [on\|off]` | Activa o desactiva el modo rápido | — |
| `/focus` | `/focus` | Alterna la vista de enfoque (focus view) que muestra solo el output relevante. Antes de v2.1.110, esta función era `Ctrl+O` | v2.1.110 |
| `/tui fullscreen` | `/tui fullscreen` | Activa el modo fullscreen sin parpadeo. El modo fullscreen renderiza en la misma área de pantalla sin limpiar el terminal. Equivalente a la variable de entorno `CLAUDE_CODE_NO_FLICKER=1` | v2.1.110 |
| `/powerup` | `/powerup` | Lecciones interactivas con demos animadas de features de Claude Code. Ideal para descubrir funcionalidades (v2.1.90) | — |
| `/loop` | `/loop [intervalo] <prompt>` | Skill que ejecuta un prompt repetidamente en un intervalo (ej: `/loop 5m comprueba si el deploy ha terminado`). El intervalo por defecto es 10 minutos | Alias: `/proactive` (v2.1.105). Es una skill bundled, no un comando built-in |

### Configuración e información

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/config` | `/config` | Abre la interfaz de Settings para ajustar tema, modelo, estilo de output, duración de turno y otras preferencias. Incluye toggle "Show turn duration" para mostrar cuánto tarda cada respuesta (v2.1.79+) | Alias: `/settings` |
| `/status` | `/status` | Abre la interfaz de Settings (pestaña Status) mostrando versión, modelo, cuenta y conectividad | — |
| `/context` | `/context` | Visualiza el uso actual del contexto como una cuadrícula de colores. Muestra sugerencias de optimización | — |
| `/cost` | `/cost` | Muestra estadísticas de uso de tokens con desglose por modelo y cache-hit para usuarios de subscription (v2.1.92). Ver [guía de seguimiento de costes](https://code.claude.com/docs/en/costs). A partir de v2.1.118, `/usage` es el comando principal que unifica `/cost` y `/stats` | Shortcut de `/usage` desde v2.1.118 |
| `/usage` | `/usage` | Desde v2.1.118, unifica `/cost` y `/stats` en un solo comando: muestra el uso total de tokens, coste de la sesión actual y límites del plan. En versiones anteriores mostraba solo los límites del plan y el estado de los rate limits | Mejorado en v2.1.118 |
| `/stats` | `/stats` | Visualiza el uso diario, historial de sesiones, rachas y preferencias de modelos. A partir de v2.1.118, `/usage` es el comando principal que los unifica | Shortcut de `/usage` desde v2.1.118 |
| `/insights` | `/insights` | Genera un informe analizando tus sesiones de Claude Code: áreas del proyecto, patrones, puntos de fricción | — |

### Memoria y CLAUDE.md

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/memory` | `/memory` | Edita los ficheros de memoria `CLAUDE.md`, activa/desactiva auto-memory, y ver entradas de auto-memory | — |
| `/init` | `/init` | Inicializa el proyecto con una guía `CLAUDE.md`. Con `CLAUDE_CODE_NEW_INIT=true` arranca un flujo interactivo que también configura skills, hooks y ficheros de memoria personal | — |

### Herramientas, permisos y hooks

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/permissions` | `/permissions` | Ver o actualizar permisos. Muestra las herramientas permitidas y denegadas | Alias: `/allowed-tools` |
| `/hooks` | `/hooks` | Ver configuraciones de hooks para eventos de herramientas | — |
| `/less-permission-prompts` | `/less-permission-prompts` | Skill integrada que escanea los transcripts recientes y propone una allowlist de comandos para añadir a `.claude/settings.json`, reduciendo los prompts de permisos futuros | v2.1.111. Es una skill bundled, no un comando built-in |

### MCP (Model Context Protocol)

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/mcp` | `/mcp` | Gestióna conexiones de servidores MCP y autenticación OAuth | — |

### Agentes y skills

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/agents` | `/agents` | Gestióna configuraciones de agentes | — |
| `/skills` | `/skills` | Lista las skills disponibles | — |
| `/plugin` | `/plugin` | Gestióna plugins de Claude Code | — |
| `/reload-plugins` | `/reload-plugins` | Recarga todos los plugins activos para aplicar cambios pendientes sin reiniciar. Reporta conteos y errores de carga | — |

### Edición y visualización

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/copy` | `/copy [N]` | Copia la última respuesta del asistente al portapapeles. Con número N, copia la N-esima respuesta más reciente. Muestra selector interactivo si hay bloques de código | — |
| `/diff` | `/diff` | Abre un visor de diff interactivo mostrando cambios sin commit y diffs por turno. Usa flechas izquierda/derecha para cambiar entre el diff de git y los turnos individuales | — |

### Preguntas laterales

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/btw` | `/btw <pregunta>` | Hace una pregunta rápida sin añadir al historial de conversación. La respuesta aparece en un overlay descartable | Funciona incluso mientras Claude está procesando. Sin acceso a herramientas |

### Modo Plan

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/plan` | `/plan` | Entra en modo plan directamente desde el prompt | Equivalente a `Shift+Tab` hasta llegar a Plan mode |
| `/ultraplan` | `/ultraplan [prompt]` | Inicia una sesión de planificación extendida con razonamiento profundo. Desde v2.1.101, auto-crea un entorno cloud por defecto sin necesidad de `--remote` | Combina effort max con sesión remota |

### Integraciónes

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/ide` | `/ide` | Gestióna integraciónes con IDEs y muestra el estado | — |
| `/chrome` | `/chrome` | Configura los ajustes de Claude en Chrome | — |
| `/install-github-app` | `/install-github-app` | Configura la GitHub App de Claude para un repositorio | Guia paso a paso para seleccionar repo y configurar la integración |
| `/install-slack-app` | `/install-slack-app` | Instala la app de Claude en Slack. Abre el navegador para completar el flujo OAuth | — |
| `/remote-control` | `/remote-control` | Hace que esta sesión este disponible para control remoto desde claude.ai | Alias: `/rc` |
| `/desktop` | `/desktop` | Continua la sesión actual en la app de escritorio de Claude Code | Solo macOS y Windows. Alias: `/app` |
| `/mobile` | `/mobile` | Muestra código QR para descargar la app móvil de Claude | Alias: `/ios`, `/android` |
| `/voice` | `/voice` | Activa el modo push-to-talk para dictado por voz. Mantener la barra espaciadora para hablar, soltarla para enviar. Soporta 20 idiomás | Requiere cuenta Claude.ai. Configurable en `/config`. Ver [atajos de teclado](./referencia-cli-atajos-teclado.md) para el atajo Space |
| `/schedule` | `/schedule [descripción]` | Crea, actualiza, lista o ejecuta táreas programadas en la nube (Cloud scheduled tasks) | — |

### Sesiones remotas

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/remote-env` | `/remote-env` | Configura el entorno remoto por defecto para sesiones web iniciadas con `--remote` | — |

### Diagnostico

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/doctor` | `/doctor` | Diagnostica y verifica la instalación y configuración de Claude Code. Desde v2.1.105 muestra iconos de estado y ofrece la opción `f` para que Claude repare automáticamente los problemás detectados | Útil para resolver problemás de configuración |
| `/feedback` | `/feedback [report]` | Envia feedback sobre Claude Code | Alias: `/bug` |
| `/team-onboarding` | `/team-onboarding` | Genera automáticamente una guía de rampa para nuevos miembros del equipo basándose en el uso local de Claude Code (CLAUDE.md, settings, skills, hooks configurados) | v2.1.101. Útil para documentar la configuración del equipo |

### Apariencia

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/theme` | `/theme [nombre]` | Cambia el tema de color o crea temas con nombre personalizados. Los temas se guardan en `~/.claude/themes/` como JSON. Incluye variantes claras y oscuras, temas para daltonismo, temas ANSI, y el tema "Auto (match terminal)" que sincroniza con el modo oscuro/claro del sistema | Mejorado en v2.1.118 |
| `/color` | `/color [color\|default]` | Establece el color de acento de la barra del prompt para la sesión actual: `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan`. `default` para resetear. Cuando Remote Control está conectado, sincroniza el color de acento con claude.ai/code para identificar visualmente qué sesión es cuál | Mejorado en v2.1.118 |

### Editor

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/vim` | `/vim` | **[ELIMINADO en v2.1.92]** Alternaba entre modos Vim y Normal. Ahora se configura en `/config` → Editor mode | Deprecado: usar `/config` |

### Informacion del sistema

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/help` | `/help` | Muestra ayuda y comandos disponibles | — |
| `/keybindings` | `/keybindings` | Abre o crea el fichero de configuración de keybindings | — |
| `/terminal-setup` | `/terminal-setup` | Configura keybindings del terminal para Shift+Enter y otros atajos | Solo visible en terminales que lo necesitan |
| `/statusline` | `/statusline` | Configura la línea de estado de Claude Code. Sin argumentos, auto-configura desde el prompt del shell. Los scripts de statusline reciben el campo `rate_limits` con información sobre límites de uso actuales (v2.1.80+) | — |
| `/release-notes` | `/release-notes` | Abre un selector interactivo de versiones para navegar el changelog (v2.1.92). Antes mostraba el changelog completo | — |

### Autenticación

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/login` | `/login` | Inicia sesión en la cuenta de Anthropic | — |
| `/logout` | `/logout` | Cierra sesión de la cuenta de Anthropic | — |
| `/privacy-settings` | `/privacy-settings` | Ver y actualizar configuración de privacidad | Solo planes Pro y Max |
| `/upgrade` | `/upgrade` | Abre la pagina de upgrade para cambiar a un plan superior | Solo visible según el plan actual |

### Táreas en segundo plano

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/tasks` | `/tasks` | Lista y gestiona táreas en segundo plano | — |

### Directorios

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/add-dir` | `/add-dir <ruta>` | Añade un nuevo directorio de trabajo a la sesión actual | — |

### Otras opciones

| Comando | Sintaxis | Descripción | Notas |
|---------|----------|-------------|-------|
| `/sandbox` | `/sandbox` | Activa/desactiva el modo sandbox | Solo en plataformás compatibles |
| `/security-review` | `/security-review` | Analiza los cambios pendientes en el branch actual buscando vulnerabilidades. Revisa el git diff e identifica riesgos | — |
| `/ultrareview` | `/ultrareview [PR#]` | Lanza un análisis integral del código del repositorio actual usando agentes paralelos. Admite número de PR de GitHub para revisar un pull request específico. Genera un informe detallado de calidad del código | v2.1.111 |
| `/pr-comments` | `/pr-comments [PR]` | Obtiene y muestra comentarios de un pull request de GitHub. Detecta el PR del branch actual automáticamente | Requiere `gh` CLI |
| `/extra-usage` | `/extra-usage` | Configura uso extra para seguir trabajando cuando se alcancen los rate limits | — |
| `/passes` | `/passes` | Comparte una semana gratuita de Claude Code con amigos | Solo visible si la cuenta es elegible |
| `/stickers` | `/stickers` | Pedir stickers de Claude Code | — |
| `/exit` | `/exit` | Sale del CLI | Alias: `/quit` |

---

## Prompts de servidores MCP

Los servidores MCP pueden exponer prompts que aparecen como comandos. Usan el formato:

```
/mcp__<servidor>__<prompt>
```

Estos comandos se descubren dinámicamente desde los servidores conectados. Por ejemplo, si tienes un servidor MCP llamado `github` con un prompt `create-pr`:

```
/mcp__github__create-pr
```

---

## Skills invocables como slash commands

Además de los comandos integrados, las **skills** de tu proyecto (ubicadas en `.claude/skills/`) son invocables directamente con `/nombre-skill`. Aparecen junto a los comandos integrados en el menú `/`.

```
/nombre-skill [argumentos]
```

Las skills del usuario global (`~/.claude/skills/`) también estan disponibles en todos los proyectos.

### Skills incluidas por defecto

Claude Code incluye algunas skills de serie que aparecen en el menú `/`:

| Skill | Descripción |
|-------|-------------|
| `/simplify` | Simplifica el código seleccionado |
| `/batch` | Procesa múltiples elementos en lote |
| `/debug` | Inicia un flujo de depuración guiado |
| `/claude-api` | Carga material de referencia del Claude API/SDK para construir aplicaciones con la API de Anthropic |
| `/loop` | Ejecuta un prompt repetidamente en un intervalo (ej: `/loop 5m comprueba el deploy`) |
| `/less-permission-prompts` | Escanea transcripts recientes y propone una allowlist de comandos para reducir prompts de permisos futuros (v2.1.111) |
| `/ultrareview` | Análisis integral del repositorio o de un PR específico usando agentes paralelos. Admite `/ultrareview <PR#>` (v2.1.111) |

### Crear skills personalizadas

Para crear una skill invocable como slash command, crea un directorio en `.claude/skills/nombre-skill/` con un fichero `SKILL.md`. Ver [estructura-carpeta-claude.md](./estructura-carpeta-claude.md) para la documentacion completa.

---

## Comandos heredados (legacy)

Los ficheros en `.claude/commands/` siguen funcionando como slash commands pero se recomienda usar `skills/` para nuevos comandos. El comando `/review` fue eliminado y requiere instalar el plugin `code-review`:

```
claude plugin install code-review@claude-code-marketplace
```

---

## Ver también

- [Atajos de teclado](./referencia-cli-atajos-teclado.md) — Atajos para usar junto a los slash commands
- [estructura-carpeta-claude.md](./estructura-carpeta-claude.md) — Cómo crear skills y agentes personalizados
- [Modos de ejecución](./referencia-cli-modos-ejecucion.md) — Los slash commands solo estan disponibles en modo interactivo
