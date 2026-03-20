# Ejercicio 01: Comandos Basicos de Claude Code

## Objetivo

Dominar los comandos basicos del CLI, modos de ejecucion y slash commands esenciales.

---

## Parte 1: Los 3 Modos de Ejecucion (10 min)

### Modo One-Shot

```bash
# Prueba 1: Pregunta simple
claude -p "Que es un ORM? Responde en una frase"

# Prueba 2: Generar codigo
claude -p "Genera una funcion TypeScript que valide un email con regex"

# Prueba 3: Con formato JSON
claude -p "Lista 3 frameworks web populares de Python" --output-format json

# Prueba 4: Pipe
echo "def factorial(n): return 1 if n<=1 else n*factorial(n-1)" | claude -p "Anade type hints y docstring a esta funcion"
```

**Anota**: Cuanto tardo cada uno? Que formato prefieres?

### Modo Interactivo

```bash
cd ~/algun-proyecto
claude

# Dentro de la sesion:
> "Que archivos hay en este proyecto?"
> "Cual es la estructura de directorios?"
> /cost
> /clear
> "Genera un archivo TODO.md con las tareas pendientes del proyecto"
> /exit
```

### Modo Pipe

```bash
# Analizar un log
cat /var/log/syslog | head -50 | claude -p "Resume estos logs, destacando errores"

# Generar commit message
git diff --staged | claude -p "Genera un commit message siguiendo conventional commits"

# Documentar
cat src/main.py | claude -p "Genera documentacion en formato docstring para cada funcion"
```

---

## Parte 2: Slash Commands Esenciales (15 min)

Inicia una sesion interactiva y prueba cada comando:

### Grupo 1: Informacion
```
/help                    # Ver todos los comandos
/cost                    # Ver tokens y coste
/model                   # Ver modelo actual
/doctor                  # Diagnostico
```

### Grupo 2: Gestion de Contexto
```
> "Explica que es una variable en Python"
> /cost                  # Anota tokens
> "Ahora explica que es una clase"
> /cost                  # Compara - el contexto crece
> /clear                 # Limpiar todo
> /cost                  # Vuelve a 0
```

### Grupo 3: Compactar
```
> "Genera una funcion que ordene una lista"
> "Anade tests para esa funcion"
> "Anade documentacion"
> /compact               # Resume todo lo anterior
> /cost                  # Menos tokens que antes
```

### Grupo 4: Modelo
```
/model                   # Ver modelo actual
/model sonnet            # Cambiar a Sonnet
/model opus              # Cambiar a Opus
/model haiku             # Cambiar a Haiku
```

---

## Parte 3: Flags del CLI (10 min)

Prueba diferentes combinaciones de flags:

```bash
# Limitar turns (iteraciones del agente)
claude -p "Crea un servidor HTTP basico en Python" --max-turns 3

# Especificar modelo
claude --model haiku -p "Que hora es en formato UTC?"

# Verbose para debug
claude --verbose -p "Lista los archivos del directorio actual"

# Sin MCP
claude --no-mcp -p "Suma 2+2"
```

---

## Criterios de Completitud

- [ ] Probados los 3 modos: one-shot, interactivo, pipe
- [ ] Usados al menos 8 slash commands diferentes
- [ ] Cambiado de modelo con /model
- [ ] Observado efecto de /clear en /cost
- [ ] Probado /compact y verificado reduccion de tokens
- [ ] Ejecutados al menos 3 flags de CLI

---

## Tabla de Referencia Rapida

| Quiero... | Uso... |
|-----------|--------|
| Pregunta rapida | `claude -p "..."` |
| Desarrollar feature | `claude` (interactivo) |
| Analizar archivo | `cat file \| claude -p "..."` |
| Limpiar contexto | `/clear` |
| Ver consumo | `/cost` |
| Reducir contexto | `/compact` |
| Cambiar modelo | `/model sonnet` |
| Continuar ayer | `claude --resume` |
