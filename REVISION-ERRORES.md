# Revisión de Errores y Alucinaciones

Revisión exhaustiva del contenido del curso. Se clasifican los hallazgos por severidad.

---

## ERRORES CRÍTICOS (contenido incorrecto o inventado)

### 1. Nombres de modelo inconsistentes en todo el curso

El curso mezcla versiones de modelos de forma contradictoria:

| Archivo | Dice | Debería decir |
|---------|------|---------------|
| `modulo-01/.../01-que-es-claude-code.md:206` | "Sonnet 4.5" con ID `claude-sonnet-4-5-20241022` | Sonnet 4.6 (`claude-sonnet-4-6`) |
| `modulo-03/.../01-la-ventana-de-contexto.md:240-242` | "Claude Sonnet 4" y "Claude Haiku 3.5" | Sonnet 4.6 y Haiku 4.5 |
| `modulo-03/.../04-prompt-caching-y-optimizacion-de-costes.md:41` | "Claude Opus 4.5" | Opus 4.6 |
| `modulo-06` | Opus 4.6 correctamente | (correcto) |

**Acción:** Unificar todas las referencias a Opus 4.6, Sonnet 4.6 y Haiku 4.5 con sus identificadores reales: `claude-opus-4-6`, `claude-sonnet-4-6`, `claude-haiku-4-5-20251001`.

### 2. Flags CLI inventados

`modulo-02-cli-primeros-pasos/teoria/01-comandos-cli.md:396-404`

| Flag | Estado |
|------|--------|
| `--chrome` | **NO EXISTE.** No hay integración con Chrome mediante flag de CLI. |
| `--agents` | **NO EXISTE** como flag de CLI. Los subagentes se gestionan internamente. |
| `--tools` | **NO EXISTE** como flag de CLI. |
| `--teleport` | **NO EXISTE.** |

Los flags reales en esa sección (`--mcp-config`, `--add-dir`, `--remote`) sí existen.

### 3. Comando `claude sessions list` inventado

`modulo-02-cli-primeros-pasos/teoria/03-sesiones-y-continuidad.md:51`

El comando `claude sessions list` no existe. Para reanudar sesiones se usa `claude --resume` o `claude -r`.

### 4. Comando `/context` inventado

`modulo-03-contexto-y-tokens/teoria/01-la-ventana-de-contexto.md:200`

El slash command `/context` no existe. Para ver uso de tokens se usa `/cost` o la barra de estado.

### 5. Sintaxis incorrecta de `/model`

`modulo-01-introduccion/teoria/01-que-es-claude-code.md:233`

```
/model opus 4.6    # ← INCORRECTO
/model opus        # ← CORRECTO
```

La sintaxis real es `/model opus`, `/model sonnet`, `/model haiku` (sin número de versión).

### 6. Módulo 15 completo: sistema de plugins INVENTADO

`modulo-15-plugins-marketplaces/` — **Todo el módulo describe un ecosistema que no existe.**

- No existe el comando `/plugin install`, `/plugin list`, `/plugin remove`
- No existe un fichero `plugin.json` como manifest de plugin
- No existe un marketplace de plugins de Claude Code
- La estructura de plugins descrita (carpeta con skills/, agents/, hooks/) es ficticia

**Acción:** Este módulo necesita ser reescrito o eliminado completamente.

### 7. URLs de MCP inventadas

| Archivo | URL falsa |
|---------|-----------|
| `modulo-13/.../04-visual-driven-development.md:119` | `https://mcp.figma.com/mcp` — No existe un MCP oficial de Figma en esta URL |
| `modulo-14/.../03-herramientas-y-patrones-avanzados.md:250` | `https://api.githubcopilot.com/mcp/` — No existe este endpoint MCP |

### 8. Comando `/install-github-app` inventado

`modulo-10-automatizacion-cicd/teoria/04-github-actions-avanzado.md:315`

Este comando no existe en Claude Code.

---

## ERRORES MEDIOS (información imprecisa o no verificable)

### 9. Tabla de precios desactualizada/inconsistente

`modulo-03/.../01-la-ventana-de-contexto.md:238-242` usa nombres de modelo incorrectos ("Claude Sonnet 4", "Claude Haiku 3.5"). Debería usar los mismos nombres que el resto del curso.

`modulo-03/.../04-prompt-caching-y-optimizacion-de-costes.md:39-43` tiene los precios correctos pero con nombre "Opus 4.5" en vez de 4.6.

### 10. Variable de entorno `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` probablemente inventada

`modulo-11-enterprise-seguridad/teoria/01-seguridad.md:33-42`

No hay documentación oficial de esta variable. Puede ser una fabricación.

### 11. Eventos de hooks exagerados

`modulo-08-hooks/teoria/04-hooks-agent-y-eventos-avanzados.md:70-75`

El curso lista muchos eventos avanzados. Los eventos principales documentados son: `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SessionStart`. Eventos como `TeammateIdle`, `TaskCompleted`, `ConfigChange`, `FileChanged`, `InstructionsLoaded`, `WorktreeCreate`, `WorktreeRemove`, `Elicitation` necesitan verificación — algunos pueden existir pero no están documentados públicamente.

### 12. Extended Thinking marcado como deprecated pero sigue referenciado

- `modulo-06/.../02-opus-razonamiento-adaptativo.md:29-33` dice que Extended Thinking está deprecated
- `modulo-02/.../cheatsheets/referencia-rapida.md:70` sigue listando `Alt+T` para toggle Extended Thinking

Inconsistencia interna.

### 13. Ejemplos de Agent SDK con tipos posiblemente incorrectos

`modulo-14/.../02-construir-agente-basico.md:73-79`

Los tipos `AssistantMessage` y `ResultMessage` en el import de Python necesitan verificación contra la API real del SDK. El nombre del paquete `claude-agent-sdk` es correcto, pero los nombres de clases específicos pueden diferir.

### 14. Claim sobre deprecación de npm para instalación

`modulo-01/.../03-instalacion-configuracion-inicial.md:64-66`

Afirma que "la instalación vía npm está oficialmente deprecada". Esto necesita verificación — npm sigue siendo un método de instalación válido.

---

## FALSOS POSITIVOS (features reales que parecen inventadas)

Para evitar confusión, estas features SÍ EXISTEN y no deben "corregirse":

| Feature | Estado real |
|---------|------------|
| Deferred Tools y ToolSearch | ✅ Real — sistema de carga diferida de herramientas |
| Subagent types (Explore, Plan, General-Purpose) | ✅ Real — tipos de agentes especializados |
| Agent Teams (experimental) | ✅ Real — feature experimental correctamente marcada |
| Managed Policies en `/etc/claude-code/settings.json` | ✅ Real — feature enterprise |
| `claude-code-action` GitHub Action | ✅ Real — acción oficial de Anthropic |
| Remote Control | ✅ Real — conexión remota a sesiones |
| Computer Use | ✅ Real — control de UI del SO |
| headersHelper para MCP | ✅ Real — helper de autenticación |
| SessionStart hook | ✅ Real — evento de ciclo de vida |
| Parámetro `model` en subagentes | ✅ Real |
| claude-agent-sdk (paquete) | ✅ Real |
| Hook field `if` para filtrado | ✅ Real — filtrado condicional de hooks |

---

## Resumen

| Severidad | Cantidad | Acción |
|-----------|----------|--------|
| Crítica | 8 issues | Corregir inmediatamente |
| Media | 6 issues | Verificar y corregir |
| Total | 14 issues reales | — |

Los errores más graves son:
1. **Módulo 15 completo inventado** (sistema de plugins/marketplace)
2. **4 flags de CLI inventados** (`--chrome`, `--agents`, `--tools`, `--teleport`)
3. **Inconsistencia de nombres de modelo** en todo el curso
4. **URLs de MCP fabricadas**
