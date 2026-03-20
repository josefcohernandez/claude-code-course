# Leer PDFs con Claude Code

La herramienta `Read` de Claude Code soporta ficheros `.pdf` con la misma sintaxis que cualquier otro fichero. Este capítulo explica cómo usarla, cómo gestionar documentos largos y qué estrategias dan mejores resultados en la práctica.

---

## Conceptos clave

### La herramienta Read con PDFs

Cuando Claude lee un PDF, combina extracción de texto y, en PDFs con contenido visual, interpretación de imágenes embebidas. Puedes referenciar un PDF con `@`:

```
> Lee @docs/especificacion-api.pdf y genera un resumen de los endpoints definidos.
```

O pedirle a Claude que lo lea directamente:

```
> Lee el fichero contrato.pdf y extrae todas las cláusulas relacionadas con SLAs.
```

### El parámetro pages para PDFs grandes

La herramienta `Read` tiene un parámetro `pages` para PDFs grandes. Sin este parámetro, Claude intentará leer el documento completo, pero **hay un límite de 20 páginas por petición**. Si el PDF tiene más de 10 páginas, debes especificar el rango:

```
> Lee las páginas 1-5 de @docs/manual-tecnico.pdf y explica la arquitectura descrita.
```

```
> Lee las páginas 11-20 de @especificacion.pdf. Resume los requisitos de seguridad.
```

El formato del parámetro es `"inicio-fin"` (ambos inclusivos). Ejemplos válidos:

- `pages: "1-5"` — primeras 5 páginas
- `pages: "3"` — solo la página 3
- `pages: "10-20"` — páginas 10 a 20 (máximo 20 páginas por bloque)

Si no especificas `pages` y el PDF tiene más de 10 páginas, Claude Code te avisará y fallará la lectura. Siempre especifica el rango cuando el documento es extenso.

---

## Estrategias para PDFs largos

### Estrategia 1: Leer el índice primero

La mayoría de documentos técnicos tienen índice en las primeras páginas. Lee el índice para identificar qué secciones son relevantes:

```
> Lee las páginas 1-3 de @especificacion.pdf. Es probable que sean el índice.
> Dime qué secciones tiene el documento y en qué páginas están.
```

Después, lee solo las secciones que necesitas:

```
> Según el índice que viste, la sección de autenticación está en las páginas 24-31.
> Lee esas páginas y genera el modelo de datos para implementarla.
```

### Estrategia 2: Lectura por bloques con subagentes

Para documentos de 50+ páginas donde necesitas extraer información de todo el documento, usa el patrón de subagentes:

```
> Voy a darte un PDF largo de especificaciones (80 páginas).
> Divide el trabajo en bloques de 20 páginas cada uno.
> Para cada bloque, extrae: endpoints de API definidos, modelos de datos y restricciones de negocio.
> Consolida todo en SPEC.md al final.
```

Claude puede usar la herramienta `Task` internamente para distribuir la lectura en subagentes paralelos.

### Estrategia 3: Lectura guiada por preguntas

En lugar de leer todo el PDF, haz preguntas específicas que ayuden a Claude a buscar en las secciones correctas:

```
> Tengo un PDF de 60 páginas: @contrato-proveedor.pdf.
> Solo me interesan las cláusulas de penalización por incumplimiento de SLA.
> Lee las páginas donde es más probable que estén (suelen estar en el último tercio).
> Si no las encuentras, dime y buscamos en otro rango.
```

---

## Casos de uso prácticos

### Caso 1: Extraer una spec de un PDF de requisitos

El cliente entregó la especificación funcional en PDF. Necesitas convertirla en un fichero SPEC.md estructurado:

```
> Lee las páginas 1-15 de @docs/requisitos-cliente.pdf.
> Genera docs/SPEC.md con la siguiente estructura:
> - Contexto del proyecto
> - Requisitos funcionales (lista numerada, cada uno verificable)
> - Requisitos no funcionales
> - Restricciones técnicas
>
> Si los requisitos no son verificables tal como están en el PDF, reescríbelos
> con condiciones de éxito claras.
```

### Caso 2: Revisar documentación técnica de una API externa

Tu equipo va a integrar con una API de terceros que tiene documentación solo en PDF:

```
> Lee las páginas 5-20 de @docs/api-pagos-tercero.pdf.
> Necesito saber:
> 1. Cómo funciona la autenticación (OAuth, API keys, etc.)
> 2. Los endpoints de creación de pagos: ruta, método HTTP, payload y respuesta
> 3. Los códigos de error posibles y su significado
> Genera un fichero docs/integracion-api-pagos.md con esta información.
```

### Caso 3: Analizar un contrato técnico

Tienes un contrato de servicio (SaaS o proveedor de infraestructura) y necesitas extraer los compromisos de disponibilidad:

```
> Lee las páginas 10-25 de @legal/contrato-aws.pdf.
> Extrae todas las cláusulas relacionadas con:
> - SLA de disponibilidad (%)
> - Tiempo de respuesta ante incidencias (por severidad)
> - Penalizaciones por incumplimiento
> - Exclusiones del SLA
> Crea un resumen en docs/sla-resumen.md en formato de tabla.
```

### Caso 4: Generar tests desde especificaciones en PDF

Tienes una especificación técnica de la que necesitas derivar tests automatizados:

```
> Lee las páginas 1-10 de @docs/especificacion-modulo-pago.pdf.
> Para cada requisito funcional que encuentres, genera un test en Python con pytest.
> Los tests deben seguir el patrón Given/When/Then en los docstrings.
> Guarda los tests en tests/test_modulo_pago.py.
```

---

## Limitaciones

### PDFs escaneados (OCR limitado)

Si el PDF es un documento escaneado (imagen de papel digitalizado, no texto nativo), la extracción de texto es significativamente peor. Señales de un PDF escaneado:

- No puedes seleccionar texto en el visor de PDF
- El fichero tiene mucho tamaño relativo al contenido de texto
- Las letras tienen bordes ligeramente borrosos

En estos casos, considera usar una herramienta de OCR externa (como `tesseract` o un servicio cloud) para convertir el PDF a texto antes de pasárselo a Claude.

### Tablas complejas con formato visual

Las tablas con muchas columnas, celdas combinadas o formato complejo pueden no extraerse correctamente. Si una tabla es crítica, verifica manualmente el resultado o pide a Claude que te confirme los valores con los que trabajó.

### Límites por sesión

Cada lectura de PDF consume tokens del contexto. Un bloque de 20 páginas con mucho contenido puede consumir entre 5.000 y 30.000 tokens, dependiendo de la densidad del texto. Ten esto en cuenta al planificar sesiones con documentos largos (ver Capítulo 3 sobre gestión de contexto).

### PDFs con protección

Si el PDF tiene restricciones de copia o está protegido con contraseña, la herramienta `Read` no podrá leerlo. Deberás eliminar la protección con las herramientas adecuadas antes de pasárselo a Claude.

---

## Resumen

- La herramienta `Read` de Claude Code soporta ficheros `.pdf` con la misma sintaxis que otros ficheros
- Para PDFs de más de 10 páginas, siempre especifica el rango con `pages: "inicio-fin"`
- El límite es 20 páginas por petición; usa múltiples lecturas o subagentes para documentos largos
- Estrategia recomendada: leer el índice primero, luego las secciones relevantes
- Los casos de uso más útiles son: extraer specs, documentar APIs, revisar contratos y generar tests desde requisitos
- Las limitaciones principales son: PDFs escaneados, tablas complejas y consumo elevado de contexto
