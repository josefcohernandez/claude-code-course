# Líneas de `.gitignore` para proyectos con Claude Code

Añade estas líneas a tu `.gitignore` según corresponda.

## Siempre incluir

```gitignore
# Variables de entorno con secretos
.env
.env.local
.env.*.local

# Configuración local de Claude Code (preferencias personales, no del equipo)
.claude/settings.local.json
CLAUDE.local.md
```

## Según el stack

### Node.js
```gitignore
node_modules/
dist/
coverage/
*.log
```

### Python
```gitignore
__pycache__/
*.pyc
.venv/
venv/
htmlcov/
.coverage
*.egg-info/
```

### Go
```gitignore
bin/
vendor/
```

### General
```gitignore
# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Docker
*.db
data/

# Builds
build/
tmp/
```

## Lo que SÍ debe estar en git (NO ignorar)

```gitignore
# Estos archivos son para el equipo:
CLAUDE.md                    # Memoria del proyecto
.claude/settings.json        # Permisos del equipo
.claude/rules/*.md           # Reglas compartidas
.claude/agents/*.md          # Subagentes del proyecto
.claude/skills/*/SKILL.md    # Skills del proyecto
.mcp.json                    # Servidores MCP del proyecto
```
