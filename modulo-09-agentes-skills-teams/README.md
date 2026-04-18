# Módulo 09: Subagentes, Skills y Agent Teams

## Orquestación avanzada de agentes en Claude Code

> **Tiempo estimado:** 3 horas
> **Nivel:** Avanzado
> **Prerrequisitos:** Módulos 01-08 completados, familiaridad con Claude Code CLI

---

## Descripción general

Este es el módulo más avanzado del curso sobre **orquestación de agentes**. Aquí aprenderemos a escalar el trabajo con Claude Code más allá de una única sesión interactiva, utilizando tres mecanismos fundamentales:

1. **Subagentes**: asistentes especializados que operan en su propia ventana de contexto
2. **Skills**: capacidades reutilizables definidas en archivos `SKILL.md`
3. **Agent Teams**: equipos de agentes que colaboran en tareas paralelas

### Por qué es importante este módulo

En proyectos reales, una única sesión de Claude Code tiene limitaciones:

- La **ventana de contexto se llena** al leer muchos archivos.
- Las tareas **secuenciales son lentas** cuando podrían paralelizarse.
- Los **workflows repetitivos** requieren reinstrucciones constantes.
- Los **equipos grandes** necesitan múltiples flujos de trabajo simultáneos.

Este módulo te enseña a superar todas estas limitaciones.

---

## Estructura del módulo

### Teoría

| Archivo | Tema | Duración |
|---------|------|----------|
| [01-subagentes.md](teoria/01-subagentes.md) | Subagentes en profundidad | 45 min |
| [02-skills.md](teoria/02-skills.md) | Sistema de skills | 30 min |
| [03-agent-teams.md](teoria/03-agent-teams.md) | Agent Teams (experimental) | 35 min |
| [04-aislamiento-worktree-y-comunicacion.md](teoria/04-aislamiento-worktree-y-comunicacion.md) | Worktree isolation, SendMessage, background agents y task management | 30 min |

### Ejercicios prácticos

| Archivo | Tema | Duración |
|---------|------|----------|
| [01-subagentes-practica.md](ejercicios/01-subagentes-practica.md) | Uso efectivo de subagentes | 15 min |
| [02-crear-skill.md](ejercicios/02-crear-skill.md) | Crear un skill personalizado | 15 min |
| [03-agent-teams.md](ejercicios/03-agent-teams.md) | Configurar un Agent Team | 15 min |

### Recursos de ejemplo

| Directorio | Contenido |
|------------|-----------|
| [agentes/](agentes/) | Definiciones de agentes personalizados (`.md`) |
| [skills/](skills/) | Archivos `SKILL.md` de ejemplo |

---

## Mapa conceptual

```text
                    +---------------------------+
                    |      Tú (desarrollador)   |
                    +-------------+-------------+
                                  |
                    +-------------v-------------+
                    |  Claude Code (principal)  |
                    +---+--------+----------+---+
                        |        |          |
              +---------+   +----+----+   +-+----------+
              |             |         |   |            |
        +-----v-----+ +----v----+ +--v---v----+ +-----v-----+
        | Subagente | | Skill   | | Subagente | | Teammate  |
        | Explore   | | Deploy  | | General   | | (team)    |
        | (búsqueda)| | (tarea) | | (complejo)| | (paralelo)|
        +-----------+ +---------+ +-----------+ +-----------+
```

---

## Conceptos clave que aprenderás

- **Aislamiento de contexto**: cómo los subagentes mantienen limpia la ventana principal.
- **Especialización**: diferentes tipos de subagentes para diferentes tareas.
- **Reutilización**: skills como workflows empaquetados e invocables.
- **Paralelismo**: Agent Teams para trabajo verdaderamente concurrente.
- **Optimización de costes**: elegir el modelo correcto para cada subagente.
- **Coordinación**: cómo los agentes se comunican entre sí.

---

## Requisitos técnicos

- Claude Code CLI instalado y configurado
- Terminal con soporte para `tmux` (recomendado para Agent Teams)
- Un proyecto de código fuente para las prácticas (cualquier lenguaje)
- Cuenta con acceso a la API de Anthropic (los Agent Teams consumen más tokens)

---

## Advertencia sobre costes

> **IMPORTANTE:** Las funcionalidades de Agent Teams son experimentales y pueden consumir significativamente más tokens que una sesión estándar (hasta ~7 veces más). Recomendamos monitorizar los costes activamente durante los ejercicios y utilizar modelos más económicos (Sonnet y Haiku) para los teammates cuando sea posible.

---

## Navegación del curso

| Anterior | Siguiente |
|----------|-----------|
| [Módulo 08: Hooks](../modulo-08-hooks/README.md) | [Módulo 10: Automatización y CI/CD](../modulo-10-automatizacion-cicd/README.md) |
