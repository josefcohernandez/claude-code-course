# Marketplaces y Gestión Enterprise de Plugins

El marketplace público de Claude Code centraliza la distribución de plugins verificados. Para organizaciones enterprise, la plataforma ofrece además la posibilidad de alojar marketplaces privados, distribuir plugins a todo el equipo y aplicar políticas que restringen qué fuentes y qué plugins están permitidos. Este capítulo cubre ambas dimensiones: el uso del marketplace público y la administración en entornos empresariales.

---

## El Marketplace Público

El marketplace público de Claude Code es el repositorio centralizado de plugins verificados por Anthropic y contribuidos por la comunidad. Se accede a él exclusivamente a través del comando interactivo `/plugin`.

### Explorar el marketplace

```bash
# Abrir el marketplace interactivo
/plugin

# Buscar plugins por nombre o tema
/plugin search deploy

# Ver información detallada de un plugin antes de instalarlo
/plugin info github

# Ver los plugins más descargados
/plugin featured
```

La interfaz interactiva de `/plugin` muestra para cada plugin:

- Nombre, versión y autor
- Descripción y caso de uso principal
- Lista de componentes incluidos (skills, hooks, agentes, servidores MCP)
- Permisos que solicita (qué herramientas puede usar)
- Número de instalaciones y puntuación de la comunidad
- Última fecha de actualización

**Antes de instalar cualquier plugin del marketplace**, revisa especialmente la sección de permisos. Un plugin que solicita acceso a `Bash` sin restricciones tiene capacidad de ejecutar comandos arbitrarios en tu sistema.

### Instalar desde el marketplace

```bash
# Instalación básica (ámbito user por defecto)
/plugin install github

# Con ámbito específico
/plugin install github --scope project

# Versión específica para reproducibilidad
/plugin install github@2.1.0 --scope project
```

---

## Marketplaces Privados para Organizaciones

Las organizaciones enterprise pueden configurar un marketplace privado para distribuir plugins internos al equipo sin publicarlos en el marketplace público.

### Configurar el servidor del marketplace privado

Un marketplace privado es un servidor HTTP que implementa la API del marketplace de Claude Code. La forma más sencilla es un repositorio Git con un fichero `registry.json` expuesto vía GitHub Pages o un servidor interno:

```json
{
  "version": "1.0",
  "plugins": [
    {
      "name": "deploy-safe",
      "version": "1.2.0",
      "description": "Flujo de deploy seguro aprobado por el equipo de plataforma",
      "author": "equipo-plataforma@empresa.com",
      "source": "https://github.com/mi-empresa/deploy-safe-plugin",
      "verified": true,
      "internal": true
    },
    {
      "name": "code-standards",
      "version": "0.8.0",
      "description": "Reglas de código, linting y formato estándar de la empresa",
      "author": "arquitectura@empresa.com",
      "source": "https://github.com/mi-empresa/code-standards-plugin",
      "verified": true,
      "internal": true
    }
  ]
}
```

### Registrar el marketplace privado en Claude Code

Los administradores configuran el marketplace privado en `managed_settings.json` (el fichero de configuración enterprise gestionado centralmente):

```json
{
  "marketplaces": [
    {
      "name": "Mi Empresa",
      "url": "https://plugins.mi-empresa.internal",
      "trusted": true
    }
  ]
}
```

Con esta configuración, los desarrolladores de la organización pueden explorar e instalar plugins internos con el mismo flujo que el marketplace público:

```bash
# Ver plugins del marketplace privado junto con el público
/plugin

# Instalar un plugin interno
/plugin install deploy-safe --marketplace "Mi Empresa"
```

### Distribuir plugins a todo el equipo (ámbito managed)

Para forzar la instalación de un plugin en todos los usuarios de la organización sin que ellos lo instalen manualmente, los administradores lo declaran en `managed_settings.json`:

```json
{
  "plugins": {
    "managed": [
      {
        "name": "code-standards",
        "version": "0.8.0",
        "scope": "managed",
        "description": "Estándares de código obligatorios para todos los proyectos"
      }
    ]
  }
}
```

Los plugins con ámbito `managed` no pueden ser desinstalados por los usuarios. Aparecen en `/plugin list` con la etiqueta `managed` y sus hooks y skills están siempre activos.

---

## Políticas de Plugins en Enterprise

### Restringir a marketplaces aprobados

La política `strictKnownMarketplaces` impide que los usuarios instalen plugins de fuentes no aprobadas:

```json
{
  "plugins": {
    "strictKnownMarketplaces": true,
    "allowedMarketplaces": [
      "https://marketplace.claude.ai",
      "https://plugins.mi-empresa.internal"
    ]
  }
}
```

Con esta política activa:

- Los usuarios solo pueden instalar plugins del marketplace oficial de Anthropic y del marketplace privado de la empresa
- Intentar instalar desde una URL arbitraria o desde una ruta local produce un error de política
- Los administradores controlan qué plugins entran al ecosistema de la organización

### Aprobar y denegar plugins específicos

Para un control más granular, los administradores pueden definir listas de plugins aprobados y bloqueados:

```json
{
  "plugins": {
    "strictKnownMarketplaces": false,
    "allowlist": [
      "github",
      "postgresql",
      "prettier-eslint",
      "deploy-safe"
    ],
    "blocklist": [
      "plugin-no-auditado",
      "third-party-bash-runner"
    ]
  }
}
```

Con `allowlist`, solo los plugins de esa lista pueden instalarse. Con `blocklist`, todos los plugins son instalables excepto los bloqueados. Si se definen ambas, `allowlist` tiene precedencia.

### Auditar plugins instalados

Los administradores pueden obtener un inventario de los plugins instalados por los usuarios de la organización:

```bash
# Ver todos los plugins instalados en todos los miembros del equipo (requiere permisos admin)
/plugin audit --org mi-empresa

# Ver plugins instalados por un usuario concreto
/plugin audit --user maria.garcia@empresa.com

# Exportar el inventario en JSON para integrarlo con herramientas de auditoría
/plugin audit --org mi-empresa --format json > inventario-plugins.json
```

El informe de auditoría muestra para cada plugin: nombre, versión, quién lo instaló, cuándo y en qué proyectos está activo.

---

## Seguridad: Evaluar Plugins de Terceros

Antes de instalar un plugin del marketplace público en un entorno enterprise, realiza esta evaluación:

### Lista de verificación de seguridad

**Origen y mantenimiento:**

- El autor es una empresa o persona con trayectoria verificable, no una cuenta recién creada
- El repositorio del plugin tiene actividad reciente (último commit en los últimos 6 meses)
- El plugin tiene más de 100 instalaciones y puntuación positiva de la comunidad

**Permisos que solicita:**

- Revisa cada permiso listado en `/plugin info <nombre>` y evalúa si es necesario para la funcionalidad descrita
- Un plugin de formateo de código no necesita acceso a `Bash`; si lo solicita, investiga por qué
- Un plugin de acceso a bases de datos necesita `Read` y posiblemente `Bash` para ejecutar queries; es esperado

**Revisión del código:**

```bash
# Descarga el plugin sin instalarlo para inspeccionarlo
git clone https://github.com/autor/nombre-plugin /tmp/plugin-auditoria

# Revisa el manifest
cat /tmp/plugin-auditoria/plugin.json

# Revisa los scripts de hooks
cat /tmp/plugin-auditoria/hooks/*.sh

# Busca patrones sospechosos: llamadas a red, acceso a credenciales, exfiltración de datos
grep -r "curl\|wget\|nc \|netcat" /tmp/plugin-auditoria/hooks/
grep -r "ANTHROPIC_API_KEY\|AWS_SECRET\|DATABASE_URL" /tmp/plugin-auditoria/hooks/
```

**Aislamiento como medida de seguridad:**

Para plugins de alto riesgo que necesitas usar, considera instalarlos con permisos reducidos:

```bash
# Instalar con permisos explícitamente restringidos (solo los que el plugin necesita)
/plugin install nombre-plugin --allow-tools "Read,Glob" --deny-tools "Bash,Write"
```

Si un plugin necesita más permisos de los que le concedes, sus componentes que requieren esos permisos simplemente no funcionarán, pero el resto del plugin sí.

---

## Errores Comunes

**Confundir `strictKnownMarketplaces` con una lista de permisos.** Esta política solo controla de dónde se pueden instalar plugins, no qué permisos tienen. Un plugin del marketplace aprobado sigue teniendo los permisos que declara en su manifest.

**No auditar periódicamente los plugins managed.** Los plugins con ámbito `managed` que se distribuyen a todo el equipo deben revisarse con cada actualización. Una actualización del autor original puede añadir nuevos permisos o cambiar el comportamiento de los hooks.

**Instalar el plugin de base de datos con credenciales de producción en el entorno de desarrollo.** Configura el plugin con credenciales de solo lectura o apuntando a una base de datos de desarrollo. Las credenciales de producción deben estar solo en entornos CI/CD controlados.

---

## Resumen

- El marketplace público se explora con `/plugin` y permite buscar, evaluar e instalar plugins verificados
- Los marketplaces privados se configuran en `managed_settings.json` con una URL y nivel de confianza
- Los plugins `managed` se distribuyen a todos los usuarios de la organización y no pueden desinstalarse individualmente
- `strictKnownMarketplaces` limita las instalaciones a marketplaces aprobados por la organización
- Las listas `allowlist` y `blocklist` permiten un control granular por nombre de plugin
- Antes de instalar un plugin de terceros, revisa el origen, los permisos solicitados y el código de los hooks
