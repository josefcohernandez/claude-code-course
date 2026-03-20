# 02 - Sistema de Permisos

## Los 3 Niveles de Permiso

| Nivel | Comportamiento |
|-------|---------------|
| **allow** | Se ejecuta sin preguntar |
| **ask** | Pide confirmación al usuario (por defecto) |
| **deny** | Bloqueado, no se puede ejecutar |

---

## Sintaxis de Permisos

### Por herramienta completa

```json
"allow": ["Read", "Glob", "Grep"]
```

### Por herramienta con patrón

```json
"allow": [
  "Bash(npm test:*)",        // Solo comandos npm test:xxx
  "Bash(git status)",        // Solo git status
  "Edit(src/**)",            // Editar solo en src/
  "Write(tests/**)"          // Escribir solo en tests/
]
```

### Patrones con wildcards

| Patrón | Significado |
|--------|-----------|
| `"Read"` | Todo Read |
| `"Bash(npm *)"` | Cualquier comando npm |
| `"Edit(src/**)"` | Editar archivos en src/ recursivo |
| `"Write(*.test.ts)"` | Escribir solo archivos test |
| `"Bash(git*)"` | Cualquier comando git |

---

## Herramientas Disponibles

| Herramienta | Qué hace | Riesgo |
|-------------|---------|--------|
| **Read** | Leer archivos | Bajo |
| **Glob** | Buscar archivos por patrón | Bajo |
| **Grep** | Buscar contenido en archivos | Bajo |
| **Write** | Crear archivos nuevos | Medio |
| **Edit** | Modificar archivos existentes | Medio |
| **Bash** | Ejecutar comandos shell | Alto |
| **WebFetch** | Hacer peticiones HTTP | Medio |
| **WebSearch** | Buscar en internet | Bajo |
| **Task** | Lanzar subagentes | Bajo |
| **TodoWrite** | Gestionar lista de tareas | Bajo |

---

## Modos de Operación

### 1. Normal (por defecto)

Claude pide confirmación para Write, Edit y Bash según la configuración de permisos.

### 2. Auto-accept Edits (acceptEdits)

Acepta automáticamente ediciones de archivos sin preguntar.
Bash y Write siguen pidiendo confirmación.

```bash
# Activar desde CLI
claude --permission-mode acceptEdits
```

### 3. Plan Mode

Claude solo propone, no ejecuta. Activar con `Shift+Tab` o `/plan`.

### 4. Delegate Mode

Claude puede delegar trabajo a subagentes con permisos más amplios.
Útil para equipos donde el líder revisa y los subagentes ejecutan.

### 5. Bypass Permissions (bypassPermissions)

**Peligroso**: No pide confirmación para nada. Solo usar en CI/CD controlado.

```bash
claude -p "ejecuta tests" --dangerously-skip-permissions
```

---

## Configuración Recomendada por Rol

### Desarrollador Backend

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep",
      "Bash(pytest*)", "Bash(python -m pytest*)",
      "Bash(make test*)", "Bash(make lint*)",
      "Bash(git status)", "Bash(git diff*)", "Bash(git log*)",
      "Edit(src/**)", "Write(tests/**)"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)",
      "Bash(pip install*)",
      "Bash(alembic downgrade*)",
      "Write(config/production*)",
      "Edit(alembic/env.py)"
    ]
  }
}
```

### Desarrollador Frontend

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep",
      "Bash(npm test*)", "Bash(npm run lint*)",
      "Bash(npx vitest*)",
      "Bash(git status)", "Bash(git diff*)",
      "Edit(src/**)", "Write(src/components/**)"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)",
      "Bash(npm publish*)", "Bash(npm install*)",
      "Write(vite.config*)", "Write(.env*)"
    ]
  }
}
```

### DevOps

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep",
      "Bash(docker*)", "Bash(kubectl get*)",
      "Bash(terraform plan*)",
      "Edit(infra/**)", "Edit(.github/**)"
    ],
    "deny": [
      "Bash(terraform apply*)",
      "Bash(kubectl delete*)",
      "Bash(docker push*)",
      "Write(.env*)", "Write(*secret*)"
    ]
  }
}
```

### QA

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep",
      "Bash(npm test*)", "Bash(pytest*)",
      "Bash(npx playwright*)",
      "Write(tests/**)", "Edit(tests/**)"
    ],
    "deny": [
      "Bash(rm *)", "Bash(sudo *)",
      "Edit(src/**)",
      "Write(src/**)"
    ]
  }
}
```

---

## Regla de Oro: deny Siempre Gana

```
Si CUALQUIER nivel dice deny → BLOQUEADO
No importa si otro nivel dice allow.
deny es absoluto.
```

Ejemplo:

```json
// Project settings
{ "permissions": { "allow": ["Bash(npm install*)"] } }

// Managed settings (empresa)
{ "permissions": { "deny": ["Bash(npm install*)"] } }

// Resultado: npm install BLOQUEADO (deny gana)
```

---

## Ver y Modificar Permisos

```bash
# En sesión interactiva
/permissions              # Ver permisos actuales

# Desde CLI
claude config list        # Ver toda la config
claude config set permissions.allow '["Read","Glob"]'
```
