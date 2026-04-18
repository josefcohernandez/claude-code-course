# Guia de Onboarding para Equipos que Usan Claude Code

## Objetivo

Incorporar a un nuevo miembro del equipo sin comprometer seguridad, calidad ni autonomia.

## Dia 1

1. Instalar Claude Code y verificar autenticacion.
2. Clonar el repositorio y revisar `CLAUDE.md`.
3. Leer `.claude/settings.json` y entender los permisos permitidos y bloqueados.
4. Configurar variables de entorno desde el gestor de secretos del equipo.
5. Ejecutar `git status`, `make test` y el flujo basico del proyecto.

## Semana 1

1. Usar Plan mode para explorar el codebase sin modificar archivos.
2. Pedir a Claude que explique arquitectura, reglas de negocio y comandos esenciales.
3. Revisar varios `git diff` historicos para entender el estilo del equipo.
4. Practicar una tarea pequena con aprobacion manual de cada accion.

## Semanas 2-3

1. Ejecutar cambios pequenos con Claude Code en modo normal.
2. Revisar cada cambio con `git diff` antes de hacer commit.
3. Ejecutar tests y lint despues de cada tarea cerrada.
4. Reportar cualquier permiso inesperado o comportamiento inseguro.

## Reglas no negociables

- No guardar credenciales en `CLAUDE.md`, prompts ni settings del proyecto.
- No aprobar comandos que no entiendas.
- No usar auto-accept fuera de los flujos aprobados por el equipo.
- No instalar plugins, MCP servers o dependencias sin justificarlo.
- No mergear cambios generados por el agente sin revision humana.

## Checklist de autonomia

- [ ] Entiende la arquitectura principal del proyecto
- [ ] Sabe interpretar los permisos del proyecto
- [ ] Revisa diffs con soltura
- [ ] Ejecuta tests y lint sin ayuda
- [ ] Sabe cuando escalar una decision al lead o al equipo de plataforma
