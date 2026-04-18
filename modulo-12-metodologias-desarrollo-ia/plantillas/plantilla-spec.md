# [Nombre del Proyecto] - Especificación Técnica

## Contexto

[1-2 parrafos explicando por que se construye esto y que problema resuelve]

---

## Fuera de Alcance (v1)

Lo que explícitamente NO incluimos en esta versión:
- [Exclusion 1]
- [Exclusion 2]
- [Exclusion 3]

---

## Requisitos Funciónales

### RF-01: [Nombre del requisito]
**Descripción:** [Qué debe hacer]
**Verificación:** [Como saber que funciona correctamente]
**Ejemplo:**
```
Input: ...
Output esperado: ...
```

### RF-02: [Nombre del requisito]
...

---

## Requisitos No Funciónales

| Requisito | Criterio | Verificación |
|-----------|----------|--------------|
| Rendimiento | API responde en < 200ms (p95) | Load test con k6 |
| Seguridad | Passwords hasheados con bcrypt | Test de integración |
| Disponibilidad | 99.9% uptime | Monitoring |

---

## Diseño Técnico

### Stack
- Lenguaje: [ej: Python 3.12]
- Framework: [ej: FastAPI]
- Base de datos: [ej: PostgreSQL 16]
- ORM: [ej: SQLAlchemy]

### Arquitectura
```
[Díagrama ASCII de la arquitectura]
```

### Modelo de Datos

#### Tabla: [nombre]
| Campo | Tipo | Restricciones | Descripción |
|-------|------|--------------|-------------|
| id | UUID | PK, auto | Identificador único |
| ... | ... | ... | ... |

### Endpoints de API

#### [METHOD] /ruta
**Descripción:** [Qué hace]
**Autenticación:** [Si/No, tipo]

Request:
```json
{
  "campo": "valor"
}
```

Response (200):
```json
{
  "campo": "valor"
}
```

Response (400):
```json
{
  "error": "Descripción del error"
}
```

---

## Edge Cases y Manejo de Errores

| Escenario | Comportamiento esperado | Código HTTP |
|-----------|------------------------|-------------|
| [Escenario 1] | [Respuesta] | [400/404/etc] |

---

## Plan de Testing

| Tipo | Cobertura | Herramienta |
|------|-----------|-------------|
| Unitarios | Lógica de negocio, validaciónes | pytest |
| Integración | Endpoints API completos | pytest + httpx |
| Seguridad | OWASP Top 10 | Revisión manual + tests |

---

## Fases de Implementación

### Fase 1: [Nombre] (estimacion)
- [ ] [Tarea 1]
- [ ] [Tarea 2]
**Dependencias:** Ninguna

### Fase 2: [Nombre] (estimacion)
- [ ] [Tarea 1]
- [ ] [Tarea 2]
**Dependencias:** Fase 1
