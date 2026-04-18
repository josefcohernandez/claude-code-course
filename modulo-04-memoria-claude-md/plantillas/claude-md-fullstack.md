# Plantilla CLAUDE.md - Proyecto Fullstack

> Copia como `CLAUDE.md` en la raíz del monorepo. Complementa con
> reglas modulares en `.claude/rules/` para cada parte del stack.

---

```markdown
# [Nombre del Proyecto]

Aplicación full stack para [descripción breve].

## Stack
- Frontend: React 19 + TypeScript + Vite
- Backend: Node.js + Express/Fastify (o Python + FastAPI)
- BD: PostgreSQL 16
- Cache: Redis 7
- Tests: Vitest (front) + Jest/pytest (back)
- CI: GitHub Actions
- Deploy: Docker + docker-compose

## Comandos
- `npm run dev` - Levantar todo (front + back + BD)
- `npm run dev:front` - Solo frontend
- `npm run dev:back` - Solo backend
- `npm test` - Todos los tests
- `npm run test:front` - Tests frontend
- `npm run test:back` - Tests backend
- `npm run lint` - Lint completo
- `npm run build` - Build de producción
- `npm run db:migrate` - Migraciones de BD
- `npm run db:seed` - Datos de prueba

## Estructura
frontend/
  src/
    components/  - Componentes React
    pages/       - Páginas y rutas
    hooks/       - Custom hooks
    api/         - Cliente API (fetch wrappers)
backend/
  src/
    routes/      - Endpoints API
    services/    - Lógica de negocio
    models/      - Modelos BD
    middleware/  - Auth, logging, etc.
shared/
  types/         - Types compartidos front/back
  constants/     - Constantes compartidas
infra/
  docker/        - Dockerfiles
  .github/       - GitHub Actions

## Convenciones
- TypeScript estricto en front y back
- camelCase para funciones; PascalCase para clases y componentes
- API REST: /api/v1/resources (plural)
- Commits: conventional commits (feat:, fix:, chore:)
- PRs: título corto + descripción con contexto

## Reglas
- Frontend y backend son independientes (comunicación solo vía API)
- Shared types para contratos API (no duplicar tipos)
- Variables de entorno en .env (nunca hardcoded)
- Docker para desarrollo local (`docker-compose up`)
- Tests obligatorios para features nuevas

## Restricciones
- No mezclar lógica frontend/backend
- No modificar docker-compose.prod.yml
- No instalar deps sin confirmar
- Ejecutar tests antes de dar tarea por completa

## Respuestas
- Concisas, sin explicaciones innecesarias
- Especificar en qué parte del stack se trabaja (front/back)
- No generar comentarios obvios
```

---

## Reglas Modulares Complementarias

Crear en `.claude/rules/`:

### frontend.md
```yaml
---
paths: ["frontend/**", "*.tsx", "*.jsx"]
---
```
Reglas específicas de React, hooks y estilos.

### backend.md
```yaml
---
paths: ["backend/**"]
---
```
Reglas de API, BD y servicios.

### testing.md
```yaml
---
paths: ["**/*.test.*", "**/*.spec.*", "tests/**"]
---
```
Reglas de testing por framework.

### infra.md
```yaml
---
paths: ["infra/**", "docker/**", "Dockerfile*", ".github/**"]
---
```
Reglas de Docker, CI/CD e infraestructura.
