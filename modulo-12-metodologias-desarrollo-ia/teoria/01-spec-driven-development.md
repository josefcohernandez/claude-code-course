# 01 - Spec-Driven Development: De la Entrevista al Código

## Introducción

Spec-Driven Development (SDD) es la metodología más efectiva para proyectos no triviales con Claude Code. En vez de saltar directamente a "implementa X", primero construyes una especificación completa que sirve como contrato entre tú y Claude. Esto reduce errores, iteraciones innecesarias y ambigüedad.

El flujo completo tiene 4 fases:

```
Entrevista → Spec → Implementación → Verificación
```

---

## Fase 1: La Entrevista

### Qué es

En vez de intentar escribir una spec perfecta tú solo, dejas que Claude te entreviste. Claude hace preguntas sobre requisitos, edge cases, decisiones técnicas y tradeoffs que quizás no habías considerado.

### Cómo funciona

```
Quiero construir [descripción breve]. Entrevístame en detalle usando AskUserQuestion.

Pregunta sobre:
- Implementación técnica
- UX y flujos de usuario
- Edge cases y errores
- Tradeoffs y decisiones de diseño
- Integraciones con sistemas existentes

No hagas preguntas obvias. Profundiza en las partes difíciles que
quizás no he considerado.

Sigue entrevistando hasta que hayamos cubierto todo. Después, escribe
la spec completa en SPEC.md.
```

### Ejemplo real

Supongamos que quieres construir un sistema de notificaciones:

```
Quiero construir un sistema de notificaciones en tiempo real para nuestra
app. Entrevístame para entender los requisitos completos.
```

Claude preguntará cosas como:

1. "¿Qué tipos de notificaciones necesitas? Push, email, in-app, SMS?"
2. "¿Los usuarios pueden configurar preferencias por tipo de notificación?"
3. "¿Necesitas garantía de entrega (at-least-once) o es aceptable perder alguna?"
4. "¿Cuál es el volumen esperado? ¿100 notificaciones/día o 100.000/hora?"
5. "¿Qué pasa con las notificaciones cuando el usuario está offline?"
6. "¿Hay requisitos de agrupación? (ej: 50 likes = 1 notificación agrupada)"
7. "¿Necesitas soporte para cancelar notificaciones ya enviadas?"

Estas preguntas descubren requisitos que muchas veces no aparecen en el primer brief.

### Por qué funciona

- **Descubre requisitos ocultos**: Claude piensa en edge cases que tú no consideraste
- **Reduce la ambigüedad**: Cada respuesta elimina interpretaciones incorrectas
- **Ahorra iteraciones**: Mejor preguntar 10 minutos antes que reescribir 2 horas después
- **Documenta decisiones**: La entrevista queda como registro de por qué se tomaron ciertas decisiones

---

## Fase 2: La Especificación

### Estructura de una buena spec

Después de la entrevista, Claude genera una spec en `SPEC.md`. Una buena spec tiene:

```markdown
# Nombre del Proyecto

## Contexto
Por qué se construye esto. Qué problema resuelve.

## Requisitos Funcionales
Qué debe hacer el sistema. Cada requisito es verificable.

## Requisitos No Funcionales
Rendimiento, seguridad, escalabilidad, compatibilidad.

## Diseño Técnico
- Arquitectura (capas, componentes, flujo de datos)
- Modelo de datos (esquema de BD, relaciones)
- API (endpoints, request/response)
- Integraciones externas

## Edge Cases y Manejo de Errores
Qué pasa cuando las cosas salen mal.

## Plan de Testing
Cómo se verifica que funciona correctamente.

## Fases de Implementación
Orden de construcción con dependencias.
```

### Reglas para una spec efectiva

1. **Cada requisito debe ser verificable.** "El sistema debe ser rápido" no es verificable. "La API responde en < 200ms para el p95" sí lo es.

2. **Incluir lo que NO hace.** Las exclusiones explícitas evitan scope creep. "v1 NO incluye notificaciones push ni soporte multi-idioma."

3. **Separar el qué del cómo.** La spec dice qué debe hacer el sistema. El plan de implementación dice cómo construirlo.

4. **Incluir ejemplos concretos.** En vez de "el usuario puede filtrar tareas", incluir un ejemplo: "GET /tasks?status=pending&priority=high devuelve solo tareas pendientes de alta prioridad."

### Revisar la spec antes de implementar

Antes de continuar, revisa la spec con ojo crítico:

```
Revisa la spec en SPEC.md. Busca:
- Requisitos ambiguos o no verificables
- Edge cases no cubiertos
- Contradicciones entre secciones
- Dependencias no resueltas
Sugiere mejoras concretas.
```

También puedes abrir la spec con `Ctrl+G` para editarla directamente en tu editor.

---

## Fase 3: Implementación desde la Spec

### Sesión limpia

Una vez la spec está lista, **inicia una sesión nueva**:

```bash
claude --resume  # para nombrar/guardar la sesión de entrevista
claude           # sesión nueva y limpia
```

La sesión nueva tiene contexto limpio dedicado 100% a implementar. La spec (`SPEC.md`) es el único input necesario.

### Prompt de implementación

```
Lee SPEC.md. Implementa fase por fase siguiendo el plan de implementación.

Para cada fase:
1. Implementa el código
2. Escribe tests que verifiquen los requisitos
3. Ejecuta los tests y corrige fallos
4. Cuando todos los tests pasen, pasa a la siguiente fase

Usa /clear entre fases para mantener el contexto limpio.
```

### Control de calidad durante implementación

No esperes al final para verificar. Después de cada fase:

```
Ejecuta los tests de la fase actual. Si alguno falla, corrígelo antes
de continuar. Muestra la cobertura de los tests escritos.
```

---

## Fase 4: Verificación Final

### Verificación cruzada contra la spec

Al terminar la implementación, verifica que la spec se cumplió:

```
Lee SPEC.md y compara con la implementación actual.
Para cada requisito funcional, indica:
- CUMPLIDO: con referencia al archivo/función que lo implementa
- PARCIAL: qué falta
- NO IMPLEMENTADO: por qué

Genera un informe en VERIFICACION.md.
```

### Revisión con sesión separada (Writer/Reviewer)

Usa una sesión nueva para revisar:

```bash
# Sesión nueva con contexto limpio
claude
```

```
Revisa el proyecto en el directorio actual. No lo escribiste tú.
Lee SPEC.md para entender los requisitos.
Busca:
- Requisitos no implementados
- Bugs potenciales
- Problemas de seguridad
- Tests faltantes
Sé crítico y específico.
```

---

## Cuándo usar Spec-Driven Development

| Situación | ¿Usar SDD? | Por qué |
|-----------|-----------|---------|
| Feature nueva de 2+ archivos | **Sí** | La spec previene errores y retrabajos |
| Bug fix puntual | No | Demasiado overhead para un fix simple |
| Refactoring grande | **Sí** | Documentar el estado actual y deseado evita regresiones |
| Prototipo/spike | No | Primero explora, luego haz spec si el prototipo avanza |
| API nueva | **Sí** | El contrato de la API debe definirse antes del código |
| Cambio de UI | Depende | Si es un cambio visual simple, no. Si cambia flujo de usuario, sí |

---

## Flujo completo resumido

```
1. ENTREVISTA (10 min)
   Claude te hace preguntas, descubre requisitos ocultos
   Output: respuestas capturadas en la conversación
   |
2. SPEC (5 min)
   Claude genera SPEC.md con toda la información
   Tú revisas y editas con Ctrl+G
   Output: SPEC.md completo y revisado
   |
3. /clear → Sesión nueva
   |
4. IMPLEMENTACIÓN (variable)
   Claude implementa fase por fase
   Tests al final de cada fase
   /clear entre fases
   Output: código + tests funcionando
   |
5. VERIFICACIÓN (10 min)
   Cruce spec vs implementación
   Review con sesión separada
   Output: VERIFICACION.md + fixes aplicados
```

---

## Resumen

| Concepto | Detalle |
|----------|---------|
| Entrevista | Claude pregunta antes de implementar, descubre edge cases |
| SPEC.md | Documento de especificación verificable y completo |
| Sesión limpia | Implementar en sesión nueva con la spec como input |
| Verificación cruzada | Comparar spec vs implementación requisito por requisito |
| Writer/Reviewer | Sesión separada para revisión con contexto limpio |

La disciplina de escribir una spec antes de codear no es burocracia: es la diferencia entre "funciona" y "funciona correctamente, cubre los edge cases, y es mantenible".
