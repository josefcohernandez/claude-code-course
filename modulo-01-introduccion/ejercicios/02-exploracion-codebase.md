# Ejercicio 02: Exploración de un Codebase Existente

## Objetivo

Aprender a usar Claude Code para comprender rápidamente un proyecto existente, practicando la técnica de "entrevista" al código.

---

## Preparación

Clona un proyecto de ejemplo (o usa uno propio):

```bash
# Opción A: Proyecto Node.js
git clone https://github.com/expressjs/express.git ~/proyecto-prueba
cd ~/proyecto-prueba

# Opción B: Proyecto Python
git clone https://github.com/tiangolo/fastapi.git ~/proyecto-prueba
cd ~/proyecto-prueba

# Opción C: Cualquier proyecto tuyo
cd ~/tu-proyecto-existente
```

---

## Parte 1: Primer Contacto (10 min)

Inicia Claude Code en el proyecto:

```bash
claude
```

Haz estas preguntas en orden:

1. "Describe la estructura general de este proyecto en un párrafo"
2. "¿Cuáles son las dependencias principales?"
3. "¿Cuál es el punto de entrada de la aplicación?"
4. "¿Cómo se ejecutan los tests?"

**Observa**: Claude Code lee archivos automáticamente (`package.json`, `README`, estructura). No necesitas copiar ni pegar nada.

---

## Parte 2: Investigación Dirigida (15 min)

Ahora profundiza con preguntas más específicas:

```
"Busca dónde se definen las rutas/endpoints principales"
"¿Qué patrón de diseño usa este proyecto para manejar errores?"
"¿Hay algún archivo de configuración de CI/CD?"
"¿Qué base de datos usa y cómo se conecta?"
```

### Técnica: La Entrevista

En lugar de leer todo el código, haz preguntas progresivas:

| Fase | Tipo de pregunta | Ejemplo |
|------|------------------|---------|
| 1. Vista general | Estructura | "¿Qué hace este proyecto?" |
| 2. Arquitectura | Patrones | "¿Qué patrón usa para X?" |
| 3. Detalle | Implementación | "¿Cómo funciona la función Y?" |
| 4. Relaciones | Dependencias | "¿Qué archivos se ven afectados si cambio Z?" |

---

## Parte 3: Encontrar un Bug Potencial (10 min)

Pide a Claude que analice:

```
"Busca posibles problemas de seguridad en el manejo de autenticación"
"¿Hay algún endpoint que no valide los parámetros de entrada?"
"Busca funciones que no manejen errores correctamente"
```

---

## Parte 4: Documentar lo Aprendido (5 min)

Pide a Claude que genere documentación:

```
"Genera un resumen técnico de este proyecto en formato Markdown,
incluyendo: stack tecnológico, estructura, cómo ejecutar
y decisiones de arquitectura principales"
```

---

## Criterios de Completitud

- [ ] Proyecto clonado o seleccionado y Claude Code iniciado en él
- [ ] Estructura general del proyecto comprendida
- [ ] Al menos 3 preguntas de investigación dirigida respondidas
- [ ] Análisis de seguridad o bugs ejecutado
- [ ] Documento resumen generado
- [ ] Observado cómo Claude navega el codebase automáticamente

---

## Reflexión

1. ¿Cuánto tiempo te habría tomado entender este proyecto sin Claude Code?
2. ¿Claude Code leyó archivos que tú no habrías pensado en mirar?
3. ¿Qué tipo de preguntas generaron respuestas más útiles?
4. ¿Revisaste `/cost` para ver cuántos tokens consumió la exploración?
