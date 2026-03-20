# Ejercicios Practicos: Plugins y Marketplaces

## Contexto

Eres parte del equipo de plataforma de una empresa de software mediana. Tu objetivo es estandarizar el entorno de desarrollo con Claude Code para todos los equipos: instalar las integraciones necesarias, crear un plugin de deploy que empaquete las validaciones del equipo y distribuirlo de forma reproducible a todos los proyectos.

---

## Requisitos Previos

| Modulo / Fichero | Razon |
|------------------|-------|
| [M07 - MCP](../../modulo-07-mcp/README.md) | Entender como funcionan los servidores MCP que los plugins usan |
| [M08 - Hooks](../../modulo-08-hooks/README.md) | Saber escribir y depurar hooks del ciclo de vida |
| [M09 - Skills y Subagentes](../../modulo-09-agentes-skills-teams/README.md) | Crear skills y subagentes que se empaquetan en el plugin |
| [01-que-son-los-plugins.md](../teoria/01-que-son-los-plugins.md) | Estructura y scopes de plugins |
| [02-plugins-integrados.md](../teoria/02-plugins-integrados.md) | Ecosistema de plugins disponibles |
| [03-crear-plugin-propio.md](../teoria/03-crear-plugin-propio.md) | Manifest, estructura y publicacion |
| [04-marketplaces-y-gestion-enterprise.md](../teoria/04-marketplaces-y-gestion-enterprise.md) | Marketplace privado y politicas enterprise |

---

## Ejercicio 1: Explorar el Marketplace e Instalar un Plugin de Code Intelligence

### Objetivo

Familiarizarte con la interfaz interactiva del marketplace, evaluar un plugin antes de instalarlo y verificar que sus capacidades funcionan en tu proyecto.

### Instrucciones

1. Abre una sesion de Claude Code en cualquier proyecto con codigo fuente (puede ser el propio repositorio del curso):

    ```bash
    cd /ruta/a/tu/proyecto
    claude
    ```

2. Accede al marketplace interactivo:

    ```bash
    /plugin
    ```

3. Busca plugins de code intelligence:

    ```bash
    /plugin search code-intelligence
    ```

4. Antes de instalar, inspecciona los detalles del plugin. Anota las respuestas a estas preguntas:
   - Que permisos solicita el plugin?
   - Que herramientas integra o mejora?
   - Cuando fue la ultima actualizacion?

    ```bash
    /plugin info code-intelligence
    ```

5. Instala el plugin con scope `user` (util en todos tus proyectos):

    ```bash
    /plugin install code-intelligence --scope user
    ```

6. Verifica la instalacion:

    ```bash
    /plugin list
    ```

7. Prueba que el plugin funciona: pide a Claude que encuentre todos los usos de una funcion en el proyecto usando navegacion semantica (no grep):

    ```
    > Encuentra todas las referencias a la funcion "calcular_total" en el proyecto.
      Usa navegacion de simbolos si esta disponible, no solo busqueda de texto.
    ```

### Criterios de Exito

- El plugin aparece en `/plugin list` con estado `activo`
- Claude responde diferente cuando tiene code intelligence activo: menciona que usa navegacion de simbolos o language server, no solo grep
- No se producen errores de permisos durante la instalacion

### Pistas

1. Si el marketplace no tiene un plugin llamado exactamente "code-intelligence", busca con `/plugin search language-server` o `/plugin search navigation` y elige el mas relevante.
2. Si trabajas en un proyecto Python, busca un plugin con soporte para `pyright`. Si trabajas en TypeScript, busca soporte para `typescript-language-server`.
3. El efecto del plugin es mas visible en proyectos grandes. Si el proyecto de prueba es pequeno, el comportamiento puede parecer igual que con grep.

---

## Ejercicio 2: Configurar la Integracion con GitHub

### Objetivo

Instalar el plugin de GitHub, configurarlo con un token de acceso y verificar que Claude puede interactuar con repositorios remotos como parte de tu flujo de trabajo.

### Instrucciones

1. Crea un token de acceso personal (PAT) en GitHub con los permisos minimos necesarios:
   - Ve a GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Permisos requeridos: `repo` (para crear PRs), `read:org` (si usas organizaciones)
   - Nombra el token "claude-code-plugin" y guarda el valor generado

2. Exporta el token como variable de entorno (agrega esta linea a tu `.bashrc` o `.zshrc`):

    ```bash
    export GITHUB_TOKEN=<tu-personal-access-token>
    ```

3. Instala el plugin de GitHub con scope `user`:

    ```bash
    /plugin install github --scope user
    ```

4. Configura el plugin con tu token:

    ```bash
    /plugin configure github
    ```

    El asistente de configuracion te pedira el `GITHUB_TOKEN`. Introduce el token que creaste en el paso 1.

5. Verifica que la integracion funciona preguntando a Claude sobre el estado del repositorio:

    ```
    > Lista los ultimos 5 pull requests abiertos de este repositorio,
      indicando titulo, autor y numero de dias abierto.
    ```

6. Crea un commit de prueba y pide a Claude que cree un pull request:

    ```bash
    # Crea una rama de prueba
    git checkout -b test/plugin-github-ejercicio

    # Crea un archivo de prueba
    echo "# Prueba de integracion GitHub plugin" > prueba-github.md
    git add prueba-github.md
    git commit -m "test: prueba de integracion con plugin de GitHub"
    git push origin test/plugin-github-ejercicio
    ```

    ```
    > Crea un pull request desde la rama actual (test/plugin-github-ejercicio)
      hacia main con el titulo "test: prueba de integracion GitHub plugin"
      y descripcion "Ejercicio del modulo de plugins de Claude Code".
    ```

7. Verifica en GitHub que el PR se creo correctamente.

8. Limpieza: cierra el PR y elimina la rama de prueba desde GitHub o con:

    ```bash
    git checkout main
    git branch -D test/plugin-github-ejercicio
    git push origin --delete test/plugin-github-ejercicio
    ```

### Criterios de Exito

- La configuracion del plugin acepta el token sin errores
- Claude lista los PRs reales del repositorio (no informacion inventada)
- El PR se crea en GitHub con el titulo y descripcion correctos
- La rama aparece en el repositorio remoto antes de crear el PR

### Pistas

1. Si el token no tiene suficientes permisos, GitHub devuelve un error 403. Revisa que el scope `repo` esta marcado en el PAT.
2. Si el repositorio del curso es privado y no tienes permisos de escritura, usa un repositorio propio para este ejercicio.
3. Puedes verificar que el plugin usa la API de GitHub (no el CLI de git) observando el log de herramientas de Claude: deberia mostrar llamadas al MCP server de GitHub, no solo comandos `git`.

---

## Ejercicio 3: Crear un Plugin de Deploy con Skill y Hook

### Objetivo

Crear desde cero un plugin que empaquete un skill de deploy y un hook de validacion pre-deploy, e instalarlo en un proyecto de prueba.

### Instrucciones

1. Crea el directorio del plugin fuera del proyecto donde lo vayas a probar:

    ```bash
    mkdir ~/plugins/deploy-safe
    cd ~/plugins/deploy-safe
    ```

2. Crea el manifest `plugin.json`:

    ```json
    {
      "name": "deploy-safe",
      "version": "0.1.0",
      "description": "Flujo de deploy seguro: valida tests antes de desplegar y reporta el resultado",
      "author": "<tu-nombre>@<tu-empresa>.com",
      "license": "MIT",
      "dependencies": {
        "tools": ["git"]
      },
      "configuration": {
        "environment": {
          "type": "string",
          "enum": ["staging", "production"],
          "default": "staging",
          "description": "Entorno de destino del deploy"
        },
        "run_tests": {
          "type": "boolean",
          "default": true,
          "description": "Ejecutar tests antes de permitir el deploy"
        }
      },
      "components": {
        "skills": ["skills/deploy.md"],
        "hooks": [
          {
            "file": "hooks/pre-deploy.sh",
            "event": "PreToolUse",
            "matcher": "Bash",
            "description": "Valida tests antes de comandos de deploy"
          }
        ]
      }
    }
    ```

3. Crea el directorio de skills y el archivo del skill:

    ```bash
    mkdir skills
    ```

    Crea `skills/deploy.md`:

    ```markdown
    ---
    name: deploy
    description: Despliega la version actual al entorno configurado tras validar el estado del repositorio
    ---

    # Skill: Deploy Seguro

    Sigue estos pasos en orden. Detente y reporta si alguno falla:

    1. Verifica que no hay cambios sin commitear: `git status --porcelain`
       - Si hay cambios, informa al usuario y para
    2. Obtener la version actual: `git describe --tags --always`
    3. Si la variable PLUGIN_RUN_TESTS es "true", ejecuta los tests del proyecto:
       - Si hay `package.json`: `npm test`
       - Si hay `pyproject.toml` o `setup.py`: `python -m pytest`
       - Si hay `Makefile` con target `test`: `make test`
    4. Si los tests pasan (o no aplican), reporta que el deploy puede proceder
    5. El usuario debe confirmar el deploy manual. No ejecutes comandos de deploy sin confirmacion explicita.
    6. Tras el deploy, verifica el estado del servicio si es posible

    Entorno configurado: $PLUGIN_ENVIRONMENT
    ```

4. Crea el directorio de hooks y el script del hook:

    ```bash
    mkdir hooks
    ```

    Crea `hooks/pre-deploy.sh`:

    ```bash
    #!/bin/bash
    # Hook PreToolUse: valida que los tests pasan antes de comandos de deploy

    TOOL_INPUT=$(cat)
    COMMAND=$(echo "$TOOL_INPUT" | python3 -c "
    import sys, json
    try:
        data = json.load(sys.stdin)
        print(data.get('command', ''))
    except Exception:
        print('')
    " 2>/dev/null)

    # Solo actuar en comandos que parecen deploys
    if ! echo "$COMMAND" | grep -qE "(kubectl apply|helm upgrade|deploy\.sh|npm run deploy|make deploy)"; then
        exit 0
    fi

    # Verificar si el usuario ha desactivado la validacion de tests
    if [ "${PLUGIN_RUN_TESTS:-true}" != "true" ]; then
        echo "Validacion de tests desactivada por configuracion. Continuando." >&2
        exit 0
    fi

    echo "[deploy-safe] Ejecutando validacion pre-deploy..." >&2

    # Detectar y ejecutar los tests del proyecto
    if [ -f "package.json" ] && grep -q '"test"' package.json; then
        npm test --silent 2>&1
        TEST_RESULT=$?
    elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        python -m pytest -q 2>&1
        TEST_RESULT=$?
    elif [ -f "Makefile" ] && grep -q '^test:' Makefile; then
        make test 2>&1
        TEST_RESULT=$?
    else
        echo "[deploy-safe] No se detecto suite de tests conocida. Omitiendo validacion." >&2
        exit 0
    fi

    if [ $TEST_RESULT -ne 0 ]; then
        printf '{"decision":"block","reason":"Los tests han fallado. Corrige los errores antes de hacer deploy al entorno %s."}\n' "${PLUGIN_ENVIRONMENT:-staging}"
        exit 2
    fi

    echo "[deploy-safe] Tests OK. El deploy puede proceder." >&2
    exit 0
    ```

5. Marca el script como ejecutable:

    ```bash
    chmod +x hooks/pre-deploy.sh
    ```

6. Instala el plugin desde la ruta local en un proyecto de prueba:

    ```bash
    cd /ruta/a/tu/proyecto-prueba
    /plugin install ~/plugins/deploy-safe --scope project
    ```

7. Configura el plugin:

    ```bash
    /plugin configure deploy-safe
    # Selecciona environment: staging
    # run_tests: true
    ```

8. Invoca el skill en una sesion de Claude Code:

    ```
    > @deploy-safe/deploy
    ```

9. Verifica que el hook bloquea cuando los tests fallan: crea un test que falle intencionalmente y luego intenta un deploy:

    ```bash
    # En un proyecto con npm, crea un test que falla
    echo 'test("falla intencional", () => { expect(1).toBe(2); });' > /tmp/test-falla.test.js
    ```

    ```
    > Ejecuta: npm run deploy (o make deploy si el proyecto usa Makefile)
    ```

    El hook debe bloquear el comando y mostrar el mensaje de error.

### Criterios de Exito

- El plugin se instala sin errores desde la ruta local
- El skill `@deploy-safe/deploy` es invocable y sigue los pasos definidos
- El hook intercepta comandos que coinciden con el patron de deploy
- El hook bloquea el deploy cuando los tests fallan, mostrando el mensaje de error configurado
- El hook no interfiere con comandos que no son deploys (por ejemplo, `git status`)

### Pistas

1. Si el hook no se activa, verifica que el fichero tiene permisos de ejecucion (`ls -la hooks/`).
2. Para depurar el hook, agrega `set -x` al inicio del script. Los mensajes de depuracion aparecen en stderr de Claude Code.
3. Si no tienes un proyecto con tests configurados, crea uno minimo:

    ```bash
    mkdir proyecto-prueba && cd proyecto-prueba
    npm init -y
    npm install --save-dev jest
    echo '{"scripts": {"test": "jest"}}' > package.json
    echo 'test("pasa", () => { expect(1).toBe(1); });' > suma.test.js
    ```

---

## Ejercicio 4: Plugin de Equipo con CLAUDE.md, Reglas y Skill de Code Review

### Objetivo

Crear un plugin que empaquete el conjunto completo de herramientas de calidad de codigo de un equipo: CLAUDE.md compartido, reglas de codigo, un skill de code review y un hook de linting automatico.

### Instrucciones

1. Crea el directorio del plugin de equipo:

    ```bash
    mkdir ~/plugins/team-standards
    cd ~/plugins/team-standards
    ```

2. Crea el manifest `plugin.json`:

    ```json
    {
      "name": "team-standards",
      "version": "1.0.0",
      "description": "Estandares de codigo del equipo: reglas, skill de code review y linting automatico",
      "author": "equipo-arquitectura@empresa.com",
      "license": "MIT",
      "configuration": {
        "language": {
          "type": "string",
          "enum": ["typescript", "python", "go", "java"],
          "default": "typescript",
          "description": "Lenguaje principal del proyecto"
        },
        "strict_mode": {
          "type": "boolean",
          "default": false,
          "description": "Activar reglas estrictas (bloquear en lugar de advertir)"
        }
      },
      "components": {
        "skills": ["skills/code-review.md"],
        "hooks": [
          {
            "file": "hooks/auto-lint.sh",
            "event": "PostToolUse",
            "matcher": "Edit",
            "description": "Ejecuta linting automatico tras cada edicion de archivo"
          }
        ],
        "context": ["context/CLAUDE.md"]
      }
    }
    ```

3. Crea el CLAUDE.md compartido del equipo:

    ```bash
    mkdir context
    ```

    Crea `context/CLAUDE.md`:

    ```markdown
    # Estandares de Codigo del Equipo

    ## Reglas generales

    - Todo codigo nuevo debe tener type hints (Python) o tipos explícitos (TypeScript)
    - Las funciones de mas de 20 lineas deben tener docstring o JSDoc
    - No se permiten variables con nombres de una sola letra excepto en iteradores simples (i, j, k)
    - Los mensajes de commit siguen Conventional Commits: feat:, fix:, docs:, refactor:, test:, chore:

    ## Convenciones de nomenclatura

    - Python: snake_case para funciones y variables, PascalCase para clases
    - TypeScript: camelCase para funciones y variables, PascalCase para clases e interfaces
    - Constantes: UPPER_SNAKE_CASE en ambos lenguajes
    - Archivos: kebab-case (mi-componente.ts, mi_modulo.py)

    ## Proceso de code review

    Todo code review debe evaluar:
    1. Correctitud: el codigo hace lo que promete
    2. Seguridad: no introduce vulnerabilidades (inyeccion, secretos hardcodeados, etc.)
    3. Rendimiento: no introduce regresiones obvias
    4. Mantenibilidad: nombres descriptivos, funciones con responsabilidad unica
    5. Tests: cambios no triviales tienen tests que los cubren

    ## Lo que NO hacer

    - No hardcodear URLs, credenciales o configuracion que varia por entorno
    - No usar `any` en TypeScript sin un comentario que justifique por que
    - No ignorar los errores de linting con comentarios de supresion sin explicacion
    - No committear archivos de configuracion local (.env, *.local, config.local.*)
    ```

4. Crea el skill de code review:

    ```bash
    mkdir skills
    ```

    Crea `skills/code-review.md`:

    ```markdown
    ---
    name: code-review
    description: Revisa el codigo de un Pull Request o conjunto de cambios siguiendo los estandares del equipo
    ---

    # Skill: Code Review del Equipo

    Realiza un code review estructurado de los cambios actuales siguiendo los estandares del equipo.

    ## Proceso

    1. Obtener los cambios: `git diff main...HEAD` (o la rama base indicada por el usuario)
    2. Analizar cada archivo modificado evaluando los cinco criterios del equipo:
       - Correctitud
       - Seguridad
       - Rendimiento
       - Mantenibilidad
       - Cobertura de tests

    ## Formato del informe

    Estructura el informe con estas secciones:

    ### Resumen
    - Numero de archivos modificados
    - Complejidad estimada del cambio (baja/media/alta)
    - Recomendacion final: APROBAR / APROBAR CON CAMBIOS MENORES / REQUIERE CAMBIOS

    ### Hallazgos
    Para cada hallazgo, indica:
    - Archivo y linea (si aplica)
    - Severidad: BLOQUEANTE / MEJORA / SUGERENCIA
    - Descripcion del problema
    - Solucion propuesta con ejemplo de codigo si es relevante

    ### Verificacion de estandares del equipo
    - [ ] Type hints / tipos explícitos
    - [ ] Documentacion de funciones largas
    - [ ] Nombres descriptivos
    - [ ] Mensajes de commit en Conventional Commits
    - [ ] Sin credenciales hardcodeadas
    ```

5. Crea el hook de linting automatico:

    ```bash
    mkdir hooks
    ```

    Crea `hooks/auto-lint.sh`:

    ```bash
    #!/bin/bash
    # Hook PostToolUse (Edit): ejecuta linting automatico tras ediciones

    TOOL_OUTPUT=$(cat)
    FILE_PATH=$(echo "$TOOL_OUTPUT" | python3 -c "
    import sys, json
    try:
        data = json.load(sys.stdin)
        print(data.get('tool_input', {}).get('file_path', ''))
    except Exception:
        print('')
    " 2>/dev/null)

    if [ -z "$FILE_PATH" ]; then
        exit 0
    fi

    LANGUAGE="${PLUGIN_LANGUAGE:-typescript}"

    case "$LANGUAGE" in
        typescript)
            if [ -f "node_modules/.bin/eslint" ] && echo "$FILE_PATH" | grep -qE "\.(ts|tsx|js|jsx)$"; then
                node_modules/.bin/eslint --fix "$FILE_PATH" --quiet 2>/dev/null
                echo "[team-standards] ESLint aplicado a $FILE_PATH" >&2
            fi
            if [ -f "node_modules/.bin/prettier" ] && echo "$FILE_PATH" | grep -qE "\.(ts|tsx|js|jsx|css|json)$"; then
                node_modules/.bin/prettier --write "$FILE_PATH" --log-level silent 2>/dev/null
                echo "[team-standards] Prettier aplicado a $FILE_PATH" >&2
            fi
            ;;
        python)
            if command -v ruff &> /dev/null && echo "$FILE_PATH" | grep -q "\.py$"; then
                ruff check --fix "$FILE_PATH" --quiet 2>/dev/null
                ruff format "$FILE_PATH" --quiet 2>/dev/null
                echo "[team-standards] Ruff aplicado a $FILE_PATH" >&2
            fi
            ;;
        go)
            if command -v gofmt &> /dev/null && echo "$FILE_PATH" | grep -q "\.go$"; then
                gofmt -w "$FILE_PATH" 2>/dev/null
                echo "[team-standards] gofmt aplicado a $FILE_PATH" >&2
            fi
            ;;
    esac

    exit 0
    ```

    ```bash
    chmod +x hooks/auto-lint.sh
    ```

6. Instala el plugin en un proyecto:

    ```bash
    cd /ruta/a/tu/proyecto
    /plugin install ~/plugins/team-standards --scope project
    /plugin configure team-standards
    # Selecciona el lenguaje de tu proyecto
    ```

7. Verifica que el CLAUDE.md del plugin esta activo preguntando a Claude sobre los estandares del equipo:

    ```
    > Cuales son los estandares de codigo del equipo para nomenclatura?
    ```

8. Prueba el skill de code review en los cambios actuales:

    ```
    > @team-standards/code-review
    ```

9. Edita un archivo del proyecto y verifica que el hook de linting se ejecuta automaticamente (deberias ver mensajes de `[team-standards]` en el log de Claude Code).

### Criterios de Exito

- El CLAUDE.md del plugin aparece como contexto activo (Claude conoce los estandares del equipo sin que se los hayas explicado)
- El skill `@team-standards/code-review` genera un informe estructurado con las cinco categorias
- El hook de linting se activa automaticamente tras cada edicion de un archivo del lenguaje configurado
- El plugin puede instalarse en un proyecto nuevo en menos de 2 minutos (reproductibilidad)

### Pistas

1. El campo `context` en el manifest del plugin es la forma de incluir un CLAUDE.md que se activa automaticamente al usar el plugin. No confundas esto con el `CLAUDE.md` del proyecto.
2. Si el linter (ESLint, Ruff, gofmt) no esta instalado en el proyecto de prueba, el hook termina sin hacer nada (exit 0). Esto es intencional: el hook es resiliente a entornos sin las herramientas instaladas.
3. Para verificar que el CLAUDE.md del plugin esta activo, pide a Claude que explique los estandares de commit del equipo. Si los conoce (Conventional Commits), el contexto esta funcionando.

---

## Ejercicio 5 (Enterprise): Configurar un Marketplace Privado

### Objetivo

Simular la configuracion de un marketplace privado de organizacion que distribuye el plugin `team-standards` del ejercicio anterior a todos los proyectos del equipo de forma centralizada.

> Este ejercicio simula el flujo enterprise. En un entorno real, el fichero `managed_settings.json` lo gestiona el administrador de la organizacion, no los desarrolladores individuales.

### Instrucciones

1. Prepara el plugin para publicacion: crea un repositorio Git local que simule el hosting del plugin:

    ```bash
    cd ~/plugins/team-standards
    git init
    git add .
    git commit -m "feat: version inicial del plugin team-standards"
    git tag v1.0.0
    ```

2. Crea el fichero `registry.json` que representa el marketplace privado de la empresa:

    ```bash
    mkdir ~/marketplace-privado
    cd ~/marketplace-privado
    ```

    Crea `registry.json`:

    ```json
    {
      "version": "1.0",
      "name": "Marketplace Interno - Mi Empresa",
      "plugins": [
        {
          "name": "team-standards",
          "version": "1.0.0",
          "description": "Estandares de codigo del equipo: reglas, skill de code review y linting automatico",
          "author": "equipo-arquitectura@empresa.com",
          "source": "file:///Users/usuario/plugins/team-standards",
          "verified": true,
          "internal": true,
          "tags": ["calidad", "linting", "code-review"]
        },
        {
          "name": "deploy-safe",
          "version": "0.1.0",
          "description": "Flujo de deploy seguro con validaciones y hook pre-deploy",
          "author": "equipo-plataforma@empresa.com",
          "source": "file:///Users/usuario/plugins/deploy-safe",
          "verified": true,
          "internal": true,
          "tags": ["deploy", "ci-cd", "validacion"]
        }
      ]
    }
    ```

    Ajusta las rutas `file:///` a las rutas absolutas reales en tu sistema.

3. Levanta un servidor HTTP simple para servir el marketplace (en una terminal separada):

    ```bash
    cd ~/marketplace-privado
    python3 -m http.server 8099
    ```

4. Registra el marketplace privado en tu configuracion local de Claude Code. Edita `~/.claude/settings.json`:

    ```json
    {
      "marketplaces": [
        {
          "name": "Marketplace Interno",
          "url": "http://localhost:8099",
          "trusted": true
        }
      ]
    }
    ```

5. Verifica que Claude Code detecta el marketplace privado:

    ```bash
    /plugin
    ```

    Deberias ver los plugins del marketplace interno listados junto con los del marketplace publico.

6. Instala `team-standards` desde el marketplace privado (en lugar de desde la ruta local):

    ```bash
    /plugin install team-standards --marketplace "Marketplace Interno" --scope project
    ```

7. Simula la distribucion enterprise: crea un fichero `managed_settings.json` que forzaria la instalacion del plugin en todos los proyectos de la organizacion:

    ```bash
    # Este fichero lo gestionaria el administrador enterprise, no el desarrollador
    # Se crea aqui solo para ilustrar la estructura
    cat > /tmp/managed_settings_ejemplo.json << 'EOF'
    {
      "marketplaces": [
        {
          "name": "Marketplace Interno",
          "url": "https://plugins.mi-empresa.internal",
          "trusted": true
        }
      ],
      "plugins": {
        "strictKnownMarketplaces": true,
        "allowedMarketplaces": [
          "https://marketplace.claude.ai",
          "https://plugins.mi-empresa.internal"
        ],
        "managed": [
          {
            "name": "team-standards",
            "version": "1.0.0",
            "scope": "managed",
            "description": "Estandares de codigo obligatorios para todos los proyectos de la empresa"
          }
        ]
      }
    }
    EOF
    echo "Estructura de managed_settings.json generada en /tmp/managed_settings_ejemplo.json"
    cat /tmp/managed_settings_ejemplo.json
    ```

8. Discute con el equipo (o reflexiona individualmente) sobre estas preguntas:
   - Por que es preferible distribuir plugins via marketplace privado en lugar de compartir la carpeta del plugin por Slack o email?
   - Que ventajas aporta `strictKnownMarketplaces` en un entorno enterprise con muchos desarrolladores?
   - Como gestionarias las actualizaciones del plugin `team-standards` cuando el equipo de arquitectura introduce nuevas reglas?

### Criterios de Exito

- El marketplace privado es accesible desde el navegador en `http://localhost:8099/registry.json`
- Claude Code lista los plugins del marketplace privado en `/plugin`
- El plugin `team-standards` se puede instalar desde el marketplace privado (no solo desde la ruta local)
- El fichero `managed_settings_ejemplo.json` es JSON valido y contiene todos los campos necesarios para una configuracion enterprise real

### Pistas

1. Si Python3 no esta disponible, puedes usar cualquier servidor HTTP simple: `npx serve ~/marketplace-privado --port 8099` o `ruby -run -e httpd ~/marketplace-privado -p 8099`.
2. En un entorno enterprise real, el servidor del marketplace tendria HTTPS, autenticacion y un proceso de CI/CD para publicar nuevas versiones. La simulacion con `http.server` ilustra el concepto sin esa complejidad.
3. La politica `strictKnownMarketplaces` en un entorno real se configura en el sistema de gestion centralizada de Anthropic para empresas (Claude for Enterprise). En este ejercicio simulamos el fichero JSON resultante.

---

## Solucion de Referencia

Los ejercicios 3 y 4 construyen plugins completos. El codigo de cada componente esta incluido en las instrucciones como solucion de referencia directa.

Para los ejercicios 1 y 2, la solucion depende del marketplace y los repositorios que tengas disponibles. El criterio de exito es funcional, no estructural.

Para el ejercicio 5, el fichero `managed_settings_ejemplo.json` generado en el paso 7 es la solucion de referencia para la configuracion enterprise.

Si tienes dudas sobre la estructura del manifest `plugin.json`, consulta [teoria/03-crear-plugin-propio.md](../teoria/03-crear-plugin-propio.md) donde se explican todos los campos con ejemplos detallados.
