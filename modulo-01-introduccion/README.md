# Módulo 01: Introducción y Metodología

## Descripción general

Este módulo presenta Claude Code como herramienta de desarrollo asistido por IA. A diferencia de los chatbots o autocompletadores de código tradicionales, Claude Code es un **agente autónomo** que trabaja directamente en tu terminal: lee tu codebase, ejecuta comandos, edita archivos y coordina cambios complejos en múltiples archivos.

Al finalizar este módulo, cada miembro del equipo, ya sea backend, frontend, DevOps o QA, tendrá Claude Code instalado, configurado y habrá completado su primera sesión interactiva con un proyecto real.

---

## Objetivos de aprendizaje

Al completar este módulo serás capaz de:

1. **Explicar** qué es Claude Code y en qué se diferencia de otras herramientas de IA para desarrollo (Copilot, ChatGPT, Cursor, etc.).
2. **Describir** el paradigma de "delegación" frente al paradigma de "dictado" al trabajar con un agente de código.
3. **Identificar** las plataformas, los modelos y las herramientas internas de Claude Code.
4. **Aplicar** la metodología de desarrollo asistido: explorar, planificar, implementar y verificar.
5. **Reconocer** antipatrones comunes y saber cómo evitarlos.
6. **Instalar y configurar** Claude Code en tu entorno de trabajo.
7. **Realizar** tu primera sesión de exploración de un codebase con Claude Code.
8. **Redactar** prompts efectivos adaptados a distintos escenarios (bugs, features, refactoring y tests).

---

## Contenido del módulo

### Teoría

| # | Archivo | Tema | Tiempo estimado |
|---|---------|------|-----------------|
| 1 | [01-que-es-claude-code.md](teoria/01-que-es-claude-code.md) | Qué es Claude Code: herramienta agéntica, plataformas, modelos, herramientas internas y el bucle agéntico | 30 min |
| 2 | [02-metodologia-desarrollo-asistido.md](teoria/02-metodologia-desarrollo-asistido.md) | Metodología de desarrollo asistido por IA: flujo de 4 fases, patrones, antipatrones y principios clave | 30 min |
| 3 | [03-instalacion-configuracion-inicial.md](teoria/03-instalacion-configuracion-inicial.md) | Guía paso a paso de instalación y configuración en todas las plataformas | 15 min |

### Ejercicios prácticos

| # | Archivo | Tema | Tiempo estimado |
|---|---------|------|-----------------|
| 1 | [01-instalacion-y-primer-uso.md](ejercicios/01-instalacion-y-primer-uso.md) | Instalar Claude Code, autenticarse y realizar la primera sesión interactiva | 20 min |
| 2 | [02-exploracion-codebase.md](ejercicios/02-exploracion-codebase.md) | Explorar un codebase desconocido con preguntas progresivamente más profundas | 20 min |

### Ejemplos de referencia

| # | Archivo | Tema |
|---|---------|------|
| 1 | [prompts-efectivos.md](ejemplos/prompts-efectivos.md) | Colección de prompts efectivos organizados por categoría, con comparativas `BAD vs. GOOD` |

---

## Tiempo total estimado

**1 hora y 30 minutos** distribuidos de la siguiente manera:

- Teoría: ~1 hora y 15 minutos
- Ejercicios prácticos: ~15 minutos

---

## Prerrequisitos

- Acceso a una terminal (`bash`, `zsh` o PowerShell)
- Node.js >= 18 instalado (para el método de instalación vía `npm`)
- Una cuenta en Anthropic (`claude.ai`) o una clave de API
- Un proyecto de código existente para explorar (puede ser de cualquier lenguaje)
- Conexión a internet

---

## Cómo abordar este módulo

1. **Lee la teoría en orden**: los tres archivos están diseñados para construir conocimiento de forma progresiva.
2. **No te saltes los ejercicios**: la práctica es fundamental. Claude Code se aprende usándolo.
3. **Ten el archivo de prompts efectivos a mano**: úsalo como referencia durante los ejercicios y en tu trabajo diario.
4. **Experimenta con tu propio proyecto**: aunque los ejercicios proponen escenarios, prueba también con tu código real.

---

## Siguiente módulo

Una vez completado este módulo, continúa con el [Módulo 02: CLI y Primeros Pasos](../modulo-02-cli-primeros-pasos/README.md), donde profundizarás en los comandos de la CLI, los atajos de teclado y los flujos de trabajo avanzados.
