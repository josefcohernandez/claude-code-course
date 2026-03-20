# Ejercicio 01: Crear Spec Completa via Entrevista con Claude

## Objetivo

Practicar el flujo completo de Spec-Driven Development: desde la entrevista con Claude hasta obtener una especificacion tecnica verificable y lista para implementar.

**Duracion estimada:** 20 minutos

---

## El Proyecto

Vas a especificar un **sistema de gestion de notas** (tipo Notion simplificado) con estas caracteristicas generales:

- Los usuarios pueden crear, editar y eliminar notas
- Las notas se pueden organizar en carpetas
- Soporte para busqueda por contenido
- Compartir notas con otros usuarios (solo lectura)

No implementes nada todavia. El objetivo es salir con una `SPEC.md` completa.

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
Quiero construir una API REST para gestion de notas (tipo Notion simplificado).
Entrevistame en detalle usando AskUserQuestion.

Los usuarios pueden crear/editar/eliminar notas, organizarlas en carpetas,
buscar por contenido, y compartir notas (solo lectura) con otros usuarios.

Pregunta sobre:
- Implementacion tecnica (stack, BD, autenticacion)
- Edge cases (notas compartidas, permisos, carpetas anidadas)
- Limites y restricciones (tamano de nota, profundidad de carpetas)
- Busqueda (full-text, por titulo, por etiquetas)
- Tradeoffs que deberia considerar

No hagas preguntas obvias. Profundiza en las partes dificiles.
Sigue entrevistando hasta que hayamos cubierto todo.
```

### Paso 3: Responder a las preguntas

Claude te hara preguntas. Responde con decisiones concretas. Ejemplos de respuestas buenas:

- "Stack: Python + FastAPI + PostgreSQL"
- "Carpetas anidadas: maximo 3 niveles de profundidad"
- "Busqueda: full-text search en titulo y contenido, sin etiquetas por ahora"
- "Tamano maximo de nota: 100KB de texto"
- "Compartir: solo por email del destinatario, sin links publicos"

---

## Parte 2: Generar la Spec (5 min)

### Paso 4: Pedir la spec

Cuando Claude haya terminado de preguntar:

```
Genera la especificacion tecnica completa en SPEC.md.

Incluye:
- Contexto y objetivos
- Requisitos funcionales (cada uno verificable)
- Requisitos no funcionales
- Modelo de datos (esquema de BD)
- Endpoints de API con request/response
- Edge cases y manejo de errores
- Plan de testing
- Fases de implementacion con dependencias

Incluye tambien una seccion "Fuera de alcance v1" con lo que
explicitamente NO incluimos.
```

### Paso 5: Revisar la spec

Abre la spec en tu editor:

- Pulsa `Ctrl+G` para abrir en editor externo, o
- Lee el archivo generado: `SPEC.md`

Verifica:

- [ ] Cada requisito funcional es verificable (tiene condicion de exito clara)
- [ ] Los endpoints incluyen request y response de ejemplo
- [ ] Los edge cases estan documentados
- [ ] El modelo de datos tiene todas las relaciones
- [ ] Hay una seccion "Fuera de alcance" explicita

---

## Parte 3: Validar la Spec (5 min)

### Paso 6: Revision critica

Pide a Claude que revise su propia spec:

```
Revisa SPEC.md con ojo critico. Busca:
- Requisitos ambiguos o no verificables
- Edge cases no cubiertos
- Inconsistencias entre secciones
- Endpoints que faltan para cubrir los requisitos
- Campos del modelo de datos que faltan

Lista los problemas encontrados y corrigelos en SPEC.md.
```

### Paso 7: Generar features Gherkin de validacion

```
A partir de SPEC.md, genera features/notas.feature con escenarios
Gherkin que cubran los 5 requisitos funcionales mas importantes.
Incluye escenarios de camino feliz Y errores.
```

---

## Verificacion

Al completar este ejercicio, deberias tener:

1. `SPEC.md` - Especificacion completa y revisada
2. `features/notas.feature` - Escenarios Gherkin para los requisitos principales

### Checklist de calidad

| Criterio | Cumplido? |
|----------|-----------|
| La spec tiene contexto, requisitos funcionales y no funcionales | |
| Cada requisito es verificable (tiene condicion de exito) | |
| El modelo de datos esta completo con relaciones | |
| Los endpoints incluyen ejemplos de request/response | |
| Hay seccion "Fuera de alcance" explicita | |
| Los edge cases estan documentados | |
| Los features Gherkin cubren camino feliz y errores | |

---

## Reflexion

Responde mentalmente:

1. Claude descubrio algun requisito o edge case que no habias considerado?
2. La entrevista cambio tu vision inicial del proyecto?
3. Cuanto tiempo habrias tardado en escribir esta spec manualmente?
4. La spec es suficiente para que otro desarrollador (o Claude en sesion nueva) implemente sin ambiguedad?
