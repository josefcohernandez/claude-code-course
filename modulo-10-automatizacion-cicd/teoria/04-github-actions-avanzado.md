# 04 - GitHub Actions Avanzado: Patrones y Workflows Especializados

## Introducción

Una vez que dominas la configuración básica de `claude-code-action@v1`, es hora de explorar patrones avanzados que maximizan su valor. En esta sección cubrimos workflows programados, revisiones por rutas críticas, automatización de issues, y cómo aprovechar la configuración `.claude/` del proyecto para mantener la coherencia entre el desarrollo local y CI.

---

## Workflows Programados con `schedule`

No todo tiene que ser reactivo a PRs o comentarios. Puedes usar `schedule` (cron) para ejecutar Claude periódicamente.

### Reporte diario de actividad

```yaml
# .github/workflows/claude-daily-report.yml
name: Claude - Reporte Diario

on:
  schedule:
    - cron: "0 9 * * 1-5"  # Lunes a viernes a las 9:00 UTC

permissions:
  contents: read
  issues: write

jobs:
  daily-report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 50  # Suficiente historial para el reporte

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Genera un reporte diario del repositorio:
            1. Resumen de commits de las últimas 24 horas
            2. PRs abiertos pendientes de revisión
            3. Issues nuevos o actualizados
            4. Métricas de actividad del equipo
            Publica el reporte como un issue nuevo con etiqueta 'daily-report'.
          claude_args: "--max-turns 10 --model claude-sonnet-4-5-20250929"
```

### Auditoría de seguridad semanal

```yaml
# .github/workflows/claude-security-audit.yml
name: Claude - Auditoría Semanal de Seguridad

on:
  schedule:
    - cron: "0 10 * * 1"  # Lunes a las 10:00 UTC

permissions:
  contents: read
  issues: write

jobs:
  security-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Realiza una auditoría de seguridad del repositorio:
            1. Revisa dependencias en busca de vulnerabilidades conocidas
            2. Busca secrets o credenciales hardcodeadas
            3. Identifica patrones de código inseguros (inyección SQL, XSS, etc.)
            4. Verifica que los archivos sensibles están en .gitignore
            Crea un issue con etiqueta 'security-audit' con los hallazgos.
          claude_args: "--max-turns 15 --model claude-sonnet-4-5-20250929"
```

### Limpieza de issues stale

```yaml
# .github/workflows/claude-stale-issues.yml
name: Claude - Limpieza de Issues

on:
  schedule:
    - cron: "0 8 1 * *"  # Primer día de cada mes

permissions:
  issues: write

jobs:
  stale-cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Revisa los issues abiertos del repositorio:
            1. Identifica issues sin actividad en los últimos 60 días
            2. Determina si siguen siendo relevantes basándote en el código actual
            3. Para cada uno, comenta con un resumen de estado y sugiere si debe cerrarse
            4. Etiqueta como 'stale' los que no parezcan relevantes
          claude_args: "--max-turns 10"
```

---

## Revisión Focalizada por Rutas Críticas

En lugar de revisar todos los PRs por igual, puedes crear workflows especializados que se activan solo cuando se modifican archivos críticos.

### Revisión de seguridad para rutas sensibles

```yaml
# .github/workflows/claude-security-review.yml
name: Claude - Revisión de Seguridad

on:
  pull_request:
    paths:
      - 'src/auth/**'
      - 'src/api/**'
      - 'src/middleware/**'
      - '**/security/**'
      - '*.config.*'
      - '.env*'
      - 'docker-compose*'
      - 'Dockerfile*'

permissions:
  contents: read
  pull-requests: write

jobs:
  security-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Este PR modifica archivos relacionados con seguridad.
            Realiza una revisión EXCLUSIVAMENTE enfocada en seguridad:
            - Vulnerabilidades OWASP Top 10
            - Secretos o credenciales expuestas
            - Inyección SQL, XSS, CSRF
            - Validación y sanitización de inputs
            - Autenticación y autorización
            - Configuración insegura de servicios
            Marca como "Changes requested" si encuentras algo crítico.
          claude_args: "--max-turns 10 --model claude-sonnet-4-5-20250929"
```

### Revisión de rendimiento para rutas de datos

```yaml
# .github/workflows/claude-perf-review.yml
name: Claude - Revisión de Rendimiento

on:
  pull_request:
    paths:
      - 'src/database/**'
      - 'src/queries/**'
      - '**/repository/**'
      - '**/*.sql'

permissions:
  contents: read
  pull-requests: write

jobs:
  perf-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Este PR modifica código relacionado con base de datos.
            Enfócate EXCLUSIVAMENTE en rendimiento:
            - Consultas N+1
            - Índices faltantes
            - Complejidad algorítmica (Big O)
            - Oportunidades de caching
            - Transacciones innecesariamente largas
            - Queries sin límite o paginación
          claude_args: "--max-turns 8 --model claude-sonnet-4-5-20250929"
```

### Revisión de API pública

```yaml
# .github/workflows/claude-api-review.yml
name: Claude - Revisión de API

on:
  pull_request:
    paths:
      - 'src/api/**'
      - 'openapi/**'
      - '**/swagger*'
      - '**/routes/**'

permissions:
  contents: read
  pull-requests: write

jobs:
  api-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Este PR modifica la API pública. Revisa:
            - Compatibilidad hacia atrás (breaking changes)
            - Consistencia en nomenclatura de endpoints
            - Códigos HTTP correctos
            - Validación de request/response
            - Documentación de endpoints (OpenAPI/Swagger)
            - Manejo de errores consistente
          claude_args: "--max-turns 8"
```

---

## Automatización de Issues

### Triaje automático con etiquetas

```yaml
# .github/workflows/claude-issue-triage.yml
name: Claude - Triaje de Issues

on:
  issues:
    types: [opened]

permissions:
  issues: write

jobs:
  triage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Analiza este issue recién creado:
            1. Clasifica su tipo: bug, feature, question, documentation, enhancement
            2. Estima prioridad: critical, high, medium, low
            3. Identifica el área del código afectada
            4. Si es un bug, sugiere posibles causas basándote en el código
            5. Sugiere etiquetas apropiadas
            Responde con un comentario estructurado en español.
          claude_args: "--max-turns 5 --model claude-sonnet-4-5-20250929"
```

### Implementación automática de issues

```yaml
# .github/workflows/claude-implement-issue.yml
name: Claude - Implementar Issue

on:
  issues:
    types: [assigned]

permissions:
  contents: write
  pull-requests: write
  issues: write

jobs:
  implement:
    # Solo si se asigna a Claude (vía etiqueta o asignación)
    if: contains(github.event.issue.labels.*.name, 'claude-implement')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Implementa la funcionalidad descrita en este issue.
            1. Lee la descripción del issue completa
            2. Analiza el código existente
            3. Implementa la solución
            4. Añade o actualiza tests
            5. Crea un PR con los cambios
          claude_args: "--max-turns 20 --model claude-sonnet-4-5-20250929"
```

---

## Workflows Multi-Job

Puedes combinar múltiples revisiones especializadas en un solo workflow.

### Pipeline de calidad completo

```yaml
# .github/workflows/claude-quality-pipeline.yml
name: Claude - Pipeline de Calidad

on:
  pull_request:
    types: [opened, synchronize]

permissions:
  contents: read
  pull-requests: write

jobs:
  # Job 1: Revisión general rápida
  quick-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Revisión rápida: identifica los 3 problemas más importantes de este PR.
            Sé breve y directo.
          claude_args: "--max-turns 3 --model claude-sonnet-4-5-20250929"

  # Job 2: Revisión de seguridad (solo si hay archivos sensibles)
  security-check:
    if: |
      contains(github.event.pull_request.changed_files, 'auth') ||
      contains(github.event.pull_request.changed_files, 'api')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "/review"  # Usa la skill de review del proyecto
          claude_args: "--max-turns 8"

  # Job 3: Verificación de tests
  test-coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Analiza si este PR tiene tests suficientes:
            1. Identifica funciones nuevas o modificadas
            2. Verifica que tienen tests correspondientes
            3. Sugiere tests faltantes con ejemplos de código
          claude_args: "--max-turns 5"
```

---

## Patrones de Eficiencia y Control de Costos

### Concurrency: evitar ejecuciones duplicadas

```yaml
# Cancelar ejecuciones anteriores del mismo PR
concurrency:
  group: claude-${{ github.event.pull_request.number || github.event.issue.number }}
  cancel-in-progress: true
```

### Timeout: evitar ejecuciones sin fin

```yaml
jobs:
  review:
    runs-on: ubuntu-latest
    timeout-minutes: 10  # Máximo 10 minutos
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          claude_args: "--max-turns 5 --max-budget-usd 0.50"
```

### Ejecución condicional inteligente

```yaml
jobs:
  review:
    # No ejecutar en PRs de dependabot o renovate
    if: |
      github.actor != 'dependabot[bot]' &&
      github.actor != 'renovate[bot]'
    runs-on: ubuntu-latest
    # ...
```

### Tabla de costos estimados

| Tipo de workflow | Modelo recomendado | `--max-turns` | Costo estimado |
|------------------|--------------------|---------------|----------------|
| Revisión rápida de PR | Sonnet | 3-5 | ~$0.02-0.10 |
| Revisión exhaustiva | Sonnet | 8-15 | ~$0.10-0.50 |
| Implementación de issue | Sonnet/Opus | 15-25 | ~$0.50-2.00 |
| Triaje de issue | Sonnet | 3-5 | ~$0.01-0.05 |
| Reporte programado | Sonnet | 5-10 | ~$0.05-0.20 |
| Auditoría de seguridad | Opus | 10-20 | ~$0.50-3.00 |

---

## Usando una GitHub App Personalizada

Para organizaciones que necesitan más control (nombre de usuario branded, permisos personalizados):

### Paso 1: Crear la GitHub App

1. Ve a [github.com/settings/apps/new](https://github.com/settings/apps/new)
2. Configura permisos: Contents (R/W), Issues (R/W), Pull requests (R/W)
3. Desmarca "Active" en Webhooks
4. Genera una private key (.pem)
5. Instala la app en tu repositorio

### Paso 2: Configurar secretos

- `APP_ID`: ID de tu GitHub App
- `APP_PRIVATE_KEY`: Contenido del archivo .pem

### Paso 3: Usar en el workflow

```yaml
steps:
  - uses: actions/checkout@v4

  # Generar token temporal de la GitHub App
  - name: Generar token
    id: app-token
    uses: actions/create-github-app-token@v2
    with:
      app-id: ${{ secrets.APP_ID }}
      private-key: ${{ secrets.APP_PRIVATE_KEY }}

  - uses: anthropics/claude-code-action@v1
    with:
      anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
      github_token: ${{ steps.app-token.outputs.token }}
```

---

## Resumen

| Patrón | Trigger | Caso de uso |
|--------|---------|-------------|
| Revisión por rutas | `pull_request.paths` | Seguridad, rendimiento, API |
| Reporte programado | `schedule.cron` | Reportes diarios/semanales |
| Triaje de issues | `issues.opened` | Clasificación automática |
| Implementación | `issues.assigned` + etiqueta | Desarrollo automatizado |
| Multi-job | `pull_request` | Pipeline de calidad completo |
| Concurrency | `concurrency.group` | Evitar duplicados y costos |
| GitHub App custom | Cualquiera | Control enterprise |

Los workflows avanzados permiten crear un sistema de calidad completo donde Claude actúa como un miembro más del equipo, con responsabilidades específicas y activación automática según el contexto.
