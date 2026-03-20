# Jupyter Notebooks con Claude Code

Un fichero `.ipynb` es un JSON que contiene celdas de código, celdas de markdown, outputs de ejecución e imágenes embebidas. Claude Code puede leerlo, analizarlo y editarlo de forma nativa. Este capítulo explica cómo sacarle partido en flujos de trabajo de data science y documentación técnica.

---

## Conceptos clave

### Notebooks como ficheros multimodales

Cuando Claude Code lee un fichero `.ipynb` con la herramienta `Read`, **procesa todo el contenido del notebook**: el código de cada celda, el texto de las celdas markdown, los outputs de texto (stdout, stderr, resultados de celdas), y los gráficos e imágenes embebidos como outputs visuales.

Esto significa que puedes pedirle a Claude que analice un análisis exploratorio completo —código, resultados y gráficos— con una sola instrucción.

### La herramienta NotebookEdit

Mientras que la herramienta `Edit` sirve para ficheros de texto y código, Claude Code tiene una herramienta especializada para notebooks: `NotebookEdit`. Esta herramienta permite:

- **Insertar** nuevas celdas (de código o markdown) en cualquier posición
- **Editar** el contenido de una celda existente
- **Eliminar** celdas
- **Cambiar el tipo** de una celda (code a markdown o viceversa)

Las operaciones se especifican por índice de celda (0-based). Claude usa esta herramienta automáticamente cuando le pides que modifique un notebook; no necesitas invocarla manualmente.

---

## Leer y analizar un notebook

### Sintaxis básica

Para que Claude lea y analice un notebook, referencíalo con `@`:

```
> Analiza @notebooks/analisis-ventas.ipynb y resume:
> 1. Qué conjunto de datos se está analizando
> 2. Las transformaciones aplicadas a los datos
> 3. Los modelos entrenados y sus métricas de rendimiento
> 4. Las conclusiones del análisis
```

Claude lee todas las celdas y sus outputs en orden, incluyendo los gráficos.

### Analizar el estado de un modelo

```
> Lee @notebooks/modelo-clasificacion.ipynb.
> ¿El modelo muestra overfitting en los gráficos de entrenamiento?
> ¿Qué técnicas de regularización recomiendas aplicar basándote en las métricas que ves?
```

Claude puede ver los gráficos de curvas de aprendizaje embebidos en el notebook y razonar sobre ellos.

---

## Editar y mejorar notebooks

### Añadir una celda después de otra

```
> Lee @notebooks/eda-clientes.ipynb.
> Después de la celda 5 (la que hace el histograma de edades), añade una celda de código
> que calcule y muestre un boxplot de la distribución de edades por segmento de cliente.
> Usa matplotlib.
```

Claude usará `NotebookEdit` para insertar la nueva celda en la posición correcta.

### Corregir una celda con errores

```
> En @notebooks/pipeline-datos.ipynb, la celda 8 está fallando con un KeyError.
> El output de error está en la celda. Corrige el código de la celda 8.
```

Claude leerá el traceback en el output de la celda y editará el código para corregir el error.

### Refactorizar celdas largas

```
> La celda 12 de @notebooks/preprocesamiento.ipynb tiene más de 80 líneas y hace
> demasiadas cosas. Refactorízala: divide su lógica en funciones bien nombradas
> y añade docstrings. Mantener el mismo output.
```

### Documentar un notebook sin documentación

```
> @notebooks/modelo-fraude.ipynb no tiene celdas markdown explicativas.
> Después de cada bloque de código significativo, inserta una celda markdown
> que explique qué hace ese bloque y por qué. Usa lenguaje técnico pero claro.
```

---

## Casos de uso prácticos

### Caso 1: Data science — iterar sobre un modelo

Un data scientist tiene un notebook con un modelo de regresión y quiere mejorarlo:

```
> Lee @notebooks/modelo-precios.ipynb completo.
> El modelo tiene un R2 de 0.72 según los outputs. Analiza las métricas y el código.
> Sugiere 3 mejoras concretas al pipeline (feature engineering, hiperparámetros, etc.)
> Implementa la mejora más sencilla primero y añade una celda con la comparación de métricas.
```

### Caso 2: Code review de un notebook

Antes de publicar un análisis, un equipo quiere que se revise la calidad del código:

```
> Haz code review de @notebooks/analisis-ab-test.ipynb.
> Busca:
> - Celdas ejecutadas fuera de orden (que el notebook no sea reproducible)
> - Leakage de datos entre train y test set
> - Hard-coded values que deberían ser constantes o parámetros
> - Gráficos sin títulos ni etiquetas en los ejes
> Lista los problemas con el número de celda y una sugerencia de fix.
```

### Caso 3: Convertir un notebook en un script

Un notebook de exploración ya está maduro y quiere convertirse en un script de producción:

```
> Lee @notebooks/pipeline-entrenamiento.ipynb.
> Genera src/train.py extrayendo solo el código de las celdas de tipo 'code'.
> Ignora las celdas de exploración visual (las que solo muestran gráficos sin guardarlos).
> Pon el código de configuración en un bloque if __name__ == "__main__":
> Añade logging con el módulo logging de Python.
```

### Caso 4: Workflow de data scientist con Claude Code

Un flujo típico para iterar sobre un notebook de análisis:

```bash
# Paso 1: Abrir Claude Code en el directorio del proyecto
cd /home/usuario/proyecto-ml
claude
```

```
> He ejecutado @notebooks/feature-engineering.ipynb. Los outputs están actualizados.
> El accuracy bajó de 0.89 a 0.84 después de añadir las nuevas variables.
> Analiza el notebook y busca cuáles de las nuevas features podrían estar
> introduciendo ruido o multicolinealidad. Propón cuáles eliminar.
```

```
> Implementa tu recomendación: elimina las 3 features que indicaste de la celda 15
> y añade el código para calcular la matriz de correlación antes de seleccionar features.
```

---

## Limitaciones

### Los outputs deben estar en el fichero

Claude lee los outputs que ya están guardados en el `.ipynb`. Si no has ejecutado el notebook (o si reiniciaste el kernel y no lo volviste a ejecutar), los outputs estarán vacíos y Claude no podrá ver los resultados. Asegúrate de que el notebook está ejecutado antes de pedirle a Claude que analice los resultados.

### Gráficos dinámicos

Los gráficos generados con bibliotecas de visualización interactiva (plotly en modo interactivo, bokeh, altair con widgets) no se embeben como imagen en el notebook de la misma forma que matplotlib. Claude puede ver el código que los genera, pero no el gráfico interactivo en sí. Si necesitas que Claude analice el resultado visual, exporta el gráfico como PNG primero.

### Notebooks muy grandes

Un notebook con 100+ celdas y muchos outputs puede consumir gran cantidad de tokens de contexto. Para notebooks muy grandes, considera:

- Referenciar solo el notebook si necesitas análisis completo
- Usar `/compact` después del análisis inicial
- Dividir el análisis por secciones (celdas 1-30, luego 31-60, etc.)

### Ejecución de celdas

Claude Code puede editar celdas de un notebook, pero no puede ejecutarlas directamente. Después de que Claude haga modificaciones, debes ejecutar las celdas modificadas en tu entorno (Jupyter Lab, VS Code, etc.) para ver los resultados.

---

## Resumen

- Claude Code lee ficheros `.ipynb` completos: código, markdown, outputs de texto y gráficos embebidos
- La herramienta `NotebookEdit` permite insertar, editar y eliminar celdas por índice
- El notebook debe estar ejecutado (outputs guardados) para que Claude analice los resultados
- Los casos de uso más útiles son: iterar sobre modelos, hacer code review, documentar y refactorizar
- Las limitaciones principales son: outputs vacíos, gráficos interactivos y consumo alto de contexto en notebooks grandes
