# Ejercicio 03: Ciclo TDD Completo con Claude

## Objetivo

Prácticar el ciclo completo Red → Green → Refactor con Claude Code, implementando un servicio de autenticación requisito a requisito usando TDD estricto.

**Duración estimada:** 20 minutos

---

## El Proyecto

Implementar un módulo de autenticación (`src/auth.py`) con:
- Hash de passwords con bcrypt
- Generación y validación de tokens JWT
- Validación de email y password

Todo usando TDD: test primero, implementación después.

---

## Parte 1: Setup (2 min)

```bash
mkdir -p /tmp/auth-tdd && cd /tmp/auth-tdd
mkdir -p src tests

# Inicializar proyecto Python
cat > requirements.txt << 'EOF'
bcrypt==4.2.0
pyjwt==2.9.0
pytest==8.3.0
pytest-cov==5.0.0
EOF

pip install -r requirements.txt 2>/dev/null
```

Abrir Claude Code:

```bash
claude
```

---

## Parte 2: TDD Requisito por Requisito (15 min)

### Requisito 1: Hash de password

```
Implementa hash_password() y verify_password() usando TDD estricto.

Paso 1: Escribe estos tests en tests/test_auth.py:
- test_hash_password_returns_different_value_than_input
- test_hash_password_returns_different_hash_each_time (salt)
- test_verify_password_correct_returns_true
- test_verify_password_incorrect_returns_false
- test_hash_password_with_empty_string_raises_error

Paso 2: Ejecuta los tests - deben FALLAR

Paso 3: Implementa en src/auth.py el mínimo código para pasar

Paso 4: Ejecuta los tests - deben PASAR

Muestra el resultado de cada paso.
```

**Verifica:** Claude debe mostrar claramente los pasos Red → Green.

### Requisito 2: Validación de email

```
Continua con TDD. Añade tests para validate_email():

- test_valid_email_returns_true (user@example.com)
- test_email_without_at_returns_false
- test_email_without_domain_returns_false
- test_email_with_spaces_returns_false
- test_empty_email_returns_false
- test_email_with_subdomain_returns_true (user@sub.domain.com)

Ciclo: tests fallan → implementa → tests pasan.
Ejecuta TODOS los tests (incluidos los del requisito 1) al terminar.
```

### Requisito 3: Validación de password

```
Continua con TDD. Añade tests para validate_password():

- test_valid_password_returns_true (min 8 chars, 1 mayuscula, 1 número)
- test_short_password_returns_false (menos de 8 chars)
- test_password_without_uppercase_returns_false
- test_password_without_number_returns_false
- test_empty_password_returns_false

Ciclo: tests fallan → implementa → tests pasan.
Ejecuta TODOS los tests al terminar.
```

### Requisito 4: Generación y validación de JWT

```
Continua con TDD. Añade tests para create_token() y verify_token():

- test_create_token_returns_string
- test_create_token_contains_user_id
- test_verify_valid_token_returns_payload
- test_verify_expired_token_raises_error
- test_verify_invalid_token_raises_error
- test_verify_token_with_wrong_secret_raises_error
- test_token_contains_expiration_claim

Usa un secret configurable y expiración de 24h por defecto.
Ciclo: tests fallan → implementa → tests pasan.
Ejecuta TODOS los tests al terminar.
```

---

## Parte 3: Refactoring (3 min)

### Paso 5: Refactorizar con tests como red de seguridad

```
Revisa src/auth.py. Refactoriza para mejorar:
- Nombres de variables
- Extraccion de constantes magicas (ej: 24 horas → TOKEN_EXPIRY_HOURS)
- Docstrings en funciones publicas
- Type hints completos

Después de cada cambio, ejecuta TODOS los tests para verificar
que no has roto nada. Si algún test falla, revierte el cambio.
```

### Paso 6: Cobertura final

```
Ejecuta todos los tests con cobertura:
pytest --cov=src --cov-report=term-missing

Si hay líneas no cubiertas, añade tests adicionales.
Objetivo: 95% de cobertura mínimo.
```

---

## Verificación

Al completar este ejercicio, deberías tener:

```
/tmp/auth-tdd/
├── src/
│   └── auth.py           # 4 funciones implementadas vía TDD
├── tests/
│   └── test_auth.py      # ~20 tests, todos pasando
└── requirements.txt
```

### Checklist

| Criterio | Cumplido? |
|----------|-----------|
| Todos los tests pasan | |
| Cada requisito se implemento con ciclo Red → Green | |
| Los tests se escribieron ANTES del código | |
| El refactoring no rompio ningun test | |
| Cobertura >= 95% | |
| Las funciones tienen type hints y docstrings | |

---

## Criterios de Evaluación

| Criterio | Puntos |
|----------|--------|
| Tests escritos antes de la implementación (Red visible) | 3 |
| Implementación minima para pasar tests (Green) | 2 |
| Refactoring sin romper tests | 2 |
| Cobertura >= 95% | 2 |
| Código limpio con type hints y docstrings | 1 |
| **Total** | **10** |

---

## Reto Extra

Si terminas antes de tiempo:

```
Añade un requisito 5 usando TDD: función refresh_token() que:
- Recibe un token válido no expirado
- Genera un nuevo token con la misma información
- El nuevo token tiene expiración renovada
- Rechaza tokens expirados
- Rechaza tokens inválidos

Escribe 5 tests, implementa, ejecuta.
```
