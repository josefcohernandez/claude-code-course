# Plantilla CLAUDE.md - Proyecto Backend

> Copia este archivo como `CLAUDE.md` en la raiz de tu proyecto backend
> y adaptalo a tu stack especifico.

---

```markdown
# [Nombre del Proyecto]

API REST para [descripcion breve].

## Stack
- Lenguaje: Python 3.12
- Framework: FastAPI
- BD: PostgreSQL 16 + SQLAlchemy 2.0 (async)
- Migraciones: Alembic
- Tests: pytest + pytest-asyncio
- Lint: Ruff + mypy
- Auth: JWT con python-jose

## Comandos
- `make dev` - Servidor desarrollo (uvicorn --reload)
- `make test` - Tests con pytest
- `make lint` - Ruff + mypy
- `make migrate` - Aplicar migraciones pendientes
- `make migrate:create MSG="descripcion"` - Nueva migracion
- `make seed` - Cargar datos de prueba

## Estructura
src/
  api/          - Endpoints FastAPI (routers)
  services/     - Logica de negocio
  models/       - Modelos SQLAlchemy
  schemas/      - Schemas Pydantic (request/response)
  middleware/   - Middleware (auth, logging, cors)
  utils/        - Utilidades
  config/       - Configuracion y settings
tests/
  unit/         - Tests unitarios
  integration/  - Tests de integracion
  fixtures/     - Fixtures compartidas

## Convenciones
- Funciones/variables: snake_case
- Clases: PascalCase
- Constantes: UPPER_SNAKE_CASE
- Archivos: snake_case.py
- Endpoints: /api/v1/resources (plural, kebab-case)
- Un router por recurso
- Un servicio por dominio

## Reglas
- Async handlers siempre (async def)
- Validacion con Pydantic v2, no manual
- Return Response models, no dicts
- Dependency injection via Depends()
- Logging con structlog, no print()
- Error handling con HTTPException
- Transacciones explicitas en servicios

## Restricciones
- No modificar alembic/env.py
- No modificar config/production.py
- No usar print(), usar logger
- No queries raw SQL (usar SQLAlchemy ORM)
- No instalar deps sin confirmar
- Ejecutar tests antes de dar tarea por completa

## Respuestas
- Concisas, sin explicaciones innecesarias
- Mostrar solo codigo que cambia
- No generar docstrings obvias
```
