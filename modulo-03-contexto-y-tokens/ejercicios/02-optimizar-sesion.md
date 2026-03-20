# Ejercicio 02: Optimizar una Sesion de Trabajo

## Objetivo

Aplicar las tecnicas de ahorro de tokens en una sesion real de desarrollo,
midiendo el impacto de cada optimizacion.

---

## Preparacion

Usa un proyecto existente o crea uno:

```bash
mkdir -p ~/opt-exercise && cd ~/opt-exercise
git init
# Crea algunos archivos de ejemplo o clona un proyecto
```

---

## Parte 1: Sesion SIN Optimizar (15 min)

Trabaja de forma "natural" sin pensar en tokens:

```bash
claude
```

Realiza estas tareas **sin usar /clear ni /compact**:

1. "Explica la estructura de este proyecto en detalle"
2. "Crea un archivo utils.py con funciones de ayuda"
3. "Ahora crea tests para utils.py"
4. "Revisa si hay algun bug en los tests"
5. "Genera documentacion para utils.py"

```
/cost   # Anotar resultado final
```

**Resultado SIN optimizar**: _____ tokens, $_____ coste

---

## Parte 2: Sesion OPTIMIZADA (15 min)

Repite las mismas 5 tareas pero aplicando tecnicas:

```bash
claude
```

**Tecnica 1: Prompts especificos**
```
> "Describe la estructura en maximo 5 lineas, solo directorios principales"
> /cost
```

**Tecnica 2: /clear entre tareas**
```
> /clear
> "Crea utils.py con: validate_email, sanitize_input, format_date. Sin explicaciones, solo codigo."
> /cost
```

**Tecnica 3: Output conciso**
```
> /clear
> "Genera tests pytest para utils.py. Solo el codigo, sin explicaciones."
> /cost
```

**Tecnica 4: Prompt preciso**
```
> /clear
> "Ejecuta pytest utils_test.py. Si falla algo, corrige solo lo que falla."
> /cost
```

**Tecnica 5: Prompt con scope**
```
> /clear
> "Genera docstrings para utils.py. Solo docstrings, no modifiques la logica."
> /cost
```

**Resultado OPTIMIZADO**: _____ tokens, $_____ coste

---

## Parte 3: Comparacion

| Metrica | Sin optimizar | Optimizado | Ahorro |
|---------|--------------|-----------|--------|
| Tokens totales | ? | ? | ?% |
| Coste total | ? | ? | ?% |
| Calidad resultado | ?/5 | ?/5 | - |
| Tiempo total | ? min | ? min | - |

---

## Parte 4: Aplicar al Trabajo Real (10 min)

Toma una tarea real de tu dia a dia y aplica las tecnicas:

1. **Antes de empezar**: Define la tarea en 1 frase especifica
2. **Elige modelo**: Sonnet para tareas normales, Opus solo si es complejo
3. **Prompt preciso**: Include archivo, linea, que cambiar
4. **/clear** entre subtareas si las hay
5. **Medir**: `/cost` al final

---

## Checklist de Optimizacion

Antes de cada sesion, repasa:

- [ ] Mi prompt es especifico? (archivo, funcion, que hacer)
- [ ] Necesito Opus o Sonnet es suficiente?
- [ ] Tengo MCPs innecesarios activos?
- [ ] Mi CLAUDE.md pide respuestas concisas?
- [ ] Voy a usar /clear entre tareas diferentes?
- [ ] Si la sesion es larga, usare /compact?

---

## Criterios de Completitud

- [ ] Sesion sin optimizar completada con metricas
- [ ] Sesion optimizada completada con metricas
- [ ] Tabla comparativa rellenada
- [ ] Al menos 50% de ahorro en tokens
- [ ] Una tarea real optimizada
