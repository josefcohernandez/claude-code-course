# Configuracion MCP: Filesystem

## Settings

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/ruta/a/directorio/permitido"
      ]
    }
  }
}
```

## Directorios Permitidos

El ultimo argumento define el directorio raiz accesible.
Puedes permitir multiples directorios:

```json
{
  "args": [
    "-y",
    "@modelcontextprotocol/server-filesystem",
    "/home/user/docs",
    "/home/user/data"
  ]
}
```

## Herramientas Disponibles

| Herramienta | Descripcion |
|-------------|------------|
| `read_file` | Leer contenido de un archivo |
| `write_file` | Escribir contenido a un archivo |
| `list_directory` | Listar archivos de un directorio |
| `create_directory` | Crear directorio |
| `move_file` | Mover/renombrar archivo |
| `search_files` | Buscar archivos por patron |
| `get_file_info` | Metadata de un archivo |

## Nota

Para la mayoria de operaciones con archivos del proyecto actual,
las herramientas built-in (Read, Write, Edit, Glob, Grep) son **mejores**
y no tienen overhead de MCP.

Usa filesystem MCP cuando necesites acceder a archivos **fuera** del
directorio del proyecto actual.
