# Módulo 02: CLI y Primeros Pasos

## Descripción general

Este módulo es tu primer contacto práctico con Claude Code. Aprenderás a instalar, configurar y utilizar la interfaz de línea de comandos (CLI) de Claude Code de manera efectiva. Desde los comandos más básicos hasta la gestión avanzada de sesiones, este módulo te dará las herramientas fundamentales para trabajar con Claude Code en tu día a día, sin importar si eres desarrollador backend, frontend, DevOps o QA.

**Tiempo estimado:** 2 horas

---

## Objetivos de aprendizaje

Al completar este módulo, serás capaz de:

1. **Ejecutar comandos básicos** de Claude Code desde la terminal con confianza.
2. **Utilizar los diferentes modos** de ejecución: interactivo, one-shot (`-p`) y pipe.
3. **Navegar el modo interactivo** usando slash commands, atajos de teclado y referencias con `@`.
4. **Gestionar sesiones** de trabajo: crear, renombrar, reanudar y bifurcar sesiones.
5. **Elegir el modo de permisos** adecuado según la tarea que estés realizando.
6. **Aplicar Claude Code a tareas reales**: corregir bugs, implementar features y automatizar flujos.
7. **Personalizar la salida** de Claude Code según tus necesidades (texto, JSON y streaming).

---

## Requisitos previos

- Haber completado el [Módulo 01: Introducción](../modulo-01-introduccion/README.md)
- Claude Code instalado y autenticado (ver instrucciones del Módulo 01)
- Terminal o shell configurado (`bash`, `zsh` o PowerShell)
- Un editor de texto o IDE instalado
- Node.js 18+ y/o Python 3.10+ instalados (para los ejercicios)

---

## Contenido del módulo

### Teoría

| # | Archivo | Descripción | Tiempo |
|---|---------|-------------|--------|
| 1 | [Comandos CLI](teoria/01-comandos-cli.md) | Referencia completa de comandos, flags y modos de ejecución | 30 min |
| 2 | [Modo Interactivo](teoria/02-modo-interactivo.md) | Slash commands, atajos de teclado, referencias y permisos | 25 min |
| 3 | [Sesiones y Continuidad](teoria/03-sesiones-y-continuidad.md) | Gestión de sesiones, checkpoints, reanudación y bifurcación | 20 min |

### Ejercicios prácticos

| # | Archivo | Descripción | Tiempo |
|---|---------|-------------|--------|
| 1 | [Comandos Básicos](ejercicios/01-comandos-basicos.md) | Práctica de comandos, navegación y formatos de salida | 15 min |
| 2 | [Primer Bug Fix](ejercicios/02-primer-bugfix.md) | Encontrar y corregir un bug real con Claude Code | 15 min |
| 3 | [Primera Feature](ejercicios/03-primer-feature.md) | Implementar una funcionalidad nueva de principio a fin | 15 min |

### Material de referencia

| Archivo | Descripción |
|---------|-------------|
| [Referencia Rápida](cheatsheets/referencia-rapida.md) | Cheatsheet con comandos, atajos y patrones más usados |

---

## Estructura de archivos

```text
modulo-02-cli-primeros-pasos/
├── README.md                              # Este archivo
├── teoria/
│   ├── 01-comandos-cli.md                 # Referencia completa de comandos
│   ├── 02-modo-interactivo.md             # Modo interactivo en profundidad
│   └── 03-sesiones-y-continuidad.md       # Gestión de sesiones
├── ejercicios/
│   ├── 01-comandos-basicos.md             # Ejercicio: comandos fundamentales
│   ├── 02-primer-bugfix.md                # Ejercicio: corregir un bug
│   └── 03-primer-feature.md               # Ejercicio: implementar una feature
├── ejemplos/                              # Código de ejemplo (usado en ejercicios)
└── cheatsheets/
    └── referencia-rapida.md               # Tarjeta de referencia rápida
```

---

## Ruta de aprendizaje sugerida

```text
1. Lee la teoría (01 → 02 → 03)
         │
         ▼
2. Realiza los ejercicios (01 → 02 → 03)
         │
         ▼
3. Imprime o guarda la referencia rápida
         │
         ▼
4. Avanza al Módulo 03: Contexto y Tokens
```

---

## Consejos para aprovechar al máximo este módulo

- **Practica mientras lees**: no te limites a leer la teoría; abre una terminal y prueba cada comando.
- **No memorices**: usa la referencia rápida como apoyo. La memoria muscular llega con la práctica.
- **Experimenta**: si algo te genera curiosidad, pruébalo. Claude Code es seguro por defecto.
- **Anota tus descubrimientos**: cada equipo y cada proyecto tienen patrones únicos; registra los tuyos.

---

## Navegación del curso

| Anterior | Siguiente |
|----------|-----------|
| [Módulo 01: Introducción](../modulo-01-introduccion/README.md) | [Módulo 03: Contexto y Tokens](../modulo-03-contexto-y-tokens/README.md) |
