# Reglas de Testing

## Estructura

- Un archivo de test por cada módulo o archivo fuente
- Separar tests unitarios de tests de integración en carpetas distintas
- Usar fixtures/setup compartido para precondiciones comunes

## Nombres

- Nombres descriptivos que expliquen el comportamiento esperado
- Formato: `test_[accion]_[condicion]_[resultado_esperado]`
- Ejemplos:
  - `test_login_con_credenciales_validas_devuelve_token`
  - `test_crear_tarea_sin_titulo_devuelve_400`

## Principios

- Cada test debe ser independiente (no depender del orden de ejecución)
- Cada test prueba UNA sola cosa
- Cubrir camino feliz Y casos de error
- Usar mocks/stubs para dependencias externas en tests unitarios
- Tests de integración con base de datos en memoria o contenedor

## Cobertura

- Objetivo mínimo: 60%
- Objetivo deseable: 80%
- Priorizar cobertura en lógica de negocio y validaciones
- No obsesionarse con cubrir getters/setters triviales

## TDD (cuando aplique)

- Escribir test primero (Red)
- Implementar el mínimo código para pasar (Green)
- Refactorizar sin romper tests (Refactor)
- Ejecutar TODOS los tests después de cada cambio
