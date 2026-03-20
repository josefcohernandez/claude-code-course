# 03 - Estrategias de Sesión

> Tiempo estimado: 20 minutos | Nivel: Intermedio

## Introducción

La forma en que estructuras tus sesiones con Claude Code determina
la calidad de las respuestas, el consumo de tokens y tu productividad.

---

## Ciclo de Vida de una Sesión

```
Inicio → [CLAUDE.md cargado] → [MCP conectado] → Interacción → ... → Fin

                    Contexto crece →→→→→→→→→→→→→
                    Calidad se mantiene ───────── (hasta ~60%)
                    Calidad baja ─────────────────── (60-95%)
                    Auto-compaction ──────────────────── (95%)
```

### Fases del Contexto

| % Contexto | Estado | Acción recomendada |
|-----------|--------|-------------------|
| 0-30% | Óptimo | Trabajar normalmente |
| 30-60% | Bueno | Monitorizar con /cost |
| 60-80% | Degradación sutil | /compact o iniciar nueva sesión |
| 80-95% | Degradación notable | /compact urgente o /clear |
| 95%+ | Auto-compaction | Se dispara automáticamente |

---

## 5 Estrategias de Sesión

### 1. Sesión Atómica (recomendada)

```
1 sesión = 1 tarea concreta = 5-20 minutos
```

```bash
# Sesión 1: Bug fix
claude
> "Bug: login falla con passwords que contienen @. Diagnostica y corrige."
> [Claude corrige]
> "Ejecuta tests"
> /exit

# Sesión 2: Feature
claude
> "Implementa endpoint GET /users/:id con validación"
> [Claude implementa]
> "Tests"
> /exit
```

**Ventajas**: Contexto limpio, respuestas óptimas, coste predecible.

### 2. Sesión con Checkpoints

Para tareas más largas, usa `/compact` como checkpoint:

```
claude
> [Implementar autenticación - 20 min]
> /compact "Mantener: schema BD, endpoints creados, tests pendientes"
> [Implementar autorización - 20 min]
> /compact "Mantener: todo auth+authz, tests faltantes"
> [Implementar tests - 15 min]
> /exit
```

### 3. Sesión Plan-First

```
claude
> Shift+Tab (Plan Mode)
> "Necesito refactorizar el sistema de pagos. Diseña un plan."
> [Revisar plan]
> Shift+Tab (Normal Mode)
> "Implementa el paso 1 del plan"
> "Implementa el paso 2"
> ...
> /exit
```

### 4. Sesión de Investigación

```
claude
> "Investiga cómo está implementado el sistema de caché en este proyecto"
> "¿Qué patrones usa?"
> "¿Hay memory leaks potenciales?"
> [Tomar notas mentales]
> /exit

# Nueva sesión para implementar los cambios
claude
> "Refactoriza el caché: [descripción basada en lo aprendido]"
```

### 5. Sesión Pipeline (One-Shot encadenados)

```bash
# No usa sesión interactiva - cada comando es independiente
git diff --staged | claude -p "Genera commit message"
claude -p "Genera tests para src/auth.ts" > tests.ts
cat error.log | claude -p "Diagnostica el error principal"
```

---

## Patrón del Día a Día

```bash
# === Inicio del día ===
cd ~/proyecto
claude
> /init                    # Si es proyecto nuevo
> "Estado del proyecto: ¿qué PRs hay abiertos, qué issues?"
> /exit

# === Tarea 1: Bug fix ===
claude
> "Bug #123: [descripción]. Diagnostica y corrige."
> [Trabajar]
> /exit

# === Tarea 2: Feature ===
claude
> Shift+Tab (Plan)
> "Feature: [descripción]. Diseñar plan."
> Shift+Tab (Normal)
> "Implementa paso 1"
> "Implementa paso 2"
> "Ejecuta tests"
> /exit

# === Tarea 3: Review ===
git diff main..feature | claude -p "Code review: bugs, mejoras, seguridad"

# === Final del día ===
git diff --staged | claude -p "Commit message para estos cambios"
```

---

## Cuándo Iniciar Nueva Sesión vs Continuar

| Situación | Acción |
|-----------|--------|
| Nueva tarea no relacionada | Nueva sesión |
| Continuación de la misma tarea | `claude --resume` |
| La sesión está lenta/degradada | Nueva sesión |
| Cambio de proyecto | Nueva sesión |
| Quiero contexto limpio | Nueva sesión o `/clear` |
| Tarea simple y rápida | One-shot (`-p`) |

---

## Métricas para Monitorizar

```
/cost     →  Tokens consumidos y coste acumulado
/status   →  Estado de la sesión y contexto
/model    →  Modelo en uso (afecta coste)
```

### Reglas de Decisión

```
Si tokens > 50K          → /compact o nueva sesión
Si tarea cambia           → /clear
Si respuestas se degradan → nueva sesión urgente
Si /cost > $1             → evaluar si seguir o nueva sesión
```

---

## Resumen

| Estrategia | Duración | Uso ideal |
|-----------|----------|----------|
| Atómica | 5-20 min | Tareas concretas (recomendada) |
| Checkpoints | 30-60 min | Features medianas |
| Plan-First | 20-40 min | Refactoring, arquitectura |
| Investigación | 10-30 min | Entender código existente |
| Pipeline | N/A | Automatización, scripts |
