# Ejercicio 01: Instalación y Primer Uso

## Objetivo

Instalar Claude Code, verificar su funcionamiento y ejecutar tu primera sesión interactiva.

---

## Parte 1: Instalación (5 min)

### Paso 1: Verificar prerrequisitos

```bash
git --version     # Necesario en todas las plataformas
```

En Windows, asegúrate de tener [Git for Windows](https://git-scm.com/downloads/win) instalado.

> [!NOTE]
> Node.js ya no es necesario. El instalador nativo de Claude Code es autocontenido.

### Paso 2: Instalar Claude Code (instalador nativo)

**macOS / Linux / WSL:**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell:**

```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD:**

```batch
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

**Alternativa con Homebrew (macOS/Linux):**

```bash
brew install --cask claude-code
```

### Paso 3: Verificar

```bash
claude --version
claude doctor
```

**Checkpoint**: `claude --version` muestra la versión instalada y `claude doctor` no reporta errores críticos.

---

## Parte 2: Autenticación (5 min)

```bash
claude
```

En el primer uso, Claude Code abre automáticamente el navegador para que te autentiques con tu cuenta de Anthropic (Pro, Max, Teams o Enterprise). Sigue las instrucciones en pantalla.

Una vez autenticado, verás el prompt interactivo de Claude Code.

> [!IMPORTANT]
> El plan gratuito de Claude.ai no incluye acceso a Claude Code. Necesitas una suscripción de pago o una cuenta Console.

---

## Parte 3: Primer Uso - Modo One-Shot (10 min)

Sal de la sesión interactiva (`/exit`) y ejecuta estos comandos:

```bash
# Pregunta simple
claude -p "¿Qué es una API REST? Responde en 2 frases."

# Generar código
claude -p "Genera una función Python que calcule el factorial de un número"

# Analizar un archivo (si tienes uno)
claude -p "Explica qué hace este archivo" < algun-archivo.py
```

**Observa**:
- Tiempo de respuesta
- Formato de la salida
- El modelo usado (por defecto Sonnet)

---

## Parte 4: Primera Sesión Interactiva (15 min)

```bash
# Crear proyecto de prueba
mkdir -p ~/mi-primer-proyecto && cd ~/mi-primer-proyecto
git init
echo "# Mi Primer Proyecto" > README.md

# Iniciar Claude Code
claude
```

Dentro de la sesión interactiva, prueba:

1. **Inicializar el proyecto**: `/init`
2. **Ver ayuda**: `/help`
3. **Preguntar sobre el proyecto**: "¿Qué archivos hay en este proyecto?"
4. **Crear un archivo**: "Crea un archivo `hello.py` con un hola mundo"
5. **Ver costes**: `/cost`
6. **Limpiar**: `/clear`
7. **Salir**: `/exit`

---

## Parte 5: Explorar Slash Commands (10 min)

En una sesión interactiva, prueba estos comandos:

| Comando | Qué hace |
|---------|----------|
| `/help` | Lista de comandos disponibles |
| `/model` | Ver o cambiar modelo |
| `/cost` | Ver consumo de tokens |
| `/clear` | Limpiar contexto |
| `/compact` | Compactar conversación |
| `/doctor` | Diagnóstico |
| `/permissions` | Ver permisos actuales |
| `/init` | Crear CLAUDE.md |

---

## Criterios de Completitud

- [ ] Claude Code instalado con el instalador nativo y versión verificada
- [ ] Autenticación configurada (primer login en navegador completado)
- [ ] `claude doctor` sin errores
- [ ] Ejecutada al menos una consulta one-shot
- [ ] Sesión interactiva completada
- [ ] Al menos 5 slash commands probados
- [ ] `/cost` revisado para entender el consumo

---

## Reflexión

Responde mentalmente:
1. ¿Cuánto tardó la instalación completa?
2. ¿Qué diferencia hay entre modo one-shot y sesión interactiva?
3. ¿Cuántos tokens consumiste en esta sesión de prueba?
