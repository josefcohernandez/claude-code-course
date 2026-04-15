# 04 - Patrones Avanzados de Desarrollo con IA

## Introducción

Esta sección cubre patrones de trabajo avanzados que multiplican la productividad: el patrón Writer/Reviewer con sesiones separadas, desarrollo visual a partir de mockups, fan-out para operaciones a escala, y git worktrees para sesiones paralelas aisladas.

---

## Patrón 1: Writer/Reviewer

### Concepto

Dos sesiones de Claude Code con roles separados:
- **Writer** (Sesión A): implementa el código
- **Reviewer** (Sesión B): revisa con contexto limpio, sin sesgo de confirmación

El Reviewer es más efectivo que el Writer revisando su propio código porque no tiene el historial de decisiones que tomó durante la implementación. Ve el código con ojos frescos.

### Flujo

```
Sesión A (Writer)                     Sesión B (Reviewer)
─────────────────                     ──────────────────
"Implementa rate limiter
para los endpoints de API"

[Claude implementa]
                                      "Revisa src/middleware/rateLimiter.ts.
                                       Busca edge cases, race conditions
                                       y consistencia con el middleware
                                       existente. Sé crítico."

                                      [Claude revisa con contexto limpio]

"Feedback del reviewer:
[pegar output de Sesión B].
Aplica las correcciones."
```

### Variantes del patrón

| Variante | Writer hace | Reviewer enfoca en |
|----------|-------------|-------------------|
| **Calidad general** | Implementar feature | Bugs, edge cases, legibilidad |
| **Seguridad** | Implementar feature | OWASP Top 10, injection, secrets |
| **Performance** | Implementar feature | N+1 queries, complejidad, caching |
| **Tests** | Implementar feature | Cobertura, edge cases, tests faltantes |
| **TDD cruzado** | Escribir tests | Implementar código para pasar tests |

### TDD Cruzado

Una variante potente: una sesión escribe los tests, otra sesión implementa el código.

```
# Sesión A: escribe tests
Lee SPEC.md. Escribe tests exhaustivos para todos los requisitos.
NO implementes el código de producción.

# Sesión B: implementa
Los tests en tests/ están fallando. Implementa el código de producción
para que todos los tests pasen. No modifiques los tests.
```

---

## Patrón 2: Desarrollo Visual (Mockup → Código)

### Concepto

Usar capturas de pantalla o mockups como input para Claude. Claude genera el código necesario para replicar el diseño visual.

### Flujo

```
1. Captura/mockup del diseño deseado
   |
2. Pegar imagen en Claude Code (Ctrl+V o drag & drop)
   |
3. Claude genera HTML/CSS/componente
   |
4. Verificar visualmente
   |
5. Iterar hasta que coincida
```

### Prompt para desarrollo visual

```
[pegar screenshot o mockup]

Implementa este diseño como un componente React.
- Usa Tailwind CSS para los estilos
- Hazlo responsive (mobile-first)
- Incluye los estados: hover, focus, disabled
- Usa los mismos colores y espaciado del mockup

Cuando termines, toma una screenshot del resultado y compárala
con el mockup original. Lista las diferencias y corrígelas.
```

### Cuándo usar

- Replicar diseños de Figma/Sketch
- Corregir bugs visuales (pegar screenshot del bug)
- Implementar landing pages desde mockups
- Crear componentes UI desde wireframes

---

## Patrón 3: Fan-Out (Operaciones a Escala)

### Concepto

Distribuir trabajo en múltiples invocaciones paralelas de `claude -p` para procesar muchos archivos simultáneamente.

### Flujo

```
1. Generar lista de archivos a procesar
   |
2. Script que itera y lanza claude -p para cada uno
   |
3. Validar resultados
```

### Ejemplo: Migración de imports

```bash
#!/bin/bash
# migrate-imports.sh
# Migrar imports de CommonJS a ES Modules en todos los archivos

# Paso 1: Listar archivos
files=$(find src -name "*.js" -not -path "*/node_modules/*")

# Paso 2: Procesar en paralelo (max 5 simultáneos)
echo "$files" | xargs -P 5 -I {} claude -p \
    "Migra el archivo {} de CommonJS (require/module.exports) a
     ES Modules (import/export). Mantén la funcionalidad idéntica.
     Solo cambia la sintaxis de imports/exports." \
    --allowedTools "Read,Edit" \
    --max-turns 3 \
    --max-budget-usd 0.10

# Paso 3: Verificar
npm test
```

### Ejemplo: Documentación masiva

```bash
#!/bin/bash
# add-docs.sh
# Añadir documentación a todos los archivos TypeScript

for file in $(find src -name "*.ts" -not -name "*.test.ts"); do
    echo "Documentando: $file"
    claude -p \
        "Añade JSDoc a todas las funciones y clases exportadas de $file.
         Mantén el código intacto, solo añade documentación.
         Sigue las convenciones de JSDoc existentes en el proyecto." \
        --allowedTools "Read,Edit" \
        --max-turns 3 \
        --max-budget-usd 0.05
done
```

### Ejemplo: Revisión de seguridad en lote

```bash
#!/bin/bash
# batch-security-review.sh

report="/tmp/security-report-$(date +%Y%m%d).md"
echo "# Security Review Report" > "$report"
echo "Date: $(date)" >> "$report"

for file in $(find src -name "*.py" -path "*/api/*"); do
    result=$(claude -p \
        "Revisa $file SOLO por vulnerabilidades de seguridad:
         - SQL injection
         - XSS
         - Secrets hardcodeados
         - Input no validado
         Responde con una lista de hallazgos o 'Sin problemas encontrados'." \
        --max-turns 1 \
        --max-budget-usd 0.05 \
        --output-format text)

    echo "## $file" >> "$report"
    echo "$result" >> "$report"
    echo "" >> "$report"
done

echo "Informe generado en: $report"
```

### Control de costos en fan-out

| Parámetro | Propósito | Ejemplo |
|-----------|-----------|---------|
| `--max-turns 1-3` | Limitar iteraciones por archivo | `--max-turns 3` |
| `--max-budget-usd` | Tope por archivo | `--max-budget-usd 0.10` |
| `--allowedTools` | Restringir herramientas | `--allowedTools "Read,Edit"` |
| `xargs -P N` | Limitar paralelismo | `xargs -P 5` (max 5 simultáneos) |

---

## Patrón 4: Git Worktrees para Sesiones Paralelas

### Concepto

Git worktrees permiten tener múltiples copias de trabajo del mismo repositorio en directorios separados. Cada worktree tiene su propio estado de archivos, mientras comparten el historial git. Esto permite ejecutar **múltiples sesiones de Claude Code en paralelo sin interferencias**.

### Crear worktrees

```bash
# Crear worktree para feature A
git worktree add ../proyecto-feature-a -b feature-a

# Crear worktree para feature B
git worktree add ../proyecto-feature-b -b feature-b

# Crear worktree para bugfix
git worktree add ../proyecto-bugfix bugfix-123
```

### Ejecutar Claude en cada worktree

```bash
# Terminal 1: Feature A
cd ../proyecto-feature-a
claude

# Terminal 2: Feature B (otra terminal)
cd ../proyecto-feature-b
claude

# Terminal 3: Bugfix (otra terminal)
cd ../proyecto-bugfix
claude
```

### Casos de uso

| Caso | Worktree 1 | Worktree 2 |
|------|-----------|-----------|
| **Writer/Reviewer** | Claude implementa feature | Claude revisa el código |
| **Feature paralela** | Claude trabaja en auth | Claude trabaja en dashboard |
| **Experimento** | Claude intenta enfoque A | Claude intenta enfoque B |
| **TDD cruzado** | Claude escribe tests | Claude implementa código |

### Limpiar worktrees

```bash
# Ver todos los worktrees
git worktree list

# Eliminar un worktree terminado
git worktree remove ../proyecto-feature-a

# Limpiar referencias huérfanas
git worktree prune
```

### Importante

- Cada worktree tiene su propio directorio `.claude/` local
- El `CLAUDE.md` del repo se comparte (es parte del repo)
- Las sesiones de Claude Code son independientes entre worktrees
- Instalar dependencias en cada worktree nuevo según el stack del proyecto

---

## Eligiendo la Metodología Correcta

| Tarea | Metodología recomendada |
|-------|------------------------|
| Feature nueva compleja | **Spec-Driven** + Gherkin + TDD |
| Bug fix con reproducción clara | **TDD Inverso**: test que reproduce → fix |
| Migración de 100+ archivos | **Fan-out** con `claude -p` |
| Código crítico (auth, payments) | **Writer/Reviewer** con sesiones separadas |
| Replicar diseño de Figma | **Visual-driven**: mockup → código |
| Múltiples features en paralelo | **Git worktrees** + sesiones independientes |
| Prototipo rápido | Implementación directa (sin SDD ni TDD) |
| Refactoring grande | **Spec-Driven** (documentar estado actual → deseado) + TDD |

---

## Resumen

| Patrón | Cuándo usarlo | Beneficio principal |
|--------|--------------|-------------------|
| Writer/Reviewer | Código crítico, seguridad | Revisión sin sesgo, ojos frescos |
| Visual-driven | UI, landing pages, componentes | Precisión visual, iteración rápida |
| Fan-out | Migraciones, documentación masiva | Paralelismo, escala |
| Git worktrees | Múltiples features en paralelo | Aislamiento completo, sin interferencias |

---

> **Profundiza**: Para aprender a revisar código generado por IA de forma profesional — checklist priorizado, 8 red flags, método de lectura en 3 pasadas — y debugging sistemático con workflow de 4 pasos, consulta los módulos [A3: Revisión de Código](https://github.com/josefcohernandez/curso-ia-agentica/blob/master/modulo-A3-revision-codigo-ia/README.md) y [A4: Debugging Sistemático](https://github.com/josefcohernandez/curso-ia-agentica/blob/master/modulo-A4-debugging-sistematico/README.md) del curso "Desarrollo Profesional con IA Agéntica".
