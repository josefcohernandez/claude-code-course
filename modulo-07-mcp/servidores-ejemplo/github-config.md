# Configuración MCP: GitHub

## Settings

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

## Variable de Entorno

```bash
# Crear token: GitHub > Settings > Developer settings > Personal access tokens
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
```

Permisos del token: `repo`, `read:org` (mínimo).

## Herramientas Disponibles

| Herramienta | Descripción |
|-------------|------------|
| `list_issues` | Listar issues de un repo |
| `create_issue` | Crear un issue |
| `list_pull_requests` | Listar PRs |
| `get_file_contents` | Leer archivo de un repo |
| `search_repositories` | Buscar repos |

## Nota

Para la mayoría de operaciones de GitHub, la CLI `gh` integrada con Bash
es una alternativa viable sin overhead de MCP:

```bash
gh issue list
gh pr list
gh api repos/owner/repo/contents/file.txt
```

Usa MCP GitHub si necesitas operaciones más complejas o frecuentes.
