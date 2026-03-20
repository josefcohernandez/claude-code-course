#!/bin/bash
# hook-security-audit.sh
# Hook PostToolUse: Registrar todas las operaciones para auditoria
#
# Uso en settings.json:
# {
#   "hooks": {
#     "PostToolUse": [
#       {
#         "command": "./scripts/hook-security-audit.sh",
#         "async": true
#       }
#     ]
#   }
# }

LOG_DIR="${HOME}/.claude/audit"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
LOG_FILE="${LOG_DIR}/${DATE}.log"

# Registrar operacion
echo "${TIME} | USER=${USER:-unknown} | TOOL=${TOOL_NAME:-unknown} | FILE=${FILEPATH:-N/A}" >> "$LOG_FILE"

# Alerta para operaciones sensibles
SENSITIVE_TOOLS=("Bash" "Write" "Edit")
for tool in "${SENSITIVE_TOOLS[@]}"; do
    if [ "$TOOL_NAME" = "$tool" ] && [ -n "$FILEPATH" ]; then
        # Verificar si es un archivo sensible
        if echo "$FILEPATH" | grep -qiE "\.(env|pem|key|secret|credential)"; then
            echo "${TIME} | ALERTA: Operacion sensible | ${TOOL_NAME} | ${FILEPATH}" >> "${LOG_DIR}/alerts-${DATE}.log"
        fi
    fi
done

exit 0
