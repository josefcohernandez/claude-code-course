# Reglas de API REST

## Formato de respuesta

- Todos los endpoints devuelven JSON
- Los errores tienen formato: `{ "error": "mensaje descriptivo" }`
- Las respuestas de listado incluyen paginación:
  ```json
  { "data": [...], "total": 100, "pagina": 1, "limite": 20, "totalPaginas": 5 }
  ```

## Códigos HTTP

- 200: Éxito (GET, PUT, PATCH)
- 201: Recurso creado (POST)
- 204: Sin contenido (DELETE exitoso)
- 400: Error de validación / request malformado
- 401: No autenticado
- 403: No autorizado (autenticado pero sin permiso)
- 404: Recurso no encontrado
- 409: Conflicto (ej: email duplicado)
- 500: Error interno del servidor

## Convenciones de URL

- Usar kebab-case para rutas: `/api/user-profiles`
- Plural para colecciones: `/api/tareas` (no `/api/tarea`)
- Anidar solo 1 nivel: `/api/usuarios/:id/tareas` (no más profundo)
- Versionado en la ruta: `/api/v1/...`

## Timestamps

- Usar formato ISO 8601: `2025-01-15T10:30:00Z`
- Almacenar siempre en UTC
- Incluir `creado_en` y `actualizado_en` en todos los recursos

## Autenticación

- Token JWT en header: `Authorization: Bearer <token>`
- Nunca enviar credenciales en query params
- Tokens con expiración (máximo 24h para access token)
