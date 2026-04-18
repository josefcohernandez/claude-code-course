# Ejercicio 02: Configurar GitHub Action para Revisión de PRs

## Objetivo

Configurar un workflow de GitHub Actions que use `claude-code-action@v1` para revisar automáticamente Pull Requests y responder a menciones de `@claude` en comentarios.

**Duración estimada:** 15 minutos

---

## Prerequisitos

- Cuenta de GitHub con acceso a GitHub Actions
- API key de Anthropic
- Un repositorio en GitHub (puede ser nuevo o existente)

---

## Parte 1: Preparar el Repositorio

### Paso 1: Crear un repositorio de prueba

Si no tienes un repositorio, crea uno nuevo:

```bash
# Crear repositorio local
mkdir github-claude-demo && cd github-claude-demo
git init

# Crear estructura básica
mkdir -p src tests

cat > src/calculator.py << 'EOF'
class Calculator:
    def add(self, a, b):
        return a + b

    def divide(self, a, b):
        return a / b

    def multiply(self, a, b):
        return a * b

    def subtract(self, a, b):
        return a - b
EOF

cat > README.md << 'EOF'
# Calculator Demo
A simple calculator for testing Claude Code GitHub Action.
EOF

git add .
git commit -m "feat: initial project setup with calculator"
```

### Paso 2: Subir a GitHub

```bash
# Crear repositorio en GitHub (requiere gh CLI)
gh repo create github-claude-demo --public --source=. --push

# O manualmente:
# git remote add origin https://github.com/TU-USUARIO/github-claude-demo.git
# git push -u origin main
```

### Paso 3: Configurar el secreto de API

```bash
# Usando GitHub CLI
gh secret set ANTHROPIC_API_KEY

# O manualmente en GitHub:
# Settings > Secrets and variables > Actions > New repository secret
# Nombre: ANTHROPIC_API_KEY
# Valor: tu-api-key-de-anthropic
```

---

## Parte 2: Crear el Workflow de Revisión

### Paso 1: Crear el archivo del workflow

Crea el directorio y archivo del workflow:

```bash
mkdir -p .github/workflows
```

Crea `.github/workflows/claude-review.yml` con el siguiente contenido:

```yaml
name: Claude Code Review

on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

jobs:
  review:
    # Ejecutar en PRs nuevos/actualizados O cuando se mencione @claude
    if: |
      github.event_name == 'pull_request' ||
      (github.event_name == 'issue_comment' &&
       contains(github.event.comment.body, '@claude'))
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      issues: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          claude_args: |
            --model claude-sonnet-4-6
            --max-turns 5
            --append-system-prompt "Eres un revisor de código experimentado. Al revisar:

            ## Reglas
            1. Revisa seguridad, rendimiento y legibilidad
            2. Sé constructivo: sugiere soluciones, no solo señala problemas
            3. Prioriza: crítico > importante > sugerencia
            4. Responde siempre en español
            5. Usa ejemplos de código cuando sugieras cambios

            ## Formato
            Organiza tu revisión en secciones:
            - **Problemas Críticos** (deben corregirse antes de merge)
            - **Mejoras Importantes** (deberían corregirse)
            - **Sugerencias** (nice to have)
            - **Aspectos Positivos** (que se hizo bien)"
```

### Paso 2: Hacer commit y push del workflow

```bash
git add .github/workflows/claude-review.yml
git commit -m "ci: add Claude Code review workflow"
git push origin main
```

---

## Parte 3: Probar con un Pull Request

### Paso 1: Crear una rama con cambios

```bash
git checkout -b feature/improve-calculator

# Hacer cambios con problemas intencionales para la revisión
cat > src/calculator.py << 'EOF'
import os  # import no utilizado

API_KEY = "sk-1234567890abcdef"  # secret hardcodeado

class Calculator:
    def add(self, a, b):
        return a + b

    def divide(self, a, b):
        # Falta manejo de división por cero
        return a / b

    def multiply(self, a, b):
        return a * b

    def subtract(self, a, b):
        return a - b

    def power(self, base, exp):
        # Implementación con recursión sin caso límite
        result = base
        for i in range(exp):
            result = result * base
        return result

    def parse_input(self, user_input):
        # Uso de eval - peligroso
        return eval(user_input)

    def log_operation(self, operation, result):
        # Escribir a archivo sin cerrar
        f = open("operations.log", "a")
        f.write(f"{operation}: {result}\n")
        # Falta f.close() o usar context manager
EOF

# Añadir tests básicos
cat > tests/test_calculator.py << 'EOF'
from src.calculator import Calculator

def test_add():
    calc = Calculator()
    assert calc.add(2, 3) == 5

def test_multiply():
    calc = Calculator()
    assert calc.multiply(3, 4) == 12

# Faltan tests para divide, subtract, power, parse_input
EOF

git add .
git commit -m "feat: add power, parse_input and logging to calculator"
git push origin feature/improve-calculator
```

### Paso 2: Crear el Pull Request

```bash
gh pr create \
    --title "feat: mejoras en la calculadora" \
    --body "## Cambios
- Función power() para calcular potencias
- Función parse_input() para parsear entrada del usuario
- Función log_operation() para logging de operaciones

## Testing
- Tests básicos añadidos" \
    --base main \
    --head feature/improve-calculator
```

### Paso 3: Esperar la revisión de Claude

1. Ve a la pestaña **Actions** del repositorio para ver el workflow en ejecución
2. Espera a que complete (normalmente 1-2 minutos)
3. Ve al Pull Request - Claude habrá dejado un comentario con su revisión

**Claude debería detectar:**
- El secret hardcodeado (`API_KEY`)
- El import no utilizado (`os`)
- La falta de manejo de división por cero
- El uso peligroso de `eval()`
- El file handle no cerrado en `log_operation`
- El bug en `power()` (resultado incorrecto)
- La falta de tests para las funciones nuevas

---

## Parte 4: Probar Menciones de @claude

### Paso 1: Comentar en el PR

Ve al Pull Request y escribe un comentario:

```
@claude Puedes sugerir como implementar correctamente la función power()
y añadir manejo de errores para división por cero?
```

### Paso 2: Esperar la respuesta

Claude responderá directamente en el PR con sugerencias de código.

### Prueba más interacciones

```
@claude Genera tests unitarios completos para todas las funciones

@claude Hay algún problema de seguridad que no hayas mencionado?

@claude Reescribe log_operation usando un context manager
```

---

## Parte 5: Tareas de Personalización

Modifica el workflow para cumplir estos requisitos adicionales:

### Tarea 1: Filtrar por tipo de archivos

- [ ] Configura el workflow para que solo se ejecute cuando se modifiquen archivos `.py`, `.ts`, `.js` o `.go`

**Pista:**

```yaml
on:
  pull_request:
    types: [opened, synchronize]
    paths:
      - '**/*.py'
      - '**/*.ts'
      - '**/*.js'
      - '**/*.go'
```

### Tarea 2: Crear un workflow especializado en seguridad

- [ ] Crea un segundo workflow `.github/workflows/claude-security.yml`
- [ ] Que se ejecute solo en PRs con la etiqueta `security-review`
- [ ] Con instrucciones específicas para revisión de seguridad (OWASP Top 10)

**Pista:**

```yaml
jobs:
  security-review:
    if: contains(github.event.pull_request.labels.*.name, 'security-review')
    # ...
```

### Tarea 3: Añadir revisión diferenciada

- [ ] Modifica las instrucciones en `claude_md` para que la revisión sea diferente según el tipo de archivo:
  - Python: enfocarse en type hints y PEP 8
  - TypeScript: enfocarse en tipado estricto y null safety
  - SQL: enfocarse en injection y rendimiento de queries

---

## Verificación

Al completar este ejercicio, deberías tener:

1. Un workflow funcional que revisa PRs automáticamente
2. Soporte para menciones `@claude` en comentarios
3. Al menos un PR revisado por Claude con feedback útil
4. Personalizaciones aplicadas según las tareas

---

## Criterios de Evaluación

| Criterio | Puntos |
|----------|--------|
| El workflow se ejecuta correctamente en un PR nuevo | 3 |
| Claude detecta los problemas principales del código | 2 |
| Las menciones `@claude` funcionan correctamente | 2 |
| Las personalizaciones están implementadas | 3 |
| **Total** | **10** |

---

## Limpieza

Si creaste un repositorio de prueba, puedes eliminarlo:

```bash
# Eliminar repositorio remoto
gh repo delete github-claude-demo --yes

# Eliminar repositorio local
rm -rf /tmp/github-claude-demo
```

---

## Troubleshooting

| Problema | Solucion |
|----------|----------|
| El workflow no se ejecuta | Verifica que el archivo esta en `.github/workflows/` y que la sintaxis YAML es correcta |
| Error de autenticación | Verifica que el secreto `ANTHROPIC_API_KEY` esta configurado correctamente |
| Claude no responde a menciones | Asegurate de que `issue_comment` esta en los triggers y los permisos incluyen `issues: write` |
| La revisión tarda mucho | Reduce `max_turns` o cambia a un modelo más rápido |
| Error de permisos | Verifica la sección `permissions` del workflow |
