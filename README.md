# Curso de Desarrollo Asistido con Claude Code

> **De principiante a experto en desarrollo con IA agéntica**

## Acerca de este curso

Este curso enseña a equipos de desarrollo a usar **Claude Code** de forma profesional y eficiente. Cubre desde los conceptos básicos hasta técnicas avanzadas como Agent Teams, MCP, Hooks y automatización CI/CD.

El contenido está basado en la **documentación oficial de Anthropic** (code.claude.com/docs) y en buenas prácticas de equipos que ya utilizan Claude Code en producción.

### Público objetivo

- Desarrolladores backend, frontend y full stack
- Ingenieros DevOps y SRE
- Profesionales de QA y testing
- Tech leads y arquitectos de software
- Cualquier perfil técnico que quiera integrar IA en su flujo de trabajo

### Requisitos previos

- Experiencia básica en programación (cualquier lenguaje)
- Familiaridad con la terminal/línea de comandos
- Cuenta en Anthropic (`claude.ai`) o acceso vía API, Bedrock o Vertex
- Node.js 18+ instalado (para Claude Code CLI)

---

## Estructura del curso

El curso está organizado en **4 bloques progresivos** con **16 módulos**:

### Bloque 1: Fundamentos (Módulos 01-04)

| Módulo | Título | Tiempo | Descripción |
|--------|--------|--------|-------------|
| [01](modulo-01-introduccion/README.md) | Introducción y Metodología | 1.5h | Qué es Claude Code, paradigma agéntico, plataformas y modelos |
| [02](modulo-02-cli-primeros-pasos/README.md) | CLI y Primeros Pasos | 2h | Comandos, modo interactivo, sesiones, primer bug fix y primera feature |
| [03](modulo-03-contexto-y-tokens/README.md) | Contexto y Tokens | 2h 15min | **El módulo más importante**: ventana de contexto, ahorro de tokens, estrategias de sesión, Compaction API |
| [04](modulo-04-memoria-claude-md/README.md) | Memoria y CLAUDE.md | 2h | Sistema de memoria, memoria estructurada con tipos, CLAUDE.md efectivo, reglas modulares |

### Bloque 2: Intermedio (Módulos 05-06)

| Módulo | Título | Tiempo | Descripción |
|--------|--------|--------|-------------|
| [05](modulo-05-configuracion-permisos/README.md) | Configuración y Permisos | 2h 05min | Jerarquía de settings, permisos, sandbox, keybindings, Auto Mode |
| [06](modulo-06-planificacion-opus/README.md) | Plan Mode, Opus 4.7 y Workflows | 2h 15min | Plan Mode, Fast Mode, razonamiento adaptativo, workflows eficientes |

### Bloque 3: Avanzado (Módulos 07-10)

| Módulo | Título | Tiempo | Descripción |
|--------|--------|--------|-------------|
| [07](modulo-07-mcp/README.md) | MCP (Model Context Protocol) | 2h 35min | Servidores MCP, configuración, Deferred Tools, Tool Search, MCP Elicitation |
| [08](modulo-08-hooks/README.md) | Hooks | 2h 05min | 26 eventos del ciclo de vida, hooks de agente, hooks de seguridad y autoformateo |
| [09](modulo-09-agentes-skills-teams/README.md) | Subagentes, Skills y Agent Teams | 3h | Subagentes, worktree isolation, SendMessage, skills, Agent Teams |
| [10](modulo-10-automatizacion-cicd/README.md) | Automatización y CI/CD | 2h 20min | Modo headless, GitHub Actions, cron nativo, tareas programadas |

### Bloque 4: Experto y Enterprise (Módulos 11-15)

| Módulo | Título | Tiempo | Descripción |
|--------|--------|--------|-------------|
| [11](modulo-11-enterprise-seguridad/README.md) | Enterprise y Seguridad | 1h 15min | Seguridad, políticas enterprise, managed-settings.d/, mejores prácticas |
| [12](modulo-12-metodologias-desarrollo-ia/README.md) | Metodologías de Desarrollo con IA | 2h | Spec-Driven Development, historias Gherkin, TDD con Claude, patrones avanzados |
| [13](modulo-13-multimodalidad-notebooks/README.md) | Multimodalidad y Notebooks | 1h 50min | Imágenes, PDFs, Jupyter notebooks, VDD, Voice y Computer Use |
| [14](modulo-14-agent-sdk/README.md) | Claude Agent SDK | 2h | Construir agentes autónomos programáticamente con Python/TypeScript |
| [15](modulo-15-plugins-marketplaces/README.md) | Plugins y Marketplaces | 1.5h | Empaquetar skills y hooks como plugins, marketplace público y privado, gestión enterprise |

### Proyecto Final (Módulo 16)

| Módulo | Título | Tiempo | Descripción |
|--------|--------|--------|-------------|
| [16](modulo-16-proyecto-final/enunciado/README.md) | Proyecto Final Integrador | 4-6h | Construir una herramienta CLI completa aplicando todo lo aprendido (M01-M15) |

**Tiempo total estimado: 33-35 horas**

---

## Ruta de aprendizaje

```
BLOQUE 1: FUNDAMENTOS
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│   M01    │───▶│   M02    │───▶│   M03    │───▶│   M04    │
│  Intro   │    │   CLI    │    │ Contexto │    │ Memoria  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                      │
                                                      ▼
BLOQUE 2: INTERMEDIO
┌──────────┐    ┌──────────┐
│   M05    │───▶│   M06    │
│  Config  │    │ Plan +   │
│ Permisos │    │  Opus    │
└──────────┘    └──────────┘
                      │
                      ▼
BLOQUE 3: AVANZADO
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│   M07    │───▶│   M08    │───▶│   M09    │───▶│   M10    │
│   MCP    │    │  Hooks   │    │ Agentes  │    │  CI/CD   │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                      │
                                                      ▼
BLOQUE 4: EXPERTO Y ENTERPRISE
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│   M11    │───▶│   M12    │───▶│   M13    │───▶│   M14    │
│Enterprise│    │ Metodo-  │    │ Multi-   │    │  Agent   │
│Seguridad │    │  logias  │    │  modal   │    │   SDK    │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                      │
                                                      ▼
                                                ┌──────────┐
                                                │   M15    │
                                                │ Plugins  │
                                                │Marketpl. │
                                                └──────────┘
                                                      │
                                                      ▼
                              ┌────────────────────────────────┐
                              │              M16               │
                              │       Proyecto Final           │
                              │          Integrador            │
                              └────────────────────────────────┘
```

---

## Cómo usar este curso

### Para formación guiada (recomendado)

1. Sigue los módulos en orden (1 → 15)
2. Lee la teoría de cada módulo con Claude Code abierto
3. Realiza los ejercicios prácticos al terminar cada módulo
4. No avances al siguiente módulo sin completar los ejercicios
5. El proyecto final (M16) integra todo lo aprendido

### Para consulta rápida

Cada módulo funciona como referencia independiente:

- **"¿Cómo gestiono el contexto?"** → [Módulo 03](modulo-03-contexto-y-tokens/README.md)
- **"¿Cómo configuro CLAUDE.md?"** → [Módulo 04](modulo-04-memoria-claude-md/README.md)
- **"¿Cómo uso Plan Mode?"** → [Módulo 06](modulo-06-planificacion-opus/README.md)
- **"¿Cómo conecto una base de datos?"** → [Módulo 07](modulo-07-mcp/README.md)
- **"¿Cómo automatizo con CI/CD?"** → [Módulo 10](modulo-10-automatizacion-cicd/README.md)
- **"¿Cómo aplico TDD/Gherkin con IA?"** → [Módulo 12](modulo-12-metodologias-desarrollo-ia/README.md)
- **"¿Cómo trabajo con imágenes y PDFs?"** → [Módulo 13](modulo-13-multimodalidad-notebooks/README.md)
- **"¿Cómo construyo agentes personalizados?"** → [Módulo 14](modulo-14-agent-sdk/README.md)
- **"¿Cómo empaqueto y distribuyo capacidades?"** → [Módulo 15](modulo-15-plugins-marketplaces/README.md)

### Para equipos

1. Comparte este repositorio con el equipo
2. Cada miembro sigue los módulos a su ritmo
3. Usa los módulos 01-06 como onboarding obligatorio
4. Los módulos 07-11 son opcionales según el rol
5. Los módulos 12-15 son muy recomendables antes del proyecto final
6. El proyecto final (M16) se puede hacer en parejas

---

## Estructura de carpetas

```
claude_tutorial/
├── README.md                          # Este archivo (índice del curso)
├── CURSO_CLAUDE_CODE.md               # Temario completo (resumen)
│
├── modulo-01-introduccion/            # Qué es Claude Code, metodología
│   ├── teoria/
│   ├── ejercicios/
│   └── ejemplos/
│
├── modulo-02-cli-primeros-pasos/      # Comandos, modo interactivo, sesiones
│   ├── teoria/
│   ├── ejercicios/
│   ├── ejemplos/
│   └── cheatsheets/
│
├── modulo-03-contexto-y-tokens/       # Ventana de contexto, ahorro de tokens
│   ├── teoria/
│   ├── ejercicios/
│   └── ejemplos/
│
├── modulo-04-memoria-claude-md/       # CLAUDE.md, reglas modulares
│   ├── teoria/
│   ├── ejercicios/
│   ├── ejemplos/
│   └── plantillas/
│
├── modulo-05-configuracion-permisos/  # Settings, permisos, sandbox
│   ├── teoria/
│   ├── ejercicios/
│   └── plantillas/
│
├── modulo-06-planificacion-opus/      # Plan Mode, Opus 4.7, workflows
│   ├── teoria/
│   ├── ejercicios/
│   └── proyecto-practico/
│
├── modulo-07-mcp/                     # Model Context Protocol
│   ├── teoria/
│   ├── ejercicios/
│   └── servidores-ejemplo/
│
├── modulo-08-hooks/                   # Hooks del ciclo de vida
│   ├── teoria/
│   ├── ejercicios/
│   └── scripts/
│
├── modulo-09-agentes-skills-teams/    # Subagentes, skills, Agent Teams
│   ├── teoria/
│   ├── ejercicios/
│   ├── agentes/
│   └── skills/
│
├── modulo-10-automatizacion-cicd/     # Automatización, GitHub Actions
│   ├── teoria/
│   ├── ejercicios/
│   └── workflows/
│
├── modulo-11-enterprise-seguridad/    # Seguridad, enterprise, equipo
│   ├── teoria/
│   ├── ejercicios/
│   └── plantillas/
│
├── modulo-12-metodologias-desarrollo-ia/  # SDD, Gherkin, TDD con IA
│   ├── teoria/
│   ├── ejercicios/
│   └── plantillas/
│
├── modulo-13-multimodalidad-notebooks/ # Imágenes, PDFs, Jupyter, VDD
│   ├── teoria/
│   ├── ejercicios/
│   └── ejemplos/
│
├── modulo-14-agent-sdk/               # Claude Agent SDK (Python/TypeScript)
│   ├── teoria/
│   ├── ejercicios/
│   └── ejemplos/
│
├── modulo-15-plugins-marketplaces/    # Plugins, marketplaces y gestión enterprise
│   ├── teoria/
│   └── ejercicios/
│
├── modulo-16-proyecto-final/          # Proyecto integrador (M01-M15)
│   ├── enunciado/
│   ├── solucion-referencia/
│   └── criterios-evaluacion/
│
└── recursos/                          # Material complementario
    ├── imagenes/
    ├── cheatsheets/                   # Referencia rápida + referencia CLI exhaustiva
    │   ├── cheatsheet-general.md      # Resumen rápido para el día a día
    │   ├── referencia-cli-indice.md   # Índice del anexo de referencia CLI
    │   ├── referencia-cli-*.md        # 6 ficheros: modos, flags, commands, atajos, env vars, output
    │   └── ...
    └── plantillas-proyecto/           # Plantillas listas para copiar (CLAUDE.md, settings, rules, etc.)
```

---

## Recursos oficiales

- [Documentación oficial de Claude Code](https://code.claude.com/docs)
- [Repositorio GitHub de Claude Code](https://github.com/anthropics/claude-code)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io)
- [Claude Code GitHub Action](https://github.com/anthropics/claude-code-action)
- [Anthropic API Documentation](https://docs.anthropic.com)

---

## Versiones

| Versión | Fecha | Base Claude Code | Cambios principales |
|---------|-------|------------------|---------------------|
| 0.1 | Febrero 2026 | Claude Code 2.x | Versión inicial (M01-M12, Proyecto Final como M13) |
| 0.2 | Marzo 2026 | Claude Code 2.1.x | +M13 Multimodalidad, +M14 Agent SDK. Actualizados M04-M10 |
| 0.3 | Marzo 2026 | Claude Code 2.1.x | +M15 Plugins/Marketplaces. Proyecto final movido a M16 |
| 1.0 | Marzo 2026 | Claude Code 2.1.70+ | Revisión, corrección de errores, licencia, referencia CLI exhaustiva |
| 3.0 | 25 marzo 2026 | Claude Code 2.1.83 | Auto Mode, MCP Elicitation, Computer Use, Compaction API, 9 nuevos hooks, managed-settings.d/, 128K output tokens |
| 3.1 | 26 marzo 2026 | Claude Code 2.1.84 | PowerShell tool, TaskCreated hook, paths: en skills, MCP 2KB cap |
| 3.2 | 27 marzo 2026 | Claude Code 2.1.85 | Conditional hooks con campo `if`, PreToolUse headless, MCP OAuth RFC 9728, OTEL env vars |
| 3.3 | 28 marzo 2026 | Claude Code 2.1.86 | Header X-Claude-Code-Session-Id, skill descriptions 250 chars, 18 correcciones verificadas |
| 3.4 | 29 marzo 2026 | Claude Code 2.1.87 | Consolidación deuda técnica: `allowRead` sandbox, `${CLAUDE_PLUGIN_DATA}`, `effort` frontmatter |
| 3.5 | 7 abril 2026 | Claude Code 2.1.92 | Hook PermissionDenied, defer en PreToolUse, MCP maxResultSizeChars, /powerup, forceRemoteSettingsRefresh, plugin bin/, 2 deprecaciones |
| 3.7 | 24 abril 2026 | Claude Code 2.1.118 | /recap, /tui fullscreen, /focus separado, temas personalizados, xhigh effort, push notifications, auto mode sin flag, /less-permission-prompts, hooks mcp_tool, Skill tool→slash commands, ENABLE_PROMPT_CACHING_1H, plugin tag, /ultrareview, 6 env vars nuevas |
| 3.6 | 14 abril 2026 | Claude Code 2.1.107 | Effort default high, wizard Vertex AI, Monitor tool, /team-onboarding, OS CA trust, monitors en plugins, PreCompact blocking, 8 env vars nuevas |

### Novedades v3.7 (24 abril 2026)

**Features cubiertas (v2.1.108-v2.1.118):** `/recap` + session recap configurable (M02), `/tui fullscreen` + `autoScrollEnabled` (M02), `/focus` separado + cambio `Ctrl+O` (M02), temas personalizados `/theme` + tema "Auto" (M02), push notifications con Remote Control (M06), nivel `xhigh` para Opus 4.7 (M06), `/effort` slider interactivo (M06), effort default `high` para Pro/Max (M06), Auto Mode sin `--enable-auto-mode` para Max+Opus4.7 (M05), `/less-permission-prompts` skill (M05), `sandbox.network.deniedDomains` (M05), bash read-only globs sin prompt (M05), `"$defaults"` en reglas autoMode (M05), hooks `type: "mcp_tool"` (M08), agent frontmatter `hooks:` en modo principal (M08/M09), modelo invoca slash commands via Skill tool (M09), `mcpServers` en frontmatter agente principal (M09), `CLAUDE_CODE_FORK_SUBAGENT` (M09), `ENABLE_PROMPT_CACHING_1H` + `FORCE_PROMPT_CACHING_5M` + deprecación `ENABLE_PROMPT_CACHING_1H_BEDROCK` (M03), `wslInheritsWindowsSettings` (M11), `blockedMarketplaces`/`strictKnownMarketplaces` enforcement (M11), OTEL `command_name`/`effort` (M11), `claude plugin tag` (M15)

**Nuevas env vars:** `ENABLE_PROMPT_CACHING_1H`, `FORCE_PROMPT_CACHING_5M`, `CLAUDE_CODE_ENABLE_AWAY_SUMMARY`, `CLAUDE_CODE_FORK_SUBAGENT`, `OTEL_LOG_RAW_API_BODIES`, `DISABLE_UPDATES`, `CLAUDE_CODE_USE_POWERSHELL_TOOL`

**Nuevos slash commands:** `/recap`, `/tui`, `/focus`, `/undo`, `/ultrareview`, `/less-permission-prompts`, `/usage`, `/color`

**Vim:** visual mode `v` y visual-line mode `V`

### Novedades v3.6 (14 abril 2026)

**Features cubiertas (v2.1.94-v2.1.107):** Effort default cambiado a `high` (M06), wizard interactivo Vertex AI (M11), Monitor tool para streaming de eventos (M10), `/team-onboarding` (M11), OS CA certificate trust (M11), `monitors` en plugins (M15), PreCompact blocking (M08), `hookSpecificOutput.sessionTitle` (M08), skill descriptions 1.536 chars (M09), `EnterWorktree` con `path` (M09), `/proactive` alias de `/loop` (M10), `/ultraplan` auto-cloud (M06)

**Nuevas env vars/flags:** `CLAUDE_CODE_USE_MANTLE`, `CLAUDE_CODE_PERFORCE_MODE`, `CLAUDE_CODE_SCRIPT_CAPS`, `CLAUDE_CODE_CERT_STORE`, `TRACEPARENT`, `OTEL_LOG_USER_PROMPTS`, `OTEL_LOG_TOOL_DETAILS`, `OTEL_LOG_TOOL_CONTENT`, `--exclude-dynamic-system-prompt-sections`

**Nuevos slash commands:** `/team-onboarding`, `/proactive`, `/ultraplan`

### Novedades v3.5 (7 abril 2026)

**Features cubiertas (v2.1.89-v2.1.92):** Hook `PermissionDenied` y decisión `"defer"` en `PreToolUse` (M08), Auto Mode `/permissions` → Recent + retry (M05), MCP `maxResultSizeChars` override 500K (M07), `disableSkillShellExecution` (M09/M15), plugins con `bin/` ejecutables (M15), `forceRemoteSettingsRefresh` fail-closed (M11), asistente Bedrock interactivo (M11), `/powerup` lecciones interactivas (M02)

**Deprecaciones:** `/tag` eliminado, `/vim` movido a `/config` → Editor mode

**Nuevas env vars/flags:** `CLAUDE_CODE_NO_FLICKER`, `MCP_CONNECTION_NONBLOCKING`, `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE`, `--remote-control-session-name-prefix`

### Novedades v3.0 (25 marzo 2026)

**Nuevos ficheros de teoría:** Auto Mode (M05), Compaction API (M03), MCP Elicitation (M07), managed-settings.d/ (M11), Voice y Computer Use (M13)

**Features cubiertas:** Remote Control, adaptive thinking, Fast Mode 2.5x, `--bare` flag, data residency, `initialPrompt` en agentes, `[Image #N]` chips, títulos de sesión IA, `sandbox.failIfUnavailable`, dynamic filtering, code execution gratuita

**Deprecaciones:** `thinking: {type: "enabled"}` y `budget_tokens`, `--output-format`, prefill en Opus 4.6, `TaskOutput`, `task.resume`

---

## Licencia

[![CC BY-NC-SA 4.0](https://img.shields.io/badge/Licencia-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

Este curso está licenciado bajo [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/).

Puedes compartir y adaptar este material siempre que:
- **Atribución** — Des crédito al autor original
- **No Comercial** — No lo uses con fines comerciales
- **Compartir Igual** — Las adaptaciones deben usar la misma licencia

Basado en la documentación pública de [Anthropic](https://docs.anthropic.com). Consulta el fichero [LICENSE](LICENSE) para el texto legal completo.

---

> **Consejo**: Empieza por el [Módulo 01](modulo-01-introduccion/README.md) y avanza paso a paso. La gestión de contexto (Módulo 03) es lo que más impactará tu productividad diaria. El proyecto final (Módulo 16) integra todo lo aprendido.
