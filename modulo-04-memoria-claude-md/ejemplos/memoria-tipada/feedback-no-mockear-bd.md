---
name: no-mockear-bd-integracion
description: En tests de integracion se usa PostgreSQL real, no mocks
type: feedback
---

No mockear la base de datos en tests de integracion.

**Why:** El equipo ya ha tenido regresiones por comportamientos que solo fallaban con la BD
real: transacciones, constraints e indices. Los mocks daban una falsa sensacion de seguridad.

**How to apply:** En tests de integracion usar la fixture de base de datos real con rollback.
Reservar mocks para tests unitarios puros de logica de negocio.
