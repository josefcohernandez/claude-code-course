# 04 - Deferred Tools y Tool Search

Este tema cubre cómo el número de servidores MCP afecta al consumo de tokens,
qué son las Deferred Tools y cómo reducen el overhead de contexto, y cómo
configurar Tool Search para activar herramientas bajo demanda.

## Conceptos clave

### El problema: overhead de tokens con muchos MCP servers

Cuando Claude Code se inicia con varios MCP servers configurados, debe cargar en el contexto el schema completo de todas las herramientas disponibles. Cada herramienta consume tokens porque Claude necesita conocer su nombre, descripción, parámetros y tipos para poder invocarla.

Con 5 servidores MCP con 10 herramientas cada uno (50 herramientas en total), el overhead puede llegar a 15.000-25.000 tokens solo en definiciones, antes de que escribas una sola línea de prompt. Esto:

- Reduce el espacio disponible para código y contexto del proyecto
- Aumenta el coste de cada mensaje
- Puede degradar la calidad en proyectos con context windows ajustadas

Este problema está directamente relacionado con la gestión de la ventana de contexto explicada en el Capítulo 3.

### Deferred Tools

Las Deferred Tools son herramientas MCP que no se cargan en el contexto al iniciar la sesión. En lugar de incluir su schema completo, Claude Code solo registra su nombre. Esto permite que existan cientos de herramientas disponibles sin saturar el contexto inicial.

| Herramienta normal | Herramienta diferida |
|--------------------|----------------------|
| Schema completo cargado al inicio | Solo el nombre registrado al inicio |
| ~200-500 tokens por herramienta | ~50 tokens por herramienta |
| Invocable inmediatamente | Requiere activación previa con ToolSearch |
| Siempre visible para Claude | Invisible hasta que se busca |

### Tool Search

Tool Search es la herramienta que Claude usa para buscar y activar herramientas diferidas bajo demanda. Una vez que una herramienta diferida ha sido activada mediante Tool Search, Claude puede invocarla normalmente durante el resto de la sesión.

**Modos de búsqueda:**

```
# Búsqueda por nombre exacto (activa las herramientas indicadas)
select:Read,Edit,Grep

# Búsqueda por keywords (activa las más relevantes para esas palabras)
notebook jupyter

# Búsqueda con filtro de nombre (el + indica prefijo de nombre)
+slack send
```

El parámetro `max_results` controla cuántas herramientas se activan en cada búsqueda.

## Ejemplos prácticos

### Configuración de Tool Search en settings

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "${POSTGRES_URL}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_TOKEN": "${SLACK_TOKEN}"
      }
    }
  },
  "toolSearch": "auto:5"
}
```

El valor `"auto:5"` indica que Claude Code cargará automáticamente las 5 herramientas más relevantes para cada mensaje, en lugar de cargar todas al inicio.

### Variantes de configuración de toolSearch

```json
{
  "toolSearch": "auto:5"
}
```

```json
{
  "toolSearch": "auto:10"
}
```

```json
{
  "toolSearch": "manual"
}
```

| Valor | Comportamiento |
|-------|---------------|
| `"auto:5"` | Carga automáticamente las 5 herramientas más relevantes por mensaje |
| `"auto:10"` | Carga automáticamente las 10 más relevantes |
| `"manual"` | Solo activa herramientas cuando Claude invoca Tool Search explícitamente |
| No configurado | Todas las herramientas se cargan al inicio (comportamiento por defecto) |

### Estimación del impacto en tokens

```
Sin Deferred Tools (configuración por defecto):
  - 3 servidores MCP x 10 herramientas = 30 herramientas
  - 30 herramientas x ~400 tokens promedio = ~12.000 tokens en definiciones
  - Por cada mensaje enviado se incluyen esos 12.000 tokens

Con Deferred Tools y toolSearch: "auto:5":
  - 30 herramientas diferidas x ~50 tokens = ~1.500 tokens (nombres)
  - 5 herramientas activadas x ~400 tokens = ~2.000 tokens (schemas)
  - Total por mensaje: ~3.500 tokens → ahorro de ~8.500 tokens por mensaje
```

### Ejemplo práctico: proyecto con 3 MCP servers

Configuración en `.claude/settings.json`:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "${POSTGRES_URL}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/<tu-usuario>/proyectos"
      ]
    }
  },
  "toolSearch": "auto:5"
}
```

Con esta configuración:
1. Al iniciar la sesión, solo se cargan los nombres de todas las herramientas
2. Al escribir un mensaje sobre base de datos, Tool Search activa automáticamente las 5 herramientas de postgres más relevantes
3. Al cambiar a un mensaje sobre GitHub, activa las herramientas de github pertinentes
4. Las herramientas ya activadas permanecen disponibles durante la sesión

### Verificar herramientas activas en la sesión

```bash
# Ver todas las herramientas MCP disponibles (activas y diferidas)
/mcp

# Ver solo las herramientas actualmente cargadas en contexto
/tools
```

## Errores comunes

**No configurar toolSearch cuando tienes más de 3 MCP servers**: Con muchos servidores, el overhead de tokens puede ser mayor que el valor que aportan las herramientas. Configura siempre `toolSearch` en proyectos con varios servidores.

**Usar `"auto:1"` o valores muy bajos**: Si se activan pocas herramientas automáticamente, Claude puede no tener acceso a las que necesita en el momento adecuado, generando errores de "herramienta no disponible".

**Confundir Deferred Tools con deshabilitar un MCP server**: Las herramientas diferidas siguen disponibles; simplemente se activan bajo demanda. Deshabilitar un servidor las elimina completamente.

**Mezclar Deferred Tools con servidores de muchas herramientas sin toolSearch manual**: Si un servidor tiene 50 herramientas y usas `"manual"`, Claude puede no activar la correcta a tiempo. Prefiere `"auto:N"` para servidores grandes.

## Resumen

- Cada herramienta MCP cargada en contexto consume ~200-500 tokens; con muchos servidores, el overhead es significativo
- Las Deferred Tools registran solo el nombre (~50 tokens) y cargan el schema completo solo cuando se necesitan
- Tool Search busca y activa herramientas diferidas por nombre exacto, keywords o prefijo
- `"toolSearch": "auto:5"` en settings activa automáticamente las 5 herramientas más relevantes por mensaje
- El ahorro típico con 3 servidores y 10 herramientas cada uno es de ~8.500 tokens por mensaje
- Usa `/mcp` para verificar qué servidores y herramientas están disponibles en la sesión
