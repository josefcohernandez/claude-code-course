# Ejemplos de Prompts Efectivos para Claude Code

## Principio Fundamental

Un buen prompt para Claude Code es **específico, contextual y acotado**.
Claude Code ya tiene acceso a tu codebase, así que no necesitas pegar código.

---

## Prompts por Categoría

### 1. Comprensión de Código

| Prompt Vago | Prompt Efectivo |
|-------------|-----------------|
| "Explica este código" | "Explica la función `processPayment` en `src/services/payment.ts`, enfocándote en el flujo de errores" |
| "¿Qué hace el proyecto?" | "Describe la arquitectura de este proyecto: capas, patrones de diseño y flujo de una request HTTP" |
| "Ayuda con auth" | "¿Cómo funciona el middleware de autenticación JWT en `src/middleware/auth.js`? ¿Qué pasa si el token expira?" |

### 2. Generación de Código

| Prompt Vago | Prompt Efectivo |
|-------------|-----------------|
| "Crea un endpoint" | "Crea un endpoint POST /api/users que reciba {name, email, role}, valide con Zod, guarde en PostgreSQL y devuelva 201" |
| "Añade tests" | "Escribe tests unitarios para `UserService.create()` cubriendo: input válido, email duplicado y error de BD" |
| "Haz un componente" | "Crea un componente React `UserTable` que reciba un array de usuarios, muestre nombre/email/rol en una tabla y permita ordenar por columna" |

### 3. Debugging

| Prompt Vago | Prompt Efectivo |
|-------------|-----------------|
| "No funciona" | "El test `auth.spec.ts:45` falla con `TypeError: Cannot read property 'id' of undefined`. El mock de `findUser` devuelve null en lugar del usuario" |
| "Hay un bug" | "El endpoint GET /api/orders devuelve 500 cuando el usuario no tiene pedidos. Revisa el handler y el servicio" |
| "Arregla el error" | "Error: `ECONNREFUSED 127.0.0.1:5432`. La conexión a PostgreSQL falla en `src/db/connection.ts`. Verifica la configuración" |

### 4. Refactoring

| Prompt Vago | Prompt Efectivo |
|-------------|-----------------|
| "Mejora el código" | "Extrae la lógica de validación de `createUser` y `updateUser` en un middleware de validación reutilizable" |
| "Limpia esto" | "Convierte las callbacks anidadas en `fileProcessor.js` a async/await manteniendo el manejo de errores" |
| "Optimiza" | "La query en `getOrdersByUser` hace N+1. Refactoriza para usar un JOIN o incluir las relaciones" |

### 5. DevOps / Infraestructura

| Prompt Vago | Prompt Efectivo |
|-------------|-----------------|
| "Añade Docker" | "Crea un Dockerfile multi-stage para esta app Node.js: build con node:22-alpine, producción con node:22-alpine slim, exponer puerto 3000" |
| "CI/CD" | "Crea un GitHub Action que ejecute lint, tests y build en PRs al branch main. Node 22, PostgreSQL como servicio" |
| "Deploy" | "Genera un docker-compose.yml con la app, PostgreSQL 16 y Redis 7, con healthchecks y volumen persistente para la BD" |

---

## Patrones de Prompt Avanzados

### Patrón: Scope Explícito

```
Modifica SOLO el archivo src/services/auth.ts:
- Añade rate limiting al método login()
- Máximo 5 intentos por IP en 15 minutos
- No toques otros archivos
```

### Patrón: Output Controlado

```
Corrige el bug en payment.service.ts línea 78.
Solo muestra los cambios, sin explicación.
```

### Patrón: Contexto de Equipo

```
Siguiendo las convenciones de este proyecto (ver CLAUDE.md),
crea un nuevo servicio para notificaciones push.
Usa el mismo patrón que OrderService.
```

### Patrón: Verificación Incluida

```
Implementa la feature X. Después:
1. Ejecuta los tests existentes
2. Si fallan, corrígelos
3. Añade tests para la nueva funcionalidad
4. Ejecuta lint
```

---

## Anti-patrones

| Anti-patrón | Por qué es malo | Alternativa |
|-------------|-----------------|-------------|
| Pegar 500 líneas de código en el prompt | Desperdicia tokens; Claude ya puede leer archivos | Referir al archivo y la línea |
| "Haz lo que creas mejor" | Demasiado abierto; resultado impredecible | Especificar el resultado esperado |
| Múltiples tareas no relacionadas | Contamina el contexto | Una tarea por sesión; `/clear` entre tareas |
| No especificar restricciones | Claude puede sobrepasar el scope | Definir qué NO debe cambiar |
| Explicar cómo funciona Claude | Pierde tokens | Ir directo a la tarea |
