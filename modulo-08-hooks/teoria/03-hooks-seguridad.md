# 03 - Hooks de Seguridad

## PreToolUse como Guardían

El evento **PreToolUse** es la herramienta principal de seguridad:
- Se ejecuta **antes** de cada operación
- Si el script retorna **exit 2**, la operación se **bloquea**
- Si el script retorna **exit 1** u otro código distinto de 0 y 2, la operación **no se bloquea** (solo se muestra en modo verbose)
- Puede validar comandos, archivos y patrones

---

## Hook: Validar Comandos Bash

Bloquear comandos peligrosos que no están en la lista de deny:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/ruta/a/validate-bash.sh"
          }
        ]
      }
    ]
  }
}
```

```bash
#!/bin/bash
# validate-bash.sh
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Patrones peligrosos
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "rm -rf /*"
    ":(){ :|:& };:"
    "> /dev/sda"
    "mkfs"
    "dd if=/dev"
    "chmod -R 777"
    "curl.*| bash"
    "wget.*| bash"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiF "$pattern"; then
        echo "BLOQUEADO: Comando peligroso detectado: $pattern" >&2
        exit 2
    fi
done

exit 0
```

---

## Hook: Proteger Archivos Sensibles

```bash
#!/bin/bash
# protect-files.sh
INPUT=$(cat)
FILEPATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(
    ".env"
    ".env.production"
    "credentials"
    "secrets"
    "id_rsa"
    "*.pem"
    "*.key"
    "config/production"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if echo "$FILEPATH" | grep -qi "$pattern"; then
        echo "BLOQUEADO: Archivo protegido: $FILEPATH" >&2
        exit 2
    fi
done

exit 0
```

---

## Hook: Auditoría de Operaciones

Registrar todas las operaciones para revisión posterior:

```bash
#!/bin/bash
# audit-log.sh
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILEPATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

LOG_FILE="${HOME}/.claude/audit.log"

echo "$(date -Iseconds) | USER=${USER} | TOOL=${TOOL_NAME} | FILE=${FILEPATH:-N/A}" >> "$LOG_FILE"
```

### Formato del log

```
2026-02-11T10:30:00+01:00 | USER=developer | TOOL=Write | FILE=src/auth.ts
2026-02-11T10:30:15+01:00 | USER=developer | TOOL=Bash | FILE=
2026-02-11T10:31:00+01:00 | USER=developer | TOOL=Edit | FILE=src/routes.ts
```

---

## Hook: Prevenir Acceso Fuera del Proyecto

```bash
#!/bin/bash
# check-project-boundary.sh
INPUT=$(cat)
FILEPATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
PROJECT_ROOT="/home/user/mi-proyecto"

if [ -n "$FILEPATH" ]; then
    REAL_PATH=$(realpath "$FILEPATH" 2>/dev/null || echo "$FILEPATH")
    if [[ "$REAL_PATH" != "$PROJECT_ROOT"* ]]; then
        echo "BLOQUEADO: Acceso fuera del proyecto: $FILEPATH" >&2
        exit 2
    fi
fi

exit 0
```

---

## PreToolUse para Integraciones Headless

> **Novedad v3.2 (v2.1.85)**

Los hooks `PreToolUse` ahora pueden **satisfacer automáticamente** la herramienta `AskUserQuestion` devolviendo `updatedInput` junto con `permissionDecision: "allow"`. Esto permite que integraciones headless (CI/CD, pipelines automatizados, agentes remotos) respondan a preguntas de Claude sin intervención humana.

```bash
#!/bin/bash
# auto-responder-headless.sh
# Responde automáticamente a AskUserQuestion en entornos headless

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

if [ "$TOOL_NAME" = "AskUserQuestion" ]; then
  QUESTION=$(echo "$INPUT" | jq -r '.tool_input.question // empty')

  # Responder automáticamente según el patrón de la pregunta
  if echo "$QUESTION" | grep -qi "continuar"; then
    echo '{"permissionDecision":"allow","updatedInput":"Si, continua con la implementación."}'
    exit 0
  fi
fi

# Para cualquier otra herramienta, permitir sin modificar
exit 0
```

Configuración:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "/scripts/auto-responder-headless.sh"
          }
        ]
      }
    ]
  }
}
```

Esto es especialmente útil en combinación con el modo no interactivo (`claude -p`) donde no hay un usuario para responder preguntas.

---

## Riesgos de Hooks Mal Configurados

| Riesgo | Consecuencia | Prevención |
|--------|-------------|-----------|
| Hook lento | Bloquea cada operación | Timeout, async cuando posible |
| Hook con bug | Bloquea todo | Probar hooks aislados |
| Hook que expone datos | Log con secrets | No loggear tool_input completo |
| Hook sin exit 0 | Bloquea operaciones válidas si retorna exit 2 | Siempre exit 0 al final |
| Hook recursivo | Loop infinito | No llamar Claude desde hooks |

---

## Testing de Hooks

Antes de activar un hook, pruébalo aislado. Dado que los hooks reciben datos vía stdin (JSON), se deben simular con un pipe:

```bash
# Simular datos de entrada como JSON vía stdin
echo '{"tool_name":"Write","tool_input":{"file_path":"src/auth.ts"}}' | bash hook-protect-files.sh
echo "Exit code: $?"   # Debe ser 0 (no protegido)

echo '{"tool_name":"Write","tool_input":{"file_path":".env.production"}}' | bash hook-protect-files.sh
echo "Exit code: $?"   # Debe ser 2 (protegido, bloqueado)
```

---

## Configuración Recomendada de Seguridad

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/scripts/validate-bash.sh"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "/scripts/protect-files.sh"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/scripts/protect-files.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/scripts/audit-log.sh",
            "async": true
          }
        ]
      }
    ]
  }
}
```
