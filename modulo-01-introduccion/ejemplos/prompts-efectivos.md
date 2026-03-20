# Ejemplos de Prompts Efectivos para Claude Code

## Principio Fundamental

Un buen prompt para Claude Code es **especifico, contextual y acotado**.
Claude Code ya tiene acceso a tu codebase, asi que no necesitas pegar codigo.

---

## Prompts por Categoria

### 1. Comprension de Codigo

| Prompt Vago | Prompt Efectivo |
|-------------|----------------|
| "Explica este codigo" | "Explica la funcion `processPayment` en `src/services/payment.ts`, enfocandote en el flujo de errores" |
| "Que hace el proyecto?" | "Describe la arquitectura de este proyecto: capas, patrones de diseno y flujo de una request HTTP" |
| "Ayuda con auth" | "Como funciona el middleware de autenticacion JWT en `src/middleware/auth.js`? Que pasa si el token expira?" |

### 2. Generacion de Codigo

| Prompt Vago | Prompt Efectivo |
|-------------|----------------|
| "Crea un endpoint" | "Crea un endpoint POST /api/users que reciba {name, email, role}, valide con Zod, guarde en PostgreSQL y devuelva 201" |
| "Anade tests" | "Escribe tests unitarios para `UserService.create()` cubriendo: input valido, email duplicado, y error de BD" |
| "Haz un componente" | "Crea un componente React `UserTable` que reciba un array de usuarios, muestre nombre/email/rol en una tabla, y permita ordenar por columna" |

### 3. Debugging

| Prompt Vago | Prompt Efectivo |
|-------------|----------------|
| "No funciona" | "El test `auth.spec.ts:45` falla con `TypeError: Cannot read property 'id' of undefined`. El mock de `findUser` devuelve null en lugar del usuario" |
| "Hay un bug" | "El endpoint GET /api/orders devuelve 500 cuando el usuario no tiene pedidos. Revisa el handler y el servicio" |
| "Arregla el error" | "Error: `ECONNREFUSED 127.0.0.1:5432`. La conexion a PostgreSQL falla en `src/db/connection.ts`. Verifica la configuracion" |

### 4. Refactoring

| Prompt Vago | Prompt Efectivo |
|-------------|----------------|
| "Mejora el codigo" | "Extrae la logica de validacion de `createUser` y `updateUser` en un middleware de validacion reutilizable" |
| "Limpia esto" | "Convierte las callbacks anidadas en `fileProcessor.js` a async/await manteniendo el manejo de errores" |
| "Optimiza" | "La query en `getOrdersByUser` hace N+1. Refactoriza para usar un JOIN o incluir las relaciones" |

### 5. DevOps / Infraestructura

| Prompt Vago | Prompt Efectivo |
|-------------|----------------|
| "Anade Docker" | "Crea un Dockerfile multi-stage para esta app Node.js: build con node:22-alpine, produccion con node:22-alpine slim, exponer puerto 3000" |
| "CI/CD" | "Crea un GitHub Action que ejecute lint, tests y build en PRs al branch main. Node 22, PostgreSQL como servicio" |
| "Deploy" | "Genera un docker-compose.yml con la app, PostgreSQL 16 y Redis 7, con healthchecks y volumen persistente para la BD" |

---

## Patrones de Prompt Avanzados

### Patron: Scope Explicito

```
Modifica SOLO el archivo src/services/auth.ts:
- Anade rate limiting al metodo login()
- Maximo 5 intentos por IP en 15 minutos
- No toques otros archivos
```

### Patron: Output Controlado

```
Corrige el bug en payment.service.ts linea 78.
Solo muestra los cambios, sin explicacion.
```

### Patron: Contexto de Equipo

```
Siguiendo las convenciones de este proyecto (ver CLAUDE.md),
crea un nuevo servicio para notificaciones push.
Usa el mismo patron que OrderService.
```

### Patron: Verificacion Incluida

```
Implementa la feature X. Despues:
1. Ejecuta los tests existentes
2. Si fallan, corrigelos
3. Anade tests para la nueva funcionalidad
4. Ejecuta lint
```

---

## Anti-patrones

| Anti-patron | Por que es malo | Alternativa |
|-------------|----------------|-------------|
| Pegar 500 lineas de codigo en el prompt | Desperdicia tokens, Claude ya puede leer archivos | Referir al archivo y linea |
| "Haz lo que creas mejor" | Demasiado abierto, resultado impredecible | Especificar el resultado esperado |
| Multiples tareas no relacionadas | Contamina el contexto | Una tarea por sesion, `/clear` entre tareas |
| No especificar restricciones | Claude puede sobrepasar el scope | Definir que NO debe cambiar |
| Explicar como funciona Claude | Pierde tokens | Ir directo a la tarea |
