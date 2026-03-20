# Ejercicio 01: Uso Efectivo de Subagentes

## Objetivo

Aprender a utilizar subagentes de forma efectiva para preservar la ventana de contexto y paralelizar trabajo. Comparar la experiencia de investigar un codebase con y sin subagentes.

**Tiempo estimado:** 15 minutos
**Nivel:** Intermedio-Avanzado

---

## Prerrequisitos

- Claude Code CLI instalado y configurado
- Un proyecto de código fuente con al menos 20-30 archivos
  - Si no tienes uno, puedes clonar cualquier proyecto open source:
    ```bash
    git clone https://github.com/expressjs/express.git proyecto-practica
    cd proyecto-practica
    ```

---

## Parte 1: Investigación SIN Subagentes (Contexto Principal)

### Instrucciones

1. Abre una sesión de Claude Code en tu proyecto:
   ```bash
   cd tu-proyecto
   claude
   ```

2. Pide una investigación que requiera leer múltiples archivos:
   ```
   Lee todos los archivos del directorio src/routes/ (o equivalente en tu proyecto)
   y explícame la estructura de rutas de la aplicación. Muestra el contenido
   de cada archivo relevante.
   ```

3. El contexto se llenará con el contenido de los archivos a medida que Claude los lea.

4. Ahora pide otra tarea:
   ```
   Ahora lee todos los archivos de tests y dime cuál es la cobertura
   de tests por módulo.
   ```

5. Con el contexto ya parcialmente ocupado, Claude puede empezar a "olvidar" partes de la conversación anterior o aproximarse a los límites de la ventana.

### Puntos de atención

- Cuántos archivos se leyeron en total
- Si Claude "perdió" contexto de la primera tarea al hacer la segunda
- Si la respuesta final fue completa o se cortó
- La percepción general de la calidad de las respuestas

---

## Parte 2: Investigación CON Subagentes (Contexto Aislado)

### Instrucciones

1. Abre una **nueva** sesión de Claude Code (para empezar limpio):
   ```bash
   claude
   ```

2. Pide la misma investigación, pero esta vez sugiere el uso de subagentes:
   ```
   Usa un subagente de tipo Explore para investigar la estructura de rutas
   de la aplicación. Quiero un resumen de cómo están organizadas las rutas,
   qué endpoints existen, y qué middlewares se aplican.
   ```

3. Claude lanzará un subagente Explore que:
   - Lee los archivos en su propio contexto
   - Devuelve un resumen al contexto principal
   - El contexto principal solo contiene el resumen, no los archivos completos

4. Ahora pide la segunda investigación también vía subagente:
   ```
   Usa otro subagente Explore para analizar los tests del proyecto.
   Quiero saber qué módulos tienen tests, cuáles no, y una estimación
   de la cobertura.
   ```

5. El contexto principal permanece limpio: solo contiene dos resúmenes.

### Puntos de atención

- El tamaño de los resúmenes frente al contenido original de los archivos
- Si el contexto principal se mantiene limpio
- La calidad de los resúmenes (¿son suficientemente informativos?)
- Si puedes hacer más preguntas de seguimiento sin problemas de contexto

---

## Parte 3: Subagente de Propósito General (Ejecución de Tests)

### Instrucciones

1. En la misma sesión (o una nueva), pide ejecutar tests con un subagente:
   ```
   Usa un subagente de propósito general para ejecutar 'npm test' (o el
   comando de tests de tu proyecto). Que analice los resultados y me
   dé un resumen de:
   - Cuántos tests pasaron/fallaron
   - Cuáles fallaron y por qué (si hay fallos)
   - Sugerencias para arreglar los fallos
   ```

2. El output completo de los tests (que puede ser cientos de líneas) se queda en el contexto del subagente. Solo recibirás un resumen estructurado, de forma que el contexto principal no se llena con el output de los tests.

### Puntos de atención

- El tamaño del output original de tests frente al resumen
- Si el resumen captura toda la información relevante
- Si los fallos se identificaron correctamente

---

## Parte 4: Comparación Final

Completa esta tabla con tus observaciones:

| Aspecto | Sin Subagentes | Con Subagentes |
|---------|---------------|----------------|
| Archivos leídos en contexto principal | ___ | ___ |
| Tamaño del contexto usado (estimado) | ___ | ___ |
| Calidad de las respuestas | ___ / 10 | ___ / 10 |
| Capacidad para preguntas de seguimiento | ___ / 10 | ___ / 10 |
| Velocidad percibida | ___ / 10 | ___ / 10 |

---

## Preguntas de Reflexión

1. ¿En qué situaciones prefieres tener el contenido completo de los archivos en tu contexto (sin subagentes)?

2. ¿Hubo alguna situación donde el resumen del subagente fue insuficiente y necesitabas más detalle?

3. Si tuvieras que investigar un monorepo con 500+ archivos, ¿cómo estructurarías la investigación usando subagentes?

4. ¿Qué tipo de subagente (Explore, Plan, General-Purpose) usarías para cada una de estas tareas?
   - a) "Busca todas las funciones deprecadas en el proyecto"
   - b) "Diseña un plan para migrar de JavaScript a TypeScript"
   - c) "Ejecuta los tests, arregla los que fallan, y confirma que pasan"
   - d) "Encuentra dónde se define la configuración de la base de datos"

### Respuestas Esperadas

> **Consejo:** Ver respuestas
>
> - a) **Explore** — solo necesita buscar y leer, no modificar
> - b) **Plan** — necesita analizar el codebase y generar un plan estructurado
> - c) **General-Purpose** — necesita ejecutar comandos, leer output, y potencialmente modificar archivos
> - d) **Explore** — búsqueda simple, no necesita modificar nada

---

## Bonus: Múltiples Subagentes en Paralelo

Si tu proyecto tiene múltiples módulos independientes, intenta lanzar una investigación paralela:

```
Necesito entender tres módulos de la aplicación. Lanza subagentes en
paralelo para investigar:
1. El módulo de autenticación (auth/)
2. El módulo de pagos (payments/)
3. El módulo de notificaciones (notifications/)

Para cada uno, quiero: estructura de archivos, dependencias principales,
y un resumen de la funcionalidad.
```

Claude lanzará tres subagentes simultáneamente y luego consolidará los resultados.
