# Qué son los Plugins de Claude Code

Un **plugin** es un bundle que empaqueta una o más capacidades de Claude Code — skills, hooks, subagentes y/o servidores MCP — en una unidad distribuible con identidad propia. Comprender cómo funcionan los plugins, su estructura interna y los ámbitos de instalación disponibles es el punto de partida para aprovechar el ecosistema de extensiones de Claude Code.

---

## Conceptos Clave

### Definición

La diferencia fundamental con los componentes individuales es que un plugin:

- Los **agrupa** bajo un manifest con nombre, versión y autor
- Los **distribuye** como una unidad indivisible: instalar el plugin instala todos sus componentes
- Los **configura** de forma coherente con valores por defecto y opciones personalizables
- Los **declara dependencias** entre ellos y con software externo (como un servidor MCP específico)

Dicho de otro modo: un skill resuelve una tarea, un hook intercepta un evento, un subagente delega trabajo. Un plugin organiza todos esos elementos en un paquete listo para usar sin configuración manual.

### Diferencia entre un skill y un plugin

Un skill (`SKILL.md`) define una capacidad invocable por nombre. Un plugin puede contener ese skill, más el hook que lo activa antes de cada commit, más el subagente que lo orquesta, todo empaquetado junto con instrucciones de configuración e integración. El plugin es la unidad de distribución; el skill es uno de sus posibles contenidos.

---

## Estructura de un Plugin

Un plugin reside en una carpeta con la siguiente estructura:

```
mi-plugin/
├── plugin.json          # Manifest obligatorio
├── skills/
│   └── deploy.md        # Uno o más archivos SKILL.md
├── agents/
│   └── revisor.md       # Uno o más subagentes (.md con frontmatter)
├── hooks/
│   └── pre-deploy.sh    # Uno o más scripts de hook
└── README.md            # Documentación del plugin (recomendado)
```

No todos los directorios son obligatorios. Un plugin mínimo puede contener solo `plugin.json` y un subdirectorio con un componente.

### El manifest `plugin.json`

El manifest es el único fichero obligatorio. Define la identidad y el contenido del plugin:

```json
{
  "name": "deploy-safe",
  "version": "1.2.0",
  "description": "Flujo de deploy seguro con validaciones pre-deploy y skill de rollback",
  "author": "equipo-plataforma@empresa.com",
  "license": "MIT",
  "dependencies": {
    "mcp": ["@modelcontextprotocol/server-github"],
    "tools": ["git", "docker"]
  },
  "configuration": {
    "environment": {
      "type": "string",
      "enum": ["staging", "production"],
      "default": "staging",
      "description": "Entorno de destino del deploy"
    },
    "notify_slack": {
      "type": "boolean",
      "default": false,
      "description": "Enviar notificación a Slack tras el deploy"
    }
  },
  "components": {
    "skills": ["skills/deploy.md"],
    "agents": ["agents/revisor.md"],
    "hooks": [
      {
        "file": "hooks/pre-deploy.sh",
        "event": "PreToolUse",
        "matcher": "Bash"
      }
    ]
  }
}
```

Los campos `name`, `version` y `description` son obligatorios. El resto es opcional pero recomendado para plugins que se van a compartir.

---

## Ámbitos de Instalación

Cuando instalas un plugin, debes elegir en qué ámbito aplica:

| Ámbito | Dónde se guarda | Quién lo usa |
|--------|-----------------|--------------|
| `project` | `.claude/plugins/` del proyecto | Solo los miembros de ese repositorio |
| `user` | `~/.claude/plugins/` | Tu usuario en todos los proyectos |
| `managed` | Gestionado por el administrador enterprise | Todos los usuarios de la organización |

**Usar `project` scope** cuando el plugin es específico del repositorio (por ejemplo, un plugin de deploy que solo aplica a ese servicio). El directorio `.claude/plugins/` debe commitearse al repositorio para que el equipo comparta la instalación.

**Usar `user` scope** cuando el plugin mejora tu flujo de trabajo personal en cualquier proyecto (por ejemplo, un plugin de productividad con tus atajos preferidos).

**El ámbito `managed`** solo es gestionable por administradores enterprise. Los usuarios no pueden instalar ni desinstalar plugins managed; solo pueden usarlos.

---

## Ciclo de Vida de un Plugin

```
instalar  -->  configurar  -->  usar  -->  actualizar  -->  desinstalar
    |               |             |             |                |
/plugin install  Rellenar      Invocar       /plugin update   /plugin remove
<nombre>         opciones de   skills,       <nombre>         <nombre>
                 configuración hooks se
                 (si las hay)  activan
                               automáticamente
```

### Instalar

```bash
# Desde el marketplace público
/plugin install deploy-safe

# Con ámbito explícito
/plugin install deploy-safe --scope project

# Desde una URL o ruta local (plugins privados o en desarrollo)
/plugin install ./mi-plugin-local
/plugin install https://github.com/mi-org/mi-plugin
```

### Configurar

Si el plugin declara campos de `configuration` en su manifest, Claude Code te pedirá los valores durante la instalación o puedes editarlos después:

```bash
/plugin configure deploy-safe
```

Los valores de configuración se guardan en el mismo ámbito que la instalación y se pasan como variables de entorno o argumentos a los componentes del plugin.

### Usar

Una vez instalado, los componentes del plugin están disponibles de forma inmediata:

- Los **skills** se pueden invocar por nombre: `@deploy-safe/deploy`
- Los **hooks** se activan automáticamente según el evento configurado
- Los **subagentes** aparecen disponibles en el contexto de la sesión

### Actualizar y Desinstalar

```bash
# Ver plugins instalados
/plugin list

# Actualizar a la última versión
/plugin update deploy-safe

# Desinstalar
/plugin remove deploy-safe
```

---

## Errores Comunes

**Confundir el ámbito `user` con el ámbito `project`.** Un plugin instalado con ámbito `user` no aparece en `.claude/plugins/` del repositorio. Si quieres que tu equipo use el mismo plugin sin instalar manualmente, usa ámbito `project` y commitea la carpeta `.claude/plugins/`.

**No commitear `.claude/plugins/` en el repositorio.** Si instalas un plugin con ámbito `project` pero no lo incluyes en el commit, los demás miembros del equipo no lo tendrán. Verifica que `.claude/plugins/` está trackeado por git.

**Asumir que los hooks del plugin tienen permisos ilimitados.** Los hooks de un plugin siguen las mismas restricciones de permisos que cualquier hook. Si el hook necesita ejecutar comandos que no están en la lista permitida, Claude Code pedirá confirmación o bloqueará la ejecución.

---

## Resumen

- Un plugin es un bundle que agrupa skills, hooks, subagentes y servidores MCP en una unidad distribuible con manifest
- La diferencia con los componentes individuales es que el plugin los empaqueta, versiona y configura juntos
- La estructura mínima es `plugin.json` (manifest obligatorio) más al menos un componente
- Existen tres ámbitos: `project` (por repositorio), `user` (por usuario) y `managed` (enterprise)
- El ciclo de vida es: instalar → configurar → usar → actualizar → desinstalar
