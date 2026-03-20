# Plantillas de Proyecto para Claude Code

Coleccion centralizada de plantillas listas para copiar en tus proyectos. Incluye plantillas propias de esta carpeta y referencias a las que viven en los modulos del curso.

---

## Plantillas de configuracion (en esta carpeta)

| Archivo | Descripcion | Uso |
|---------|-------------|-----|
| [claude-md-starter.md](./claude-md-starter.md) | CLAUDE.md minimo para arrancar cualquier proyecto | Copiar como `CLAUDE.md` en la raiz |
| [settings-starter.json](./settings-starter.json) | settings.json equilibrado (ni muy restrictivo ni muy permisivo) | Copiar como `.claude/settings.json` |
| [rules-codigo.md](./rules-codigo.md) | Reglas de codigo genericas | Copiar en `.claude/rules/codigo.md` |
| [rules-api.md](./rules-api.md) | Reglas para APIs REST | Copiar en `.claude/rules/api.md` |
| [rules-testing.md](./rules-testing.md) | Reglas para tests | Copiar en `.claude/rules/testing.md` |
| [gitignore-claude.md](./gitignore-claude.md) | Lineas de .gitignore relevantes para Claude Code | Anadir a tu `.gitignore` |

---

## Plantillas de metodologia (Modulo 12)

| Archivo | Descripcion | Modulo |
|---------|-------------|--------|
| [plantilla-spec.md](../../modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-spec.md) | Especificacion tecnica (SPEC.md) para SDD | M12 |
| [plantilla-user-story-gherkin.md](../../modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-user-story-gherkin.md) | Historia de usuario en formato Gherkin | M12 |
| [plantilla-plan-implementacion.md](../../modulo-12-metodologias-desarrollo-ia/plantillas/plantilla-plan-implementacion.md) | Plan de implementacion por fases | M12 |

---

## Plantillas de CLAUDE.md por stack (Modulo 04)

| Archivo | Descripcion | Modulo |
|---------|-------------|--------|
| [claude-md-backend.md](../../modulo-04-memoria-claude-md/plantillas/claude-md-backend.md) | CLAUDE.md orientado a backend (Python/Node/Go) | M04 |
| [claude-md-frontend.md](../../modulo-04-memoria-claude-md/plantillas/claude-md-frontend.md) | CLAUDE.md orientado a frontend (React/Vue/Angular) | M04 |
| [claude-md-fullstack.md](../../modulo-04-memoria-claude-md/plantillas/claude-md-fullstack.md) | CLAUDE.md para proyectos fullstack | M04 |

---

## Plantillas de permisos (Modulo 05)

| Archivo | Descripcion | Modulo |
|---------|-------------|--------|
| [settings-restrictivo.json](../../modulo-05-configuracion-permisos/plantillas/settings-restrictivo.json) | Permisos muy restrictivos (entorno seguro) | M05 |
| [settings-permisivo.json](../../modulo-05-configuracion-permisos/plantillas/settings-permisivo.json) | Permisos amplios (desarrollo rapido) | M05 |

---

## Plantillas enterprise (Modulo 11)

| Archivo | Descripcion | Modulo |
|---------|-------------|--------|
| [managed-policy-ejemplo.md](../../modulo-11-enterprise-seguridad/plantillas/managed-policy-ejemplo.md) | Politica managed para organizaciones | M11 |

---

## Como usar las plantillas

### Inicio rapido de un proyecto nuevo

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

### Personalizar despues de copiar

Todas las plantillas tienen marcadores `[...]` que debes reemplazar con valores reales de tu proyecto. Busca todos los `[` en los archivos copiados y personaliza.
