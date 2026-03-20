# Modulo 01: Introduccion a Claude Code

## Descripcion General

Este modulo presenta Claude Code como herramienta de desarrollo asistido por IA. A diferencia de los chatbots o autocompletadores de codigo tradicionales, Claude Code es un **agente autonomo** que trabaja directamente en tu terminal: lee tu codebase, ejecuta comandos, edita archivos y coordina cambios complejos en multiples archivos.

Al finalizar este modulo, cada miembro del equipo --ya sea backend, frontend, DevOps o QA-- tendra Claude Code instalado, configurado y habra completado su primera sesion interactiva con un proyecto real.

---

## Objetivos de Aprendizaje

Al completar este modulo seras capaz de:

1. **Explicar** que es Claude Code y en que se diferencia de otras herramientas de IA para desarrollo (Copilot, ChatGPT, Cursor, etc.)
2. **Describir** el paradigma de "delegacion" frente al paradigma de "dictado" al trabajar con un agente de codigo
3. **Identificar** las plataformas, modelos y herramientas internas de Claude Code
4. **Aplicar** la metodologia de desarrollo asistido: Explorar, Planificar, Implementar, Verificar
5. **Reconocer** anti-patrones comunes y saber como evitarlos
6. **Instalar y configurar** Claude Code en tu entorno de trabajo
7. **Realizar** tu primera sesion de exploracion de un codebase con Claude Code
8. **Redactar** prompts efectivos adaptados a distintos escenarios (bugs, features, refactoring, tests)

---

## Contenido del Modulo

### Teoria

| # | Archivo | Tema | Tiempo estimado |
|---|---------|------|-----------------|
| 1 | [01-que-es-claude-code.md](teoria/01-que-es-claude-code.md) | Que es Claude Code: herramienta agentica, plataformas, modelos, herramientas internas, el bucle agentico | 30 min |
| 2 | [02-metodologia-desarrollo-asistido.md](teoria/02-metodologia-desarrollo-asistido.md) | Metodologia de desarrollo asistido por IA: flujo de 4 fases, patrones, anti-patrones y principios clave | 30 min |
| 3 | [03-instalacion-configuracion-inicial.md](teoria/03-instalacion-configuracion-inicial.md) | Guia paso a paso de instalacion y configuracion en todas las plataformas | 15 min |

### Ejercicios Practicos

| # | Archivo | Tema | Tiempo estimado |
|---|---------|------|-----------------|
| 1 | [01-instalacion-y-primer-uso.md](ejercicios/01-instalacion-y-primer-uso.md) | Instalar Claude Code, autenticarse y realizar la primera sesion interactiva | 20 min |
| 2 | [02-exploracion-codebase.md](ejercicios/02-exploracion-codebase.md) | Explorar un codebase desconocido con preguntas progresivamente mas profundas | 20 min |

### Ejemplos de Referencia

| # | Archivo | Tema |
|---|---------|------|
| 1 | [prompts-efectivos.md](ejemplos/prompts-efectivos.md) | Coleccion de prompts efectivos organizados por categoria, con comparativas BAD vs GOOD |

---

## Tiempo Total Estimado

**2 horas** distribuidas de la siguiente manera:

- Teoria: ~1 hora 15 minutos
- Ejercicios practicos: ~40 minutos
- Consulta de ejemplos y referencia: ~5 minutos (consulta continua durante el modulo)

---

## Prerequisitos

- Acceso a una terminal (bash, zsh, PowerShell)
- Node.js >= 18 instalado (para metodo de instalacion via npm)
- Una cuenta en Anthropic (claude.ai) o una clave API
- Un proyecto de codigo existente para explorar (puede ser cualquier lenguaje)
- Conexion a internet

---

## Como Abordar Este Modulo

1. **Lee la teoria en orden**: los tres archivos estan disenados para construir conocimiento de forma progresiva.
2. **No saltes los ejercicios**: la practica es fundamental. Claude Code se aprende usando Claude Code.
3. **Ten el archivo de prompts efectivos a mano**: usalo como referencia durante los ejercicios y en tu trabajo diario.
4. **Experimenta con tu propio proyecto**: aunque los ejercicios proponen escenarios, prueba tambien con tu codigo real.

---

## Siguiente Modulo

Una vez completado este modulo, continua con el [Modulo 02: CLI y Primeros Pasos](../modulo-02-cli-primeros-pasos/), donde profundizaras en los comandos de la CLI, atajos de teclado y flujos de trabajo avanzados.
