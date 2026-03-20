# Modulo 04: Memoria y CLAUDE.md

## Descripcion general

Este modulo cubre el sistema de memoria de Claude Code: como recuerda contexto entre sesiones,
como configurar instrucciones persistentes mediante archivos `CLAUDE.md`, y como organizar
reglas modulares para equipos y proyectos complejos. Dominar este sistema es la diferencia
entre repetir instrucciones en cada sesion y tener un asistente que ya conoce tu proyecto.

## Tiempo estimado

**2 horas** (75 min teoria + 45 min ejercicios)

## Objetivos de aprendizaje

Al completar este modulo seras capaz de:

1. **Explicar** la jerarquia completa de memoria de Claude Code y como se resuelven conflictos
   entre niveles.
2. **Crear** un archivo `CLAUDE.md` efectivo y conciso para un proyecto real.
3. **Configurar** reglas modulares con `.claude/rules/` para diferentes partes del codebase.
4. **Usar** reglas con filtro de ruta para aplicar instrucciones solo a archivos relevantes.
5. **Distinguir** entre lo que debe ir en `CLAUDE.md` y lo que Claude puede inferir solo.
6. **Aplicar** plantillas de `CLAUDE.md` adaptadas a diferentes tipos de proyecto.
7. **Crear** ficheros de memoria tipados (`user`, `feedback`, `project`, `reference`) con el formato frontmatter correcto.
8. **Decidir** que informacion merece guardarse en memoria y que mecanismo usar segun el caso de uso.

## Contenido

### Teoria

| Archivo | Tema | Tiempo |
|---------|------|--------|
| [01-sistema-memoria.md](teoria/01-sistema-memoria.md) | Sistema de memoria completo | 15 min |
| [02-escribir-claude-md-efectivo.md](teoria/02-escribir-claude-md-efectivo.md) | Escribir un CLAUDE.md efectivo | 20 min |
| [03-reglas-modulares.md](teoria/03-reglas-modulares.md) | Reglas modulares con .claude/rules/ | 10 min |
| [04-memoria-estructurada-con-tipos.md](teoria/04-memoria-estructurada-con-tipos.md) | Memoria estructurada: los 4 tipos de memoria | 30 min |

### Ejercicios

| Archivo | Tema | Tiempo |
|---------|------|--------|
| [01-crear-claude-md.md](ejercicios/01-crear-claude-md.md) | Crear CLAUDE.md para tu proyecto | 25 min |
| [02-reglas-modulares.md](ejercicios/02-reglas-modulares.md) | Crear y probar reglas modulares | 20 min |

### Plantillas

| Archivo | Tipo de proyecto |
|---------|-----------------|
| [claude-md-frontend.md](plantillas/claude-md-frontend.md) | Frontend (React/Vue/Angular) |
| [claude-md-backend.md](plantillas/claude-md-backend.md) | Backend API (Node/Python/Java) |
| [claude-md-fullstack.md](plantillas/claude-md-fullstack.md) | Fullstack completo |

## Prerequisitos

- Haber completado los modulos 01 a 03.
- Tener Claude Code instalado y funcionando.
- Tener acceso a un repositorio de codigo (propio o de ejemplo).

## Conceptos clave

- **CLAUDE.md**: Archivo de instrucciones persistentes que Claude carga al inicio de cada sesion.
- **Auto memory**: Notas que Claude escribe automaticamente para si mismo entre sesiones.
- **Reglas modulares**: Archivos `.md` en `.claude/rules/` que se cargan automaticamente.
- **Reglas con filtro de ruta**: Reglas que solo aplican a archivos que coinciden con un patron glob.
- **Jerarquia de memoria**: Sistema de precedencia donde lo mas especifico gana sobre lo general.
- **Tipos de memoria**: Cuatro categorias de memoria estructurada — `user`, `feedback`, `project` y `reference`.
- **MEMORY.md**: Indice central de memorias; solo contiene punteros a ficheros individuales, no contenido directo.
