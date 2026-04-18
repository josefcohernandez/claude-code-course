# Ejercicio 01: Plan Mode en Practica

## Objetivo

Disenar una API REST completa usando Plan Mode, comparando la calidad
entre planificar con Opus vs implementar directamente con Sonnet.

---

## Contexto del Mini-Proyecto

Vas a disenar una API REST para un **sistema de reservas de salas de reunion**:

- Salas con nombre, capacidad, equipamiento (proyector, pizarra, videoconferencia)
- Reservas con sala, fecha, hora inicio/fin, organizador, asistentes
- Conflictos: no se puede reservar una sala ya ocupada
- Búsqueda: salas disponibles en un rango horario

---

## Parte 1: Planificacion con Opus (15 min)

```bash
claude --model opus
```

```
> Shift+Tab (Plan Mode)

> Disenar una API REST para sistema de reservas de salas:
>
> Requisitos:
> - CRUD de salas (nombre, capacidad, equipamiento)
> - CRUD de reservas (sala, fecha, hora inicio/fin, organizador)
> - Deteccion de conflictos de horario
> - Búsqueda de salas disponibles por rango horario
> - Autenticacion JWT
>
> Stack: Python + FastAPI + PostgreSQL + SQLAlchemy
>
> Incluir en el plan:
> 1. Modelos de datos (tablas, relaciones)
> 2. Endpoints (metodo, ruta, request/response)
> 3. Logica de deteccion de conflictos
> 4. Estructura de archivos
> 5. Tests a escribir
```

**Guarda el plan** (copia a un archivo o toma nota).

```
> /cost   # Anotar tokens del plan
> /exit
```

---

## Parte 2: Implementacion con Sonnet (20 min)

```bash
mkdir -p ~/room-booking && cd ~/room-booking
claude --model sonnet
```

```
> "Implementa el paso 1 del plan: modelos de datos"
> "Implementa el paso 2: endpoints de salas"
> "Implementa el paso 3: endpoints de reservas con deteccion de conflictos"
> "Implementa el paso 4: busqueda de salas disponibles"
> "Escribe tests para la deteccion de conflictos"
> "Ejecuta los tests"
> /cost
```

---

## Parte 3: Comparacion Sin Plan (15 min)

En otro directorio, implementa lo mismo SIN planificar:

```bash
mkdir -p ~/room-booking-noplan && cd ~/room-booking-noplan
claude --model sonnet
```

```
> "Crea una API REST con FastAPI para reservas de salas de reunion.
>  CRUD de salas, CRUD de reservas, deteccion conflictos, busqueda
>  disponibilidad. PostgreSQL + SQLAlchemy. Incluye tests."
> /cost
```

---

## Parte 4: Comparativa

| Metrica | Con Plan (Opus+Sonnet) | Sin Plan (Solo Sonnet) |
|---------|----------------------|----------------------|
| Tokens planificacion | ? | 0 |
| Tokens implementacion | ? | ? |
| Tokens total | ? | ? |
| Coste total | ? | ? |
| Archivos creados | ? | ? |
| Tests pasando | ?/? | ?/? |
| Deteccion conflictos correcta? | Si/No | Si/No |
| Estructura limpia? | Si/No | Si/No |

---

## Reflexion

1. El plan de Opus fue util? Que anadio vs improvisar?
2. La implementacion fue mas rapida con plan?
3. La calidad del codigo fue mejor con plan?
4. El coste extra de Opus se justifica?
5. En que tipo de tareas usarias Plan Mode en tu dia a dia?

---

## Criterios de Completitud

- [ ] Plan diseñado con Opus en Plan Mode
- [ ] Implementacion completada con Sonnet
- [ ] Version sin plan completada para comparar
- [ ] Tabla comparativa rellenada
- [ ] Reflexion documentada
