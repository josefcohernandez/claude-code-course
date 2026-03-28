# Modulo 02: CLI y Primeros Pasos

## Descripcion General

Este modulo es tu primer contacto practico con Claude Code. Aprenderemos a instalar, configurar y utilizar la interfaz de linea de comandos (CLI) de Claude Code de manera efectiva. Desde los comandos mas basicos hasta la gestion avanzada de sesiones, este modulo te dara las herramientas fundamentales para trabajar con Claude Code en tu dia a dia, sin importar si eres desarrollador backend, frontend, DevOps o QA.

**Tiempo estimado:** 2 horas

---

## Objetivos de Aprendizaje

Al completar este modulo, seras capaz de:

1. **Ejecutar comandos basicos** de Claude Code desde la terminal con confianza
2. **Utilizar los diferentes modos** de ejecucion: interactivo, one-shot (`-p`) y pipe
3. **Navegar el modo interactivo** usando slash commands, atajos de teclado y referencias con `@`
4. **Gestionar sesiones** de trabajo: crear, renombrar, reanudar y bifurcar sesiones
5. **Elegir el modo de permisos** adecuado segun la tarea que estes realizando
6. **Aplicar Claude Code a tareas reales**: corregir bugs, implementar features y automatizar flujos
7. **Personalizar la salida** de Claude Code segun tus necesidades (texto, JSON, streaming)

---

## Requisitos Previos

- Haber completado el [Modulo 01: Introduccion](../modulo-01-introduccion/README.md)
- Claude Code instalado y autenticado (ver instrucciones del Modulo 01)
- Terminal/shell configurado (bash, zsh, PowerShell)
- Un editor de texto o IDE instalado
- Node.js 18+ y/o Python 3.10+ instalado (para los ejercicios)

---

## Contenido del Modulo

### Teoria

| # | Archivo | Descripcion | Tiempo |
|---|---------|-------------|--------|
| 1 | [Comandos CLI](teoria/01-comandos-cli.md) | Referencia completa de comandos, flags y modos de ejecucion | 30 min |
| 2 | [Modo Interactivo](teoria/02-modo-interactivo.md) | Slash commands, atajos de teclado, referencias y permisos | 25 min |
| 3 | [Sesiones y Continuidad](teoria/03-sesiones-y-continuidad.md) | Gestion de sesiones, checkpoints, reanudacion y bifurcacion | 20 min |

### Ejercicios Practicos

| # | Archivo | Descripcion | Tiempo |
|---|---------|-------------|--------|
| 1 | [Comandos Basicos](ejercicios/01-comandos-basicos.md) | Practica de comandos, navegacion y formatos de salida | 15 min |
| 2 | [Primer Bugfix](ejercicios/02-primer-bugfix.md) | Encontrar y corregir un bug real con Claude Code | 15 min |
| 3 | [Primer Feature](ejercicios/03-primer-feature.md) | Implementar una funcionalidad nueva de principio a fin | 15 min |

### Material de Referencia

| Archivo | Descripcion |
|---------|-------------|
| [Referencia Rapida](cheatsheets/referencia-rapida.md) | Cheatsheet con comandos, atajos y patrones mas usados |

---

## Estructura de Archivos

```
modulo-02-cli-primeros-pasos/
├── README.md                              # Este archivo
├── teoria/
│   ├── 01-comandos-cli.md                 # Referencia completa de comandos
│   ├── 02-modo-interactivo.md             # Modo interactivo en profundidad
│   └── 03-sesiones-y-continuidad.md       # Gestion de sesiones
├── ejercicios/
│   ├── 01-comandos-basicos.md             # Ejercicio: comandos fundamentales
│   ├── 02-primer-bugfix.md                # Ejercicio: corregir un bug
│   └── 03-primer-feature.md               # Ejercicio: implementar feature
├── ejemplos/                              # Codigo de ejemplo (usado en ejercicios)
└── cheatsheets/
    └── referencia-rapida.md               # Tarjeta de referencia rapida
```

---

## Ruta de Aprendizaje Sugerida

```
1. Lee la teoria (01 → 02 → 03)
         │
         ▼
2. Realiza los ejercicios (01 → 02 → 03)
         │
         ▼
3. Imprime/guarda la referencia rapida
         │
         ▼
4. Avanza al Modulo 03: Contexto y Tokens
```

---

## Consejos para Aprovechar al Maximo este Modulo

- **Practica mientras lees**: No solo leas la teoria; abre una terminal y prueba cada comando
- **No memorices**: Usa la referencia rapida como apoyo. La memoria muscular viene con la practica
- **Experimenta**: Si algo te genera curiosidad, pruebalo. Claude Code es seguro por defecto
- **Anota tus descubrimientos**: Cada equipo y proyecto tiene patrones unicos; registra los tuyos

---

## Navegacion del Curso

| Anterior | Siguiente |
|----------|-----------|
| [Modulo 01: Introduccion](../modulo-01-introduccion/README.md) | [Modulo 03: Contexto y Tokens](../modulo-03-contexto-y-tokens/README.md) |
