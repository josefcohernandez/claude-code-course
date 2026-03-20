# 03 - Instalación y Configuración Inicial de Claude Code

Este apartado cubre la instalación de Claude Code, la configuración de la autenticación y la verificación del entorno en los tres sistemas operativos principales.

---

## 1. Requisitos previos

| Requisito | Versión mínima | Cómo verificar | Notas |
|-----------|---------------|----------------|-------|
| **Node.js** | 18.0+ | `node --version` | Se recomienda LTS (22.x) |
| **npm** | 8.0+ | `npm --version` | Viene incluido con Node.js |
| **Terminal** | - | - | Bash, Zsh, PowerShell (vía WSL2) |
| **Conexión a internet** | - | - | Necesaria para la API |
| **SO** | - | - | macOS, Linux o Windows con WSL2 |

### Instalación de Node.js

```bash
# Opción recomendada: nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install 22
nvm use 22

# macOS con Homebrew
brew install node@22

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verificar
node --version   # v18.x o superior
npm --version    # 8.x o superior
```

---

## 2. Instalación de Claude Code

```bash
# Instalación global
npm install -g @anthropic-ai/claude-code

# Verificar
claude --version

# Actualizar
npm update -g @anthropic-ai/claude-code
```

---

## 3. Autenticación

### Opción A: Cuenta de claude.ai (recomendado)

```bash
claude auth login
# Se abre el navegador para autenticarte
```

### Opción B: API Key directa

```bash
export ANTHROPIC_API_KEY="sk-ant-xxxxxxxxxxxxx"
# Persistente:
echo 'export ANTHROPIC_API_KEY="sk-ant-xxx"' >> ~/.bashrc
```

### Opción C: Amazon Bedrock (enterprise)

```bash
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-east-1
export AWS_PROFILE=mi-perfil-bedrock
```

### Opción D: Google Vertex AI (enterprise)

```bash
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=tu-proyecto-gcp
```

| Método | Ideal para | Requiere |
|--------|-----------|----------|
| claude.ai | Uso personal, equipos pequeños | Cuenta Anthropic |
| API Key | Automatización, CI/CD | API key de Anthropic |
| Bedrock | Empresas AWS | Cuenta AWS + Bedrock |
| Vertex AI | Empresas GCP | Proyecto GCP + Vertex |

---

## 4. Verificación

```bash
claude --version          # Versión instalada
claude doctor             # Diagnóstico completo
claude -p "di hola"       # Test rápido (one-shot)
```

`claude doctor` verifica: Node.js, autenticación, conectividad API, permisos, git.

---

## 5. Compatibilidad por plataforma

### macOS
Funciona nativo. Mejor soporte.

### Linux
Funciona nativo. Si tienes problemas de permisos npm:

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Windows (WSL2 obligatorio)

Claude Code **no funciona** en PowerShell/CMD nativos.

```powershell
wsl --install          # Desde PowerShell admin
# Reiniciar, abrir Ubuntu WSL2
# Instalar Node.js y Claude Code dentro de WSL2
```

---

## 6. Integración con IDEs

### VS Code
```bash
code --install-extension anthropic.claude-code
```

### JetBrains
Settings > Plugins > Marketplace > "Claude Code"

### Terminal independiente
```bash
cd /ruta/a/tu/proyecto && claude
```

---

## 7. Configuración inicial recomendada

```bash
cd /ruta/a/tu/proyecto
claude
# Dentro de la sesión:
/init          # Crear CLAUDE.md
/model         # Ver modelo actual
/doctor        # Verificar estado
```

### Variables de entorno útiles

| Variable | Propósito | Ejemplo |
|----------|----------|---------|
| `ANTHROPIC_API_KEY` | API key | `sk-ant-xxx` |
| `CLAUDE_MODEL` | Modelo por defecto | `claude-sonnet-4-20250514` |
| `HTTP_PROXY` | Proxy corporativo | `http://proxy:8080` |
| `CLAUDE_CODE_USE_BEDROCK` | Usar Bedrock | `1` |

---

## 8. Troubleshooting

| Problema | Solución |
|----------|---------|
| Node.js versión incorrecta | `nvm install 22 && nvm use 22` |
| EACCES permission denied | No usar `sudo`, reconfigurar prefix npm |
| ECONNREFUSED/ETIMEDOUT | Configurar `HTTP_PROXY`/`HTTPS_PROXY` |
| git not available | `sudo apt install git` o `xcode-select --install` |
| Auth falla | `claude auth logout && claude auth login` |

---

## Resumen

| Paso | Comando | Verificación |
|------|---------|-------------|
| 1. Node.js 18+ | `nvm install 22` | `node --version` |
| 2. Claude Code | `npm install -g @anthropic-ai/claude-code` | `claude --version` |
| 3. Autenticarse | `claude auth login` | `claude doctor` |
| 4. Probar | `claude -p "hola"` | Respuesta exitosa |
| 5. Iniciar | `cd proyecto && claude` | Sesión interactiva |
