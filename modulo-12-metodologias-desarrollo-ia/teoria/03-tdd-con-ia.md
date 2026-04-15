# 03 - Test-Driven Development Asistido por IA

## Introducción

TDD (Test-Driven Development) sigue el ciclo **Red → Green → Refactor**: primero escribes un test que falla (red), luego escribes el mínimo código para que pase (green), y finalmente refactorizas. Con Claude Code, este ciclo se acelera dramáticamente porque Claude puede generar tanto tests como implementación, pero manteniendo la disciplina de escribir tests primero.

La clave es que **los tests son la verificación automática** que permite a Claude autocorregirse. Sin tests, Claude genera código que "parece correcto" pero puede tener bugs sutiles. Con tests, Claude sabe inmediatamente si su implementación funciona.

---

## El Ciclo TDD con Claude

### Flujo clásico TDD

```
Red:      Escribir test que falla
Green:    Escribir mínimo código para pasar el test
Refactor: Mejorar el código sin romper tests
```

### Flujo TDD con Claude Code

```
1. Tú defines QUÉ testear (requisito / comportamiento)
   |
2. Claude escribe el test (Red: el test falla)
   |
3. Claude implementa el código (Green: el test pasa)
   |
4. Claude refactoriza (Refactor: tests siguen pasando)
   |
5. Repetir para el siguiente requisito
```

La diferencia es que **tú controlas el QUÉ** y **Claude ejecuta el CÓMO**, pero siempre con tests como punto de partida.

---

## Patrón 1: Test-First Básico

### Prompt

```
Implementa la función validateEmail() usando TDD:

1. PRIMERO escribe los tests. Incluye casos:
   - Email válido (user@example.com)
   - Email sin @ (inválido)
   - Email sin dominio (user@)
   - Email con espacios (inválido)
   - Email vacío (inválido)
   - Email con subdominios (user@sub.domain.com)

2. Ejecuta los tests - deben FALLAR porque la función no existe

3. Implementa validateEmail() con el mínimo código para pasar todos los tests

4. Ejecuta los tests - deben PASAR

5. Refactoriza si hay oportunidades de mejora. Ejecuta tests de nuevo.
```

### Lo que Claude hace

```python
# Paso 1: Escribe tests
# test_validate_email.py

def test_valid_email():
    assert validate_email("user@example.com") == True

def test_missing_at():
    assert validate_email("userexample.com") == False

def test_missing_domain():
    assert validate_email("user@") == False
# ... más tests

# Paso 2: Ejecuta → TODOS FALLAN (Red)
# FAILED: ModuleNotFoundError - validate_email no existe

# Paso 3: Implementa
def validate_email(email: str) -> bool:
    if not email or ' ' in email:
        return False
    parts = email.split('@')
    if len(parts) != 2:
        return False
    local, domain = parts
    return bool(local) and '.' in domain and bool(domain.split('.')[-1])

# Paso 4: Ejecuta → TODOS PASAN (Green)

# Paso 5: Refactoriza si es necesario
```

---

## Patrón 2: TDD desde Gherkin

Combina Gherkin (capítulo anterior) con TDD:

```
Lee features/auth.feature. Para cada escenario:

1. Escribe un test de integración que lo implementa
2. Ejecuta el test - debe fallar
3. Implementa el código de producción necesario
4. Ejecuta el test - debe pasar
5. Pasa al siguiente escenario

No implementes más de un escenario a la vez.
Ejecuta todos los tests después de cada escenario para verificar
que no has roto nada anterior.
```

### Ejemplo con auth.feature

```gherkin
# features/auth.feature

Feature: Autenticación
  Scenario: Registro exitoso
    When un usuario envía POST /register con nombre, email y password válidos
    Then la respuesta tiene status 201
    And el body contiene el usuario sin el campo password

  Scenario: Registro con email duplicado
    Given un usuario registrado con email "ana@test.com"
    When otro usuario intenta registrarse con email "ana@test.com"
    Then la respuesta tiene status 409
    And el body contiene error "El email ya está registrado"
```

Claude procederá:

1. **Test para "Registro exitoso"** → falla (no hay endpoint) → implementa POST /register → test pasa
2. **Test para "Registro con email duplicado"** → falla (no hay validación de duplicados) → añade validación → test pasa
3. Ejecuta ambos tests → ambos pasan → continúa

---

## Patrón 3: TDD Inverso (Code-First, Test-Verify)

A veces ya tienes código sin tests. Claude puede generar tests que verifiquen el comportamiento actual y luego mejorar el código:

```
Analiza src/services/payment.py. Genera tests exhaustivos para el
comportamiento actual de todas las funciones públicas:
- Caminos felices
- Errores y excepciones
- Edge cases (null, vacío, valores límites)

Ejecuta los tests. Si alguno falla, NO corrijas el test: indica
que encontraste un bug potencial en el código de producción.
```

Esto es útil para:
- Código legacy sin tests
- Antes de refactorizar (los tests protegen contra regresiones)
- Para entender qué hace realmente el código (los tests documentan comportamiento)

---

## Patrón 4: TDD con Cobertura

```
Implementa el servicio TaskService usando TDD.
Requisitos:
- create_task(data): crea tarea, valida campos obligatorios
- get_task(id): obtiene tarea por ID, 404 si no existe
- update_task(id, data): actualiza, solo el creador puede hacerlo
- delete_task(id): elimina, solo el creador puede hacerlo
- list_tasks(filters): filtra por estado, prioridad, asignado

Después de implementar todos los requisitos:
1. Ejecuta los tests con cobertura
2. Identifica líneas no cubiertas
3. Añade tests para cubrir esas líneas
4. Objetivo: mínimo 90% de cobertura
```

---

## Buenas Prácticas de TDD con Claude

### 1. Un test, una cosa

```python
# Bien: cada test verifica un comportamiento
def test_create_task_returns_201():
def test_create_task_without_title_returns_400():
def test_create_task_sets_default_status():

# Mal: test verifica múltiples cosas
def test_create_task():
    # verifica status, body, defaults, permisos... todo junto
```

### 2. Tests independientes entre sí

```python
# Bien: cada test crea su propio estado
def test_delete_task(db):
    task = create_test_task(db)  # setup propio
    response = client.delete(f"/tasks/{task.id}")
    assert response.status_code == 200

# Mal: test depende del estado dejado por otro test
def test_delete_task():
    # asume que test_create_task() ya creó una tarea con id=1
    response = client.delete("/tasks/1")
```

### 3. Pedir a Claude que nombre tests descriptivamente

```
Nombra los tests como comportamientos, no como métodos:
- test_login_with_expired_token_returns_401
- test_admin_can_delete_any_task
- test_pagination_returns_correct_total_count

No uses: test_case_1, test_login_1, test_endpoint
```

### 4. Separar tests unitarios e integración

```
Estructura los tests en:
tests/
  unit/           # Tests de lógica pura, sin BD ni HTTP
    test_validators.py
    test_utils.py
  integration/    # Tests con BD y endpoints HTTP reales
    test_auth_api.py
    test_tasks_api.py

Los tests unitarios deben ejecutarse en < 5 segundos.
Los tests de integración pueden tardar más pero deben ser aislados.
```

---

## Cuándo usar TDD con Claude

| Situación | ¿Usar TDD? | Por qué |
|-----------|-----------|---------|
| Lógica de negocio compleja | **Sí** | Tests definen el comportamiento esperado sin ambigüedad |
| API REST endpoints | **Sí** | Tests de integración verifican request/response |
| Refactoring de código existente | **Sí** | Tests protegen contra regresiones |
| Código legacy sin tests | **Sí (inverso)** | Primero genera tests, luego refactoriza |
| Prototipo rápido | **No** | El prototipo puede descartarse, TDD añade overhead |
| Scripts one-shot | **No** | El script se usa una vez, no justifica tests |
| UI puramente visual | **Depende** | Tests de snapshot sí, TDD clásico no aplica bien |

---

## Prompt plantilla: TDD completo

```
Implementa [funcionalidad] usando Test-Driven Development estricto.

Para cada requisito:
1. Escribe un test que falla (describe el comportamiento esperado)
2. Ejecuta el test para confirmar que falla
3. Escribe el mínimo código para que pase
4. Ejecuta para confirmar que pasa
5. Refactoriza si hay oportunidades
6. Ejecuta todos los tests para verificar que nada se rompió

Requisitos:
- [requisito 1]
- [requisito 2]
- [requisito 3]

Implementa un requisito a la vez, en orden.
Al terminar, ejecuta todos los tests con cobertura.
Objetivo: > 90% coverage.
```

---

## Resumen

| Concepto | Detalle |
|----------|---------|
| Red → Green → Refactor | Ciclo clásico TDD: test falla → pasa → mejora |
| Test-First | Claude escribe tests antes del código de producción |
| TDD desde Gherkin | Cada escenario Gherkin se convierte en un test |
| TDD Inverso | Generar tests para código existente, luego mejorar |
| Cobertura | Objetivo mínimo 90% con tests enfocados |

TDD con Claude no es más lento que implementar directamente. De hecho, suele ser más rápido porque los tests atrapan bugs inmediatamente en vez de descubrirlos horas después.

---

> **Profundiza**: Para técnicas avanzadas de testing con IA — property-based testing, mutation testing, visual regression, y patrones de AI pair programming — consulta el [Módulo D3: Testing Avanzado y AI Pair Programming](https://github.com/josefcohernandez/curso-ia-agentica/blob/master/modulo-D3-testing-pair-programming/README.md) del curso "Desarrollo Profesional con IA Agéntica".
