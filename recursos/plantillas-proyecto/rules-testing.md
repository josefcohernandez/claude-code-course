# Reglas de Testing

## Estructura

- Un archivo de test por cada modulo/archivo fuente
- Separar tests unitarios de tests de integracion en carpetas distintas
- Usar fixtures/setup compartido para precondiciones comunes

## Nombres

- Nombres descriptivos que expliquen el comportamiento esperado
- Formato: `test_[accion]_[condicion]_[resultado_esperado]`
- Ejemplos:
  - `test_login_con_credenciales_validas_devuelve_token`
  - `test_crear_tarea_sin_titulo_devuelve_400`

## Principios

- Cada test debe ser independiente (no depender del orden de ejecucion)
- Cada test prueba UNA sola cosa
- Cubrir camino feliz Y casos de error
- Usar mocks/stubs para dependencias externas en tests unitarios
- Tests de integracion con base de datos en memoria o contenedor

## Cobertura

- Objetivo minimo: 60%
- Objetivo deseable: 80%
- Priorizar cobertura en logica de negocio y validaciones
- No obsesionarse con cubrir getters/setters triviales

## TDD (cuando aplique)

- Escribir test primero (Red)
- Implementar el minimo codigo para pasar (Green)
- Refactorizar sin romper tests (Refactor)
- Ejecutar TODOS los tests despues de cada cambio
