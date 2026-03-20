# 01 - Qué es MCP (Model Context Protocol)

## Definición

MCP es un **estándar abierto** creado por Anthropic que permite a modelos de IA
conectarse con herramientas y datos externos. Es como un "USB para IA":
un protocolo universal para conectar cualquier herramienta.

---

## Arquitectura

```
Claude Code (Cliente MCP)
    ↕ JSON-RPC
Servidor MCP
    ↕
Herramienta/Servicio (PostgreSQL, GitHub, Slack, etc.)
```

Claude Code actúa como **cliente MCP** que se comunica con **servidores MCP**.
Cada servidor expone herramientas (tools) que Claude puede invocar.

---

## Qué Expone un Servidor MCP

| Tipo | Descripción | Ejemplo |
|------|------------|---------|
| **Tools** | Acciones ejecutables | `query_database`, `create_issue` |
| **Resources** | Datos consultables | Schema de BD, archivos |
| **Prompts** | Templates de prompts | Prompts predefinidos para tareas comunes |

---

## Transportes

| Transporte | Cómo funciona | Uso típico |
|-----------|--------------|-----------|
| **stdio** | Proceso hijo, comunicación por stdin/stdout | Local (más común) |
| **HTTP/SSE** | Servidor HTTP con Server-Sent Events | Remoto |
| **OAuth 2.0** | HTTP con autenticación OAuth | Servicios cloud |

La mayoría de servidores MCP usan **stdio**: Claude Code lanza el proceso
del servidor y se comunica por stdin/stdout.

---

## Servidores MCP Populares

| Servidor | Qué hace | Herramientas |
|----------|---------|-------------|
| **PostgreSQL** | Consultar/modificar BD | query, list_tables, describe_table |
| **GitHub** | Issues, PRs, repos | create_issue, list_prs, get_file |
| **Filesystem** | Acceso a archivos | read_file, write_file, list_directory |
| **Slack** | Mensajes y canales | send_message, list_channels |
| **Puppeteer** | Navegador web | navigate, screenshot, click |
| **Memory** | Almacenamiento persistente | store, retrieve, search |
| **SQLite** | BD local | query, execute |
| **Brave Search** | Búsqueda web | search |

Hay cientos de servidores MCP disponibles. Catálogo: https://github.com/modelcontextprotocol/servers

---

## Impacto en Tokens

**Cada servidor MCP activo consume tokens** en cada mensaje, porque Claude
necesita conocer las herramientas disponibles:

| Servidores activos | Overhead por mensaje |
|-------------------|---------------------|
| 0 | 0 tokens |
| 1 (5 tools) | ~500-1,000 tokens |
| 3 (15 tools) | ~2,000-4,000 tokens |
| 5+ (30+ tools) | ~5,000-10,000 tokens |

Esto se aplica a **cada mensaje**, así que en una sesión de 20 mensajes
con 3 MCPs activos, son ~40K-80K tokens extra solo de overhead.

---

## MCP vs Herramientas Built-in

Claude Code ya tiene herramientas integradas (Read, Write, Edit, Bash, etc.).
MCP añade herramientas **externas**:

| Built-in | MCP |
|----------|-----|
| Read/Write/Edit archivos | Consultar base de datos |
| Bash (comandos shell) | Interactuar con APIs |
| Grep/Glob (búsqueda) | Servicios cloud |
| WebFetch/WebSearch | Herramientas personalizadas |

**Regla**: Si puedes hacerlo con Bash o built-in, no necesitas MCP.
MCP es para integraciones que no se pueden hacer con shell commands.

---

## Cuándo Usar MCP

| Escenario | ¿MCP recomendado? |
|-----------|-----------------|
| Consultar PostgreSQL | Sí (mejor que Bash + psql) |
| Crear issues en GitHub | Depende (gh CLI funciona bien) |
| Leer archivos locales | No (Read built-in es mejor) |
| Interactuar con Jira | Sí (no hay buena CLI alternativa) |
| Buscar en Slack | Sí |
| Ejecutar scripts | No (Bash built-in) |
