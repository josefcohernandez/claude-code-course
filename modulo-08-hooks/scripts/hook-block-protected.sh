#!/bin/bash
# hook-block-protected.sh
# Hook PreToolUse: Bloquear escritura en archivos/directorios protegidos
# Exit 1 = bloquear, Exit 0 = permitir
#
# Uso en settings.json:
# {
#   "hooks": {
#     "PreToolUse": [
#       {
#         "matcher": "Write",
#         "command": "./scripts/hook-block-protected.sh"
#       },
#       {
#         "matcher": "Edit",
#         "command": "./scripts/hook-block-protected.sh"
#       }
#     ]
#   }
# }

FILEPATH="$FILEPATH"

# Si no hay filepath, permitir (puede ser otro tipo de operacion)
if [ -z "$FILEPATH" ]; then
    exit 0
fi

# Lista de patrones protegidos
PROTECTED_PATTERNS=(
    ".env"
    ".env.production"
    ".env.staging"
    "config/production"
    "secrets/"
    "credentials"
    ".pem"
    ".key"
    "id_rsa"
    "id_ed25519"
    ".secret"
    "password"
    "token.json"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if echo "$FILEPATH" | grep -qi "$pattern"; then
        echo "BLOQUEADO: No se permite modificar archivo protegido: $FILEPATH"
        echo "Patron detectado: $pattern"
        exit 1
    fi
done

# Permitir
exit 0
