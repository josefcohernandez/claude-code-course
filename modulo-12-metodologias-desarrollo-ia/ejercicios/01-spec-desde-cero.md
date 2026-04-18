# Ejercicio 01: Crear Spec Completa vía Entrevista con Claude

## Objetivo

Practicar el flujo completo de Spec-Driven Development: desde la entrevista con Claude hasta obtener una especificación técnica verificable y lista para implementar.

**Duración estimada:** 20 minutos

---

## El Proyecto

Vas a especificar un **sistema de gestión de notas** (tipo Notion simplificado) con estas características generales:

- Los usuarios pueden crear, editar y eliminar notas
- Las notas se pueden organizar en carpetas
- Soporte para busqueda por contenido
- Compartir notas con otros usuarios (solo lectura)

No implementes nada todavía. El objetivo es salir con una `SPEC.md` completa.

---

## Parte 1: La Entrevista (10 min)

### Paso 1: Iniciar la entrevista

Crea un directorio de trabajo y abre Claude Code:

```bash
mkdir -p /tmp/notas-app && cd /tmp/notas-app
claude
```

### Paso 2: Prompt de entrevista

Copia este prompt exacto:

```
Quiero construir una API REST para gestión de notas (tipo Notion simplificado).
Entrevístame en detalle usando AskUserQuestion.

Los usuarios pueden crear/editar/eliminar notas, organizarlas en carpetas,
buscar por contenido, y compartir notas (solo lectura) con otros usuarios.

Pregunta sobre:
- Implementación técnica (stack, BD, autenticación)
- Edge cases (notas compartidas, permisos, carpetas anidadas)
- Límites y restricciones (tamaño de nota, profundidad de carpetas)
- Búsqueda (full-text, por título, por etiquetas)
- Tradeoffs que debería considerar

No hagas preguntas obvias. Profundiza en las partes difíciles.
Sigue entrevistando hasta que hayamos cubierto todo.
```

### Paso 3: Responder a las preguntas

Claude te hará preguntas. Responde con decisiones concretas. Ejemplos de respuestas buenas:

- "Stack: Python + FastAPI + PostgreSQL"
- "Carpetas anidadas: máximo 3 niveles de profundidad"
- "Búsqueda: full-text search en título y contenido, sin etiquetas por ahora"
- "Tamaño máximo de nota: 100KB de texto"
- "Compartir: solo por email del destinatario, sin links públicos"

---

## Parte 2: Generar la Spec (5 min)

### Paso 4: Pedir la spec

Cuando Claude haya terminado de preguntar:

```
Genera la especificación técnica completa en SPEC.md.

Incluye:
- Contexto y objetivos
- Requisitos funcionales (cada uno verificable)
- Requisitos no funcionales
- Modelo de datos (esquema de BD)
- Endpoints de API con request/response
- Edge cases y manejo de errores
- Plan de testing
- Fases de implementación con dependencias

Incluye también una sección "Fuera de alcance v1" con lo que
explícitamente NO incluimos.
```

### Paso 5: Revisar la spec

Abre la spec en tu editor:

- Pulsa `Ctrl+G` para abrir en editor externo, o
- Lee el archivo generado: `SPEC.md`

Verifica:

- [ ] Cada requisito funcional es verificable (tiene condición de éxito clara)
- [ ] Los endpoints incluyen request y response de ejemplo
- [ ] Los edge cases están documentados
- [ ] El modelo de datos tiene todas las relaciones
- [ ] Hay una sección "Fuera de alcance" explícita

---

## Parte 3: Validar la Spec (5 min)

### Paso 6: Revisión crítica

Pide a Claude que revise su propia spec:

```
Revisa SPEC.md con ojo crítico. Busca:
- Requisitos ambiguos o no verificables
- Edge cases no cubiertos
- Inconsistencias entre secciones
- Endpoints que faltan para cubrir los requisitos
- Campos del modelo de datos que faltan

Lista los problemas encontrados y corrígelos en SPEC.md.
```

### Paso 7: Generar features Gherkin de validación

```
A partir de SPEC.md, genera features/notas.feature con escenarios
Gherkin que cubran los 5 requisitos funcionales más importantes.
Incluye escenarios de camino feliz Y errores.
```

---

## Verificación

Al completar este ejercicio, deberías tener:

1. `SPEC.md` - Especificación completa y revisada
2. `features/notas.feature` - Escenarios Gherkin para los requisitos principales

### Checklist de calidad

| Criterio | Cumplido? |
|----------|-----------|
| La spec tiene contexto, requisitos funcionales y no funcionales | |
| Cada requisito es verificable (tiene condición de éxito) | |
| El modelo de datos está completo con relaciones | |
| Los endpoints incluyen ejemplos de request/response | |
| Hay sección "Fuera de alcance" explícita | |
| Los edge cases están documentados | |
| Los features Gherkin cubren camino feliz y errores | |

---

## Reflexión

Responde mentalmente:

1. Claude descubrió algún requisito o edge case que no habías considerado?
2. ¿La entrevista cambió tu visión inicial del proyecto?
3. ¿Cuánto tiempo habrías tardado en escribir esta spec manualmente?
4. La spec es suficiente para que otro desarrollador (o Claude en sesión nueva) implemente sin ambigüedad?
