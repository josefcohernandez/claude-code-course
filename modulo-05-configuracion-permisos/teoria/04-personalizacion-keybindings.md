# 04 - Personalización de Keybindings

Claude Code permite personalizar sus atajos de teclado para adaptar la experiencia al flujo de trabajo personal. Esta sección cubre el fichero de configuración, los tipos de atajos disponibles y las diferencias con los keybindings del IDE.

## El fichero de keybindings

Claude Code permite personalizar sus atajos de teclado mediante el fichero `~/.claude/keybindings.json`. Este fichero es personal (nivel usuario) y no se comparte con el equipo, a diferencia de los ficheros de configuración en `.claude/settings.json` del proyecto.

La estructura es un array JSON donde cada entrada define un atajo:

```json
[
  {
    "key": "<combinacion-de-teclas>",
    "command": "<nombre-del-comando>",
    "description": "<descripcion-opcional>"
  }
]
```

### Chord bindings

Un chord binding es una combinación de teclas en secuencia, no simultánea. Se define separando las teclas con un espacio:

```json
[
  {
    "key": "ctrl+k ctrl+c",
    "command": "clearContext",
    "description": "Chord binding: Ctrl+K seguido de Ctrl+C para limpiar contexto"
  }
]
```

Para activar este atajo debes pulsar `Ctrl+K`, soltarlo, y luego pulsar `Ctrl+C`. Los chord bindings son útiles para evitar conflictos con atajos de sistema.

## Ejemplos prácticos

### Configuración básica

```json
[
  {
    "key": "ctrl+shift+t",
    "command": "toggleThinking"
  },
  {
    "key": "ctrl+k ctrl+c",
    "command": "clearContext",
    "description": "Chord binding: Ctrl+K seguido de Ctrl+C para limpiar contexto"
  },
  {
    "key": "ctrl+shift+p",
    "command": "togglePlanMode",
    "description": "Alternar Plan Mode sin usar Shift+Tab"
  },
  {
    "key": "ctrl+shift+m",
    "command": "openModelSelector",
    "description": "Abrir selector de modelo rápidamente"
  }
]
```

### Comandos disponibles para bind

| Comando | Acción |
|---------|--------|
| `toggleThinking` | Activa/desactiva el razonamiento extendido visible |
| `clearContext` | Limpia el contexto de la sesión actual |
| `togglePlanMode` | Alterna entre Plan Mode y modo normal |
| `openModelSelector` | Abre el selector de modelo |
| `toggleAutoAccept` | Activa/desactiva la aceptación automática de cambios |
| `showCost` | Muestra el coste acumulado de la sesión |
| `newSession` | Inicia una nueva sesión (equivale a `/clear`) |

### Keybindings en `.claude/keybindings.json` del proyecto

Además del fichero personal, puedes crear un `keybindings.json` dentro del directorio `.claude/` del proyecto para que todos los miembros del equipo compartan los mismos atajos:

```json
[
  {
    "key": "ctrl+shift+r",
    "command": "toggleAutoAccept",
    "description": "Modo rápido de revisión para el equipo"
  }
]
```

Este fichero sí se debe incluir en el repositorio para compartirlo.

## Diferencia entre keybindings de Claude Code CLI y los del IDE

Es importante no confundir estos dos tipos de atajos:

| Aspecto | Keybindings de Claude Code CLI | Keybindings del IDE (VS Code / JetBrains) |
|---------|-------------------------------|------------------------------------------|
| Fichero de configuración | `~/.claude/keybindings.json` | `keybindings.json` del IDE |
| Alcance | Solo afectan a Claude Code en terminal | Afectan a todas las extensiones del IDE |
| Comandos disponibles | Comandos internos de Claude Code | Comandos del IDE y extensiones |
| Aplicación | Terminal donde ejecutas `claude` | Editor gráfico |

Si usas la extensión de Claude Code para VS Code o JetBrains, los atajos se configuran en la interfaz de keybindings del propio IDE, no en este fichero.

## Cómo resetear keybindings a los defaults

Para volver a los atajos de teclado por defecto, elimina o vacía el fichero de keybindings:

```bash
# Opción 1: eliminar el fichero (se recreará con defaults al reiniciar Claude Code)
rm ~/.claude/keybindings.json

# Opción 2: dejar el array vacío
echo '[]' > ~/.claude/keybindings.json

# Verificar el fichero actual
cat ~/.claude/keybindings.json
```

## Errores comunes

**JSON inválido**: Un error de sintaxis en el array impide que se carguen todos los keybindings. Verifica siempre que el JSON sea válido antes de guardar:

```bash
# Validar el fichero antes de usar
cat ~/.claude/keybindings.json | python3 -m json.tool
```

**Conflictos con el sistema operativo**: Atajos como `Ctrl+C` o `Ctrl+Z` están reservados por la terminal y no pueden ser sobreescritos. Usa chord bindings o combinaciones con `Ctrl+Shift` para evitar conflictos.

**Confundir ámbitos**: Modificar el fichero de keybindings del IDE no tiene efecto en el CLI de Claude Code, y viceversa.

## Resumen

- El fichero personal es `~/.claude/keybindings.json`; el de proyecto va en `.claude/keybindings.json`
- Cada entrada es un objeto con `key`, `command` y opcionalmente `description`
- Los chord bindings permiten secuencias de teclas separadas por espacio (`"ctrl+k ctrl+c"`)
- Los comandos disponibles incluyen `toggleThinking`, `clearContext`, `togglePlanMode` y otros
- Los keybindings de Claude Code CLI son independientes de los del IDE
- Para resetear, elimina el fichero o déjalo como array vacío `[]`
