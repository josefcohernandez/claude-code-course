# 02 - 7 Hooks Prácticos

## Hook 1: Auto-formateo con Prettier

Después de que Claude escriba o edite un archivo, formatearlo automáticamente:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.{ts,tsx,js,jsx,json,css,md})",
        "command": "npx prettier --write $FILEPATH"
      },
      {
        "matcher": "Edit(*.{ts,tsx,js,jsx,json,css,md})",
        "command": "npx prettier --write $FILEPATH"
      }
    ]
  }
}
```

Para Python:

```json
{
  "matcher": "Write(*.py)",
  "command": "ruff format $FILEPATH && ruff check --fix $FILEPATH"
}
```

---

## Hook 2: Linter después de Cambios

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit(*.ts)",
        "command": "npx eslint $FILEPATH --max-warnings 0"
      }
    ]
  }
}
```

Si el linter falla (exit code no-zero), Claude ve el error y puede corregir.

---

## Hook 3: Tests Automáticos

Ejecutar tests del archivo modificado:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit(src/**/*.ts)",
        "command": "npx vitest run --reporter=verbose $(echo $FILEPATH | sed 's/src/tests/' | sed 's/.ts/.test.ts/')"
      }
    ]
  }
}
```

---

## Hook 4: Logging de Operaciones

Registrar todas las operaciones de Claude para auditoría:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "command": "echo \"$(date +%Y-%m-%dT%H:%M:%S) | $TOOL_NAME | $FILEPATH\" >> /tmp/claude-audit.log",
        "async": true
      }
    ]
  }
}
```

---

## Hook 5: Bloquear Escritura en Directorios Protegidos

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "command": "bash -c 'echo $FILEPATH | grep -qE \"(config/production|.env|secrets/)\" && exit 1 || exit 0'"
      },
      {
        "matcher": "Edit",
        "command": "bash -c 'echo $FILEPATH | grep -qE \"(config/production|.env|secrets/)\" && exit 1 || exit 0'"
      }
    ]
  }
}
```

Si el archivo está en un directorio protegido, exit 1 → operación bloqueada.

---

## Hook 6: Inyectar Contexto en PreCompact

Cuando el contexto se compacta, asegurar que información crítica no se pierde:

```json
{
  "hooks": {
    "PreCompact": [
      {
        "type": "prompt",
        "prompt": "CRÍTICO: Mantener en el resumen: schema actual de BD (users, orders, products), endpoints implementados, y decisiones de arquitectura pendientes."
      }
    ]
  }
}
```

---

## Hook 7: Notificación al Terminar

Recibir notificación cuando Claude termina una tarea larga:

### Linux

```json
{
  "hooks": {
    "Stop": [
      {
        "command": "notify-send 'Claude Code' 'Tarea completada'",
        "async": true
      }
    ]
  }
}
```

### macOS

```json
{
  "hooks": {
    "Stop": [
      {
        "command": "osascript -e 'display notification \"Tarea completada\" with title \"Claude Code\"'",
        "async": true
      }
    ]
  }
}
```

---

## Resumen de Hooks

| # | Propósito | Evento | Matcher | ¿Sync? |
|---|----------|--------|---------|-------|
| 1 | Auto-formateo | PostToolUse | Write/Edit(*.ts) | Sí |
| 2 | Linter | PostToolUse | Edit(*.ts) | Sí |
| 3 | Tests auto | PostToolUse | Edit(src/**) | Sí |
| 4 | Logging | PostToolUse | (todos) | No (async) |
| 5 | Bloquear protegido | PreToolUse | Write/Edit | Sí |
| 6 | Contexto crítico | PreCompact | - | Sí |
| 7 | Notificación | Stop | - | No (async) |
