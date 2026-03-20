# Ejercicio 01: Instalacion y Primer Uso

## Objetivo

Instalar Claude Code, verificar su funcionamiento y ejecutar tu primera sesion interactiva.

---

## Parte 1: Instalacion (10 min)

### Paso 1: Verificar prerequisitos

```bash
node --version    # Debe ser 18+
npm --version     # Debe ser 8+
git --version     # Recomendado
```

Si no tienes Node.js:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install 22
```

### Paso 2: Instalar Claude Code

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

### Paso 3: Autenticarse

```bash
claude auth login
```

### Paso 4: Verificar

```bash
claude doctor
```

**Checkpoint**: Deberias ver todos los checks en verde.

---

## Parte 2: Primer Uso - Modo One-Shot (10 min)

Ejecuta estos comandos y observa las respuestas:

```bash
# Pregunta simple
claude -p "Que es una API REST? Responde en 2 frases."

# Generar codigo
claude -p "Genera una funcion Python que calcule el factorial de un numero"

# Analizar un archivo (si tienes uno)
claude -p "Explica que hace este archivo" < algun-archivo.py
```

**Observa**:
- Tiempo de respuesta
- Formato de la salida
- El modelo usado (por defecto Sonnet)

---

## Parte 3: Primera Sesion Interactiva (15 min)

```bash
# Crear proyecto de prueba
mkdir -p ~/mi-primer-proyecto && cd ~/mi-primer-proyecto
git init
echo "# Mi Primer Proyecto" > README.md

# Iniciar Claude Code
claude
```

Dentro de la sesion interactiva, prueba:

1. **Inicializar el proyecto**: `/init`
2. **Ver ayuda**: `/help`
3. **Preguntar sobre el proyecto**: "Que archivos hay en este proyecto?"
4. **Crear un archivo**: "Crea un archivo `hello.py` con un hola mundo"
5. **Ver costes**: `/cost`
6. **Limpiar**: `/clear`
7. **Salir**: `/exit`

---

## Parte 4: Explorar Slash Commands (10 min)

En una sesion interactiva, prueba estos comandos:

| Comando | Que hace |
|---------|---------|
| `/help` | Lista de comandos disponibles |
| `/model` | Ver/cambiar modelo |
| `/cost` | Ver consumo de tokens |
| `/clear` | Limpiar contexto |
| `/compact` | Compactar conversacion |
| `/doctor` | Diagnostico |
| `/permissions` | Ver permisos actuales |
| `/init` | Crear CLAUDE.md |

---

## Criterios de Completitud

- [ ] Claude Code instalado y version verificada
- [ ] Autenticacion configurada
- [ ] `claude doctor` sin errores
- [ ] Ejecutada al menos una consulta one-shot
- [ ] Sesion interactiva completada
- [ ] Al menos 5 slash commands probados
- [ ] `/cost` revisado para entender el consumo

---

## Reflexion

Responde mentalmente:
1. Cuanto tardo la instalacion completa?
2. Que diferencia hay entre modo one-shot y sesion interactiva?
3. Cuantos tokens consumiste en esta sesion de prueba?
