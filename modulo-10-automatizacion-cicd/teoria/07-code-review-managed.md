# 07 - Code Review como Servicio Gestionado

## Objetivos de aprendizaje

Al completar esta sección, serás capaz de:

1. **Activar el Code Review managed service** instalando la GitHub App de Claude Code con los permisos necesarios.
2. **Solicitar revisiones** mediante el comentario `@claude review` en cualquier PR de GitHub.
3. **Interpretar los findings** diferenciando entre `Important`, `Nit` y `Pre-existing`.
4. **Personalizar el comportamiento** del revisor con un fichero `REVIEW.md` en la raíz del repositorio.
5. **Comparar las tres opciones de revisión** (`/ultrareview`, `claude-code-action` y el managed service) y elegir la adecuada para cada caso.
6. **Estimar el coste** de las revisiones y controlar el gasto con el dashboard de analytics.

---

## ¿Qué es el Code Review managed service?

El Code Review managed service es un servicio gestionado por Anthropic que lanza una flota de agentes especializados para revisar PRs de GitHub. A diferencia de configurar un workflow de GitHub Actions propio, aquí no hay runners que mantener ni YAML que escribir: el servicio vive en la infraestructura de Anthropic.

El flujo completo es:

1. Abre (o recibe) una PR en tu repositorio de GitHub.
2. Escribe `@claude review` como comentario en la PR.
3. La GitHub App de Claude Code recibe el evento, lanza la revisión y publica los hallazgos como comentarios inline en el diff.

---

## Setup inicial

### Requisito de plan

El Code Review managed service está disponible únicamente en los planes **Team** y **Enterprise**. No está disponible en el plan Free ni en el plan Pro individual.

### Instalar la GitHub App

1. Ve a [github.com/apps/claude-code](https://github.com/apps/claude-code) e instala la app.
2. Selecciona los repositorios a los que quieres dar acceso (puedes empezar con uno).
3. Acepta los permisos de administrador de repositorio requeridos:
   - `Contents`: lectura del código
   - `Pull requests`: escritura para publicar comentarios
   - `Issues`: escritura para referencias cruzadas

Una vez instalada la app, cualquier miembro del repositorio con acceso puede invocar `@claude review` en una PR.

---

## Invocar una revisión

Escribe el siguiente comentario en cualquier PR del repositorio:

```text
@claude review
```

Claude analiza el diff completo de la PR y publica comentarios inline. La revisión suele completarse en menos de dos minutos para PRs de tamaño normal (menos de 400 líneas modificadas).

También puedes acompañar la invocación de instrucciones adicionales:

```text
@claude review — presta especial atención a la lógica de reintentos y al manejo de errores HTTP
```

---

## Tipos de findings

Los hallazgos se publican como comentarios inline en el diff de la PR, cada uno con una etiqueta de severidad:

| Etiqueta | Significado | Acción recomendada |
|----------|-------------|-------------------|
| `Important` | Problema que debería corregirse antes del merge | Corregir antes de aprobar |
| `Nit` | Sugerencia de estilo o mejora menor | Valorar y decidir |
| `Pre-existing` | Problema detectado que ya existía antes de esta PR | No bloquea el merge; registrar como deuda técnica |

La etiqueta `Pre-existing` es especialmente útil: evita que los revisores automáticos bloqueen PRs legítimas por problemas heredados del código que no forman parte del cambio actual.

---

## Personalizar el revisor con REVIEW.md

Si colocas un fichero `REVIEW.md` en la raíz del repositorio, Claude lo leerá antes de cada revisión y ajustará su comportamiento. Es el equivalente del `CLAUDE.md` pero específico para el servicio de revisión.

### Estructura recomendada

```markdown
# Code Review Instructions

## Focus on
- Security vulnerabilities and injection risks
- Performance issues in database queries
- Test coverage for new features

## Skip
- Style issues (we use a linter for that)
- The `legacy/` directory
- Auto-generated files in `src/generated/`

## Language
Spanish

## Extra context
This is a financial application. Any code that handles monetary amounts
must use the `Decimal` type, never `float`.
```

### Secciones útiles en REVIEW.md

| Sección | Qué incluir |
|---------|-------------|
| `Focus on` | Aspectos críticos para tu proyecto (seguridad, rendimiento, cobertura de tests) |
| `Skip` | Directorios, ficheros o tipos de issue que el revisor debe ignorar |
| `Language` | Idioma en el que Claude debe escribir los comentarios |
| `Extra context` | Convenciones del proyecto, decisiones de arquitectura, restricciones técnicas |

---

## Dashboard de analytics

El managed service incluye un dashboard de métricas accesible desde claude.ai para los administradores del plan:

- Número de revisiones ejecutadas por período
- Distribución de findings por tipo (`Important`, `Nit`, `Pre-existing`)
- Repositorios más activos
- Tendencia de hallazgos a lo largo del tiempo (útil para medir la mejora de la calidad del código)
- Coste acumulado del período

---

## Estimación de costes

El precio del managed service es variable según el tamaño de la PR:

| Tamaño de PR | Líneas modificadas aprox. | Coste estimado |
|--------------|--------------------------|---------------|
| Pequeña | < 100 | ~$5-10 |
| Media | 100-400 | ~$10-20 |
| Grande | 400-1000 | ~$20-35 |
| Muy grande | > 1000 | > $35 |

> Estos rangos son orientativos. El coste real depende de la complejidad del código y de los MCP connectors adicionales configurados.

Para controlar el gasto, puedes establecer un límite mensual desde la configuración del plan en claude.ai.

---

## Comparación de las tres opciones de revisión

Anthropic ofrece tres formas distintas de usar Claude para revisar código. Cada una tiene un perfil de uso diferente:

| Opción | Dónde ejecuta | Coste | Configuración | Mejor para |
|--------|--------------|-------|---------------|------------|
| `/ultrareview` (CLI) | Tu máquina local | Incluido en la suscripción | Ninguna | Revisiones exhaustivas antes de abrir una PR |
| `claude-code-action` (GitHub Actions) | Tus runners de CI | Coste de tokens de API | YAML del workflow | Control total, self-hosted, integración en pipeline existente |
| Code Review managed | Nube Anthropic | ~$15-25 por revisión | Solo REVIEW.md | Equipos sin infraestructura CI, zero config, planes Team/Enterprise |

### Cuándo elegir cada opción

**`/ultrareview` local:** cuando quieres una revisión profunda antes de abrir la PR, sin coste adicional y con acceso completo al repositorio local.

**`claude-code-action`:** cuando ya tienes GitHub Actions configurado, quieres integrar la revisión en el pipeline existente (junto con linting, tests, etc.) y necesitas control total sobre los triggers y los permisos.

**Code Review managed:** cuando el equipo no quiere mantener infraestructura de CI, o cuando se necesita activar la revisión de forma ad hoc con un simple comentario sin configurar nada.

---

## Ejemplo de REVIEW.md para un proyecto Python/Django

```markdown
# Code Review Instructions

## Focus on
- SQL injection risks in ORM queries and raw SQL
- Missing database indexes on filtered fields
- Django security best practices (CSRF, XSS, clickjacking headers)
- Test coverage: every new view must tener al menos un test de integración
- Use of `Decimal` for all monetary calculations (never `float`)

## Skip
- `migrations/` directory
- `staticfiles/` directory
- `.pre-commit-config.yaml` changes

## Language
Spanish

## Extra context
We follow the Two Scoops of Django coding conventions.
The project runs on Django 4.2 LTS with PostgreSQL 15.
Authentication is handled by `django-allauth`; do not suggest custom auth solutions.
```

---

## Errores comunes

| Error | Causa probable | Solución |
|-------|---------------|---------|
| `@claude review` no genera respuesta | La GitHub App no está instalada en el repositorio | Instala la app con permisos de admin |
| Los comentarios están en inglés aunque el REVIEW.md dice español | El REVIEW.md no se encuentra en la raíz del repo | Verifica que el fichero está en `/REVIEW.md`, no en un subdirectorio |
| Findings en código que no forma parte de la PR | Claude analiza el contexto del diff, no solo las líneas nuevas | Añade a `Skip` los directorios con código legacy que no quieres revisar |
| La revisión tarda más de 5 minutos | PR muy grande o MCP connectors con latencia alta | Para PRs > 1000 líneas, considera dividir el PR o usar `/ultrareview` local |
| No veo el dashboard de analytics | El usuario no tiene rol de administrador en el plan | Solicita al administrador del plan acceso al dashboard |

---

## Resumen

- El **Code Review managed service** ejecuta revisiones de PRs en la nube de Anthropic sin configurar runners propios; se activa con `@claude review` en el comentario de una PR.
- Los findings se categorizan en **Important**, **Nit** y **Pre-existing**, lo que evita bloquear PRs por deuda técnica heredada.
- El fichero **`REVIEW.md`** en la raíz del repositorio personaliza el foco, los directorios excluidos y el idioma de los comentarios.
- El servicio incluye un **dashboard de analytics** con métricas de hallazgos y coste acumulado.
- Solo disponible en planes **Team y Enterprise**, con un coste aproximado de **$15-25 por revisión** dependiendo del tamaño del PR.
- La elección entre `/ultrareview`, `claude-code-action` y el managed service depende del contexto: uso local, CI existente o zero config de equipo.

## Siguiente paso

Continúa con [08-integraciones-slack-y-web.md](08-integraciones-slack-y-web.md) para aprender a usar Claude Code directamente desde Slack y desde la interfaz web.
