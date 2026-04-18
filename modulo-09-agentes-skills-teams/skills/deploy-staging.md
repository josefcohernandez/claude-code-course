# Skill: Deploy a Staging

> Archivo de definición para `.claude/skills/deploy-staging/SKILL.md`

## Definición del Skill

```markdown
# Deploy a Staging

Despliega la rama actual al entorno de staging.

## Pasos

1. Verificar que estamos en una rama feature (no main/master)
2. Ejecutar tests: `npm test`
3. Build: `npm run build`
4. Verificar que el build fue exitoso
5. Push a la rama remota: `git push origin HEAD`
6. Lanzar el deploy a staging:
   - Si hay docker-compose.staging.yml: `docker-compose -f docker-compose.staging.yml up -d --build`
   - Si hay script deploy: `./scripts/deploy-staging.sh`
   - Si hay GitHub Actions: crear tag staging-YYYYMMDD-HHMM
7. Verificar healthcheck del servicio
8. Reportar URL de staging y estado

## Variables
- $ARGUMENTS: Mensaje opcional para el deploy

## Restricciones
- No desplegar desde main/master directamente
- No desplegar si los tests fallan
- No desplegar si el build falla
```

## Cómo Usarlo

### Configurar

```bash
mkdir -p .claude/skills/deploy-staging
# Copiar el contenido de arriba a:
# .claude/skills/deploy-staging/SKILL.md
```

### Invocar

```bash
claude
> /deploy-staging
> /deploy-staging "Feature de notificaciones lista para QA"
```

### Flujo

```
/deploy-staging "Nueva feature de pagos"
    ↓
1. Verifica rama ≠ main          ✓ (feature/pagos)
2. Ejecuta npm test              ✓ (42 tests passed)
3. Ejecuta npm run build         ✓ (build exitoso)
4. Push a remoto                 ✓ (pushed)
5. Lanza el deploy               ✓ (docker-compose up)
6. Healthcheck                   ✓ (200 OK)
    ↓
"Deploy exitoso: https://staging.miapp.com
 Rama: feature/pagos
 Commit: abc123
 Mensaje: Nueva feature de pagos"
```

## Ventajas del Skill frente a hacerlo manualmente

| Manual | Skill |
|--------|-------|
| Recordar todos los pasos | Un comando |
| Olvidar ejecutar tests | Tests obligatorios |
| Deploy desde main por error | Validación de rama |
| Sin verificación post-deploy | Healthcheck automático |
