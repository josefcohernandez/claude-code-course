# 02 - Historias de Usuario en Gherkin como Input para Claude

## Introducción

Gherkin es un lenguaje estructurado para describir comportamiento esperado usando la sintaxis `Given/When/Then`. Es el estándar de Behavior-Driven Development (BDD) y resulta ser un **input extraordinario para Claude Code** porque:

1. Es **preciso y no ambiguo**: cada escenario describe exactamente un comportamiento
2. Es **verificable**: cada escenario puede convertirse directamente en un test
3. Es **legible por humanos**: product owners, QA y desarrolladores lo entienden igual
4. Claude lo **traduce directamente a tests**: los escenarios Gherkin mapean 1:1 con test cases

---

## Sintaxis Gherkin

### Estructura básica

```gherkin
Feature: Nombre descriptivo de la funcionalidad
  Como [rol de usuario]
  Quiero [acción/capacidad]
  Para [beneficio/valor]

  Scenario: Nombre del escenario específico
    Given [estado inicial / precondiciones]
    When [acción del usuario]
    Then [resultado esperado]
```

### Palabras clave

| Keyword | Significado | Ejemplo |
|---------|-------------|---------|
| `Feature` | Funcionalidad completa | `Feature: Autenticación de usuarios` |
| `Scenario` | Caso específico | `Scenario: Login exitoso con credenciales válidas` |
| `Given` | Precondición (estado inicial) | `Given un usuario registrado con email "ana@test.com"` |
| `When` | Acción del usuario | `When el usuario envía POST /login con credenciales válidas` |
| `Then` | Resultado esperado | `Then la respuesta tiene status 200` |
| `And` | Paso adicional (en cualquier sección) | `And el body contiene un token JWT válido` |
| `But` | Excepción o condición negativa | `But el token expira en 24 horas` |
| `Scenario Outline` | Escenario con múltiples datos | Con `Examples:` tabla de datos |
| `Background` | Precondiciones comunes a todos los escenarios | Se ejecuta antes de cada `Scenario` |

### Ejemplo completo

```gherkin
Feature: Gestión de tareas
  Como usuario autenticado
  Quiero crear, ver, editar y eliminar tareas
  Para organizar mi trabajo diario

  Background:
    Given un usuario autenticado con token JWT válido
    And la base de datos contiene 3 tareas existentes

  Scenario: Crear tarea con datos válidos
    When el usuario envía POST /tasks con:
      | campo       | valor                    |
      | titulo      | Revisar pull request     |
      | descripcion | PR #42 necesita revisión |
      | prioridad   | alta                     |
    Then la respuesta tiene status 201
    And el body contiene la tarea creada con id generado
    And la tarea tiene created_by igual al usuario autenticado
    And la tarea tiene estado "pendiente" por defecto

  Scenario: Crear tarea sin título (error de validación)
    When el usuario envía POST /tasks sin campo título
    Then la respuesta tiene status 400
    And el body contiene error "El título es obligatorio"

  Scenario: Listar tareas con filtro por estado
    Given existen tareas con estados "pendiente", "en_progreso" y "completada"
    When el usuario envía GET /tasks?status=pendiente
    Then la respuesta tiene status 200
    And el body contiene solo tareas con estado "pendiente"
    And la respuesta incluye metadatos de paginación

  Scenario Outline: Validación de prioridad
    When el usuario envía POST /tasks con prioridad "<prioridad>"
    Then la respuesta tiene status <status>

    Examples:
      | prioridad | status |
      | baja      | 201    |
      | media     | 201    |
      | alta      | 201    |
      | critica   | 201    |
      | invalida  | 400    |
      |           | 400    |

  Scenario: Solo el creador puede eliminar su tarea
    Given una tarea creada por el usuario "ana"
    When el usuario "carlos" envía DELETE /tasks/{id}
    Then la respuesta tiene status 403
    And el body contiene error "No tienes permiso para eliminar esta tarea"
```

---

## Usar Gherkin como Input para Claude

### Flujo de trabajo

```
1. Escribir features en Gherkin (tú o con ayuda de Claude)
   |
2. Claude genera tests desde los escenarios
   |
3. Claude implementa el código para pasar los tests
   |
4. Verificar que todos los escenarios pasan
```

### Paso 1: Escribir las features

Puedes escribirlas tú directamente o pedir ayuda a Claude:

```
Lee el archivo SPEC.md. Genera historias de usuario en formato Gherkin
para cada requisito funcional. Guarda cada feature en un archivo
.feature separado dentro del directorio features/:
- features/auth.feature
- features/tasks.feature
- features/filters.feature

Incluye escenarios para el camino feliz Y para los errores.
Usa Scenario Outline cuando haya múltiples variaciones del mismo caso.
```

### Paso 2: Generar tests desde Gherkin

```
Lee features/tasks.feature. Genera tests de integración que
implementen cada escenario. Usa pytest + httpx para Python
(o la herramienta equivalente de nuestro stack).

Cada Scenario debe mapear a exactamente un test.
Cada Scenario Outline debe generar un test parametrizado.
Los tests deben fallar porque el código aún no existe.
```

### Paso 3: Implementar para pasar los tests

```
Los tests de features/tasks.feature están fallando.
Implementa el código necesario para que todos los tests pasen.
Ejecuta los tests después de cada cambio significativo.
No modifiques los tests, solo el código de producción.
```

### Paso 4: Verificar

```
Ejecuta todos los tests. Para cada feature file, muestra:
- Número de escenarios: total / pasando / fallando
- Si alguno falla, corrige el código (no el test)
```

---

## Gherkin para distintos tipos de proyecto

### API REST

```gherkin
Feature: API de productos
  Scenario: Obtener producto por ID
    Given un producto existente con id 42
    When el cliente envía GET /api/v1/products/42
    Then la respuesta tiene status 200
    And el header Content-Type es "application/json"
    And el body contiene:
      | campo  | valor        |
      | id     | 42           |
      | nombre | Widget Pro   |
      | precio | 29.99        |
```

### Frontend / UI

```gherkin
Feature: Formulario de registro
  Scenario: Registro exitoso muestra mensaje de bienvenida
    Given el usuario está en la página /register
    When el usuario rellena el formulario con datos válidos
    And hace clic en "Crear cuenta"
    Then aparece el mensaje "Cuenta creada exitosamente"
    And el usuario es redirigido a /dashboard

  Scenario: Email duplicado muestra error inline
    Given ya existe un usuario con email "ana@test.com"
    When el usuario intenta registrarse con email "ana@test.com"
    Then aparece error "Este email ya está registrado" bajo el campo email
    And el campo email se marca en rojo
    But los demás campos mantienen sus valores
```

### CLI / Herramientas

```gherkin
Feature: Comando de migración de base de datos
  Scenario: Migrar a la última versión
    Given la base de datos está en versión 3
    And existen migraciones hasta la versión 5
    When el usuario ejecuta "db migrate up"
    Then se aplican las migraciones 4 y 5 en orden
    And la salida muestra "Applied 2 migrations successfully"
    And la base de datos está en versión 5
```

---

## Gherkin como Criterio de Aceptación

Cada historia de usuario tiene sus escenarios Gherkin como criterios de aceptación. El feature está "terminado" cuando **todos los escenarios pasan**.

```
Feature: Historia US-003 - Filtrado de tareas
  # Criterios de aceptación: TODOS deben pasar para cerrar la historia

  Scenario: Filtrar por estado          # AC-1
  Scenario: Filtrar por prioridad       # AC-2
  Scenario: Filtrar por asignado        # AC-3
  Scenario: Combinar múltiples filtros  # AC-4
  Scenario: Filtro sin resultados       # AC-5
  Scenario: Filtro con valor inválido   # AC-6
```

Esto da una **definición de "hecho" objetiva**: no hay discusión sobre si la feature está completa. O todos los escenarios pasan, o no.

---

## Buenas prácticas para Gherkin con Claude

1. **Un escenario = un comportamiento.** No mezcles múltiples comportamientos en un escenario.

2. **Given para estado, When para acción, Then para resultado.** No pongas acciones en Given ni verificaciones en When.

3. **Usa Background para precondiciones comunes.** Evita repetir `Given un usuario autenticado` en cada escenario.

4. **Scenario Outline para variaciones.** Si tienes 5 escenarios que solo cambian los datos, usa `Scenario Outline` + `Examples`.

5. **Nombra los escenarios como comportamientos.** "Login exitoso con credenciales válidas" es mejor que "Test caso 1".

6. **Incluye siempre escenarios de error.** Los caminos de error son los que más bugs producen.

7. **Escribe en el lenguaje del dominio.** "Cuando el cliente compra un producto" es mejor que "Cuando se envía POST /orders".

---

## Resumen

| Concepto | Detalle |
|----------|---------|
| Gherkin | Formato Given/When/Then para describir comportamiento |
| Feature | Funcionalidad completa con múltiples escenarios |
| Scenario | Caso específico con precondiciones, acción y resultado |
| Scenario Outline | Escenario parametrizado con tabla de Examples |
| Background | Precondiciones comunes ejecutadas antes de cada escenario |
| Flujo con Claude | Features → Tests → Implementación → Verificación |
| Criterio de aceptación | Feature "hecha" = todos los escenarios pasan |

Gherkin transforma requisitos vagos en especificaciones ejecutables. Cuando le das a Claude un archivo `.feature` bien escrito, el resultado es predecible, verificable y de alta calidad.
