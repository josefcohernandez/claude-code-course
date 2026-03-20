# Ejercicios Prácticos: Claude Agent SDK

## Contexto

Eres un desarrollador de una empresa de software que quiere automatizar tareas de revisión y análisis de código usando el Agent SDK de Anthropic. A lo largo de estos cinco ejercicios construirás agentes cada vez más complejos, desde un análisis básico de directorio hasta un CLI especializado que sustituye un proceso manual de tu equipo.

## Requisitos previos

| Capítulo | Razón |
|----------|-------|
| Capítulo 1 (Introducción) | Concepto de bucle agéntico |
| Capítulo 7 (MCP) | Protocolo MCP y servidores |
| Capítulo 9 (Agentes) | Subagentes y su configuración |
| 01-introduccion-agent-sdk.md | Instalación y cuándo usar el SDK |
| 02-construir-agente-basico.md | Estructura de `query()` y opciones |
| 03-herramientas-y-patrones-avanzados.md | Patrones, MCP, sesiones, hooks |
| 04-integracion-con-claude-code.md | Deploy como CLI y servicio |

---

## Ejercicio 1: Agente básico que analiza un directorio

### Objetivo

Crear un agente que explore un directorio, identifique el tipo de proyecto y genere un resumen estructurado con la información clave.

### Instrucciones

1. Crea un directorio de trabajo y un entorno virtual:

    ```bash
    mkdir agente-sdk-ejercicios
    cd agente-sdk-ejercicios
    python3 -m venv .venv
    source .venv/bin/activate
    pip install claude-agent-sdk
    ```

2. Configura tu API key:

    ```bash
    export ANTHROPIC_API_KEY=<tu-api-key>
    ```

3. Crea el archivo `ejercicio1.py` con el siguiente código base:

    ```python
    import asyncio
    from claude_agent_sdk import query, ClaudeAgentOptions, AssistantMessage, ResultMessage


    async def analizar_directorio(ruta: str) -> None:
        """
        Analiza un directorio y genera un resumen del proyecto.
        """
        print(f"Analizando: {ruta}\n")

        async for message in query(
            prompt=(
                f"Analiza el proyecto en el directorio {ruta}. "
                "Genera un resumen que incluya: "
                "1. Lenguaje principal y versión (si se puede determinar) "
                "2. Propósito del proyecto (1-2 frases) "
                "3. Estructura de directorios principales "
                "4. Dependencias externas principales "
                "5. Cómo ejecutar el proyecto (si hay instrucciones)"
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Read", "Glob", "Grep", "Bash"],
                permission_mode="acceptEdits",
                system_prompt=(
                    "Eres un asistente de análisis de proyectos de software. "
                    "Genera resúmenes concisos y útiles para desarrolladores. "
                    "Responde siempre en español."
                ),
            ),
        ):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if hasattr(block, "text") and block.text:
                        print(block.text, end="", flush=True)

            elif isinstance(message, ResultMessage):
                print(f"\n\n[Estado final: {message.subtype}]")


    if __name__ == "__main__":
        import sys
        ruta = sys.argv[1] if len(sys.argv) > 1 else "."
        asyncio.run(analizar_directorio(ruta))
    ```

4. Ejecuta el agente apuntando a un proyecto real:

    ```bash
    python ejercicio1.py /ruta/a/tu/proyecto
    ```

5. Experimenta cambiando el prompt para pedir información distinta (tests, linters, CI/CD).

### Criterios de éxito

- El agente imprime texto en tiempo real mientras trabaja (no espera al final)
- El resumen incluye las 5 secciones pedidas con información real del proyecto
- El estado final muestra `success`
- El código maneja correctamente los distintos tipos de mensaje (`AssistantMessage`, `ResultMessage`)

### Pistas

1. Si el agente no imprime nada, verifica que `ANTHROPIC_API_KEY` está configurada correctamente.
2. Si ves `error_max_turns`, el proyecto es muy grande. Acota el prompt a un subdirectorio específico.
3. Para ver todas las herramientas que usa el agente, añade impresión de los bloques con `name` dentro de `AssistantMessage`.

---

## Ejercicio 2: Agente con herramientas de lectura y escritura

### Objetivo

Crear un agente que lea archivos Python de un proyecto, identifique funciones sin type hints y las añada automáticamente editando los archivos.

### Instrucciones

1. Crea un archivo Python de ejemplo con funciones sin type hints:

    ```python
    # ejemplo.py
    def calcular_descuento(precio, porcentaje):
        if porcentaje < 0 or porcentaje > 100:
            raise ValueError("El porcentaje debe estar entre 0 y 100")
        return precio * (1 - porcentaje / 100)


    def formatear_precio(precio, moneda="EUR"):
        return f"{precio:.2f} {moneda}"


    def aplicar_impuesto(precio, tasa_impuesto):
        return precio * (1 + tasa_impuesto)
    ```

2. Crea el archivo `ejercicio2.py`:

    ```python
    import asyncio
    from claude_agent_sdk import query, ClaudeAgentOptions, AssistantMessage, ResultMessage


    async def agregar_type_hints(directorio: str) -> None:
        """
        Agrega type hints a funciones Python que no los tienen.
        """
        print(f"Procesando archivos Python en: {directorio}\n")

        async for message in query(
            prompt=(
                f"Busca todos los archivos Python en {directorio}. "
                "Para cada función o método que no tenga type hints en sus parámetros o retorno: "
                "1. Infiere los tipos correctos analizando el cuerpo de la función "
                "2. Agrega los type hints directamente en los archivos "
                "3. Si necesitas importar tipos (Optional, List, Dict, etc.), agrega los imports "
                "Muestra qué cambios hiciste en cada archivo."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Read", "Edit", "Glob", "Grep"],
                permission_mode="acceptEdits",
                system_prompt=(
                    "Eres un experto en Python moderno. "
                    "Agrega type hints precisos y completos siguiendo PEP 484. "
                    "Usa tipos del módulo 'typing' cuando sea necesario. "
                    "Para Python 3.10+, usa la sintaxis nativa (list[str] en lugar de List[str])."
                ),
            ),
        ):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if hasattr(block, "text") and block.text:
                        print(block.text, end="", flush=True)
                    elif hasattr(block, "name"):
                        print(f"\n[Usando herramienta: {block.name}]")

            elif isinstance(message, ResultMessage):
                estado = "Completado" if message.subtype == "success" else f"Error: {message.subtype}"
                print(f"\n\n[{estado}]")


    if __name__ == "__main__":
        import sys
        directorio = sys.argv[1] if len(sys.argv) > 1 else "."
        asyncio.run(agregar_type_hints(directorio))
    ```

3. Ejecuta el agente:

    ```bash
    python ejercicio2.py .
    ```

4. Verifica que `ejemplo.py` ha sido modificado con los type hints correctos.

### Criterios de éxito

- El agente identifica correctamente las funciones sin type hints
- Los type hints añadidos son correctos y ejecutables (no causan errores de sintaxis)
- Los imports necesarios se añaden automáticamente
- El archivo `ejemplo.py` original es modificado directamente (no se crea uno nuevo)

### Pistas

1. Usa `git diff ejemplo.py` para ver exactamente qué cambió el agente.
2. Verifica la sintaxis con `python -m py_compile ejemplo.py` después de la modificación.
3. Si el agente no encuentra los archivos, asegúrate de que el directorio existe y tiene archivos `.py`.

---

## Ejercicio 3: Pipeline de dos agentes (generador y revisor)

### Objetivo

Implementar el patrón Writer/Reviewer: un agente genera código y otro lo revisa de forma independiente.

### Instrucciones

1. Crea el archivo `ejercicio3.py` implementando el pipeline:

    ```python
    import asyncio
    from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


    async def generar_codigo(especificacion: str) -> tuple[str, str | None]:
        """
        Primer agente: genera código a partir de una especificación.
        Retorna (codigo_generado, session_id).
        """
        print("=== GENERADOR: Escribiendo código ===\n")
        codigo = ""
        session_id = None

        async for message in query(
            prompt=(
                f"Implementa en Python la siguiente funcionalidad: {especificacion}. "
                "Escribe el código en el archivo 'solucion.py'. "
                "Incluye docstrings, type hints y manejo de errores."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Write", "Bash"],
                permission_mode="acceptEdits",
                system_prompt=(
                    "Eres un desarrollador Python senior. "
                    "Escribe código limpio, bien documentado y siguiendo PEP 8. "
                    "Siempre incluye manejo de errores y casos borde."
                ),
            ),
        ):
            if hasattr(message, "subtype") and message.subtype == "init":
                session_id = message.session_id
            if isinstance(message, ResultMessage) and message.subtype == "success":
                codigo = getattr(message, "result", "")
                print(f"Código generado. Sesión: {session_id}\n")

        return codigo, session_id


    async def revisar_codigo(archivo: str) -> str:
        """
        Segundo agente: revisa el código generado de forma independiente.
        Opera con contexto fresco para evitar sesgos.
        """
        print("=== REVISOR: Evaluando código ===\n")
        evaluacion = ""

        async for message in query(
            prompt=(
                f"Revisa el archivo {archivo} como si fuera un code review de un Pull Request. "
                "Evalúa: "
                "1. Correctitud: ¿el código hace lo que promete? "
                "2. Robustez: ¿maneja correctamente los casos de error y borde? "
                "3. Legibilidad: ¿los nombres son descriptivos y el código es claro? "
                "4. Buenas prácticas: ¿sigue PEP 8 y convenciones de Python? "
                "5. Tests: ¿qué tests habrías escrito para este código? "
                "Da una puntuación final del 1 al 10 y lista las mejoras prioritarias."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Read"],
                system_prompt=(
                    "Eres un revisor de código experimentado. "
                    "Sé objetivo y constructivo. Tu rol es mejorar la calidad, no aprobar el trabajo. "
                    "Identifica tanto los puntos fuertes como los débiles del código."
                ),
            ),
        ):
            if isinstance(message, ResultMessage) and message.subtype == "success":
                evaluacion = getattr(message, "result", "")

        return evaluacion


    async def pipeline_generacion_revision(especificacion: str) -> None:
        """Ejecuta el pipeline completo: generar -> revisar."""

        # Paso 1: Generar
        _, _ = await generar_codigo(especificacion)

        # Paso 2: Revisar (contexto completamente separado)
        evaluacion = await revisar_codigo("solucion.py")

        print("=== EVALUACIÓN DEL REVISOR ===\n")
        print(evaluacion)


    if __name__ == "__main__":
        ESPECIFICACION = (
            "Una función 'buscar_en_texto(texto: str, patron: str, case_sensitive: bool = True)' "
            "que busca todas las ocurrencias de un patrón en un texto y devuelve una lista de "
            "tuplas (posicion_inicio, posicion_fin, texto_encontrado). "
            "Debe soportar búsqueda por palabras completas y por patrones regex básicos."
        )
        asyncio.run(pipeline_generacion_revision(ESPECIFICACION))
    ```

2. Ejecuta el pipeline:

    ```bash
    python ejercicio3.py
    ```

3. Observa cómo el revisor proporciona feedback diferente al que daría el generador sobre su propio código.

### Criterios de éxito

- El agente generador crea `solucion.py` con código funcional
- El agente revisor opera con un contexto nuevo (sin `resume`)
- La evaluación del revisor incluye las 5 dimensiones pedidas
- La puntuación numérica aparece en la evaluación final

### Pistas

1. La clave del patrón es que el revisor NO usa `resume`. Esto garantiza objetividad.
2. Si quieres ver cómo cambia la evaluación, intenta pasar el `session_id` del generador al revisor y compara.
3. **Extensión:** añade un tercer agente que aplique las correcciones del revisor. El código esqueleto es:

    ```python
    async def corregir_codigo(archivo: str, feedback: str) -> None:
        """
        Tercer agente: aplica las correcciones sugeridas por el revisor.
        Recibe el feedback como texto y edita el archivo directamente.
        """
        print("=== CORRECTOR: Aplicando mejoras ===\n")

        async for message in query(
            prompt=(
                f"Lee el archivo {archivo} y aplica las siguientes mejoras sugeridas por el revisor:\n\n"
                f"{feedback}\n\n"
                "Edita el archivo directamente. Para cada cambio que hagas, explica brevemente "
                "qué modificaste y por qué."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Read", "Edit"],
                permission_mode="acceptEdits",
                system_prompt=(
                    "Eres un desarrollador Python senior. "
                    "Aplica las mejoras sugeridas de forma cuidadosa y razonada. "
                    "Si una sugerencia no es aplicable o empeoraría el código, explica por qué "
                    "en lugar de aplicarla ciegamente."
                ),
            ),
        ):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if hasattr(block, "text") and block.text:
                        print(block.text, end="", flush=True)
            elif isinstance(message, ResultMessage):
                estado = "Correcciones aplicadas" if message.subtype == "success" else f"Error: {message.subtype}"
                print(f"\n\n[{estado}]")


    # Para usar los tres agentes en secuencia, modifica pipeline_generacion_revision:
    async def pipeline_completo(especificacion: str) -> None:
        """Pipeline de tres etapas: generar -> revisar -> corregir."""
        # Etapa 1
        _, _ = await generar_codigo(especificacion)

        # Etapa 2
        evaluacion = await revisar_codigo("solucion.py")
        print("=== EVALUACIÓN DEL REVISOR ===\n")
        print(evaluacion)

        # Etapa 3: el corrector recibe el feedback del revisor
        await corregir_codigo("solucion.py", evaluacion)
    ```

    Necesitarás añadir `AssistantMessage` a los imports de `claude_agent_sdk` en `ejercicio3.py` para que el corrector pueda imprimir el razonamiento en tiempo real.

---

## Ejercicio 4: Integrar un servidor MCP como herramienta

### Objetivo

Crear un agente que use un servidor MCP para acceder a una fuente de datos externa (sistema de archivos avanzado o base de datos SQLite).

### Instrucciones

Este ejercicio usa el servidor MCP `@modelcontextprotocol/server-filesystem`, que expone operaciones de sistema de archivos via MCP.

1. Instala las dependencias:

    ```bash
    npm install -g @modelcontextprotocol/server-filesystem
    pip install claude-agent-sdk
    ```

2. Crea una base de datos SQLite de ejemplo:

    ```python
    # setup_db.py
    import sqlite3

    conn = sqlite3.connect("ventas.db")
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS productos (
            id INTEGER PRIMARY KEY,
            nombre TEXT NOT NULL,
            precio REAL NOT NULL,
            categoria TEXT NOT NULL,
            stock INTEGER NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS ventas (
            id INTEGER PRIMARY KEY,
            producto_id INTEGER REFERENCES productos(id),
            cantidad INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            total REAL NOT NULL
        )
    """)

    productos = [
        (1, "Laptop Pro", 1299.99, "Electronica", 15),
        (2, "Mouse Inalambrico", 49.99, "Electronica", 50),
        (3, "Teclado Mecanico", 129.99, "Electronica", 30),
        (4, "Monitor 4K", 599.99, "Electronica", 10),
        (5, "Auriculares BT", 199.99, "Audio", 25),
    ]

    ventas = [
        (1, 1, 2, "2026-03-01", 2599.98),
        (2, 2, 5, "2026-03-02", 249.95),
        (3, 3, 1, "2026-03-02", 129.99),
        (4, 1, 1, "2026-03-03", 1299.99),
        (5, 4, 3, "2026-03-05", 1799.97),
        (6, 5, 2, "2026-03-07", 399.98),
        (7, 2, 10, "2026-03-10", 499.90),
    ]

    cursor.executemany(
        "INSERT OR IGNORE INTO productos VALUES (?, ?, ?, ?, ?)", productos
    )
    cursor.executemany(
        "INSERT OR IGNORE INTO ventas VALUES (?, ?, ?, ?, ?)", ventas
    )

    conn.commit()
    conn.close()
    print("Base de datos creada: ventas.db")
    ```

    ```bash
    python setup_db.py
    ```

3. Crea el archivo `ejercicio4.py`:

    ```python
    import asyncio
    from claude_agent_sdk import query, ClaudeAgentOptions, ResultMessage


    async def analizar_ventas_con_mcp(pregunta: str) -> None:
        """
        Agente que usa un servidor MCP sqlite para consultar datos de ventas.
        Requiere: npm install -g @modelcontextprotocol/server-sqlite
        """
        import os
        ruta_db = os.path.abspath("ventas.db")

        async for message in query(
            prompt=pregunta,
            options=ClaudeAgentOptions(
                mcp_servers={
                    "sqlite": {
                        "command": "npx",
                        "args": [
                            "-y",
                            "@modelcontextprotocol/server-sqlite",
                            ruta_db,
                        ],
                    }
                },
                system_prompt=(
                    "Eres un analista de datos. Usa las herramientas MCP disponibles "
                    "para consultar la base de datos y responde con datos precisos y "
                    "visualizaciones en texto cuando sea útil (tablas ASCII, listas)."
                ),
            ),
        ):
            if isinstance(message, ResultMessage) and message.subtype == "success":
                print(message.result)
            elif isinstance(message, ResultMessage):
                print(f"Error: {message.subtype}")


    if __name__ == "__main__":
        preguntas = [
            "¿Cuál es el producto más vendido en términos de ingresos?",
            "¿Cuál es el ingreso total de ventas del mes de marzo 2026?",
            "¿Qué productos tienen stock por debajo de 20 unidades?",
        ]

        for pregunta in preguntas:
            print(f"\n--- Pregunta: {pregunta} ---")
            asyncio.run(analizar_ventas_con_mcp(pregunta))
    ```

4. Ejecuta las consultas:

    ```bash
    python ejercicio4.py
    ```

### Criterios de éxito

- El servidor MCP se conecta sin errores de configuración
- El agente responde correctamente a las tres preguntas con datos reales de la base de datos
- Las respuestas incluyen datos numéricos precisos (no estimaciones)
- El agente usa las herramientas MCP (no usa `Bash` para consultar el SQLite directamente)

### Pistas

1. Si el servidor MCP no se instala correctamente, usa `npx -y @modelcontextprotocol/server-sqlite --help` para verificar.
2. El servidor sqlite de MCP expone herramientas como `query` y `list_tables`. El agente las descubre automáticamente.
3. Si prefieres no instalar dependencias npm, sustituye el MCP de SQLite por el MCP de sistema de archivos (`@modelcontextprotocol/server-filesystem`) y adapta las preguntas para explorar archivos.

---

## Ejercicio 5: CLI especializado como mini-Claude Code

### Objetivo

Crear un CLI de línea de comandos que funcione como un asistente especializado para revisiones de Pull Request, encapsulando la lógica del agente en una herramienta reutilizable.

### Instrucciones

1. Crea el archivo `pr-reviewer.py`:

    ```python
    #!/usr/bin/env python3
    """
    PR Reviewer - Asistente de revisión de Pull Requests.

    Uso:
        python pr-reviewer.py review <rama-base> <rama-pr>
        python pr-reviewer.py security <directorio>
        python pr-reviewer.py summary <directorio>
    """
    import asyncio
    import sys
    from claude_agent_sdk import query, ClaudeAgentOptions, AssistantMessage, ResultMessage


    SYSTEM_PROMPT_REVISOR = (
        "Eres un senior software engineer especializado en code reviews. "
        "Tus revisiones son constructivas, específicas y priorizadas. "
        "Para cada problema encontrado incluyes: "
        "(1) descripción del problema, "
        "(2) por qué es un problema, "
        "(3) cómo solucionarlo con un ejemplo de código. "
        "Clasifica los hallazgos como: BLOQUEANTE, MEJORA, SUGERENCIA. "
        "Responde en español."
    )


    async def revisar_pr(rama_base: str, rama_pr: str) -> None:
        """Revisa los cambios entre dos ramas como si fuera un PR."""
        print(f"Revisando cambios de '{rama_pr}' respecto a '{rama_base}'...\n")

        async for message in query(
            prompt=(
                f"Ejecuta 'git diff {rama_base}..{rama_pr}' para ver los cambios del PR. "
                "También ejecuta 'git log {rama_base}..{rama_pr} --oneline' para ver los commits. "
                "Revisa los cambios como si fuera una revisión de Pull Request profesional. "
                "Incluye: resumen de cambios, hallazgos clasificados por severidad, "
                "y una recomendación final (APROBAR / APROBAR CON CAMBIOS / RECHAZAR)."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Bash", "Read"],
                permission_mode="acceptEdits",
                system_prompt=SYSTEM_PROMPT_REVISOR,
            ),
        ):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if hasattr(block, "text") and block.text:
                        print(block.text, end="", flush=True)
            elif isinstance(message, ResultMessage):
                if message.subtype != "success":
                    print(f"\n[Error: {message.subtype}]", file=sys.stderr)


    async def analisis_seguridad(directorio: str) -> None:
        """Analiza vulnerabilidades de seguridad en un directorio."""
        print(f"Analizando seguridad en: {directorio}\n")

        async for message in query(
            prompt=(
                f"Analiza el código en {directorio} en busca de vulnerabilidades de seguridad. "
                "Busca específicamente: inyección SQL, XSS, CSRF, secretos hardcodeados, "
                "dependencias con CVEs conocidos, validación insuficiente de entradas, "
                "y exposición de información sensible en logs o errores. "
                "Para cada vulnerabilidad encontrada, indica el archivo y línea."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Read", "Glob", "Grep"],
                system_prompt=(
                    "Eres un experto en seguridad de aplicaciones (AppSec). "
                    "Conoces OWASP Top 10, CWE/SANS Top 25 y buenas prácticas de seguridad. "
                    "Sé sistemático y no reportes falsos positivos sin evidencia clara."
                ),
            ),
        ):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if hasattr(block, "text") and block.text:
                        print(block.text, end="", flush=True)
            elif isinstance(message, ResultMessage):
                if message.subtype != "success":
                    print(f"\n[Error: {message.subtype}]", file=sys.stderr)


    async def generar_resumen(directorio: str) -> None:
        """Genera un resumen ejecutivo del proyecto para onboarding."""
        print(f"Generando resumen de: {directorio}\n")

        async for message in query(
            prompt=(
                f"Analiza el proyecto en {directorio} y genera un resumen ejecutivo "
                "de una página para un nuevo desarrollador que se une al equipo. "
                "Incluye: propósito del proyecto, arquitectura principal, "
                "decisiones técnicas clave, cómo ejecutar en local, y cómo contribuir."
            ),
            options=ClaudeAgentOptions(
                allowed_tools=["Read", "Glob", "Bash"],
                system_prompt=(
                    "Eres un tech lead con experiencia en onboarding. "
                    "Escribe para audiencias técnicas que no conocen el proyecto. "
                    "Sé conciso pero completo."
                ),
            ),
        ):
            if isinstance(message, AssistantMessage):
                for block in message.content:
                    if hasattr(block, "text") and block.text:
                        print(block.text, end="", flush=True)
            elif isinstance(message, ResultMessage):
                if message.subtype != "success":
                    print(f"\n[Error: {message.subtype}]", file=sys.stderr)


    def mostrar_ayuda() -> None:
        print(__doc__)
        sys.exit(0)


    def main() -> None:
        if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
            mostrar_ayuda()

        comando = sys.argv[1]

        if comando == "review":
            if len(sys.argv) != 4:
                print("Uso: pr-reviewer.py review <rama-base> <rama-pr>")
                sys.exit(1)
            asyncio.run(revisar_pr(sys.argv[2], sys.argv[3]))

        elif comando == "security":
            directorio = sys.argv[2] if len(sys.argv) > 2 else "."
            asyncio.run(analisis_seguridad(directorio))

        elif comando == "summary":
            directorio = sys.argv[2] if len(sys.argv) > 2 else "."
            asyncio.run(generar_resumen(directorio))

        else:
            print(f"Comando desconocido: {comando}")
            mostrar_ayuda()


    if __name__ == "__main__":
        main()
    ```

2. Prueba los tres modos del CLI:

    ```bash
    # Revisar cambios entre dos ramas (requiere estar en un repositorio git)
    python pr-reviewer.py review main feature/nueva-funcionalidad

    # Analizar seguridad de un directorio
    python pr-reviewer.py security ./src

    # Generar resumen de onboarding
    python pr-reviewer.py summary .
    ```

3. Opcional: instala el CLI globalmente para usarlo desde cualquier proyecto:

    ```bash
    # Crear setup.py para instalación
    cat > setup.py << 'EOF'
    from setuptools import setup

    setup(
        name="pr-reviewer",
        version="0.1.0",
        py_modules=["pr-reviewer"],
        install_requires=["claude-agent-sdk"],
        entry_points={
            "console_scripts": ["pr-reviewer=pr-reviewer:main"],
        },
    )
    EOF

    pip install -e .
    pr-reviewer --help
    ```

### Criterios de éxito

- Los tres comandos (`review`, `security`, `summary`) funcionan sin errores
- El comando `review` genera una evaluación con la recomendación final (APROBAR / RECHAZAR)
- El comando `security` clasifica los hallazgos con archivos y líneas concretas
- El CLI muestra salida en tiempo real (streaming) durante la ejecución
- El código puede instalarse y usarse como herramienta de línea de comandos

### Pistas

1. Para el comando `review`, necesitas estar en un repositorio git con al menos dos ramas. Si no tienes uno, usa el propio repositorio del curso: `python pr-reviewer.py review master book`.
2. Si el comando `review` falla porque no hay diferencias entre ramas, prueba `review HEAD~3 HEAD` para revisar los últimos 3 commits.
3. Extiende el CLI: añade un comando `test` que ejecute los tests del proyecto y explique los fallos, o un comando `docs` que genere documentación automáticamente.

---

## Solución de referencia

Los cinco ejercicios tienen soluciones funcionales en la teoría del capítulo:

- Ejercicio 1 y 2 → teoria/02-construir-agente-basico.md
- Ejercicio 3 → teoria/03-herramientas-y-patrones-avanzados.md (Patrón de Evaluación)
- Ejercicio 4 → teoria/03-herramientas-y-patrones-avanzados.md (Integración con MCP)
- Ejercicio 5 → teoria/04-integracion-con-claude-code.md (Como CLI)

Para los ejercicios 1-4, el código base proporcionado es la solución. El ejercicio real es ejecutarlo, observar el comportamiento y experimentar con variaciones del prompt y las opciones.
