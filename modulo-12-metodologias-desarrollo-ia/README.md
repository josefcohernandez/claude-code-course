# Modulo 12: Metodologias de Desarrollo con IA

## Descripcion General

Este modulo presenta metodologias estructuradas para desarrollar software con Claude Code como copiloto. No se trata de "pedirle cosas a la IA", sino de aplicar procesos disciplinados que producen resultados predecibles y de calidad profesional. Cubrimos Spec-Driven Development, historias de usuario en formato Gherkin como input para Claude, TDD asistido por IA, y patrones avanzados de trabajo en paralelo.

**Tiempo estimado:** 2 horas

---

## Objetivos de Aprendizaje

Al completar este modulo, seras capaz de:

1. **Aplicar Spec-Driven Development** completo: entrevista → spec → implementacion → verificacion
2. **Escribir historias de usuario en Gherkin** y usarlas como input directo para Claude
3. **Practicar TDD asistido por IA**: Claude escribe tests primero, luego implementa
4. **Usar el patron Writer/Reviewer** con sesiones separadas
5. **Aplicar fan-out** para migraciones y cambios a escala
6. **Usar git worktrees** para sesiones paralelas aisladas
7. **Elegir la metodologia correcta** segun el tipo de tarea

---

## Estructura del Modulo

### Teoria

| Archivo | Tema | Duracion |
|---------|------|----------|
| [01-spec-driven-development.md](teoria/01-spec-driven-development.md) | Spec-Driven Development: de la entrevista al codigo | 30 min |
| [02-historias-usuario-gherkin.md](teoria/02-historias-usuario-gherkin.md) | Historias de usuario en Gherkin como input para Claude | 25 min |
| [03-tdd-con-ia.md](teoria/03-tdd-con-ia.md) | Test-Driven Development asistido por IA | 25 min |
| [04-patrones-avanzados.md](teoria/04-patrones-avanzados.md) | Writer/Reviewer, visual-driven, fan-out, worktrees | 20 min |

### Ejercicios Practicos

| Archivo | Ejercicio | Duracion |
|---------|-----------|----------|
| [01-spec-desde-cero.md](ejercicios/01-spec-desde-cero.md) | Crear spec completa via entrevista con Claude | 20 min |
| [02-implementar-user-stories.md](ejercicios/02-implementar-user-stories.md) | De historias Gherkin a codigo funcionando | 20 min |
| [03-tdd-completo.md](ejercicios/03-tdd-completo.md) | Ciclo TDD completo con Claude | 20 min |

### Plantillas

| Archivo | Descripcion |
|---------|-------------|
| [plantilla-spec.md](plantillas/plantilla-spec.md) | Template de especificacion tecnica |
| [plantilla-user-story-gherkin.md](plantillas/plantilla-user-story-gherkin.md) | Template de historia de usuario en Gherkin |
| [plantilla-plan-implementacion.md](plantillas/plantilla-plan-implementacion.md) | Template de plan de implementacion |

---

## Prerequisitos

- Haber completado los modulos 1 a 6 (especialmente M01 metodologia y M06 plan mode)
- Modulo 9 (skills/agentes) recomendado para patrones avanzados
- Familiaridad con conceptos de testing

---

## Conceptos Clave

| Concepto | Descripcion |
|----------|-------------|
| **Spec-Driven Development** | Metodologia donde primero se crea una spec completa y despues se implementa |
| **Entrevista con Claude** | Claude hace preguntas usando AskUserQuestion antes de implementar |
| **Gherkin** | Formato Given/When/Then para describir comportamiento esperado |
| **TDD con IA** | Claude escribe tests primero (red), luego implementa (green), luego refactoriza |
| **Writer/Reviewer** | Dos sesiones separadas: una implementa, otra revisa con contexto limpio |
| **Fan-out** | Distribuir trabajo en paralelo con `claude -p` sobre multiples archivos |
| **Git worktrees** | Directorios de trabajo aislados del mismo repo para sesiones paralelas |

---

## Flujo de Trabajo Recomendado

```
1. Teoria: Spec-Driven + Gherkin + TDD (80 min)
   |
2. Ejercicio 01: Crear spec via entrevista (20 min)
   |
3. Ejercicio 02: Implementar user stories Gherkin (20 min)
   |
4. Ejercicio 03: Ciclo TDD completo (20 min)
   |
5. Aplicar en el Modulo 13 (Proyecto Final)
```

---

## Por que un modulo de metodologias

Las herramientas cambian. Claude Code evolucionara, otros asistentes de IA apareceran. Pero las **metodologias** perduran. Un desarrollador que domine estas tecnicas sacara partido de cualquier herramienta de IA, hoy y en el futuro.

La diferencia entre un desarrollador que "usa IA" y uno que **desarrolla con IA** es exactamente esto: tener un proceso disciplinado en vez de improvisar cada interaccion.

---

## Recursos Adicionales

- [Best Practices - Documentacion oficial](https://code.claude.com/docs/en/best-practices)
- [Common Workflows - Documentacion oficial](https://code.claude.com/docs/en/common-workflows)
- [Cucumber - Referencia Gherkin](https://cucumber.io/docs/gherkin/reference/)
