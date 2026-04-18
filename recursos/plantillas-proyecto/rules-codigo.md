# Reglas de Código

## Estilo

- Usar nombres descriptivos para variables y funciones
- Funciones cortas: máximo 30 líneas, idealmente menos de 20
- Un archivo, una responsabilidad
- Prefiere composición sobre herencia

## Manejo de errores

- Todas las funciones asíncronas deben tener manejo de errores
- Los errores deben propagarse con mensajes descriptivos
- Nunca silenciar errores con bloques `catch` vacíos
- Usar tipos de error específicos cuando sea posible

## Logging

- No usar `console.log`/`print` en producción; usar un logger configurado
- Loguear al nivel correcto: debug, info, warn, error
- Nunca loguear datos sensibles (passwords, tokens, datos personales)

## Seguridad

- Nunca hardcodear secretos; usar variables de entorno
- Validar todos los inputs del usuario
- Usar queries parametrizadas; nunca concatenar SQL
- Mantener dependencias actualizadas
