# Módulo 08: Hooks

## Descripción general

Los hooks permiten ejecutar comandos de shell automáticamente en respuesta a eventos del ciclo de vida de Claude Code. Van desde el autoformateo hasta la validación de seguridad.

## Objetivos

1. Comprender el sistema de 26 eventos de hooks.
2. Configurar hooks prácticos para desarrollo.
3. Implementar hooks de seguridad.
4. Crear scripts reutilizables.

## Duración

**2 h 05 min** (80 min de teoría + 45 min de ejercicios)

## Prerrequisitos

Módulos 01-07 completados.

## Estructura

```text
modulo-08-hooks/
├── README.md
├── teoria/
│   ├── 01-sistema-hooks.md
│   ├── 02-hooks-practicos.md
│   ├── 03-hooks-seguridad.md
│   └── 04-hooks-agent-y-eventos-avanzados.md
├── ejercicios/
│   ├── 01-hooks-autoformateo.md
│   └── 02-hooks-seguridad.md
└── scripts/
    ├── hook-autoformat.sh
    ├── hook-security-audit.sh
    └── hook-block-protected.sh
```

## Contenido de teoría

| Archivo | Tema | Duración |
|---------|------|----------|
| [01-sistema-hooks.md](teoria/01-sistema-hooks.md) | Sistema de hooks y eventos del ciclo de vida | 15 min |
| [02-hooks-practicos.md](teoria/02-hooks-practicos.md) | Hooks prácticos para desarrollo | 15 min |
| [03-hooks-seguridad.md](teoria/03-hooks-seguridad.md) | Hooks de seguridad y auditoría | 15 min |
| [04-hooks-agent-y-eventos-avanzados.md](teoria/04-hooks-agent-y-eventos-avanzados.md) | Hooks de tipo `agent`, nuevos eventos y hooks async | 20 min |
