# Channels: Eventos Externos en tu Sesión de Claude Code

Hasta ahora has visto cómo Claude Code recibe instrucciones que tú escribes (o dictás). Channels invierte esa dirección: son fuentes externas —Telegram, Discord, iMessages— las que envían mensajes a tu sesión activa para que Claude los procese y actúe sobre ellos. Este capítulo explica qué son los Channels, cómo configurarlos y cuándo usarlos.

---

## Objetivos de aprendizaje

Al terminar este capítulo serás capaz de:

1. Explicar qué diferencia a un Channel de un servidor MCP convencional
2. Instalar y vincular un plugin de Channel (Telegram, Discord u otro)
3. Activar Channels al iniciar Claude Code o durante una sesión en curso
4. Configurar sender allowlists para controlar qué mensajes procesa Claude
5. Entender los controles de empresa disponibles para Channels

---

## Parte 1: Qué son los Channels

### La diferencia respecto a servidores MCP convencionales

Los servidores MCP que has visto en M07 funcionan en modo pull: Claude decide cuándo llamar a una herramienta MCP y espera la respuesta. Los Channels funcionan en modo push: son servidores MCP especiales que empujan eventos entrantes hacia tu sesión activa de Claude Code sin que Claude los haya solicitado.

```text
MCP convencional:  Claude → llama herramienta → recibe respuesta
Channels:          Evento externo → Channel lo envía a Claude → Claude actúa
```

Desde el punto de vista técnico, un Channel es un plugin que mantiene una conexión persistente con un servicio externo (Telegram, Discord, etc.) y traduce los mensajes de ese servicio en eventos que Claude Code recibe como si fueran nuevas líneas de conversación.

### Qué puede hacer Claude con un mensaje de Channel

Cuando Claude Code recibe un mensaje a través de un Channel, lo procesa como cualquier otro input y puede ejecutar las mismas acciones que en una sesión normal:

- Leer y editar ficheros del proyecto
- Ejecutar comandos de terminal
- Llamar a herramientas MCP configuradas
- Responder al canal de origen con un mensaje de vuelta

Esto permite flujos de trabajo donde Claude reacciona a eventos del entorno sin que el desarrollador tenga que estar frente al terminal.

### Flujo típico de uso

```text
Desarrollador trabaja en el proyecto
        |
        ↓
Falla el build de producción en CI
        |
        ↓
Sistema de CI envía mensaje a Telegram: "Build #847 ha fallado — timeout en test E2E"
        |
        ↓
Channel Telegram reenvía el mensaje a la sesión activa de Claude Code
        |
        ↓
Claude ejecuta diagnóstico: revisa logs, compara con último commit, identifica la causa
        |
        ↓
Claude responde al canal con un resumen y, si tiene permisos, abre un PR con la corrección
```

---

## Parte 2: Configuración de Channels

### Requisitos previos

| Requisito | Detalle |
|-----------|---------|
| Claude Code | Versión compatible con plugins (comprueba con `claude --version`) |
| Autenticación | Cuenta claude.ai (OAuth). No disponible con API key directa |
| Plugin instalado | El plugin del servicio correspondiente (Telegram, Discord, etc.) |
| Cuenta en el servicio | Cuenta activa en el servicio que quieres conectar |

### Instalar un plugin de Channel

Los plugins oficiales se instalan con el slash command `/plugin install`:

```bash
# Instalar el plugin de Telegram
/plugin install telegram@claude-plugins-official

# Instalar el plugin de Discord
/plugin install discord@claude-plugins-official
```

Al instalar, Claude Code muestra un código de confirmación (pairing code) en el terminal. Debes introducir ese código en el bot o la aplicación correspondiente para vincular tu cuenta del servicio con tu sesión de Claude Code.

```text
Plugin telegram@claude-plugins-official instalado.
Para vincular tu cuenta de Telegram:
  1. Abre @ClaudeCodeBot en Telegram
  2. Envía el mensaje: /pair XXXXXX
Código de vinculación: XXXXXX (válido durante 10 minutos)
```

El proceso de pairing es de un solo uso por cuenta. Una vez vinculado, el plugin recuerda la asociación para sesiones futuras.

### Activar Channels al iniciar Claude Code

El flag `--channels` activa todos los Channels instalados al iniciar una sesión:

```bash
# Activar todos los Channels instalados
claude --channels

# Activar solo el canal de Telegram
claude --channels telegram
```

### Activar un Channel durante una sesión en curso

Si ya tienes una sesión activa, puedes activar un Channel con el slash command:

```bash
/channels
```

Esto activa todos los Channels instalados. Una vez activos, permanecen activos hasta que cierres la sesión o los desactives manualmente.

---

## Parte 3: Sender Allowlists

### Por qué necesitas controlar quién puede enviar mensajes

Cuando activas un Channel de Telegram, en principio cualquier usuario que sepa el ID de tu bot podría enviar mensajes que Claude procesaría y actuaría sobre ellos. Las sender allowlists te permiten restringir qué usuarios, grupos o bots pueden activar acciones en Claude Code.

### Configurar la allowlist

La allowlist se configura en los settings de usuario o de proyecto. El formato depende del proveedor del Channel:

```json
{
  "channels": {
    "telegram": {
      "allowedSenders": ["@mi_usuario", "@mi_equipo"]
    },
    "discord": {
      "allowedSenders": ["servidor-id:canal-id"]
    }
  }
}
```

Los mensajes de remitentes no incluidos en la allowlist se ignoran silenciosamente. Claude Code no responde ni registra esos mensajes.

### Recomendaciones para la allowlist

- Incluir solo los usuarios o grupos que genuinamente van a enviar instrucciones (tu usuario personal, el bot de CI de tu empresa, el canal de alertas del equipo)
- Revisar la allowlist cada vez que añadas un nuevo canal de comunicación al equipo
- En proyectos con datos sensibles, restringir la allowlist a un único usuario para evitar que mensajes inesperados desencadenen acciones automatizadas

---

## Parte 4: Controles de Empresa (Enterprise)

En entornos Team y Enterprise, los administradores controlan el uso de Channels mediante dos settings de organización:

| Setting | Descripción |
|---------|-------------|
| `channelsEnabled` | Activa o desactiva la funcionalidad de Channels a nivel de toda la organización |
| `allowedChannelPlugins` | Lista blanca de plugins de Channels que los miembros pueden instalar y usar |

Si `channelsEnabled` está en `false`, el flag `--channels` no tiene efecto y los slash commands de Channel devuelven un error explicativo.

Si `allowedChannelPlugins` está configurado, solo los plugins incluidos en esa lista pueden instalarse:

```json
{
  "channelsEnabled": true,
  "allowedChannelPlugins": [
    "telegram@claude-plugins-official",
    "discord@claude-plugins-official"
  ]
}
```

Cualquier intento de instalar un plugin no incluido en la lista falla con un mensaje que indica que el plugin no está permitido por la política de la organización.

### Flag para desarrollo de plugins propios

Si estás desarrollando tu propio plugin de Channel, necesitas el flag:

```bash
claude --dangerously-load-development-channels
```

Este flag omite la verificación de firma del plugin y carga plugins locales sin publicar. Solo debe usarse en entornos de desarrollo; nunca en producción ni en máquinas con acceso a código o datos sensibles.

---

## Casos de uso

### Notificaciones de CI/CD

El caso de uso más común es recibir notificaciones de pipelines de CI/CD en Telegram o Discord y que Claude actúe automáticamente:

- El pipeline falla → Claude revisa los logs y propone un fix
- Un test flaky se detecta → Claude abre una issue con la evidencia
- Un despliegue a producción termina → Claude actualiza el CHANGELOG

### Alertas de monitorización

Integrar el canal de alertas de tu sistema de monitorización (Datadog, Grafana, PagerDuty) para que Claude investigue automáticamente:

- Una alerta de alto error rate → Claude revisa los logs recientes y el código implicado
- Un spike de latencia → Claude compara con la configuración de caché y propone ajustes

### Colaboración asíncrona de equipo

Un miembro del equipo envía una pregunta desde Discord mientras tú estás en una reunión:

- "¿Cuál es la función que valida los permisos de usuario?" → Claude responde con el nombre del fichero y la línea
- "El endpoint /api/orders devuelve 500 en staging" → Claude revisa los logs y responde con la causa

### Integración con iMessages

En macOS, la integración con iMessages permite que mensajes de texto de contactos específicos lleguen a Claude Code. Útil para escenarios donde el canal de comunicación principal del equipo son los mensajes directos.

---

## Errores comunes

**Error: Canal activo pero Claude no responde a los mensajes**

Verifica la sender allowlist. Si el remitente no está en `allowedSenders`, los mensajes se ignoran sin aviso. Añade el usuario o grupo correspondiente a la allowlist.

**Error: `/plugin install` falla con "plugin not allowed"**

La política de organización (`allowedChannelPlugins`) no incluye ese plugin. Contacta con el administrador de Claude Code de tu organización para que añada el plugin a la lista permitida.

**Error: El código de pairing ha expirado**

Los códigos de pairing tienen un tiempo de validez de 10 minutos. Ejecuta `/plugin install <plugin>` de nuevo para obtener un código nuevo.

**Error: `--channels` no tiene efecto**

Comprueba si la organización tiene `channelsEnabled: false`. Si estás en una cuenta personal, verifica que tienes la versión correcta de Claude Code y que el plugin está instalado (`/plugin list` para ver los plugins instalados).

---

## Puntos clave

- Los Channels son servidores MCP en modo push: fuentes externas envían eventos a tu sesión activa, en lugar de que Claude llame a herramientas
- Los casos de uso principales son CI/CD, alertas de monitorización y colaboración de equipo a través de Telegram, Discord o iMessages
- El pairing vincula tu cuenta del servicio con tu sesión de Claude Code mediante un código de un solo uso
- Las sender allowlists controlan qué usuarios o grupos pueden activar acciones en Claude Code; los mensajes de remitentes no autorizados se ignoran
- En entornos Enterprise, `channelsEnabled` y `allowedChannelPlugins` controlan la disponibilidad de la funcionalidad

---

## Siguiente paso

[07-chrome-integration.md](07-chrome-integration.md) — Integración con Chrome: debugging de consola y DOM, test de formularios y extracción de datos desde el navegador.
