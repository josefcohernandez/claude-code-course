# Ejercicio 02: De Historias Gherkin a Código Funcionando

## Objetivo

Implementar una funcionalidad completa partiendo únicamente de historias de usuario escritas en formato Gherkin. Claude genera tests desde los escenarios y luego implementa el código para pasarlos.

**Duración estimada:** 20 minutos

---

## El Proyecto

Vas a implementar un **servicio de carrito de compras** partiendo de escenarios Gherkin. No hay spec previa: las historias Gherkin SON la especificación.

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
    Given un catálogo con los siguientes productos:
      | id | nombre      | precio | stock |
      | 1  | Camiseta    | 25.00  | 10    |
      | 2  | Pantalón    | 45.00  | 5     |
      | 3  | Zapatos     | 80.00  | 3     |
    And un carrito vacío para el usuario "cliente1"

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
    Then el sistema rechaza la operación con error "Stock insuficiente"
    And el carrito sigue vacío

  Scenario: Eliminar producto del carrito
    Given el carrito contiene 2 "Camiseta" y 1 "Pantalón"
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
    Then el carrito está vacío

  Scenario: Vaciar carrito completo
    Given el carrito contiene 2 "Camiseta" y 1 "Pantalón"
    When el usuario vacía el carrito
    Then el carrito está vacío
    And el total del carrito es 0.00

  Scenario Outline: Calcular total con múltiples productos
    Given el carrito contiene <cant_a> "<prod_a>" y <cant_b> "<prod_b>"
    Then el total del carrito es <total>

    Examples:
      | cant_a | prod_a   | cant_b | prod_b   | total  |
      | 1      | Camiseta | 1      | Pantalón | 70.00  |
      | 2      | Camiseta | 1      | Zapatos  | 130.00 |
      | 3      | Pantalón | 2      | Zapatos  | 295.00 |

  Scenario: No se puede agregar producto inexistente
    When el usuario agrega el producto "Sombrero" con cantidad 1
    Then el sistema rechaza la operación con error "Producto no encontrado"
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
- Cada Scenario = exactamente 1 función de test
- Cada Scenario Outline = 1 test parametrizado con @pytest.mark.parametrize
- El Background se implementa como fixtures
- Los tests deben llamar a funciones/métodos del módulo `src/cart.py`
- Los tests deben FALLAR porque src/cart.py no existe todavía

Guarda los tests en tests/test_cart.py.
Ejecuta los tests para confirmar que fallan.
```

**Verifica:** Claude debe generar ~10 tests que todos fallen con `ModuleNotFoundError` o `ImportError`.

---

## Parte 3: Implementar para Pasar los Tests (10 min)

### Paso 5: Implementar

```
Los tests en tests/test_cart.py están fallando porque no existe
la implementación. Implementa src/cart.py con las clases y funciones
necesarias para que TODOS los tests pasen.

Reglas:
- NO modifiques los tests
- Implementa el mínimo código necesario
- Ejecuta los tests después de cada cambio significativo
- Cuando todos pasen, muestra el resultado final
```

### Paso 6: Verificar cobertura

```
Ejecuta los tests con cobertura (pytest --cov=src).
Si hay líneas no cubiertas, añade tests adicionales en
tests/test_cart_extra.py para cubrir esas líneas.
```

---

## Parte 4: Traza Gherkin → Test → Código

### Paso 7: Verificar trazabilidad

```
Genera una tabla de trazabilidad que muestre:
- Escenario Gherkin → Función de test → Función/metodo implementado

Formato:
| Escenario | Test | Implementación |
|-----------|------|----------------|

Verifica que cada escenario tiene test y cada test tiene implementación.
```

---

## Verificación

Al completar este ejercicio, deberías tener:

```
/tmp/shopping-cart/
├── features/
│   └── cart.feature          # Escenarios Gherkin (input)
├── tests/
│   ├── test_cart.py          # Tests generados desde Gherkin
│   └── test_cart_extra.py    # Tests adicionales de cobertura
└── src/
    └── cart.py               # Implementación
```

### Checklist

| Criterio | Cumplido? |
|----------|-----------|
| Todos los tests generados desde Gherkin pasan | |
| Cada Scenario tiene exactamente 1 test | |
| El Scenario Outline genera tests parametrizados | |
| src/cart.py no fue modificado por ti (solo por Claude) | |
| Los tests no fueron modificados después de generarlos | |
| La cobertura es >= 90% | |

---

## Criterios de Evaluación

| Criterio | Puntos |
|----------|--------|
| Features Gherkin bien escritas (proporcionadas) | 2 |
| Tests generados correctamente desde Gherkin | 3 |
| Implementación pasa todos los tests | 3 |
| Cobertura >= 90% | 2 |
| **Total** | **10** |
