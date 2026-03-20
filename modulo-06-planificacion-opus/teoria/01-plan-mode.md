# 01 - Plan Mode

## Qué es Plan Mode

Plan Mode es un modo de operación donde Claude Code **propone cambios sin ejecutarlos**.
Diseña la solución, te la muestra, y tú decides si aprobar la implementación.

---

## Activar Plan Mode

| Método | Cómo |
|--------|------|
| Atajo de teclado | `Shift+Tab` (toggle) |
| Slash command | `/plan` |
| Indicador visual | El prompt cambia para mostrar modo Plan activo |

Para volver a modo Normal: `Shift+Tab` de nuevo.

---

## Comportamiento en Plan Mode

### Lo que Claude HACE
- Lee archivos para entender el contexto
- Analiza la arquitectura existente
- Propone una lista de cambios con justificación
- Sugiere estructura de archivos
- Estima impacto y riesgos

### Lo que Claude NO HACE
- No crea archivos
- No edita archivos
- No ejecuta comandos
- No instala dependencias

---

## Flujo Recomendado: Plan → Review → Implement

```
1. Shift+Tab                    → Activar Plan Mode
2. "Diseña [descripción]"       → Claude propone plan
3. Revisar el plan              → Tú evalúas
4. Ajustar si necesario         → "Cambia X por Y en el plan"
5. Shift+Tab                    → Volver a Normal
6. "Implementa el plan"         → Claude ejecuta
```

### Ejemplo Concreto

```
> Shift+Tab (Plan Mode)
> "Necesito un sistema de autenticación JWT con refresh tokens,
>  middleware de verificación y endpoints de login/register/refresh"

Claude responde con:
- Archivos a crear (middleware/auth.ts, routes/auth.ts, etc.)
- Dependencias necesarias (jsonwebtoken, bcrypt)
- Schema de BD (tabla users, refresh_tokens)
- Flujo de autenticación (diagrama)
- Tests a escribir

> "Me gusta, pero usa Argon2 en vez de bcrypt"
> Claude ajusta el plan

> Shift+Tab (Normal Mode)
> "Implementa el plan aprobado"
> Claude crea archivos, instala deps, escribe tests
```

---

## Cuándo Usar Plan Mode

| Escenario | Plan Mode? | Razón |
|-----------|-----------|-------|
| Feature nueva significativa | Sí | Diseña antes de código |
| Refactoring multi-archivo | Sí | Entender impacto |
| Cambio de arquitectura | Sí | Evaluar alternativas |
| Bug fix simple (1 archivo) | No | Directo es más rápido |
| Añadir un test | No | No requiere planificación |
| Commit message | No | Trivial |
| Exploración de código | No | Solo lectura |

---

## Plan Mode + Opus

La combinación más potente:

```bash
# Usar Opus para planificar (mejor razonamiento)
/model opus
> Shift+Tab (Plan Mode)
> "Diseña la migración del monolito a microservicios"
> [Plan detallado de Opus]

# Cambiar a Sonnet para implementar (más barato)
> Shift+Tab (Normal Mode)
> /model sonnet
> "Implementa el paso 1 del plan"
```

O usar el alias `opusplan`:

```bash
claude --model opusplan
# Automáticamente: Opus para planificar, Sonnet para ejecutar
```

---

## Tips

1. **Sé específico** en la petición de plan: qué quieres lograr, restricciones, preferencias
2. **Itera el plan** antes de implementar: es gratis ajustar el plan
3. **Opus para planes complejos**: Su razonamiento es superior
4. **No planifiques trivialidades**: Un plan para `console.log` es overkill
5. **Guarda planes buenos**: Pueden servir como documentación de decisiones

---

## Tokens en Plan Mode

Plan Mode consume tokens de **lectura e inferencia** pero **no de ejecución**:

| Fase | Tokens gastados |
|------|----------------|
| Planificación | Input (lectura archivos) + Output (plan) |
| Revisión | Input (tu feedback) + Output (plan ajustado) |
| Implementación | Input + Output + Tool calls |

Planificar antes de implementar suele **ahorrar tokens totales** porque
evita implementaciones incorrectas que habría que rehacer.
