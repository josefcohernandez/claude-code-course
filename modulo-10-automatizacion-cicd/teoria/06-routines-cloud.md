# 06 - Routines: Automatización Cloud de Claude Code

## Objetivos de aprendizaje

Al completar esta sección, serás capaz de:

1. **Distinguir Routines de las tareas locales** (`CronCreate`, crontab) y entender cuándo usar cada enfoque.
2. **Crear Routines** desde la web de claude.ai, la app Desktop y el CLI con `/schedule`.
3. **Configurar los tres tipos de trigger**: schedule (cron), API trigger y GitHub events.
4. **Personalizar una Routine** con prompt de instrucciones, repositorios, MCP connectors y scripts de entorno.
5. **Disparar Routines externamente** mediante el endpoint HTTP `/fire` con bearer token.
6. **Revisar transcripts** de ejecuciones pasadas para depurar y auditar.

---

## ¿Qué son las Routines?

Las Routines son el sistema de automatización cloud de Claude Code. A diferencia de `CronCreate` —que programa tareas que requieren una sesión de Claude Code abierta en tu máquina— las Routines se ejecutan en la **infraestructura de Anthropic**: no necesitas tener el portátil encendido ni una sesión activa.

Cada Routine es una unidad de automatización configurable con:

- Un **prompt** que describe exactamente qué debe hacer Claude.
- Uno o varios **repositorios de GitHub** sobre los que trabajar.
- Un **trigger** que determina cuándo se ejecuta.
- Parámetros opcionales de entorno, MCP connectors y acceso a red.

### Routines vs. CronCreate: diferencias clave

| Característica | Routines | CronCreate |
|----------------|----------|------------|
| Infraestructura | Nube Anthropic | Máquina local |
| Requiere sesión activa | No | Sí |
| Triggers disponibles | Schedule, API HTTP, GitHub events | Solo cron |
| Transcript accesible | Sí, desde la web | Solo en la sesión |
| Repositorios de GitHub | Configurado en la Routine | Acceso al repo local |
| Caso de uso típico | Automatización de equipo permanente | Monitorización durante el trabajo |

---

## Crear una Routine

### Desde la web o la app Desktop

1. Accede a [claude.ai](https://claude.ai) y abre la sección **Routines** (menú lateral).
2. Haz clic en **New Routine**.
3. Completa los campos de configuración (ver sección siguiente).
4. Guarda y activa la Routine.

### Desde el CLI con `/schedule`

Dentro de una sesión de Claude Code interactiva:

```text
/schedule "Cada día laborable a las 9:00, revisa los PRs abiertos del repositorio,
añade el label 'needs-review' a los que llevan más de 24 horas sin actividad
y comenta en cada uno con un resumen de los cambios pendientes."
```

Claude pedirá confirmación y configurará el trigger de forma automática.

---

## Tipos de trigger

### Schedule (cron)

Ejecuta la Routine en un horario fijo usando sintaxis cron estándar.

```text
Expresiones cron de ejemplo:

0 9 * * 1-5    Cada día laborable a las 9:00 UTC
0 8 * * 1      Cada lunes a las 8:00 UTC
0 */6 * * *    Cada 6 horas
0 18 * * 5     Cada viernes a las 18:00 UTC
```

**Cuándo usar:** tareas periódicas independientes del flujo de trabajo (reportes diarios, auditorías semanales, limpieza mensual).

### API trigger

Genera un endpoint HTTP `/fire` con bearer token. Cualquier script externo puede disparar la Routine con una llamada `curl`:

```bash
# Disparar una Routine desde un script externo
curl -X POST https://api.claude.ai/routines/<id-routine>/fire \
  -H "Authorization: Bearer <token-de-la-routine>" \
  -H "Content-Type: application/json" \
  -d '{"context": "Revisión semanal de dependencias iniciada por deploy pipeline"}'
```

El campo `context` es opcional y se inyecta en el prompt de la Routine como información adicional.

**Cuándo usar:** disparar la Routine al final de un deploy, desde otro pipeline de CI, o desde un script de automatización que ya tienes.

### GitHub events

Ejecuta la Routine automáticamente cuando ocurren eventos en el repositorio de GitHub conectado:

| Evento | Descripción |
|--------|-------------|
| `pull_request.opened` | Al abrir una PR nueva |
| `pull_request.merged` | Al hacer merge de una PR |
| `release.published` | Al publicar un release |
| `issue.opened` | Al abrir un issue nuevo |

**Cuándo usar:** complementar GitHub Actions cuando no quieres gestionar la infraestructura de runners, o cuando necesitas que Claude tenga acceso persistente a múltiples repositorios sin configurar cada uno por separado.

---

## Configuración de una Routine

Al crear o editar una Routine, los parámetros disponibles son:

| Parámetro | Descripción |
|-----------|-------------|
| **Nombre** | Identificador legible para listar Routines |
| **Prompt** | Instrucciones detalladas de lo que Claude debe hacer en cada ejecución |
| **Repositorio(s)** | Uno o varios repos de GitHub donde trabajar |
| **MCP connectors** | Servidores MCP adicionales a los que puede conectarse (bases de datos, APIs, etc.) |
| **Setup script** | Script de shell que se ejecuta antes del prompt (instalar dependencias, configurar entorno) |
| **Network access** | Lista de dominios que la ejecución puede alcanzar |
| **Daily cap** | Número máximo de ejecuciones por día (seguridad frente a bucles accidentales) |

### Ejemplo: Routine de revisión diaria de PRs

```text
Nombre: Revisión matutina de PRs

Trigger: Schedule — 0 9 * * 1-5 (lunes a viernes a las 9:00 UTC)

Repositorio: mi-org/mi-proyecto

Prompt:
Revisa todos los PRs abiertos del repositorio y para cada uno:
1. Añade el label "needs-review" si lleva más de 24 horas abierto sin revisión aprobada.
2. Añade el label "conflict" si tiene conflictos de merge con la rama principal.
3. Publica un comentario resumiendo el estado si no ha habido actividad en 48 horas.
Usa un tono conciso y profesional. Los comentarios deben estar en español.

Daily cap: 2 (evitar ejecuciones duplicadas por fallos transitorios)
```

---

## Consultar transcripts

Cada ejecución de una Routine genera un **transcript** completo: el historial de mensajes entre Claude y las herramientas que usó (lecturas de archivos, llamadas a la API de GitHub, etc.).

Para consultarlos:

1. Ve a la sección **Routines** en claude.ai.
2. Selecciona la Routine.
3. En el historial de ejecuciones, haz clic en cualquier entrada para ver el transcript completo.

Los transcripts son útiles para:
- Verificar que la Routine hace exactamente lo esperado.
- Depurar cuando una ejecución falla o produce resultados inesperados.
- Auditar cambios automáticos en el repositorio.

---

## Ejemplo práctico: Routine con API trigger para deploy

Este ejemplo muestra cómo integrar una Routine en el pipeline de deploy de un proyecto. Al terminar el deploy, se dispara la Routine para generar las notas de la versión y notificar al equipo.

### Configuración de la Routine

```text
Nombre: Post-deploy notes

Trigger: API trigger

Repositorio: mi-org/mi-proyecto

Prompt:
Se acaba de publicar un nuevo deploy. El contexto de la ejecución incluye
el nombre de la versión.

Realiza las siguientes tareas:
1. Ejecuta 'git log --oneline --since=7.days' para obtener los commits recientes.
2. Agrupa los commits por tipo: feat, fix, chore, docs.
3. Crea un issue en GitHub titulado "Release Notes - <contexto>" con el resumen
   en formato Markdown, agrupado por tipo de cambio.
4. Cierra todos los issues que estén mencionados en los commits de esta semana
   (busca referencias como "fixes #123" o "closes #456").
```

### Script de deploy que dispara la Routine

```bash
#!/bin/bash
# deploy.sh — se ejecuta al finalizar el deploy en producción

set -euo pipefail

VERSION="v$(date +%Y.%m.%d)"

echo "Deploy completado. Disparando Routine de post-deploy..."

curl -X POST "https://api.claude.ai/routines/<id-routine>/fire" \
  -H "Authorization: Bearer <token-routine>" \
  -H "Content-Type: application/json" \
  -d "{\"context\": \"${VERSION}\"}"

echo "Routine disparada correctamente para la versión ${VERSION}."
```

---

## Errores comunes

| Error | Causa probable | Solución |
|-------|---------------|---------|
| La Routine no se ejecuta en la hora configurada | El cron usa UTC, no tu zona horaria local | Ajusta la hora sumando o restando la diferencia con UTC |
| El endpoint `/fire` devuelve 401 | Token expirado o incorrecto | Regenera el token desde la configuración de la Routine |
| La Routine supera el daily cap | Fallos transitorios que causan reintentos | Aumenta el daily cap o revisa la lógica de retry del trigger |
| El setup script falla y la Routine no ejecuta el prompt | Dependencia no instalada en el entorno de Anthropic | Usa el setup script para instalar todo lo necesario antes del prompt |
| Los cambios en el repo no se reflejan | La Routine usa un snapshot del repo, no tiempo real | Asegúrate de que el token de GitHub tiene permisos de lectura actualizados |

---

## Resumen

- Las **Routines** ejecutan tareas de Claude Code en la nube de Anthropic sin necesidad de una sesión local activa.
- Existen tres tipos de trigger: **schedule** (cron), **API trigger** (endpoint HTTP `/fire`) y **GitHub events** (PR, release, issue).
- Cada Routine se configura con un prompt, uno o varios repositorios, MCP connectors opcionales, un setup script y un daily cap de seguridad.
- Los **transcripts** de cada ejecución son accesibles desde la web para depuración y auditoría.
- Son especialmente útiles para automatizaciones de equipo permanentes que deben funcionar independientemente del estado de la máquina local.

## Siguiente paso

Continúa con [07-code-review-managed.md](07-code-review-managed.md) para aprender a usar el servicio gestionado de revisión de código de Anthropic sin configurar infraestructura propia.
