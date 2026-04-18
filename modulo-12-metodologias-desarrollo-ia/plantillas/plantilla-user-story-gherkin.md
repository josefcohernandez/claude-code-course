# Plantilla: Historia de Usuario en Formato Gherkin

## Estructura de una Feature

```gherkin
Feature: [ID] - [Nombre descriptivo de la funcionalidad]
  Como [rol de usuario]
  Quiero [acción o capacidad]
  Para [beneficio o valor de negocio]

  # Precondiciones comunes a todos los escenarios
  Background:
    Given [estado inicial compartido]
    And [otra precondición compartida]

  # --------------------------------------------------
  # Camino feliz (Happy Path)
  # --------------------------------------------------

  Scenario: [Acción exitosa con datos válidos]
    Given [precondición específica]
    When [acción del usuario]
    Then [resultado esperado principal]
    And [resultado secundario]

  # --------------------------------------------------
  # Validaciones y errores
  # --------------------------------------------------

  Scenario: [Error por dato faltante]
    When [acción sin dato obligatorio]
    Then [error con mensaje descriptivo]
    And [estado no cambia]

  Scenario: [Error por dato inválido]
    When [acción con dato inválido]
    Then [error con mensaje descriptivo]

  # --------------------------------------------------
  # Permisos y autorización
  # --------------------------------------------------

  Scenario: [Acción sin permiso]
    Given [usuario sin permiso adecuado]
    When [intenta la acción]
    Then [error 403 con mensaje]

  # --------------------------------------------------
  # Escenarios parametrizados
  # --------------------------------------------------

  Scenario Outline: [Validación de campo con múltiples valores]
    When [acción con campo] "<valor>"
    Then la respuesta tiene status <status>

    Examples:
      | valor    | status |
      | válido1  | 200    |
      | válido2  | 200    |
      | inválido | 400    |
      |          | 400    |

  # --------------------------------------------------
  # Edge cases
  # --------------------------------------------------

  Scenario: [Caso límite 1]
    Given [condición especial]
    When [acción]
    Then [comportamiento esperado en caso límite]
```

---

## Ejemplo Completo: API de Autenticación

```gherkin
Feature: US-001 - Registro de usuarios
  Como visitante de la aplicación
  Quiero crear una cuenta con email y password
  Para poder acceder a las funcionalidades protegidas

  Background:
    Given la base de datos de usuarios está limpia

  # Happy path
  Scenario: Registro exitoso con datos válidos
    When envio POST /register con:
      | campo    | valor             |
      | nombre   | Ana Garcia        |
      | email    | ana@example.com   |
      | password | MiPassword123     |
    Then la respuesta tiene status 201
    And el body contiene:
      | campo  | valor           |
      | nombre | Ana Garcia      |
      | email  | ana@example.com |
    But el body NO contiene el campo "password"
    And el password esta hasheado en la base de datos

  # Validaciones
  Scenario: Registro sin email
    When envio POST /register sin campo email
    Then la respuesta tiene status 400
    And el body contiene error "El email es obligatorio"

  Scenario: Registro con email inválido
    When envio POST /register con email "no-es-un-email"
    Then la respuesta tiene status 400
    And el body contiene error "El formato de email es inválido"

  Scenario: Registro con email duplicado
    Given existe un usuario con email "ana@example.com"
    When envio POST /register con email "ana@example.com"
    Then la respuesta tiene status 409
    And el body contiene error "El email ya está registrado"

  Scenario: Registro con password débil
    When envio POST /register con password "123"
    Then la respuesta tiene status 400
    And el body contiene error "El password debe tener mínimo 8 caracteres"

  Scenario Outline: Validación de password
    When envio POST /register con password "<password>"
    Then la respuesta tiene status <status>

    Examples:
      | password         | status | razon                        |
      | Ab1              | 400    | Muy corto                    |
      | abcdefgh         | 400    | Sin mayúscula ni número      |
      | ABCDEFGH         | 400    | Sin minúscula ni número      |
      | Abcdefg1         | 201    | Cumple todos los requisitos  |
      | MyP@ssw0rd!      | 201    | Válido con caracteres esp.   |


Feature: US-002 - Login de usuarios
  Como usuario registrado
  Quiero iniciar sesión con mis credenciales
  Para obtener un token de acceso

  Background:
    Given un usuario registrado:
      | email           | password      |
      | ana@example.com | MiPassword123 |

  Scenario: Login exitoso
    When envio POST /login con:
      | campo    | valor             |
      | email    | ana@example.com   |
      | password | MiPassword123     |
    Then la respuesta tiene status 200
    And el body contiene un campo "token" con JWT válido
    And el token contiene el user_id del usuario
    And el token expira en 24 horas

  Scenario: Login con password incorrecto
    When envio POST /login con:
      | campo    | valor             |
      | email    | ana@example.com   |
      | password | PasswordIncorrect |
    Then la respuesta tiene status 401
    And el body contiene error "Credenciales inválidas"
    But el error NO indica si el email o password es incorrecto

  Scenario: Login con email inexistente
    When envio POST /login con email "noexiste@example.com"
    Then la respuesta tiene status 401
    And el body contiene error "Credenciales inválidas"

  Scenario: Login sin campos requeridos
    When envio POST /login sin campo email
    Then la respuesta tiene status 400
```

---

## Checklist de Calidad

Antes de dar por terminada una feature Gherkin, verifica:

- [ ] Cada escenario tiene nombre descriptivo (comportamiento, no "test 1")
- [ ] Background contiene solo precondiciones comunes a TODOS los escenarios
- [ ] Given = estado, When = acción, Then = resultado (sin mezclar)
- [ ] Hay escenarios de camino feliz Y errores
- [ ] Los Scenario Outline se usan cuando hay 3+ variaciones del mismo caso
- [ ] Los mensajes de error son descriptivos y específicos
- [ ] Los edge cases están cubiertos
- [ ] Cada escenario es independiente (no depende de otro)
