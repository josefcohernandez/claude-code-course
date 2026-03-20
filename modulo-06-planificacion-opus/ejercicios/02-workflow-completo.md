# Ejercicio 02: Workflow Completo de Desarrollo

## Objetivo

Aplicar un workflow completo (Plan → Implement → Test → Review → Commit)
para una feature real, midiendo eficiencia en cada fase.

---

## La Feature: Sistema de Notificaciones

Implementar un sistema simple de notificaciones in-app:
- Crear notificacion (titulo, mensaje, tipo: info/warning/error, destinatario)
- Listar notificaciones de un usuario (paginadas)
- Marcar como leida
- Contar notificaciones no leidas

---

## Fase 1: Planificacion (10 min)

```bash
claude --model opus
> Shift+Tab (Plan Mode)
> "Diena un sistema de notificaciones in-app con:
>  - Crear notificacion (titulo, mensaje, tipo, destinatario)
>  - Listar por usuario con paginacion
>  - Marcar como leida
>  - Contar no leidas
>  Stack: [tu stack preferido]
>  Incluir: modelos, endpoints, tests"
> /cost
```

Anota: tokens_plan = ____

---

## Fase 2: Implementacion (20 min)

```bash
> Shift+Tab (Normal Mode)
> /model sonnet
> "Implementa los modelos segun el plan"
> /cost
> "Implementa los endpoints"
> /cost
> "Implementa la paginacion"
> /cost
```

Anota: tokens_impl = ____

---

## Fase 3: Testing (10 min)

```bash
> "Escribe tests para: crear notificacion, listar paginadas,
>  marcar como leida, contar no leidas"
> "Ejecuta los tests"
> "Si alguno falla, corrigelo"
> /cost
```

Anota: tokens_test = ____

---

## Fase 4: Review (5 min)

```bash
> /clear
> "Revisa todo el codigo del sistema de notificaciones.
>  Busca: bugs, edge cases, mejoras de rendimiento, seguridad.
>  No modifiques, solo reporta."
> /cost
```

Anota: tokens_review = ____

Si hay issues importantes, corregirlos.

---

## Fase 5: Commit (2 min)

```bash
> /exit
git add -A
git diff --staged | claude --model haiku -p "Commit message conventional commits"
```

---

## Metricas Totales

| Fase | Modelo | Tokens | Coste | Tiempo |
|------|--------|--------|-------|--------|
| Plan | Opus | ? | ? | ? min |
| Implementacion | Sonnet | ? | ? | ? min |
| Testing | Sonnet | ? | ? | ? min |
| Review | Sonnet | ? | ? | ? min |
| Commit | Haiku | ? | ? | ? min |
| **Total** | Mix | **?** | **$?** | **? min** |

---

## Reflexion

1. Que fase consumio mas tokens?
2. Que fase fue mas valiosa?
3. Usarias este workflow para todas las features?
4. Que simplificarias para features pequenas?
5. Que porcentaje del tiempo total fue planificacion vs implementacion?

---

## Criterios de Completitud

- [ ] Plan completado con Opus
- [ ] Implementacion completada con Sonnet
- [ ] Tests escritos y pasando
- [ ] Review ejecutado
- [ ] Tabla de metricas rellenada
- [ ] Commit realizado
