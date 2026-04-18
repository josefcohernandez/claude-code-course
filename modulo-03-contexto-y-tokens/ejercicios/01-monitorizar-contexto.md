# Ejercicio 01: Monitorizar y Entender el Contexto

## Objetivo

Aprender a monitorizar el consumo de tokens en tiempo real y entender
cómo diferentes operaciones afectan a la ventana de contexto.

---

## Parte 1: Línea Base (10 min)

```bash
cd ~/algun-proyecto  # Un proyecto con al menos 10 archivos
claude
```

### Medir el coste base

```
/cost
```

Anota: tokens al inicio (sistema + CLAUDE.md si existe).

### Medir operaciones individuales

Después de cada operación, ejecuta `/cost` y anota el incremento:

| Operación | Tokens antes | Tokens después | Incremento |
|-----------|-------------|---------------|-----------|
| Inicio de sesión | 0 | ? | ? |
| "Hola, que archivos hay?" | ? | ? | ? |
| "Lee package.json" | ? | ? | ? |
| "Lee el archivo más grande del src/" | ? | ? | ? |
| "Ejecuta git status" | ? | ? | ? |
| "Ejecuta npm test (o equivalente)" | ? | ? | ? |

---

## Parte 2: Efecto Acumulativo (10 min)

Sin usar /clear, haz 5 preguntas seguidas sobre diferentes partes del proyecto:

```
> "Qué hace la función principal?"
> /cost
> "Qué dependencias usa el proyecto?"
> /cost
> "Como esta configurado el linting?"
> /cost
> "Hay archivos de configuración de Docker?"
> /cost
> "Cual es la estructura de la base de datos?"
> /cost
```

Llena la tabla:

| Pregunta # | Tokens acumulados | Incremento | Calidad respuesta (1-5) |
|-----------|------------------|-----------|------------------------|
| 1 | ? | ? | ? |
| 2 | ? | ? | ? |
| 3 | ? | ? | ? |
| 4 | ? | ? | ? |
| 5 | ? | ? | ? |

---

## Parte 3: Efecto de /clear (5 min)

```
/clear
/cost
```

Compara el coste después del /clear con el inicio.

Repite una de las preguntas anteriores:
```
> "Qué hace la función principal?"
> /cost
```

Es la calidad de la respuesta diferente con contexto limpio?

---

## Parte 4: Efecto de /compact (10 min)

Sin /clear, vuelve a hacer 5 preguntas:

```
> [5 preguntas sobre el proyecto]
> /cost                    # Anotar tokens
> /compact "Mantener solo la arquitectura general"
> /cost                    # ¿Cuánto se redujo?
```

| Métrica | Antes de /compact | Después de /compact | Reducción |
|---------|------------------|--------------------| ---------|
| Tokens | ? | ? | ?% |

---

## Parte 5: Comparación de Modelos (5 min)

Haz la misma pregunta con diferentes modelos y compara:

```
/model haiku
> "Describe la arquitectura de este proyecto"
> /cost

/clear

/model sonnet
> "Describe la arquitectura de este proyecto"
> /cost

/clear

/model opus
> "Describe la arquitectura de este proyecto"
> /cost
```

| Modelo | Tokens input | Tokens output | Coste | Calidad (1-5) |
|--------|-------------|--------------|-------|--------------|
| Haiku | ? | ? | ? | ? |
| Sonnet | ? | ? | ? | ? |
| Opus | ? | ? | ? | ? |

---

## Criterios de Completitud

- [ ] Tabla de coste por operación completada
- [ ] Efecto acumulativo documentado
- [ ] /clear probado y efecto medido
- [ ] /compact probado y reducción medida
- [ ] Comparación de 3 modelos realizada
- [ ] Conclusiones sobre cuando compactar/limpiar

---

## Reflexión

1. ¿Qué operación consume más tokens?
2. A partir de cuantos tokens notas degradacion?
3. /compact conservo la información relevante?
4. ¿Qué modelo ofrece mejor relación calidad/precio para tu uso?
