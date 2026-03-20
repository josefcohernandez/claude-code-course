# Crear un Plugin Propio

Empaquetar tus propias capacidades en un plugin te permite distribuirlas de forma reproducible, versionarlas con semántica clara y compartirlas con el equipo o la comunidad sin que nadie tenga que configurar los componentes manualmente. Este capítulo cubre el proceso completo: desde la estructura de carpetas hasta la publicación en el marketplace.

---

## Conceptos Clave

### Cuándo crear un plugin propio

Crea un plugin cuando tengas un conjunto de capacidades que:

- Se usan juntas de forma consistente en múltiples proyectos
- Requieren configuración específica que no quieres repetir en cada proyecto
- Quieres compartir con tu equipo o con la comunidad de forma reproducible
- Son lo suficientemente complejas como para merecer versionado propio

Si solo necesitas una capacidad en un proyecto concreto, un skill o hook en `.claude/` es suficiente.

---

## Estructura de un Plugin Personalizado

```
mi-plugin/
├── plugin.json          # Manifest (obligatorio)
├── skills/
│   └── deploy.md        # Skill invocable por nombre
├── agents/
│   └── revisor.md       # Subagente especializado
├── hooks/
│   ├── pre-deploy.sh    # Hook de validación
│   └── post-deploy.sh   # Hook de notificación
└── README.md            # Documentación para usuarios del plugin
```

Cada subdirectorio es opcional; incluye solo los componentes que necesitas.

---

## El Manifest `plugin.json`

El manifest define la identidad, dependencias, configuración y componentes del plugin.

```json
{
  "name": "deploy-safe",
  "version": "1.0.0",
  "description": "Flujo de deploy seguro con validaciones, rollback y notificación a Slack",
  "author": "equipo-plataforma@empresa.com",
  "homepage": "https://github.com/mi-empresa/deploy-safe-plugin",
  "license": "MIT",
  "engines": {
    "claude-code": ">=2.0.0"
  },
  "dependencies": {
    "mcp": ["@modelcontextprotocol/server-github"],
    "tools": ["git", "docker", "kubectl"]
  },
  "configuration": {
    "environment": {
      "type": "string",
      "enum": ["staging", "production"],
      "default": "staging",
      "description": "Entorno de destino del deploy"
    },
    "slack_webhook": {
      "type": "string",
      "description": "URL del webhook de Slack para notificaciones (opcional)",
      "required": false
    },
    "require_tests": {
      "type": "boolean",
      "default": true,
      "description": "Exigir que los tests pasen antes de permitir el deploy"
    }
  },
  "components": {
    "skills": [
      "skills/deploy.md",
      "skills/rollback.md"
    ],
    "agents": [
      "agents/revisor.md"
    ],
    "hooks": [
      {
        "file": "hooks/pre-deploy.sh",
        "event": "PreToolUse",
        "matcher": "Bash",
        "description": "Valida que los tests pasan antes de ejecutar comandos de deploy"
      },
      {
        "file": "hooks/post-deploy.sh",
        "event": "PostToolUse",
        "matcher": "Bash",
        "description": "Notifica a Slack cuando se completa un deploy"
      }
    ]
  }
}
```

**Campos obligatorios:** `name`, `version`, `description`.

**Campos recomendados para publicación:** `author`, `license`, `homepage`, `engines`.

---

## Empaquetar Skills Existentes

Si ya tienes skills en `.claude/skills/` de tu proyecto, puedes empaquetarlos en un plugin sin modificarlos. Copia los archivos `SKILL.md` al subdirectorio `skills/` del plugin y regístralos en el manifest.

Ejemplo de skill de deploy (`skills/deploy.md`):

```markdown
---
name: deploy
description: Despliega la versión actual a un entorno específico tras validar tests y configuración
---

# Skill: Deploy Seguro

Antes de cualquier deploy:
1. Verifica que los tests de la suite principal pasan (`npm test` o equivalente)
2. Confirma que no hay cambios sin commitear en git
3. Valida que las variables de entorno requeridas están definidas
4. Construye el artefacto de despliegue
5. Despliega al entorno configurado
6. Verifica el health check post-deploy
7. Si falla el health check, ejecuta el rollback automático

Reporta cada paso con su resultado (ok/error) antes de continuar al siguiente.
```

El skill anterior hace referencia al entorno configurado en `plugin.json`. El plugin inyecta el valor de `environment` como variable de entorno `PLUGIN_ENVIRONMENT` al ejecutar el skill.

---

## Empaquetar Hooks con el Plugin

Los hooks del plugin se definen en el directorio `hooks/` y se registran en el manifest con el evento y el matcher correspondientes.

Ejemplo de hook de validación pre-deploy (`hooks/pre-deploy.sh`):

```bash
#!/bin/bash
# Hook PreToolUse: bloquea comandos de deploy si los tests fallan

# Leer el comando que Claude intenta ejecutar desde stdin
TOOL_INPUT=$(cat)
COMMAND=$(echo "$TOOL_INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('command', ''))")

# Solo actuar en comandos que parecen deploys
if echo "$COMMAND" | grep -qE "(kubectl apply|docker push|helm upgrade|deploy\.sh)"; then
    echo "Pre-deploy check: ejecutando tests..." >&2

    # Detectar el gestor de tests disponible
    if [ -f "package.json" ]; then
        npm test --silent
        EXIT_CODE=$?
    elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        python -m pytest -q
        EXIT_CODE=$?
    else
        echo "No se detectó suite de tests. Continuando sin validación." >&2
        EXIT_CODE=0
    fi

    if [ $EXIT_CODE -ne 0 ]; then
        # Salida con código 2 bloquea el comando y muestra el mensaje a Claude
        echo '{"decision": "block", "reason": "Los tests no pasan. Corrige los errores antes de hacer deploy."}'
        exit 2
    fi

    echo "Tests OK. Continuando con el deploy." >&2
fi

# Salida con código 0: el comando se ejecuta normalmente
exit 0
```

Ejemplo de hook de notificación post-deploy (`hooks/post-deploy.sh`):

```bash
#!/bin/bash
# Hook PostToolUse: notifica a Slack cuando un deploy se completa

# PLUGIN_SLACK_WEBHOOK viene de la configuración del plugin
if [ -z "$PLUGIN_SLACK_WEBHOOK" ]; then
    exit 0
fi

TOOL_OUTPUT=$(cat)
COMMAND=$(echo "$TOOL_OUTPUT" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('tool_input', {}).get('command', ''))" 2>/dev/null)

# Solo notificar en comandos de deploy
if echo "$COMMAND" | grep -qE "(kubectl apply|helm upgrade|deploy\.sh)"; then
    ENTORNO="${PLUGIN_ENVIRONMENT:-staging}"
    curl -s -X POST "$PLUGIN_SLACK_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d "{\"text\": \"Deploy completado en *${ENTORNO}* por ${USER}. Comando: \`${COMMAND}\`\"}" \
        > /dev/null
fi

exit 0
```

---

## Incluir un Servidor MCP en el Plugin

Si tu plugin requiere un servidor MCP externo, decláralo en `dependencies.mcp` del manifest. Claude Code instalará y configurará el servidor automáticamente al instalar el plugin.

Para un servidor MCP personalizado que forma parte del plugin (no es un paquete público), inclúyelo en el directorio del plugin y referencíalo en la configuración:

```json
{
  "name": "deploy-safe",
  "version": "1.0.0",
  "description": "Flujo de deploy con acceso a Kubernetes vía MCP",
  "dependencies": {
    "mcp": {
      "kubernetes-mcp": {
        "command": "npx",
        "args": ["-y", "@anthropic-mcp/kubernetes"],
        "env": {
          "KUBECONFIG": "${KUBECONFIG}"
        }
      }
    }
  }
}
```

La sintaxis `${VARIABLE}` en los valores de `env` permite pasar variables de entorno del sistema al servidor MCP sin hardcodear credenciales en el manifest.

---

## Probar el Plugin Localmente

Antes de publicar, instala el plugin desde la ruta local para verificar que funciona correctamente:

```bash
# Desde el directorio del proyecto donde quieres probar el plugin
/plugin install ./ruta/a/mi-plugin --scope project
```

Lista los plugins instalados para confirmar que se registró correctamente:

```bash
/plugin list
```

Verifica que los skills son invocables:

```bash
# Dentro de una sesión de Claude Code
@deploy-safe/deploy
```

Verifica que los hooks se activan en el evento correcto ejecutando el comando que debería disparar el hook y observando los mensajes de stderr del hook en el log de Claude Code.

Para desinstalar la versión local y repetir el ciclo:

```bash
/plugin remove deploy-safe
```

---

## Publicar en el Marketplace

Cuando el plugin está listo para compartirse:

1. Crea un repositorio público en GitHub con la estructura del plugin en la raíz
2. Publica el plugin en el marketplace de Claude Code:

    ```bash
    /plugin publish --source https://github.com/mi-usuario/deploy-safe-plugin
    ```

3. Claude Code valida el manifest, verifica la estructura de carpetas y registra el plugin con el nombre declarado en `plugin.json`

Para publicar desde npm (si prefieres ese registro):

```bash
# El package.json debe incluir los campos claude-code en la sección custom
npm publish

# Instalar desde npm
/plugin install npm:@mi-org/deploy-safe
```

---

## Versionado y Actualizaciones

El versionado sigue semántica SemVer (`MAYOR.MENOR.PARCHE`):

| Tipo de cambio | Versión |
|----------------|---------|
| Nuevo campo en `configuration` (con default) | MENOR |
| Nuevo skill o hook añadido | MENOR |
| Cambio incompatible en la interfaz de un skill | MAYOR |
| Corrección de un hook que fallaba | PARCHE |
| Cambio en el comportamiento de un hook (no es bug) | MENOR o MAYOR |

Para publicar una nueva versión, incrementa `version` en `plugin.json` y ejecuta de nuevo `/plugin publish`. Los usuarios reciben la actualización con:

```bash
/plugin update deploy-safe
```

Si quieres fijar una versión específica al instalar (para reproducibilidad):

```bash
/plugin install deploy-safe@1.0.0
```

---

## Errores Comunes

**No marcar los scripts de hooks como ejecutables.** Si `hooks/pre-deploy.sh` no tiene permisos de ejecución (`chmod +x`), el hook fallará silenciosamente en algunos sistemas. Verifica los permisos antes de publicar.

**Hardcodear URLs o credenciales en el manifest.** Usa el sistema de `configuration` para valores que varían entre instalaciones. Los usuarios configuran sus propios valores; el manifest solo define los campos y sus valores por defecto.

**No probar el plugin en un proyecto limpio.** El plugin puede funcionar en el proyecto donde lo desarrollaste pero fallar en otros si depende de archivos o variables de entorno que no están presentes universalmente. Prueba siempre en un repositorio diferente al de desarrollo.

**Publicar sin documentación.** Un `README.md` claro que explique qué hace el plugin, qué configuración requiere y cómo se usa multiplica la adopción. Incluye al menos un ejemplo de uso.

---

## Resumen

- La estructura mínima de un plugin es `plugin.json` más al menos un subdirectorio con un componente
- El manifest declara nombre, versión, dependencias, configuración disponible y componentes incluidos
- Los skills, hooks y subagentes existentes se empaquetan copiándolos a los subdirectorios del plugin y registrándolos en el manifest
- Para incluir un servidor MCP, decláralo en `dependencies.mcp` con su comando de inicio
- El ciclo de desarrollo local es: crear → instalar con `--scope project` → probar → desinstalar → iterar
- La publicación se hace vía `/plugin publish` apuntando al repositorio del plugin
