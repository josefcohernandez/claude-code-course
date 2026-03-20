# Construir un Agente Básico

La función `query()` es el punto de entrada del SDK. Devuelve un iterador asíncrono de mensajes que representan el progreso del agente en tiempo real. Este capítulo explica su estructura, las opciones de configuración disponibles y un ejemplo completo con manejo de todos los tipos de mensaje.

---

## Conceptos clave

### La función `query()`

Los mensajes que emite el iterador son:

- Mensajes de razonamiento de Claude (texto)
- Llamadas a herramientas (qué herramienta y con qué argumentos)
- Resultados de herramientas (lo que devolvió cada herramienta)
- Mensaje de resultado final

En Python, `query()` es una función asíncrona. Necesitas llamarla dentro de un contexto `async` y procesarla con `async for`.

### Estructura mínima en Python

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions


async def main():
    async for message in query(
        prompt="¿Qué archivos hay en este directorio?",
        options=ClaudeAgentOptions(
            allowed_tools=["Bash", "Glob"],
        ),
    ):
        if hasattr(message, "result"):
            print(message.result)


asyncio.run(main())
```

Este agente puede usar las herramientas `Bash` y `Glob` para explorar el directorio de trabajo. Claude decide autónomamente cuáles usar según la tarea.

### Estructura mínima en TypeScript

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

async function main() {
    for await (const message of query({
        prompt: "¿Qué archivos hay en este directorio?",
        options: {
            allowedTools: ["Bash", "Glob"],
        },
    })) {
        if ("result" in message) {
            console.log(message.result);
        }
    }
}

main();
```

---

## Ejemplo completo: Agente de análisis de código

Este ejemplo muestra un agente que analiza la estructura de un proyecto y genera un resumen. Incluye manejo de todos los tipos de mensaje.

### Python

```python
import asyncio
from claude_agent_sdk import (
    query,
    ClaudeAgentOptions,
    AssistantMessage,
    ResultMessage,
)


async def analizar_proyecto(ruta: str) -> str:
    """Analiza la estructura de un proyecto y devuelve un resumen."""
    resumen = []

    async for message in query(
        prompt=f"Analiza la estructura del proyecto en {ruta}. "
               "Describe los directorios principales, el lenguaje de programación, "
               "las dependencias y el propósito general del proyecto.",
        options=ClaudeAgentOptions(
            allowed_tools=["Read", "Glob", "Grep", "Bash"],
            permission_mode="acceptEdits",
            system_prompt=(
                "Eres un asistente de análisis de código. "
                "Examina proyectos de software y genera resúmenes claros y concisos. "
                "Responde siempre en español."
            ),
        ),
    ):
        # Texto del razonamiento de Claude
        if isinstance(message, AssistantMessage):
            for block in message.content:
                if hasattr(block, "text") and block.text:
                    print(f"[Claude] {block.text}")
                elif hasattr(block, "name"):
                    print(f"[Herramienta] {block.name}")

        # Resultado final del agente
        elif isinstance(message, ResultMessage):
            print(f"\n--- Resultado ({message.subtype}) ---")
            if hasattr(message, "result"):
                resumen.append(message.result)

    return "\n".join(resumen)


asyncio.run(analizar_proyecto("./src"))
```

### TypeScript

```typescript
import {
    query,
    AssistantMessage,
    ResultMessage,
} from "@anthropic-ai/claude-agent-sdk";

async function analizarProyecto(ruta: string): Promise<string> {
    const resumen: string[] = [];

    for await (const message of query({
        prompt: `Analiza la estructura del proyecto en ${ruta}. ` +
            "Describe los directorios principales, el lenguaje de programación, " +
            "las dependencias y el propósito general del proyecto.",
        options: {
            allowedTools: ["Read", "Glob", "Grep", "Bash"],
            permissionMode: "acceptEdits",
            systemPrompt:
                "Eres un asistente de análisis de código. " +
                "Examina proyectos de software y genera resúmenes claros y concisos. " +
                "Responde siempre en español.",
        },
    })) {
        // Texto del razonamiento de Claude
        if (message.type === "assistant" && message.message?.content) {
            for (const block of message.message.content) {
                if ("text" in block && block.text) {
                    console.log(`[Claude] ${block.text}`);
                } else if ("name" in block) {
                    console.log(`[Herramienta] ${block.name}`);
                }
            }
        }

        // Resultado final del agente
        if (message.type === "result") {
            console.log(`\n--- Resultado (${message.subtype}) ---`);
            if ("result" in message) {
                resumen.push(message.result as string);
            }
        }
    }

    return resumen.join("\n");
}

analizarProyecto("./src").then(console.log);
```

---

## El bucle agéntico en detalle

Cuando llamas a `query()`, el SDK inicia el siguiente proceso automáticamente:

```
query(prompt, options)
       |
       v
   [1] Claude recibe el prompt y el system prompt
       |
       v
   [2] Claude decide: ¿necesito usar una herramienta?
       |
       ├── Sí: llama a la herramienta (ej: Read("auth.py"))
       |         |
       |         v
       |    El SDK ejecuta la herramienta
       |         |
       |         v
       |    Resultado enviado de vuelta a Claude
       |         |
       |         └──> vuelve a [2]
       |
       └── No: genera la respuesta final
                 |
                 v
            ResultMessage (subtype: "success" o "error")
```

Cada paso genera mensajes que tu código puede consumir del iterador. El bucle termina cuando Claude considera que la tarea está completa o se alcanza el límite de turnos.

---

## Opciones de configuración

La clase `ClaudeAgentOptions` (Python) u `options` (TypeScript) controla el comportamiento del agente:

### Herramientas (`allowed_tools` / `allowedTools`)

Define qué herramientas puede usar el agente. Solo las herramientas listadas están disponibles:

```python
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Glob", "Grep"],        # Solo lectura
)

options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Glob", "Bash"],  # Lectura y escritura
)

options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Bash", "Glob", "Grep", "WebSearch"],  # Completo
)
```

### Modo de permisos (`permission_mode` / `permissionMode`)

Controla cuánta supervisión humana requiere el agente:

| Modo | Comportamiento | Caso de uso |
|------|---------------|-------------|
| `acceptEdits` | Auto-aprueba ediciones de archivos; pregunta por otras acciones | Desarrollo de confianza |
| `bypassPermissions` | Ejecuta todo sin confirmaciones | CI/CD en entornos aislados |
| `default` | Requiere callback `canUseTool` para cada aprobación | Control granular personalizado |

```python
# Para scripts automatizados en CI (entorno aislado)
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Bash"],
    permission_mode="bypassPermissions",
)

# Para ejecución supervisada
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Bash"],
    permission_mode="acceptEdits",
)
```

### System prompt

Define el rol y comportamiento del agente:

```python
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Glob", "Grep"],
    system_prompt=(
        "Eres un experto en seguridad de aplicaciones web. "
        "Analiza el código en busca de vulnerabilidades OWASP Top 10. "
        "Prioriza los hallazgos por severidad: crítica, alta, media, baja."
    ),
)
```

### Límite de turnos

```python
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Bash"],
    max_turns=20,        # Máximo de iteraciones del bucle agéntico
)
```

### Modelo

```python
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Glob"],
    model="claude-haiku-4-5",   # Modelo más rápido y económico para tareas simples
)

options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Bash"],
    model="claude-opus-4-6",    # Modelo más potente para tareas complejas
)
```

---

## Errores comunes

**Olvidar `await` o usar `for` en lugar de `async for` en Python.** La función `query()` devuelve un `AsyncIterator`. Sin `async for` obtendrás un error de tipo en tiempo de ejecución.

```python
# INCORRECTO
for message in query(prompt="...", options=...):  # Error: no es iterable síncrono
    ...

# CORRECTO
async for message in query(prompt="...", options=...):
    ...
```

**Definir herramientas que el agente necesita pero no incluir en `allowed_tools`.** Si el agente necesita leer archivos pero `Read` no está en la lista, Claude no podrá hacerlo aunque lo intente.

**Usar `bypassPermissions` fuera de entornos aislados.** Este modo ejecuta todo sin confirmaciones. Úsalo solo en contenedores o entornos CI/CD sin acceso a datos sensibles.

**No manejar el `ResultMessage` de error.** El agente puede terminar con `subtype="error"`. Siempre comprueba el subtipo antes de asumir éxito:

```python
elif isinstance(message, ResultMessage):
    if message.subtype == "success":
        print("Éxito:", message.result)
    else:
        print("Error en el agente:", message.subtype)
```

---

## Resumen

- `query(prompt, options)` es el punto de entrada del SDK; devuelve un `AsyncIterator` de mensajes
- `ClaudeAgentOptions` controla herramientas disponibles, permisos, system prompt y modelo
- El bucle agéntico es automático: Claude decide qué herramientas usar, el SDK las ejecuta, el resultado vuelve a Claude
- Usa `permission_mode="acceptEdits"` para desarrollo y `"bypassPermissions"` en CI/CD aislado
- El agente termina cuando Claude considera la tarea completa o se alcanza `max_turns`
- Siempre comprueba el subtipo del `ResultMessage` para distinguir éxito de error
