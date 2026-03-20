# Ejercicio 01: Configurar un Proyecto

## Objetivo

Crear y verificar la configuracion completa de Claude Code para un proyecto.

---

## Parte 1: Crear Proyecto Base (5 min)

```bash
mkdir -p ~/config-exercise && cd ~/config-exercise
git init
mkdir -p src tests .claude
echo '{"name": "config-exercise"}' > package.json
echo "# Config Exercise" > README.md
```

---

## Parte 2: Configurar settings.json del Proyecto (10 min)

Crea `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Bash(npm test*)",
      "Bash(npm run lint*)",
      "Bash(git status)",
      "Bash(git diff*)",
      "Bash(git log*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(npm publish*)"
    ]
  }
}
```

Inicia Claude Code y verifica:

```bash
claude
> /permissions
```

Confirma que Read, Glob, Grep estan en allow.

---

## Parte 3: Configurar settings.local.json (5 min)

Crea `.claude/settings.local.json` (personal, no commitear):

```json
{
  "permissions": {
    "allow": [
      "Edit(src/**)",
      "Write(tests/**)"
    ]
  }
}
```

Anade a `.gitignore`:

```
.claude/settings.local.json
```

Verifica que se aplica:

```bash
claude
> /permissions
```

---

## Parte 4: Probar Modos de Operacion (10 min)

### Modo Normal

```bash
claude
> "Crea un archivo src/hello.js con un console.log"
```

Claude deberia pedir confirmacion para Write.

### Modo Plan

```
> Shift+Tab  (o /plan)
> "Disena una estructura para un API REST"
```

Claude propone sin ejecutar.

### Auto-accept Edits

```
> Shift+Tab  (volver a Normal)
> /exit
claude --permission-mode acceptEdits
> "Modifica src/hello.js para que imprima 'hola mundo'"
```

La edicion se aplica sin preguntar.

---

## Parte 5: Probar Deny (5 min)

```bash
claude
> "Ejecuta rm -rf /tmp/algo"
```

Deberia ser **bloqueado** por el deny.

```
> "Ejecuta sudo apt update"
```

Tambien bloqueado.

---

## Criterios de Completitud

- [ ] .claude/settings.json creado con allow y deny
- [ ] .claude/settings.local.json creado y en .gitignore
- [ ] /permissions muestra los permisos correctos
- [ ] Modo Plan probado
- [ ] Auto-accept edits probado
- [ ] Comando deny verificado (bloqueado correctamente)
