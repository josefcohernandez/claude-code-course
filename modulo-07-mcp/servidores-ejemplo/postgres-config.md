# Configuracion MCP: PostgreSQL

## Settings

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

## Variable de Entorno

```bash
export DATABASE_URL="postgresql://usuario:password@localhost:5432/mi_database"
```

## Herramientas Disponibles

| Herramienta | Descripcion |
|-------------|------------|
| `query` | Ejecutar SELECT queries |
| `list_tables` | Listar tablas de la BD |
| `describe_table` | Schema de una tabla |

## Permisos Recomendados

```json
{
  "permissions": {
    "allow": [
      "mcp__postgres__query",
      "mcp__postgres__list_tables",
      "mcp__postgres__describe_table"
    ],
    "deny": [
      "mcp__postgres__execute"
    ]
  }
}
```

## Queries de Ejemplo

```
> "Que tablas hay en la base de datos?"
> "Muestra el schema de la tabla users"
> "Dame los ultimos 10 pedidos con el nombre del usuario"
> "Cuantos usuarios se registraron este mes?"
```
