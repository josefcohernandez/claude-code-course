# Checklist de Seguridad para Equipos con Claude Code

## Antes de empezar

- [ ] `CLAUDE.md` no contiene credenciales, tokens ni secretos embebidos
- [ ] `CLAUDE.local.md` y archivos equivalentes estan ignorados por Git
- [ ] `.env`, `.env.*` y artefactos con secretos no se trackean en el repositorio
- [ ] El equipo sabe donde guardar secretos y como rotarlos

## Permisos y ejecucion

- [ ] Existe una politica `deny` para comandos destructivos
- [ ] El `allow` contiene solo las operaciones minimas necesarias
- [ ] `sudo`, `rm -rf`, `env`, `printenv` y patrones similares estan bloqueados
- [ ] El sandbox esta activado en los entornos que manejan datos sensibles
- [ ] El uso de auto-accept esta restringido a operaciones seguras

## MCP y herramientas externas

- [ ] Los servidores MCP provienen de fuentes confiables
- [ ] Las credenciales de MCP usan variables de entorno, no valores hardcodeados
- [ ] Cada servidor MCP tiene el menor nivel de acceso posible
- [ ] Los plugins y extensiones de terceros han pasado una revision minima

## Flujo de trabajo del equipo

- [ ] Todo cambio generado por Claude Code se revisa con `git diff`
- [ ] Se ejecutan tests y lint antes de mergear
- [ ] Hay una convencion compartida para `CLAUDE.md`, settings y hooks
- [ ] El onboarding del equipo explica que puede y que no puede hacer el agente
- [ ] Hay un proceso claro para reportar comportamientos inseguros o inesperados

## Revision periodica

- [ ] La configuracion se revisa al menos una vez por sprint o por release
- [ ] Se comprueba que no haya secretos filtrados en el historial reciente
- [ ] Las nuevas dependencias o integraciones se auditan antes de habilitarlas
- [ ] Las politicas enterprise siguen alineadas con el riesgo real del proyecto
