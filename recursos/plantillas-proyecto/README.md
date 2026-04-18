# Plantillas de Proyecto para Claude Code

Colección centralizada de plantillas listas para copiar en tus proyectos. Incluye plantillas propias de esta carpeta y referencias a las que viven en los módulos del curso.

---

## Plantillas de configuración (en esta carpeta)

| Archivo | Descripción | Uso |
|---------|-------------|-----|
| [claude-md-starter.md](./claude-md-starter.md) | CLAUDE.md mínimo para arrancar cualquier proyecto | Copiar como `CLAUDE.md` en la raíz |
| [settings-starter.json](./settings-starter.json) | settings.json equilibrado (ni muy restrictivo ni muy permisivo) | Copiar como `.claude/settings.json` |
| [rules-codigo.md](./rules-codigo.md) | Reglas de código genéricas | Copiar en `.claude/rules/codigo.md` |
| [rules-api.md](./rules-api.md) | Reglas para APIs REST | Copiar en `.claude/rules/api.md` |
| [rules-testing.md](./rules-testing.md) | Reglas para tests | Copiar en `.claude/rules/testing.md` |
| [gitignore-claude.md](./gitignore-claude.md) | Líneas de `.gitignore` relevantes para Claude Code | Añadir a tu `.gitignore` |

---

## Plantillas de metodología (Módulo 12)

| Archivo | Descripción | Módulo |
|---------|-------------|--------|
| [plantilla-spec.md](../../modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-spec.md) | Especificación técnica (`SPEC.md`) para SDD | M12 |
| [plantilla-user-story-gherkin.md](../../modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-user-story-gherkin.md) | Historia de usuario en formato Gherkin | M12 |
| [plantilla-plan-implementacion.md](../../modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-plan-implementacion.md) | Plan de implementación por fases | M12 |

---

## Plantillas de CLAUDE.md por stack (Módulo 04)

| Archivo | Descripción | Módulo |
|---------|-------------|--------|
| [claude-md-backend.md](../../modulo-04-memoria-claude-md/plantillas/claude-md-backend.md) | CLAUDE.md orientado a backend (Python/Node/Go) | M04 |
| [claude-md-frontend.md](../../modulo-04-memoria-claude-md/plantillas/claude-md-frontend.md) | CLAUDE.md orientado a frontend (React/Vue/Angular) | M04 |
| [claude-md-fullstack.md](../../modulo-04-memoria-claude-md/plantillas/claude-md-fullstack.md) | CLAUDE.md para proyectos full stack | M04 |

---

## Plantillas de permisos (Módulo 05)

| Archivo | Descripción | Módulo |
|---------|-------------|--------|
| [settings-restrictivo.json](../../modulo-05-configuracion-permisos/plantillas/settings-restrictivo.json) | Permisos muy restrictivos (entorno seguro) | M05 |
| [settings-permisivo.json](../../modulo-05-configuracion-permisos/plantillas/settings-permisivo.json) | Permisos amplios (desarrollo rápido) | M05 |

---

## Plantillas enterprise (Módulo 11)

| Archivo | Descripción | Módulo |
|---------|-------------|--------|
| [managed-policy-ejemplo.md](../../modulo-11-enterprise-seguridad/plantillas/managed-policy-ejemplo.md) | Política managed para organizaciones | M11 |

---

## Cómo usar las plantillas

### Inicio rápido de un proyecto nuevo

```bash
mkdir mi-proyecto && cd mi-proyecto
git init

# 1. Copiar CLAUDE.md starter
cp /ruta/al/curso/recursos/plantillas-proyecto/claude-md-starter.md CLAUDE.md

# 2. Configurar permisos
mkdir -p .claude/rules
cp /ruta/al/curso/recursos/plantillas-proyecto/settings-starter.json .claude/settings.json

# 3. Copiar reglas relevantes
cp /ruta/al/curso/recursos/plantillas-proyecto/rules-codigo.md .claude/rules/
cp /ruta/al/curso/recursos/plantillas-proyecto/rules-api.md .claude/rules/      # si es API
cp /ruta/al/curso/recursos/plantillas-proyecto/rules-testing.md .claude/rules/

# 4. (Opcional) Spec-Driven Development
cp /ruta/al/curso/modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-spec.md SPEC.md
mkdir features  # para Gherkin

# 5. Abrir Claude Code
claude
```

### Personalizar después de copiar

Todas las plantillas tienen marcadores `[...]` que debes reemplazar con valores reales de tu proyecto. Busca todos los `[` en los archivos copiados y personaliza cada plantilla antes de usarla.
