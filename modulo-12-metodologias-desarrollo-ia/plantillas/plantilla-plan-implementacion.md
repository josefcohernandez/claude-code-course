# Plan de Implementacion: [Nombre del Proyecto]

## Resumen

| Campo | Valor |
|-------|-------|
| Spec de referencia | SPEC.md |
| Stack | [ej: Python + FastAPI + PostgreSQL] |
| Fases | [N] |
| Metodologia | [SDD + Gherkin + TDD] |

---

## Fase 1: [Setup y configuracion] (~XX min)

### Objetivo
[Que se logra al completar esta fase]

### Tareas
- [ ] Inicializar proyecto y dependencias
- [ ] Configurar CLAUDE.md
- [ ] Configurar .claude/settings.json
- [ ] Setup de base de datos

### Verificacion
```bash
# Comando(s) para verificar que la fase esta completa
[ej: make dev → servidor arranca sin errores]
```

### Modelo recomendado
Sonnet (setup mecanico)

---

## Fase 2: [Modelo de datos] (~XX min)

### Objetivo
[Que se logra al completar esta fase]

### Tareas
- [ ] Definir modelos/esquemas
- [ ] Crear migraciones
- [ ] Tests unitarios de modelos

### Features Gherkin asociadas
- `features/[nombre].feature` - Escenarios: [listar]

### Verificacion
```bash
[ej: pytest tests/unit/test_models.py → todos pasan]
```

### Modelo recomendado
Sonnet (implementacion directa)

### Notas
- /clear antes de empezar esta fase
- [Cualquier consideracion especial]

---

## Fase 3: [Feature principal] (~XX min)

### Objetivo
[Que se logra al completar esta fase]

### Tareas
- [ ] Generar tests desde Gherkin (Red)
- [ ] Implementar logica de negocio (Green)
- [ ] Refactorizar (Refactor)
- [ ] Tests de integracion

### Features Gherkin asociadas
- `features/[nombre].feature` - Todos los escenarios

### Dependencias
- Fase 2 completada (modelos disponibles)

### Verificacion
```bash
[ej: pytest tests/ → todos pasan, cobertura > 80%]
```

### Modelo recomendado
Sonnet para implementacion, Opus para edge cases complejos

---

## Fase N: [Review y documentacion] (~XX min)

### Objetivo
Verificar calidad, seguridad y completitud

### Tareas
- [ ] Verificacion cruzada SPEC.md vs implementacion
- [ ] Review de seguridad (sesion Writer/Reviewer)
- [ ] Cobertura de tests >= [objetivo]%
- [ ] Generar documentacion API
- [ ] README con instrucciones de setup

### Verificacion
```bash
pytest --cov=src --cov-report=term-missing
# Todos los tests pasan, cobertura >= objetivo
```

---

## Sesiones de Claude Code

| Sesion | Fase(s) | Modelo | /clear |
|--------|---------|--------|--------|
| 1 | Fase 1 | Sonnet | Al iniciar |
| 2 | Fase 2 | Sonnet | Al iniciar |
| 3 | Fase 3 | Sonnet + Opus | Al iniciar |
| N | Review | Sonnet (sesion nueva) | Sesion separada (Reviewer) |

---

## Estimacion de Costos

| Fase | Modelo | Tokens est. | Costo est. |
|------|--------|-------------|------------|
| Fase 1 | Sonnet | ~10K | ~$0.05 |
| Fase 2 | Sonnet | ~15K | ~$0.08 |
| Fase 3 | Sonnet | ~25K | ~$0.12 |
| Review | Sonnet | ~10K | ~$0.05 |
| **Total** | | **~60K** | **~$0.30** |
