# Ejercicio 02: Tu Primer Bugfix con Claude Code

## Objetivo

Usar Claude Code para diagnosticar y corregir un bug en un proyecto real,
siguiendo el flujo: describir problema → investigar → corregir → verificar.

---

## Preparación: Crear el Proyecto con Bug

Crea un mini-proyecto con un bug intencionado:

```bash
mkdir -p ~/bugfix-exercise/src && cd ~/bugfix-exercise
git init
```

Crea `src/calculator.py`:

```python
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    return a / b  # Bug: no maneja división por cero

def calculate_average(numbers):
    total = 0
    for n in numbers:
        total = total + n
    return total / len(numbers)  # Bug: no maneja lista vacía

def parse_number(text):
    return int(text)  # Bug: no maneja decimales ni texto inválido
```

Crea `src/test_calculator.py`:

```python
from calculator import add, subtract, multiply, divide, calculate_average, parse_number

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

def test_divide():
    assert divide(10, 2) == 5.0
    assert divide(10, 0) == "Error"  # Falla

def test_average():
    assert calculate_average([1, 2, 3]) == 2.0
    assert calculate_average([]) == 0  # Falla

def test_parse():
    assert parse_number("42") == 42
    assert parse_number("3.14") == 3.14  # Falla
    assert parse_number("abc") is None   # Falla

if __name__ == "__main__":
    test_add()
    print("test_add OK")
    try:
        test_divide()
        print("test_divide OK")
    except Exception as e:
        print(f"test_divide FAILED: {e}")
    try:
        test_average()
        print("test_average OK")
    except Exception as e:
        print(f"test_average FAILED: {e}")
    try:
        test_parse()
        print("test_parse OK")
    except Exception as e:
        print(f"test_parse FAILED: {e}")
```

```bash
git add -A && git commit -m "Initial project with bugs"
```

---

## Parte 1: Diagnóstico (5 min)

Inicia Claude Code y describe el problema:

```bash
claude
```

```
Los tests de calculator.py están fallando.
Ejecuta los tests y diagnostica qué bugs hay.
```

**Observa**: Claude leerá los archivos, ejecutará los tests y te dirá qué falla.

---

## Parte 2: Corrección (10 min)

Pide a Claude que corrija los bugs:

```
Corrige los 3 bugs que encontraste:
1. divide() debe manejar división por cero
2. calculate_average() debe manejar lista vacía
3. parse_number() debe manejar decimales y texto inválido
Mantén la API existente compatible.
```

**Revisa** los cambios que Claude propone antes de aceptarlos.

---

## Parte 3: Verificación (5 min)

```
Ejecuta los tests de nuevo para verificar que todos pasan.
```

Si alguno falla, pide a Claude que lo corrija:

```
El test X sigue fallando. Revisa y corrige.
```

---

## Parte 4: Mejora (10 min - opcional)

```
Añade 3 tests adicionales para edge cases que no están cubiertos.
Después ejecuta todos los tests.
```

---

## Criterios de Completitud

- [ ] Proyecto creado con los 3 bugs
- [ ] Claude diagnosticó los 3 bugs correctamente
- [ ] Los 3 bugs corregidos
- [ ] Todos los tests pasan
- [ ] (Bonus) Tests adicionales añadidos

---

## Reflexión

1. Claude encontró los bugs más rápido que tú?
2. Las correcciones fueron correctas a la primera?
3. Revisaste los cambios antes de aceptarlos?
4. Cuántos tokens consumió este bugfix? (`/cost`)
