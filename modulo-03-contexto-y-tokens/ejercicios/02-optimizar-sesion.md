# Ejercicio 02: Optimizar una Sesión de Trabajo

## Objetivo

Aplicar las técnicas de ahorro de tokens en una sesión real de desarrollo,
midiendo el impacto de cada optimización.

---

## Preparación

Usa un proyecto existente o crea uno:

```bash
mkdir -p ~/opt-exercise && cd ~/opt-exercise
git init
# Crea algunos archivos de ejemplo o clona un proyecto
```

---

## Parte 1: Sesión SIN Optimizar (15 min)

Trabaja de forma "natural" sin pensar en tokens:

```bash
claude
```

Realiza estas tareas **sin usar /clear ni /compact**:

1. "Explica la estructura de este proyecto en detalle"
2. "Crea un archivo útils.py con funciones de ayuda"
3. "Ahora crea tests para útils.py"
4. "Revisa si hay algún bug en los tests"
5. "Genera documentacion para útils.py"

```
/cost   # Anotar resultado final
```

**Resultado SIN optimizar**: _____ tokens, $_____ coste

---

## Parte 2: Sesión OPTIMIZADA (15 min)

Repite las mismás 5 tareas pero aplicando técnicas:

```bash
claude
```

**Técnica 1: Prompts específicos**
```
> "Describe la estructura en máximo 5 líneas, solo directorios principales"
> /cost
```

**Técnica 2: /clear entre tareas**
```
> /clear
> "Crea útils.py con: validate_email, sanitize_input, format_date. Sin explicaciones, solo código."
> /cost
```

**Técnica 3: Output conciso**
```
> /clear
> "Genera tests pytest para útils.py. Solo el código, sin explicaciones."
> /cost
```

**Técnica 4: Prompt preciso**
```
> /clear
> "Ejecuta pytest útils_test.py. Si falla algo, corrige solo lo que falla."
> /cost
```

**Técnica 5: Prompt con scope**
```
> /clear
> "Genera docstrings para útils.py. Solo docstrings, no modifiques la lógica."
> /cost
```

**Resultado OPTIMIZADO**: _____ tokens, $_____ coste

---

## Parte 3: Comparación

| Métrica | Sin optimizar | Optimizado | Ahorro |
|---------|--------------|-----------|--------|
| Tokens totales | ? | ? | ?% |
| Coste total | ? | ? | ?% |
| Calidad resultado | ?/5 | ?/5 | - |
| Tiempo total | ? min | ? min | - |

---

## Parte 4: Aplicar al Trabajo Real (10 min)

Toma una tarea real de tu día a día y aplica las técnicas:

1. **Antes de empezar**: Define la tarea en 1 frase específica
2. **Elige modelo**: Sonnet para tareas normales, Opus solo si es complejo
3. **Prompt preciso**: Include archivo, línea, que cambiar
4. **/clear** entre subtareas si las hay
5. **Medir**: `/cost` al final

---

## Checklist de Optimización

Antes de cada sesión, repasa:

- [ ] Mi prompt es específico? (archivo, función, que hacer)
- [ ] Necesito Opus o Sonnet es suficiente?
- [ ] Tengo MCPs innecesarios activos?
- [ ] Mi CLAUDE.md pide respuestas concisas?
- [ ] Voy a usar /clear entre tareas diferentes?
- [ ] Si la sesión es larga, usare /compact?

---

## Criterios de Completitud

- [ ] Sesión sin optimizar completada con métricas
- [ ] Sesión optimizada completada con métricas
- [ ] Tabla comparativa rellenada
- [ ] Al menos 50% de ahorro en tokens
- [ ] Una tarea real optimizada
