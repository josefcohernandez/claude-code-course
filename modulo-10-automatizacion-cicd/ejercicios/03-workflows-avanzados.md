# Ejercicio 03: Workflows Avanzados de GitHub Actions

## Objetivo

Crear workflows especializados que aprovechan las capacidades avanzadas de `claude-code-action@v1`: revision por rutas criticas, tareas programadas, skills del proyecto en CI, y triaje automatico de issues.

**Duracion estimada:** 20 minutos

---

## Prerequisitos

- Haber completado el Ejercicio 02 (GitHub Action basico funcionando)
- Repositorio en GitHub con `ANTHROPIC_API_KEY` configurado
- Familiaridad con la estructura `.claude/` del proyecto (modulo 4 y 5)

---

## Parte 1: Crear una Skill de Revision para CI

Vamos a crear una skill de revision que funcione tanto en la terminal como en GitHub Actions.

### Paso 1: Crear la skill

```bash
mkdir -p .claude/skills/review
```

Crea `.claude/skills/review/SKILL.md`:

```markdown
---
name: review
description: Revision de codigo enfocada en calidad, seguridad y buenas practicas
---

Revisa el codigo siguiendo estos criterios:

## Seguridad
- Busca secrets hardcodeados, eval(), inyeccion SQL/XSS
- Verifica validacion de inputs del usuario
- Comprueba manejo seguro de archivos (context managers)

## Calidad
- Manejo adecuado de errores (no silenciar excepciones)
- Funciones con responsabilidad unica
- Nombres descriptivos de variables y funciones

## Tests
- Identifica funciones sin cobertura de tests
- Sugiere casos de prueba faltantes

## Formato de salida
Organiza en: Critico > Importante > Sugerencia > Positivo
Incluye numeros de linea y ejemplos de codigo para corregir.
Responde en espanol.
```

### Paso 2: Probar localmente

```bash
# Dentro de Claude Code
/review src/calculator.py
```

### Paso 3: Usar la skill en un workflow

Crea `.github/workflows/claude-skill-review.yml`:

```yaml
name: Claude - Review con Skill

on:
  pull_request:
    types: [opened, synchronize]

permissions:
  contents: read
  pull-requests: write

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "/review"
          claude_args: "--max-turns 5"
```

### Paso 4: Commit y push

```bash
git add .claude/skills/review/SKILL.md .github/workflows/claude-skill-review.yml
git commit -m "feat: add review skill for local and CI use"
git push origin main
```

**Verificacion:** La misma skill `/review` funciona en tu terminal y en CI.

---

## Parte 2: Workflow de Revision de Seguridad por Rutas

### Paso 1: Crear el workflow

Crea `.github/workflows/claude-security.yml`:

```yaml
name: Claude - Seguridad

on:
  pull_request:
    paths:
      - 'src/auth/**'
      - 'src/api/**'
      - '*.config.*'
      - '.env*'
      - 'Dockerfile*'

permissions:
  contents: read
  pull-requests: write

jobs:
  security:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Revision de seguridad enfocada en OWASP Top 10.
            Si encuentras algo critico, solicita cambios.
          claude_args: "--max-turns 8 --model claude-sonnet-4-5-20250929"
```

### Paso 2: Probar con un PR que toque rutas sensibles

```bash
git checkout -b feature/auth-change

# Crear un archivo de autenticacion con problemas intencionales
mkdir -p src/auth
cat > src/auth/login.py << 'EOF'
import sqlite3

PASSWORD = "admin123"  # Secret hardcodeado

def authenticate(username, password):
    conn = sqlite3.connect("users.db")
    # Vulnerable a SQL injection
    query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    result = conn.execute(query).fetchone()
    return result is not None

def reset_password(email):
    # Sin rate limiting ni validacion
    token = email  # Token predecible
    return f"https://app.com/reset?token={token}"
EOF

git add src/auth/login.py
git commit -m "feat: add login authentication"
git push origin feature/auth-change
```

Crea un PR y observa como se activa **solo** el workflow de seguridad (no el general).

---

## Parte 3: Workflow Programado (Cron)

### Paso 1: Crear workflow de reporte semanal

Crea `.github/workflows/claude-weekly.yml`:

```yaml
name: Claude - Reporte Semanal

on:
  schedule:
    - cron: "0 10 * * 1"  # Lunes a las 10:00 UTC
  workflow_dispatch:  # Permitir ejecucion manual

permissions:
  contents: read
  issues: write

jobs:
  report:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 100

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Genera un reporte semanal del repositorio:
            1. Resumen de actividad (commits, PRs, issues)
            2. Archivos mas modificados
            3. Sugerencias de mejora
            Publica como issue con etiqueta 'weekly-report'.
          claude_args: "--max-turns 8"
```

### Paso 2: Probar manualmente

En GitHub, ve a Actions > "Claude - Reporte Semanal" > "Run workflow" para ejecutarlo sin esperar al lunes.

---

## Parte 4: Triaje Automatico de Issues

### Paso 1: Crear el workflow

Crea `.github/workflows/claude-triage.yml`:

```yaml
name: Claude - Triaje

on:
  issues:
    types: [opened]

permissions:
  issues: write

jobs:
  triage:
    if: github.actor != 'dependabot[bot]'
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Clasifica este issue:
            - Tipo (bug/feature/question/docs)
            - Prioridad (critical/high/medium/low)
            - Area del codigo afectada
            - Sugiere etiquetas
            Responde en espanol.
          claude_args: "--max-turns 3 --model claude-sonnet-4-5-20250929"
```

### Paso 2: Probar creando un issue

```bash
gh issue create \
    --title "Bug: la funcion divide() no maneja division por cero" \
    --body "Cuando llamo calculator.divide(10, 0), la aplicacion crashea con ZeroDivisionError en vez de mostrar un mensaje de error amigable."
```

Observa como Claude comenta automaticamente con el triaje.

---

## Parte 5: Tareas de Personalizacion

### Tarea 1: Combinar revision general + seguridad

- [ ] Modifica los workflows para que un PR en `src/auth/` active **ambos**: la revision general Y la de seguridad
- [ ] Usa `concurrency` para evitar que se ejecuten dos veces si se actualizan commits rapidamente

### Tarea 2: Crear una skill de triaje

- [ ] Mueve las instrucciones de triaje del workflow a `.claude/skills/triage/SKILL.md`
- [ ] Usa `prompt: "/triage"` en el workflow
- [ ] Prueba que `/triage` tambien funciona en la terminal

### Tarea 3: Workflow con GitHub App personalizada

- [ ] Si tienes acceso a crear GitHub Apps: crea una app personalizada
- [ ] Usa `actions/create-github-app-token@v2` en el workflow
- [ ] Verifica que los comentarios aparecen con el nombre de tu app

---

## Verificacion

Al completar este ejercicio, deberias tener:

1. Una skill `/review` que funciona en terminal y en CI
2. Un workflow de seguridad activado por rutas criticas
3. Un workflow programado ejecutable manualmente
4. Un workflow de triaje automatico de issues
5. Al menos una personalizacion implementada

---

## Criterios de Evaluacion

| Criterio | Puntos |
|----------|--------|
| Skill `/review` funciona en terminal y CI | 2 |
| Workflow de seguridad se activa solo en rutas correctas | 2 |
| Workflow programado es ejecutable manualmente | 2 |
| Triaje automatico funciona en un issue nuevo | 2 |
| Al menos una tarea de personalizacion completada | 2 |
| **Total** | **10** |
