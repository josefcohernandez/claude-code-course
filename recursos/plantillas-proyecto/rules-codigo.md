# Reglas de Codigo

## Estilo

- Usar nombres descriptivos para variables y funciones
- Funciones cortas: maximo 30 lineas, idealmente menos de 20
- Un archivo, una responsabilidad
- Prefiere composicion sobre herencia

## Manejo de errores

- Todas las funciones asincronas deben tener manejo de errores
- Los errores deben propagarse con mensajes descriptivos
- Nunca silenciar errores con bloques catch vacios
- Usar tipos de error especificos cuando sea posible

## Logging

- No usar console.log/print en produccion; usar un logger configurado
- Loguear al nivel correcto: debug, info, warn, error
- Nunca loguear datos sensibles (passwords, tokens, datos personales)

## Seguridad

- Nunca hardcodear secretos, usar variables de entorno
- Validar todos los inputs del usuario
- Usar queries parametrizadas, nunca concatenar SQL
- Mantener dependencias actualizadas
