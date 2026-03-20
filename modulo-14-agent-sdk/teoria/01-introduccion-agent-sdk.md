# Qué es el Claude Agent SDK

El **Claude Agent SDK** es la biblioteca oficial de Anthropic para construir agentes autónomos en Python y TypeScript. Proporciona exactamente las mismas herramientas, el mismo bucle agéntico y la misma gestión de contexto que alimentan Claude Code, pero de forma programática y embebible en cualquier aplicación. Este capítulo explica qué ofrece, cuándo usarlo y cómo instalarlo.

---

## Conceptos clave

### Qué es el Agent SDK

En lugar de interactuar con el modelo via un bucle de herramientas que tú tienes que implementar manualmente, el Agent SDK te da un agente completo en una sola llamada:

```python
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Encuentra y corrige el bug en auth.py",
    options=ClaudeAgentOptions(allowed_tools=["Read", "Edit", "Bash"]),
):
    print(message)
```

Claude lee el archivo, encuentra el problema, edita el código y verifica el resultado, todo de forma autónoma.

> Nota: el SDK se llamaba anteriormente "Claude Code SDK". Si encuentras referencias al nombre antiguo en documentación externa, hacen referencia al mismo producto.

### Herramientas integradas sin configuración adicional

El SDK incluye las mismas herramientas que usa Claude Code internamente:

| Herramienta | Qué hace |
|-------------|----------|
| `Read` | Lee cualquier archivo del directorio de trabajo |
| `Write` | Crea nuevos archivos |
| `Edit` | Hace ediciones precisas en archivos existentes |
| `Bash` | Ejecuta comandos de terminal, scripts, operaciones git |
| `Glob` | Busca archivos por patrón (`**/*.ts`, `src/**/*.py`) |
| `Grep` | Busca en contenido de archivos con regex |
| `WebSearch` | Busca en la web información actualizada |
| `WebFetch` | Obtiene y parsea contenido de páginas web |
| `AskUserQuestion` | Hace preguntas al usuario con opciones de respuesta |

No tienes que implementar la ejecución de herramientas: el SDK lo gestiona.

---

## Cuándo usar cada herramienta

Anthropic ofrece varias formas de usar Claude. Elegir la correcta ahorra tiempo y reduce complejidad.

### API directa (Client SDK / `anthropic`)

Usa la API directa cuando necesitas llamadas de completion simples o control total sobre el bucle de herramientas:

```python
# Con anthropic (Client SDK): tú implementas el bucle
import anthropic

client = anthropic.Anthropic()
response = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Explica este error: ..."}]
)
print(response.content[0].text)
```

Ideal para: chatbots simples, completions de texto, clasificación, extracción de datos estructurados.

### Subagentes de Claude Code (Capítulo 9)

Los subagentes de Claude Code son agentes especializados que operan dentro de tu sesión interactiva de Claude Code. Se definen con archivos `.md` y frontmatter YAML:

```markdown
---
name: code-reviewer
description: Revisa calidad y seguridad del código
tools: Read, Glob, Grep
model: sonnet
---
Eres un revisor de código senior...
```

Ideal para: automatizar tareas repetitivas dentro de tu flujo de desarrollo, mantener contexto limpio en sesiones largas, delegar investigación a agentes especializados.

### Agent SDK

El Agent SDK es la opción cuando quieres construir un producto o pipeline que use agentes autónomos fuera de Claude Code:

```python
# Con Agent SDK: el SDK gestiona el bucle agéntico
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Analiza toda la carpeta src/ y genera un informe de seguridad",
    options=ClaudeAgentOptions(
        allowed_tools=["Read", "Glob", "Grep"],
        system_prompt="Eres un experto en seguridad de aplicaciones."
    ),
):
    ...
```

Ideal para: servicios que exponen capacidades agénticas via API, automatización de CI/CD más allá de GitHub Actions, CLIs especializados para tu equipo, pipelines de procesamiento de datos con IA, productos SaaS que integran agentes Claude.

### Tabla de decisión

| Escenario | Herramienta recomendada |
|-----------|------------------------|
| Pregunta puntual, completion simple | API directa |
| Automatizar en mi flujo de trabajo diario | Claude Code CLI |
| Delegar investigación en una sesión larga | Subagentes (Capítulo 9) |
| Construir un servicio o producto con agentes | Agent SDK |
| Pipeline de CI/CD con lógica compleja | Agent SDK |
| Script de un solo uso que edita archivos | Claude Code CLI (`-p`) |

---

## Arquitectura del Agent SDK

El Agent SDK sigue el mismo patrón del bucle agéntico que Claude Code:

```
Tu aplicación
     |
     | query(prompt, options)
     v
+-----------------------------+
|        Agent SDK            |
|                             |
|  Prompt ──> Claude ──> ?    |
|                      |      |
|              ¿Tool use?     |
|                 |           |
|         Ejecutar tool       |
|                 |           |
|         Resultado ──> Claude|
|                      |      |
|              ¿Terminado?    |
|               si  |  no    |
|                   |   └──> repite
|              Resultado final|
+-----------------------------+
     |
     | AsyncIterator[Message]
     v
Tu código (procesa mensajes)
```

Cada iteración del bucle genera mensajes que puedes procesar en tiempo real: razonamiento de Claude, llamadas a herramientas, resultados de herramientas y el resultado final.

---

## Instalación

### Python

Requiere Python 3.10 o superior.

```bash
# Con pip (entorno virtual recomendado)
python3 -m venv .venv
source .venv/bin/activate
pip install claude-agent-sdk
```

```bash
# Con uv (alternativa rápida)
uv init && uv add claude-agent-sdk
```

### TypeScript / Node.js

Requiere Node.js 18 o superior.

```bash
npm install @anthropic-ai/claude-agent-sdk
```

### Configurar la API key

```bash
export ANTHROPIC_API_KEY=<tu-api-key>
```

El SDK también admite proveedores alternativos:

```bash
# Amazon Bedrock
export CLAUDE_CODE_USE_BEDROCK=1
# Configurar credenciales AWS de forma habitual

# Google Vertex AI
export CLAUDE_CODE_USE_VERTEX=1
# Configurar credenciales Google Cloud de forma habitual

# Microsoft Azure AI Foundry
export CLAUDE_CODE_USE_FOUNDRY=1
# Configurar credenciales Azure de forma habitual
```

---

## Errores comunes

**No usar entorno virtual en Python.** Instalar el SDK globalmente puede generar conflictos de dependencias. Usa siempre un entorno virtual o `uv`.

**Confundir el Agent SDK con el Client SDK (`anthropic`).** Son dos bibliotecas distintas. El Client SDK (`pip install anthropic`) es para llamadas directas a la API. El Agent SDK (`pip install claude-agent-sdk`) incluye el bucle agéntico y la ejecución de herramientas.

**Intentar usar `claude.ai` login en aplicaciones de terceros.** El Agent SDK requiere autenticación por API key. El login de claude.ai no está disponible para aplicaciones de terceros salvo aprobación expresa de Anthropic.

**No manejar la naturaleza asíncrona del SDK.** En Python, `query()` devuelve un `AsyncIterator`. Debes usar `async for` dentro de una función `async def` y ejecutarla con `asyncio.run()`.

---

## Resumen

- El Agent SDK es la biblioteca oficial para construir agentes Claude en tus propias aplicaciones
- Incluye herramientas integradas (Read, Edit, Bash, etc.) sin que tengas que implementar su ejecución
- Usa la API directa para completions simples, subagentes de Claude Code para tu flujo de desarrollo, y el Agent SDK para construir productos y pipelines con agentes
- La arquitectura sigue el mismo bucle agéntico que Claude Code: explorar, planificar, usar herramientas, verificar
- Instalación: `pip install claude-agent-sdk` (Python) o `npm install @anthropic-ai/claude-agent-sdk` (TypeScript)
- Autenticación por API key; también compatible con Bedrock, Vertex AI y Azure
