# Modulo 09: Subagentes, Skills y Agent Teams

## Orquestacion Avanzada de Agentes en Claude Code

> **Tiempo estimado:** 3 horas
> **Nivel:** Avanzado
> **Prerequisitos:** Modulos 01-08 completados, familiaridad con Claude Code CLI

---

## Descripcion General

Este es el modulo mas avanzado del curso sobre **orquestacion de agentes**. Aqui aprenderemos a escalar el trabajo con Claude Code mas alla de una unica sesion interactiva, utilizando tres mecanismos fundamentales:

1. **Subagentes** — Asistentes especializados que operan en su propia ventana de contexto
2. **Skills** — Capacidades reutilizables definidas en archivos SKILL.md
3. **Agent Teams** — Equipos de agentes que colaboran en tareas paralelas

### Por que es importante este modulo

En proyectos reales, una unica sesion de Claude Code tiene limitaciones:

- La **ventana de contexto se llena** al leer muchos archivos
- Las tareas **secuenciales son lentas** cuando podrian paralelizarse
- Los **workflows repetitivos** requieren reinstrucciones constantes
- Los **equipos grandes** necesitan multiples flujos de trabajo simultaneos

Este modulo te ensena a superar todas estas limitaciones.

---

## Estructura del Modulo

### Teoria

| Archivo | Tema | Duracion |
|---------|------|----------|
| [01-subagentes.md](teoria/01-subagentes.md) | Subagentes en profundidad | 45 min |
| [02-skills.md](teoria/02-skills.md) | Sistema de Skills | 30 min |
| [03-agent-teams.md](teoria/03-agent-teams.md) | Agent Teams (experimental) | 35 min |
| [04-aislamiento-worktree-y-comunicacion.md](teoria/04-aislamiento-worktree-y-comunicacion.md) | Worktree isolation, SendMessage, background agents y task management | 30 min |

### Ejercicios Practicos

| Archivo | Tema | Duracion |
|---------|------|----------|
| [01-subagentes-practica.md](ejercicios/01-subagentes-practica.md) | Uso efectivo de subagentes | 15 min |
| [02-crear-skill.md](ejercicios/02-crear-skill.md) | Crear un skill personalizado | 15 min |
| [03-agent-teams.md](ejercicios/03-agent-teams.md) | Configurar un Agent Team | 15 min |

### Recursos de Ejemplo

| Directorio | Contenido |
|------------|-----------|
| [agentes/](agentes/) | Definiciones de agentes personalizados (.md) |
| [skills/](skills/) | Archivos SKILL.md de ejemplo |

---

## Mapa Conceptual

```
                    +---------------------------+
                    |      Tu (Desarrollador)   |
                    +-------------+-------------+
                                  |
                    +-------------v-------------+
                    |   Claude Code (Principal)  |
                    +---+--------+----------+---+
                        |        |          |
              +---------+   +----+----+   +-+----------+
              |             |         |   |            |
        +-----v-----+ +----v----+ +--v---v----+ +-----v-----+
        | Subagente  | | Skill   | | Subagente | | Teammate  |
        | Explore    | | Deploy  | | General   | | (Team)    |
        | (busqueda) | | (tarea) | | (complejo)| | (paralelo)|
        +------------+ +---------+ +-----------+ +-----------+
```

---

## Conceptos Clave que Aprenderas

- **Aislamiento de contexto**: como los subagentes mantienen limpia la ventana principal
- **Especializacion**: diferentes tipos de subagentes para diferentes tareas
- **Reutilizacion**: skills como workflows empaquetados e invocables
- **Paralelismo**: Agent Teams para trabajo verdaderamente concurrente
- **Optimizacion de costos**: elegir el modelo correcto para cada subagente
- **Coordinacion**: como los agentes se comunican entre si

---

## Requisitos Tecnicos

- Claude Code CLI instalado y configurado
- Terminal con soporte para tmux (recomendado para Agent Teams)
- Un proyecto de codigo fuente para las practicas (cualquier lenguaje)
- Cuenta con acceso a la API de Anthropic (los Agent Teams consumen mas tokens)

---

## Advertencia sobre Costos

> **IMPORTANTE:** Las funcionalidades de Agent Teams son experimentales y pueden
> consumir significativamente mas tokens que una sesion estandar (hasta ~7x mas).
> Recomendamos monitorizar los costos activamente durante los ejercicios y
> utilizar modelos mas economicos (Sonnet, Haiku) para los teammates cuando sea posible.

---

## Navegacion del Curso

| Anterior | Siguiente |
|----------|-----------|
| [Modulo 08: Hooks](../modulo-08-hooks/README.md) | [Modulo 10: Automatizacion CI/CD](../modulo-10-automatizacion-cicd/README.md) |
