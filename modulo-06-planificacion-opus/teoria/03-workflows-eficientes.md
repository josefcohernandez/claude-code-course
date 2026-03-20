# 03 - Workflows Eficientes

## 5 Workflows Probados

### 1. Writer → Reviewer

Claude escribe código, luego lo revisa como si fuera otra persona.

```
Sesión 1 (Writer):
> "Implementa el endpoint POST /api/orders"
> [Claude implementa]
> /exit

Sesión 2 (Reviewer):
> "Revisa el archivo src/api/orders.ts buscando:
>  bugs, vulnerabilidades de seguridad, edge cases no manejados,
>  y oportunidades de mejora. No modifiques nada, solo reporta."
> [Claude reporta issues]
> /clear
> "Ahora corrige los issues 1, 3 y 5 que encontraste"
```

**Cuándo usar**: Features críticas, código que maneja dinero/auth/datos sensibles.

### 2. Spec First

Definir la especificación antes de escribir código.

```
> Shift+Tab (Plan Mode)
> "Diseña la especificación para un sistema de notificaciones:
>  - Tipos: email, push, in-app
>  - Canales configurables por usuario
>  - Cola de procesamiento
>  - Reintentos con backoff
>  Describe: modelos, endpoints, flujo, tests"

> [Revisar spec]
> "Ajusta: usa Redis para la cola, no RabbitMQ"

> Shift+Tab (Normal)
> "Implementa los modelos según la spec"
> "Implementa los endpoints"
> "Implementa la cola"
> "Escribe tests"
```

**Cuándo usar**: Features medianas/grandes, cuando quieres documentación.

### 3. TDD con Claude

Test-Driven Development asistido.

```
Paso 1 - Escribir tests primero:
> "Escribe tests para un servicio de UserService que soporte:
>  create, getById, update, delete, listByRole.
>  Los tests deben fallar (no hay implementación aún)."

Paso 2 - Verificar que fallan:
> "Ejecuta los tests y confirma que fallan"

Paso 3 - Implementar para que pasen:
> "Implementa UserService para que todos los tests pasen.
>  No modifiques los tests."

Paso 4 - Refactorizar:
> "Refactoriza UserService manteniendo los tests verdes.
>  Extrae lógica de validación a un módulo aparte."
```

**Cuándo usar**: Código crítico, cuando quieres alta cobertura de tests.

### 4. Iterative Refinement

Empezar simple, mejorar iterativamente.

```
Iteración 1 - MVP:
> "Crea un endpoint GET /api/products que devuelva todos los productos"
> "Ejecuta tests"

Iteración 2 - Paginación:
> "Añade paginación: ?page=1&limit=20. Mantener retrocompatibilidad."
> "Ejecuta tests"

Iteración 3 - Filtros:
> "Añade filtros: ?category=X&minPrice=Y&maxPrice=Z"
> "Ejecuta tests"

Iteración 4 - Cache:
> "Añade cache Redis con TTL de 5 min. Invalidar al crear/editar producto."
> "Ejecuta tests"
```

**Cuándo usar**: Features que crecen incrementalmente, cuando no tienes spec clara.

### 5. Divide and Conquer

Dividir tarea grande en subtareas independientes.

```
Sesión Principal (Plan):
> "Necesito migrar de Express a Fastify. Diseña un plan dividido
>  en subtareas independientes que pueda ejecutar en sesiones separadas."

Claude propone:
1. Migrar configuración y middleware base
2. Migrar rutas de auth
3. Migrar rutas de users
4. Migrar rutas de orders
5. Migrar tests
6. Verificación final

Sesión 1: > "Ejecuta subtarea 1: migrar config y middleware"
Sesión 2: > "Ejecuta subtarea 2: migrar rutas auth"
...
```

**Cuándo usar**: Migraciones, refactorings grandes, cambios transversales.

---

## Anti-Workflows (qué NO hacer)

| Anti-workflow | Problema | Alternativa |
|--------------|---------|------------|
| "Haz todo de una vez" | Contexto saturado, errores | Dividir en sesiones |
| No revisar el plan | Implementación incorrecta | Siempre revisar Plan Mode |
| Todo con Opus | Coste excesivo | Opus planifica, Sonnet ejecuta |
| No ejecutar tests | Bugs no detectados | Tests después de cada cambio |
| Sesión de 2+ horas | Degradación | Sesiones de 15-30 min |

---

## Patrón del Día a Día

```bash
# 1. Planificar (5 min, Opus)
claude --model opus
> Shift+Tab
> "Hoy necesito: [lista de tareas]. Prioriza y sugiere orden."
> /exit

# 2. Implementar (por tarea, Sonnet)
claude
> "Tarea 1: [descripción precisa]"
> [implementar]
> "Ejecuta tests"
> /exit

# 3. Repetir para cada tarea
claude
> "Tarea 2: [descripción precisa]"
> ...
> /exit

# 4. Review final (Sonnet)
git diff main..HEAD | claude -p "Review completo: bugs, seguridad, mejoras"

# 5. Commit (Haiku)
git diff --staged | claude --model haiku -p "Commit message conventional commits"
```

---

## Métricas de Eficiencia

Lleva un registro durante una semana:

| Métrica | Cómo medir |
|---------|-----------|
| Tokens por tarea | `/cost` antes y después |
| Tiempo por tarea | Cronómetro |
| Iteraciones por tarea | Cuántas veces corriges a Claude |
| % tests pasando | Ejecutar tests al final |
| Coste diario total | Sumar `/cost` de todas las sesiones |

Objetivo: reducir iteraciones y tokens manteniendo calidad.
