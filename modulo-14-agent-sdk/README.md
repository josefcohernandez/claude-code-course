# Modulo 14: Claude Agent SDK

## Construir Agentes Personalizados Programaticamente

> **Tiempo estimado:** 2 horas
> **Nivel:** Experto (Bloque 4)
> **Prerequisitos:** Modulos 01-09 completados

---

## Objetivos de Aprendizaje

Al terminar este modulo seras capaz de:

- Distinguir el Agent SDK de otras formas de usar Claude (API directa, subagentes de Claude Code, CLI)
- Instalar y configurar el Agent SDK en Python y TypeScript
- Construir un agente basico con herramientas integradas y bucle agentico automatico
- Aplicar patrones avanzados: orquestacion de sub-agentes, pipelines y evaluadores
- Integrar servidores MCP como fuentes de datos y herramientas del agente
- Gestionar sesiones, hooks y permisos desde codigo
- Decidir cuando usar el Agent SDK frente a otras alternativas

---

## Prerequisitos

| Modulo | Por que es necesario |
|--------|----------------------|
| [M01](../modulo-01-introduccion/README.md) | Conceptos de agencia, bucle agentico |
| [M03](../modulo-03-contexto-y-tokens/README.md) | Gestion de contexto y tokens |
| [M05](../modulo-05-configuracion-permisos/README.md) | Sistema de permisos |
| [M07](../modulo-07-mcp/README.md) | Protocolo MCP, servidores y herramientas |
| [M08](../modulo-08-hooks/README.md) | Hooks del ciclo de vida |
| [M09](../modulo-09-agentes-skills-teams/README.md) | Subagentes, skills, orquestacion |

---

## Duracion Estimada

| Seccion | Tiempo |
|---------|--------|
| Teoria (4 ficheros) | 80 min |
| Ejercicios practicos | 40 min |
| **Total** | **2 horas** |

---

## Contenido

### Teoria

| Archivo | Tema | Duracion |
|---------|------|----------|
| [01-introduccion-agent-sdk.md](teoria/01-introduccion-agent-sdk.md) | Que es el Agent SDK, cuando usarlo y arquitectura | 20 min |
| [02-construir-agente-basico.md](teoria/02-construir-agente-basico.md) | Estructura minima, herramientas integradas, bucle agentico | 20 min |
| [03-herramientas-y-patrones-avanzados.md](teoria/03-herramientas-y-patrones-avanzados.md) | Patrones avanzados, MCP, sesiones, hooks y observabilidad | 25 min |
| [04-integracion-con-claude-code.md](teoria/04-integracion-con-claude-code.md) | Workflow Claude Code + Agent SDK, deploy, comparativa de frameworks | 15 min |

### Ejercicios Practicos

| Archivo | Tema | Duracion |
|---------|------|----------|
| [01-primer-agente.md](ejercicios/01-primer-agente.md) | Cinco ejercicios progresivos desde agente basico hasta CLI personalizado | 40 min |

---

## Conceptos Clave

| Concepto | Descripcion |
|----------|-------------|
| `query()` | Funcion principal del SDK; devuelve un iterador asincrono de mensajes |
| Bucle agentico | Claude decide que herramientas usar, las ejecuta y observa resultados automaticamente |
| `ClaudeAgentOptions` | Configuracion del agente: herramientas, permisos, system prompt, MCP, hooks |
| `allowed_tools` | Lista de herramientas pre-aprobadas que el agente puede usar sin pedir permiso |
| `permission_mode` | Nivel de supervision humana: `acceptEdits`, `bypassPermissions`, `default` |
| `AgentDefinition` | Definicion de un sub-agente especializado |
| `HookMatcher` | Asocia callbacks a eventos del ciclo de vida dentro del SDK |
| `resume` | Reanuda una sesion existente por su ID para mantener contexto entre ejecuciones |

---

## Flujo de Trabajo Recomendado

```
1. DISENAR el agente en Claude Code (Plan Mode)
        |
        v
2. PROTOTIPAR con subagentes de Claude Code (M09)
        |
        v
3. IMPLEMENTAR con Agent SDK (Python o TypeScript)
        |
        v
4. TESTEAR localmente con permission_mode="acceptEdits"
        |
        v
5. DESPLEGAR como servicio, CLI o GitHub Action
```

---

## Diferencias Clave con Subagentes de Claude Code

| Aspecto | Subagentes (M09) | Agent SDK |
|---------|-----------------|-----------|
| Entorno | Dentro de Claude Code CLI | Tu propia aplicacion |
| Control | Declarativo (YAML frontmatter) | Programatico (Python/TS) |
| Integracion | Con tu flujo de desarrollo | Con cualquier sistema |
| Despliegue | No aplica (es interactivo) | Servicio, CLI, CI/CD |
| Casos de uso | Automatizar tareas de desarrollo | Construir productos con agentes |

---

## Navegacion

| Anterior | Siguiente |
|----------|-----------|
| [Modulo 13: Multimodalidad y Notebooks](../modulo-13-multimodalidad-notebooks/README.md) | [Modulo 15: Plugins y Marketplaces](../modulo-15-plugins-marketplaces/README.md) |
