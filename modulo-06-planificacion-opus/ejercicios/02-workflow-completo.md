# Ejercicio 02: Workflow Completo de Desarrollo

## Objetivo

Aplicar un workflow completo (Plan → Implement → Test → Review → Commit)
para una feature real, midiendo eficiencia en cada fase.

---

## La Feature: Sistema de Notificaciones

Implementar un sistema simple de notificaciones in-app:
- Crear notificación (título, mensaje, tipo: info/warning/error, destinatario)
- Listar notificaciones de un usuario (paginadas)
- Marcar como leída
- Contar notificaciones no leídas

---

## Fase 1: Planificación (10 min)

```bash
claude --model opus
> Shift+Tab (Plan Mode)
> "Diseña un sistema de notificaciones in-app con:
>  - Crear notificación (título, mensaje, tipo, destinatario)
>  - Listar por usuario con paginación
>  - Marcar como leída
>  - Contar no leídas
>  Stack: [tu stack preferido]
>  Incluir: modelos, endpoints, tests"
> /cost
```

Anota: tokens_plan = ____

---

## Fase 2: Implementación (20 min)

```bash
> Shift+Tab (Normal Mode)
> /model sonnet
> "Implementa los modelos según el plan"
> /cost
> "Implementa los endpoints"
> /cost
> "Implementa la paginación"
> /cost
```

Anota: tokens_impl = ____

---

## Fase 3: Testing (10 min)

```bash
> "Escribe tests para: crear notificación, listar paginadas,
>  marcar como leída, contar no leídas"
> "Ejecuta los tests"
> "Si alguno falla, corrígelo"
> /cost
```

Anota: tokens_test = ____

---

## Fase 4: Review (5 min)

```bash
> /clear
> "Revisa todo el código del sistema de notificaciones.
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

## Métricas Totales

| Fase | Modelo | Tokens | Coste | Tiempo |
|------|--------|--------|-------|--------|
| Plan | Opus | ? | ? | ? min |
| Implementación | Sonnet | ? | ? | ? min |
| Testing | Sonnet | ? | ? | ? min |
| Review | Sonnet | ? | ? | ? min |
| Commit | Haiku | ? | ? | ? min |
| **Total** | Mix | **?** | **$?** | **? min** |

---

## Reflexión

1. ¿Qué fase consumió más tokens?
2. ¿Qué fase fue más valiosa?
3. ¿Usarías este workflow para todas las features?
4. ¿Qué simplificarías para features pequeñas?
5. ¿Qué porcentaje del tiempo total fue planificación vs. implementación?

---

## Criterios de Completitud

- [ ] Plan completado con Opus
- [ ] Implementación completada con Sonnet
- [ ] Tests escritos y pasando
- [ ] Review ejecutado
- [ ] Tabla de métricas rellenada
- [ ] Commit realizado
