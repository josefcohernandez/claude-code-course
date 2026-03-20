# 02 - Metodología de Desarrollo Asistido por IA

## El flujo de trabajo en 4 fases

La metodología de desarrollo asistido con Claude Code se estructura en cuatro fases claras. Seguir este flujo de forma disciplinada es lo que separa a los equipos que obtienen resultados excelentes de los que obtienen resultados mediocres.

### Fase 1: Explorar (Plan Mode)

**Objetivo:** Entender el estado actual del proyecto y el alcance de la tarea.

Antes de escribir una sola línea de código, Claude Code debe explorar tu proyecto. Esta fase es crítica porque Claude Code no conoce tu codebase al inicio de cada sesión.

```
Tú: Necesito añadir autenticación OAuth2 con Google a nuestra API.
    Antes de hacer nada, explora el proyecto y dime:
    - Qué framework usamos
    - Cómo está estructurada la autenticación actual
    - Qué dependencias tenemos relacionadas
    - Dónde están los tests de autenticación
```

Durante esta fase, Claude Code usará Grep, Glob y Read para mapear tu proyecto. El resultado será un entendimiento claro de:

- La arquitectura actual
- Las convenciones del equipo
- Los puntos de integración
- Los tests existentes

**Consejo:** Puedes activar el modo "plan only" con `/plan` para que Claude Code solo explore y razone sin hacer cambios.

### Fase 2: Planificar

**Objetivo:** Definir un plan de acción antes de implementar.

Una vez que Claude Code entiende tu proyecto, pídele que elabore un plan:

```
Tú: Bien, ahora dame un plan detallado de los cambios necesarios
    para implementar OAuth2 con Google. Lista los archivos que
    modificarás, los que crearás, y el orden de los cambios.
```

Claude Code generará un plan como:

1. Instalar dependencias: `passport-google-oauth20`, `@types/passport-google-oauth20`
2. Crear `src/auth/strategies/google.strategy.ts`
3. Modificar `src/auth/auth.module.ts` para registrar la estrategia
4. Crear `src/auth/controllers/google-auth.controller.ts`
5. Actualizar `src/config/environment.ts` con variables de Google OAuth
6. Crear migración para campo `googleId` en tabla users
7. Actualizar tests en `tests/auth/`
8. Actualizar documentación de API

**Tu rol en esta fase:** Revisar el plan, pedir ajustes, aprobar o rechazar decisiones de diseño. Es mucho más barato corregir un plan que corregir una implementación.

### Fase 3: Implementar

**Objetivo:** Ejecutar el plan aprobado.

Una vez aprobado el plan, da luz verde:

```
Tú: El plan se ve bien. Impleméntalo paso a paso.
    Ejecuta los tests después de cada cambio significativo.
```

Claude Code procederá a:
- Crear y editar archivos según el plan
- Ejecutar tests incrementalmente
- Corregir problemas que surjan durante la implementación
- Consultarte si encuentra decisiones ambiguas

### Fase 4: Verificar y Commit

**Objetivo:** Confirmar que la implementación es correcta y registrarla.

```
Tú: Ejecuta todos los tests, el linter y confirma que todo pasa.
    Después, haz un commit con un mensaje descriptivo.
```

Claude Code:
- Ejecuta la suite completa de tests
- Ejecuta linters y formateadores
- Revisa el diff completo
- Crea el commit (si se lo pides)

---

## Cuándo planificar y cuándo ir directo

No todas las tareas requieren las 4 fases. Usa este criterio:

### Ir directo (sin planificación formal)

Tareas que puedes delegar directamente:

- **Corrección de bugs simples:** "El botón de logout no redirige a /login, corrígelo"
- **Cambios de texto/UI:** "Cambia el título de la página de 'Welcome' a 'Bienvenido'"
- **Añadir un test:** "Añade un test para el caso de email vacío en el registro"
- **Tareas mecánicas:** "Actualiza todas las dependencias a su última versión compatible"
- **Formateo/linting:** "Aplica el formato de Prettier a todo el proyecto"

### Planificar primero

Tareas que requieren exploración y plan:

- **Features nuevas:** Cualquier funcionalidad que no existía antes
- **Refactoring significativo:** Cambiar la estructura de múltiples archivos
- **Cambios de arquitectura:** Migrar de REST a GraphQL, cambiar ORM, etc.
- **Integraciones:** Conectar con servicios externos
- **Cambios transversales:** Que afectan a muchas partes del sistema

### Regla general

> Si la tarea toca **3 archivos o menos** y no requiere decisiones de diseño, ve directo.
> Si toca **más de 3 archivos** o requiere decisiones de diseño, planifica primero.

---

## La técnica de la entrevista

Una de las técnicas más poderosas con Claude Code es **dejar que te entreviste** antes de comenzar a trabajar. En lugar de intentar escribir un prompt perfecto, dile a Claude Code que te haga preguntas. Esta técnica se describe brevemente aquí; el **Capítulo 12** desarrolla en profundidad cómo integrarla en un flujo spec-first completo.

### Cómo funciona

```
Tú: Quiero implementar un sistema de notificaciones en tiempo real
    para nuestra aplicación. Antes de planificar, hazme las preguntas
    que necesites para entender completamente los requisitos.
```

Claude Code te preguntará cosas como:

1. "¿Qué tipos de notificaciones necesitas? (push, email, in-app, SMS)"
2. "¿Qué tecnología de real-time prefieres? (WebSockets, SSE, polling)"
3. "¿Las notificaciones deben ser persistentes (guardarse en BD) o solo en memoria?"
4. "¿Qué volumen de notificaciones esperas por usuario/día?"
5. "¿Necesitas agrupación de notificaciones? (ej: '5 personas comentaron tu post')"
6. "¿Hay requisitos de entrega garantizada o son best-effort?"
7. "¿Qué pasa con las notificaciones cuando el usuario está offline?"

### Por qué es tan efectiva

- **Descubre requisitos ocultos** que no habías considerado
- **Reduce la ambigüedad** antes de escribir código
- **Alinea expectativas** entre lo que imaginas y lo que se implementará
- **Ahorra iteraciones** al evitar malentendidos

---

## El patrón Writer/Reviewer

Este patrón utiliza **dos sesiones separadas** de Claude Code para mejorar la calidad del código. Su desarrollo completo, incluyendo variantes con múltiples revisores y la integración con subagentes, se cubre en el **Capítulo 12**.

### Cómo funciona en esencia

**Sesión 1 — Writer:** una sesión de Claude Code implementa la funcionalidad.

**Sesión 2 — Reviewer:** una **nueva sesión** de Claude Code revisa lo que escribió la primera, sin el sesgo de confirmación de quien escribió el código originalmente.

```
Tú: Revisa los cambios recientes en este proyecto (usa git diff).
    Busca: bugs potenciales, problemas de rendimiento, falta de
    manejo de errores, inconsistencias con los patrones del proyecto,
    y posibles problemas de seguridad.
```

La sesión de revisión analiza el código con ojos frescos, simulando un code review real entre dos desarrolladores. Es especialmente útil para cambios críticos o de seguridad.

---

## Feedback loops ajustados

El desarrollo asistido funciona mejor con **ciclos de retroalimentación cortos y frecuentes**. Corregir pronto y a menudo es la clave.

### El principio

> Cuanto antes corrijas una desviación, menos costosa es la corrección.

### Ejemplo de feedback loop ajustado

```
Tú: Implementa el endpoint de búsqueda de productos con filtros.

Claude: [implementa el endpoint]

Tú: Bien, pero usa Elasticsearch en vez de búsqueda en BD.
    Tenemos un servicio de Elastic ya configurado en src/services/elastic.ts

Claude: [reimplementa con Elasticsearch]

Tú: Perfecto. Ahora añade paginación con cursor-based pagination,
    no offset-based.

Claude: [añade cursor-based pagination]

Tú: Ejecuta los tests y asegúrate de que todo pasa.

Claude: [ejecuta tests, corrige un test que falla, confirma que pasan]
```

### Vs feedback loop desajustado (anti-patrón)

```
Tú: Implementa el endpoint de búsqueda de productos con filtros,
    usando Elasticsearch con el servicio en src/services/elastic.ts,
    con cursor-based pagination, soporte para filtros por categoría,
    precio, rating, disponibilidad, con ordenación por relevancia,
    precio y fecha, con caché de resultados en Redis, con rate limiting
    por usuario, y con logs estructurados en formato JSON.

Claude: [implementa todo de golpe, posiblemente con errores acumulados]
```

El segundo enfoque parece eficiente pero genera más errores porque:
- Claude Code tiene que tomar muchas decisiones a la vez
- Si se equivoca en algo fundamental al principio, todo lo posterior está mal
- Es más difícil identificar dónde están los problemas

### Regla práctica

> Divide las tareas en pasos que puedas verificar individualmente.
> Cada paso debería ser verificable con un test o una inspección rápida.

---

## El enfoque spec-first

Para tareas complejas, el enfoque más robusto es escribir una especificación primero. Los principios generales del flujo son:

1. **Entrevistar** — Claude Code te hace preguntas para clarificar requisitos
2. **Escribir la especificación** — se redacta un documento técnico en `specs/`
3. **Nueva sesión para implementar** — con contexto limpio, partiendo de la spec como fuente de verdad
4. **Verificar** — la spec sirve también como criterios de aceptación

Este flujo convierte la especificación en documentación duradera del diseño, reutilizable en revisiones futuras. La operativa completa — incluyendo plantillas de spec, integración con Gherkin y TDD, y ejemplos paso a paso — se desarrolla en el **Capítulo 12**.

---

## Desarrollo conversacional e iterativo

Un error común es esperar que Claude Code produzca el resultado perfecto en la primera interacción. El desarrollo asistido es **conversacional** por naturaleza.

### El ciclo natural

```
Tú dices algo -> Claude Code actúa -> Tú revisas -> Tú corriges/ajustas -> Repite
```

Este ciclo es **normal y esperado**. No es un fallo del sistema, es cómo funciona.

### Ejemplo de iteración productiva

```
Tú: Genera un componente de tabla reutilizable para React.

Claude: [genera un componente básico]

Tú: Añádele soporte para ordenación por columnas.

Claude: [añade ordenación]

Tú: La ordenación funciona pero quiero que el icono de la flecha
    sea más visible. Usa los iconos de lucide-react.

Claude: [actualiza los iconos]

Tú: Ahora añade paginación. Mira cómo lo hacemos en el componente
    UserList en src/components/UserList.tsx y sigue el mismo patrón.

Claude: [añade paginación siguiendo el patrón existente]
```

Cada iteración **refina** el resultado. Esto es mucho más efectivo que intentar especificar todo de golpe.

### Consejos para iterar bien

1. **Sé específico en las correcciones:** En lugar de "no me gusta", di exactamente qué quieres diferente
2. **Referencia archivos concretos:** "Hazlo como en src/components/Button.tsx"
3. **Verifica después de cada cambio:** No acumules 5 peticiones sin verificar
4. **Usa `/clear` si te pierdes:** Si la conversación se vuelve confusa, empieza de nuevo con un prompt mejor

---

## Principios clave

Estos principios aplican a cualquier tarea y a cualquier rol del equipo (backend, frontend, DevOps, QA):

### Principio 1: Siempre dale a Claude una forma de verificar su trabajo

Este es posiblemente el principio **más importante** de todo el libro.

**Malo:**
```
Refactoriza el servicio de pagos para usar el patrón Strategy.
```

**Bueno:**
```
Refactoriza el servicio de pagos para usar el patrón Strategy.
Cuando termines, ejecuta 'npm run test' para verificar que todos
los tests pasan. Si algún test falla, corrígelo.
```

**Aún mejor:**
```
Refactoriza el servicio de pagos para usar el patrón Strategy.
Antes de empezar, ejecuta 'npm run test' y confirma que todo pasa.
Después de refactorizar, ejecuta los tests de nuevo y confirma
que siguen pasando. Si algún test falla, corrígelo antes de continuar.
```

Formas de verificación según el contexto:

| Contexto | Verificación |
|----------|-------------|
| Backend | Ejecutar tests unitarios y de integración |
| Frontend | Ejecutar tests + verificar con screenshot |
| DevOps | Ejecutar plan de Terraform / docker build |
| QA | Ejecutar suite de tests e2e |
| Cualquiera | Ejecutar linter, type-check, build |

### Principio 2: Sé específico en los prompts

Claude Code trabaja mejor cuanta más información específica le das.

**Vago:**
```
Mejora el rendimiento de la página de productos.
```

**Específico:**
```
La página de productos en src/pages/Products.tsx tarda 3 segundos
en cargar porque hace 5 llamadas a la API secuenciales.
Refactorízala para que las llamadas sean paralelas usando
Promise.all(). Mira el patrón que usamos en src/pages/Dashboard.tsx
como referencia.
```

Elementos que hacen un prompt específico:

- **Archivos concretos:** "en src/pages/Products.tsx"
- **Problema concreto:** "tarda 3 segundos por llamadas secuenciales"
- **Solución esperada:** "usar Promise.all()"
- **Referencia a patrones:** "como en Dashboard.tsx"
- **Restricciones:** "mantener la misma interfaz pública"

### Principio 3: Explora primero, planifica segundo, codifica tercero

```
1. Explora el proyecto   -> Entender qué hay
2. Planifica los cambios -> Decidir qué hacer
3. Implementa            -> Hacer los cambios
4. Verifica              -> Confirmar que funciona
```

Nunca saltes del paso 1 al 3. La planificación evita retrabajo.

### Principio 4: Referencia lo existente

Claude Code es mucho más efectivo cuando puede seguir patrones existentes:

```
Crea un nuevo endpoint CRUD para la entidad "Product".
Sigue exactamente el mismo patrón que el CRUD de "User"
en src/controllers/userController.ts, src/services/userService.ts,
y src/routes/userRoutes.ts.
```

Esto funciona porque:
- Claude Code puede leer los archivos de referencia
- Aplica las mismas convenciones automáticamente
- El resultado es consistente con el resto del proyecto

---

## Anti-patrones a evitar

Estos son los errores más comunes que cometen los equipos al adoptar Claude Code. Reconocerlos y evitarlos te ahorrará horas de frustración.

### Anti-patrón 1: La sesión "fregadero" (Kitchen Sink Session)

**Qué es:** Mezclar tareas no relacionadas en una misma sesión de Claude Code.

**Ejemplo:**
```
Tú: Arregla el bug del login.
Tú: Ahora añade el campo teléfono al perfil.
Tú: Oye, también optimiza las queries de la página de dashboard.
Tú: Y de paso, actualiza las dependencias de seguridad.
```

**Por qué es malo:**
- El contexto de Claude Code se llena de información de tareas anteriores
- Las tareas pueden interferir entre sí (un cambio para el bug afecta al campo teléfono)
- Si algo falla, no sabes qué tarea lo causó
- Los commits mezclan cambios no relacionados

**Solución:** Una sesión por tarea. Usa `/clear` entre tareas o abre un nuevo terminal.

```
Sesión 1: Arregla el bug del login -> commit
Sesión 2: Añade campo teléfono -> commit
Sesión 3: Optimiza queries -> commit
Sesión 4: Actualiza dependencias -> commit
```

### Anti-patrón 2: Sobre-corrección (Over-Correcting)

**Qué es:** Corregir a Claude Code más de 2-3 veces seguidas sobre el mismo aspecto.

**Ejemplo:**
```
Tú: No, no uses esa función, usa la otra.
Tú: No, tampoco esa. La que está en utils/helpers.ts.
Tú: No, esa es la versión vieja. La nueva está en v2/helpers.ts.
Tú: Sigue sin ser la correcta...
```

**Por qué es malo:**
- Cada corrección agrega confusión al contexto
- Claude Code empieza a "adivinar" en lugar de razonar
- El resultado final es impredecible

**Solución:** Si necesitas corregir más de 2 veces, usa `/clear` y escribe un prompt mejor con toda la información:

```
Usa la función formatPhone() que está en src/v2/helpers.ts (línea 45).
No uses la versión vieja en src/utils/helpers.ts (está deprecada).
```

### Anti-patrón 3: CLAUDE.md demasiado largo (Over-Specified CLAUDE.md)

**Qué es:** Escribir un archivo CLAUDE.md excesivamente largo y detallado.

**Por qué es malo:**
- Claude Code tiene un límite de contexto
- Un CLAUDE.md de 2000 líneas consume contexto valioso
- Claude Code puede empezar a ignorar partes del archivo
- Se vuelve difícil de mantener

**Solución:** Mantener el CLAUDE.md conciso y enfocado:
- Máximo 500-800 líneas
- Solo información que Claude Code **necesita** saber
- Comandos para correr tests, build, lint
- Convenciones críticas del equipo
- Patrones preferidos
- Usar archivos CLAUDE.md anidados en subdirectorios para información específica

Lo veremos en detalle en el **Capítulo 4**.

### Anti-patrón 4: Confianza sin verificación (Trust-Then-Verify Gap)

**Qué es:** Confiar en que Claude Code hizo todo bien sin ejecutar tests ni revisar los cambios.

**Ejemplo:**
```
Tú: Implementa todo el sistema de pagos.
Claude: [hace 20 cambios en 15 archivos]
Tú: Perfecto, haz commit y push.
```

**Por qué es malo:**
- Claude Code puede introducir bugs sutiles
- Puede romper funcionalidad existente sin darse cuenta
- Puede tomar decisiones de diseño subóptimas
- Estás haciendo push de código sin revisar

**Solución:** Siempre verifica:

```
Tú: Antes de hacer commit:
    1. Ejecuta todos los tests
    2. Ejecuta el linter
    3. Muéstrame un resumen de todos los cambios (git diff)
    4. Confirma que el build es exitoso
```

Y después de que Claude Code haga todo eso, **tú también revisa** el diff antes del commit.

### Anti-patrón 5: Exploración infinita (Infinite Exploration)

**Qué es:** Pedirle a Claude Code que explore sin un objetivo claro ni un límite.

**Ejemplo:**
```
Tú: Analiza todo el proyecto y dime qué podemos mejorar.
```

**Por qué es malo:**
- Claude Code explorará archivo tras archivo sin un fin claro
- Consumirá todo el contexto disponible
- Producirá una lista interminable de "mejoras" sin priorizar
- No podrás actuar sobre los resultados

**Solución:** Acotar siempre la exploración:

```
Tú: Analiza los 5 endpoints más lentos según nuestros logs
    (están en docs/performance-report.md) y sugiere optimizaciones
    concretas para cada uno. Enfócate solo en problemas de queries
    a la base de datos.
```

### Anti-patrón 6: No dar contexto de negocio

**Qué es:** Dar instrucciones puramente técnicas sin explicar el "por qué".

**Ejemplo malo:**
```
Añade un campo 'priority' tipo integer a la tabla 'tickets'.
```

**Ejemplo bueno:**
```
Nuestro sistema de soporte necesita que los tickets tengan prioridad
para que los agentes puedan atender primero los más urgentes.
Añade un campo 'priority' a la tabla 'tickets' con valores:
1=crítica, 2=alta, 3=media, 4=baja. Por defecto, media.
Actualiza la API para que se pueda filtrar y ordenar por prioridad.
```

El contexto de negocio ayuda a Claude Code a tomar mejores decisiones cuando se encuentra con ambigüedades.
