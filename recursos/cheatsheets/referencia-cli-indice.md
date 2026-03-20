# Referencia CLI de Claude Code — Indice

> Referencia exhaustiva del CLI de Claude Code, estilo "man page". Cubre todos los modos de ejecucion, flags, comandos, atajos, variables de entorno y formatos de salida.
>
> Si buscas un resumen rapido para el dia a dia, consulta [cheatsheet-general.md](./cheatsheet-general.md).

---

## Que es esta referencia

Este anexo documenta de forma exhaustiva la interfaz de linea de comandos (CLI) de Claude Code. Esta orientado a:

- **Consulta puntual**: encontrar el flag exacto o la variable de entorno que necesitas
- **Aprendizaje profundo**: entender el comportamiento detallado de cada opcion
- **Automatizacion**: construir scripts y pipelines que usen Claude Code de forma no interactiva
- **Depuracion**: diagnosticar comportamientos inesperados con informacion completa

A diferencia del [cheatsheet-general.md](./cheatsheet-general.md), que es una referencia rapida con los comandos mas usados, esta referencia incluye todas las opciones documentadas, incluidas las avanzadas y las menos frecuentes.

---

## Ficheros de la referencia

| Fichero | Contenido |
|---------|-----------|
| [referencia-cli-modos-ejecucion.md](./referencia-cli-modos-ejecucion.md) | Modos de ejecucion: interactivo, one-shot, headless/pipe, stdin, remoto y teleport |
| [referencia-cli-flags-arranque.md](./referencia-cli-flags-arranque.md) | Todos los flags disponibles al arrancar `claude` (tabla exhaustiva) |
| [referencia-cli-slash-commands.md](./referencia-cli-slash-commands.md) | Todos los slash commands del modo interactivo |
| [referencia-cli-atajos-teclado.md](./referencia-cli-atajos-teclado.md) | Todos los atajos de teclado, con variantes por plataforma |
| [referencia-cli-variables-entorno.md](./referencia-cli-variables-entorno.md) | Todas las variables de entorno que afectan a Claude Code |
| [referencia-cli-formatos-salida.md](./referencia-cli-formatos-salida.md) | Formatos de salida (`--output-format`), JSON Schema y parseo con jq |

---

## Otros recursos de configuracion

| Fichero | Contenido |
|---------|-----------|
| [cheatsheet-general.md](./cheatsheet-general.md) | Resumen rapido para el dia a dia |
| [estructura-carpeta-claude.md](./estructura-carpeta-claude.md) | Estructura completa de `.claude/` y ficheros de configuracion |
| [github-actions-claude-code.md](./github-actions-claude-code.md) | Integracion con GitHub Actions |

---

## Guia de uso rapido

Para encontrar lo que buscas:

- **"Quiero ejecutar Claude sin interaccion"** → [Modo headless](./referencia-cli-modos-ejecucion.md#modo-headless--p)
- **"Que hace el flag `--permission-mode`"** → [Flags de arranque](./referencia-cli-flags-arranque.md)
- **"Como rewind a un punto anterior"** → [Slash commands: /rewind](./referencia-cli-slash-commands.md)
- **"Atajo para cambiar de modelo"** → [Atajos de teclado](./referencia-cli-atajos-teclado.md)
- **"Limitar tokens de pensamiento"** → [Variables de entorno](./referencia-cli-variables-entorno.md)
- **"Parsear la salida JSON con jq"** → [Formatos de salida](./referencia-cli-formatos-salida.md)

---

## Fuentes

- [Documentacion oficial CLI](https://code.claude.com/docs/en/cli-reference)
- [Documentacion modo interactivo](https://code.claude.com/docs/en/interactive-mode)
- [Documentacion de comandos](https://code.claude.com/docs/en/commands)
- [Variables de entorno](https://code.claude.com/docs/en/env-vars)
- [Configuracion y settings](https://code.claude.com/docs/en/settings)
