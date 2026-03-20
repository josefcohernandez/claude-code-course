# Ejercicio 02: De Historias Gherkin a Codigo Funcionando

## Objetivo

Implementar una funcionalidad completa partiendo unicamente de historias de usuario escritas en formato Gherkin. Claude genera tests desde los escenarios y luego implementa el codigo para pasarlos.

**Duracion estimada:** 20 minutos

---

## El Proyecto

Vas a implementar un **servicio de carrito de compras** partiendo de escenarios Gherkin. No hay spec previa: las historias Gherkin SON la especificacion.

---

## Parte 1: Crear el Proyecto y las Features (5 min)

### Paso 1: Setup

```bash
mkdir -p /tmp/shopping-cart && cd /tmp/shopping-cart
mkdir -p features tests src
```

### Paso 2: Escribir las features

Crea el archivo `features/cart.feature` con este contenido:

```gherkin
Feature: Carrito de compras
  Como comprador
  Quiero gestionar productos en mi carrito
  Para poder realizar una compra

  Background:
    Given un catalogo con los siguientes productos:
      | id | nombre      | precio | stock |
      | 1  | Camiseta    | 25.00  | 10    |
      | 2  | Pantalon    | 45.00  | 5     |
      | 3  | Zapatos     | 80.00  | 3     |
    And un carrito vacio para el usuario "cliente1"

  Scenario: Agregar producto al carrito
    When el usuario agrega el producto "Camiseta" con cantidad 2
    Then el carrito contiene 1 item
    And el item "Camiseta" tiene cantidad 2
    And el total del carrito es 50.00

  Scenario: Agregar mismo producto incrementa cantidad
    Given el carrito contiene 1 "Camiseta"
    When el usuario agrega el producto "Camiseta" con cantidad 2
    Then el item "Camiseta" tiene cantidad 3
    And el total del carrito es 75.00

  Scenario: Agregar producto sin stock suficiente
    When el usuario agrega el producto "Zapatos" con cantidad 5
    Then el sistema rechaza la operacion con error "Stock insuficiente"
    And el carrito sigue vacio

  Scenario: Eliminar producto del carrito
    Given el carrito contiene 2 "Camiseta" y 1 "Pantalon"
    When el usuario elimina "Camiseta" del carrito
    Then el carrito contiene 1 item
    And el total del carrito es 45.00

  Scenario: Actualizar cantidad de un producto
    Given el carrito contiene 2 "Camiseta"
    When el usuario actualiza la cantidad de "Camiseta" a 5
    Then el item "Camiseta" tiene cantidad 5
    And el total del carrito es 125.00

  Scenario: Actualizar cantidad a cero elimina el producto
    Given el carrito contiene 2 "Camiseta"
    When el usuario actualiza la cantidad de "Camiseta" a 0
    Then el carrito esta vacio

  Scenario: Vaciar carrito completo
    Given el carrito contiene 2 "Camiseta" y 1 "Pantalon"
    When el usuario vacia el carrito
    Then el carrito esta vacio
    And el total del carrito es 0.00

  Scenario Outline: Calcular total con multiples productos
    Given el carrito contiene <cant_a> "<prod_a>" y <cant_b> "<prod_b>"
    Then el total del carrito es <total>

    Examples:
      | cant_a | prod_a   | cant_b | prod_b   | total  |
      | 1      | Camiseta | 1      | Pantalon | 70.00  |
      | 2      | Camiseta | 1      | Zapatos  | 130.00 |
      | 3      | Pantalon | 2      | Zapatos  | 295.00 |

  Scenario: No se puede agregar producto inexistente
    When el usuario agrega el producto "Sombrero" con cantidad 1
    Then el sistema rechaza la operacion con error "Producto no encontrado"
```

---

## Parte 2: Generar Tests desde Gherkin (5 min)

### Paso 3: Abrir Claude Code

```bash
cd /tmp/shopping-cart
claude
```

### Paso 4: Generar tests

```
Lee features/cart.feature. Genera tests en Python (pytest) que
implementen cada escenario Gherkin.

Reglas:
- Cada Scenario = exactamente 1 funcion de test
- Cada Scenario Outline = 1 test parametrizado con @pytest.mark.parametrize
- El Background se implementa como fixtures
- Los tests deben llamar a funciones/metodos del modulo src/cart.py
- Los tests deben FALLAR porque src/cart.py no existe todavia

Guarda los tests en tests/test_cart.py.
Ejecuta los tests para confirmar que fallan.
```

**Verifica:** Claude debe generar ~10 tests que todos fallen con `ModuleNotFoundError` o `ImportError`.

---

## Parte 3: Implementar para Pasar los Tests (10 min)

### Paso 5: Implementar

```
Los tests en tests/test_cart.py estan fallando porque no existe
la implementacion. Implementa src/cart.py con las clases y funciones
necesarias para que TODOS los tests pasen.

Reglas:
- NO modifiques los tests
- Implementa el minimo codigo necesario
- Ejecuta los tests despues de cada cambio significativo
- Cuando todos pasen, muestra el resultado final
```

### Paso 6: Verificar cobertura

```
Ejecuta los tests con cobertura (pytest --cov=src).
Si hay lineas no cubiertas, anade tests adicionales en
tests/test_cart_extra.py para cubrir esas lineas.
```

---

## Parte 4: Traza Gherkin → Test → Codigo

### Paso 7: Verificar trazabilidad

```
Genera una tabla de trazabilidad que muestre:
- Escenario Gherkin → Funcion de test → Funcion/metodo implementado

Formato:
| Escenario | Test | Implementacion |
|-----------|------|----------------|

Verifica que cada escenario tiene test y cada test tiene implementacion.
```

---

## Verificacion

Al completar este ejercicio, deberias tener:

```
/tmp/shopping-cart/
├── features/
│   └── cart.feature          # Escenarios Gherkin (input)
├── tests/
│   ├── test_cart.py          # Tests generados desde Gherkin
│   └── test_cart_extra.py    # Tests adicionales de cobertura
└── src/
    └── cart.py               # Implementacion
```

### Checklist

| Criterio | Cumplido? |
|----------|-----------|
| Todos los tests generados desde Gherkin pasan | |
| Cada Scenario tiene exactamente 1 test | |
| El Scenario Outline genera tests parametrizados | |
| src/cart.py no fue modificado por ti (solo por Claude) | |
| Los tests no fueron modificados despues de generarlos | |
| La cobertura es >= 90% | |

---

## Criterios de Evaluacion

| Criterio | Puntos |
|----------|--------|
| Features Gherkin bien escritas (proporcionadas) | 2 |
| Tests generados correctamente desde Gherkin | 3 |
| Implementacion pasa todos los tests | 3 |
| Cobertura >= 90% | 2 |
| **Total** | **10** |
