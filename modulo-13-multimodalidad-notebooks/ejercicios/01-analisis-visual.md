# Ejercicio 01: Análisis Visual Completo

## Contexto

Trabajas en el equipo de desarrollo de una plataforma de e-commerce. Esta semana tienes que resolver cinco tareas que implican capacidades multimodales de Claude Code: analizar una pantalla de interfaz, documentar la arquitectura del sistema, extraer una especificación de un PDF, mejorar un notebook de análisis de datos y, por último, implementar una pantalla nueva a partir de un wireframe.

**Duración estimada:** 30 minutos

---

## Objetivo

Practicar las cuatro capacidades multimodales de Claude Code en situaciones realistas:

1. Análisis de screenshot de interfaz de usuario → código
2. Documentación de diagrama de arquitectura → Markdown
3. Extracción de especificación desde PDF → SPEC.md
4. Análisis y mejora de un Jupyter notebook
5. Flujo completo Visual-Driven Development: wireframe → código → comparación

---

## Requisitos previos

Se requiere haber leído los Capítulos 2 y 3 del curso, así como la teoría de este capítulo (ficheros 01, 02, 03 y 04). Además se necesita Python con Jupyter instalado (para la parte 4) y Node.js con un proyecto React disponible (para la parte 5), o crear uno con `npm create vite@latest`.

---

## Instrucciones paso a paso

### Parte 1: Analizar un screenshot de interfaz (5 min)

**Situación:** Un usuario reportó que el formulario de registro se ve mal en móvil. Te enviaron un screenshot.

#### Paso 1: Preparar el entorno

```bash
mkdir -p /tmp/ejercicio-multimodal/parte1
cd /tmp/ejercicio-multimodal/parte1
```

#### Paso 2: Obtener el formulario de referencia

El ejercicio toma como punto de partida el formulario HTML incluido a continuación. Guárdalo como `formulario-ejemplo.html` en el directorio del ejercicio y ábrelo en el navegador para capturar un screenshot que guardarás como `formulario-actual.png`.

```bash
cat > formulario-ejemplo.html << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Registro</title>
  <style>
    body { font-family: sans-serif; max-width: 400px; margin: 40px auto; padding: 0 20px; }
    input { width: 100%; padding: 6px; margin: 8px 0 16px; box-sizing: border-box; }
    button { background: #333; color: white; padding: 10px 24px; border: none; cursor: pointer; }
  </style>
</head>
<body>
  <h2>Crear cuenta</h2>
  <label>Nombre</label>
  <input type="text" placeholder="Tu nombre">
  <label>Email</label>
  <input type="email" placeholder="tu@email.com">
  <label>Contraseña</label>
  <input type="password">
  <button>Registrarme</button>
</body>
</html>
EOF
```

Abre `formulario-ejemplo.html` en el navegador y captura un screenshot. Guárdalo como `formulario-actual.png`.

#### Paso 3: Pedir a Claude que analice y mejore

Abre Claude Code y usa la referencia con `@`:

```bash
claude
```

```
> Analiza el formulario de registro en @formulario-actual.png.
> El equipo de diseño quiere modernizarlo. Genera formulario-mejorado.html con:
> - Diseño más moderno (bordes redondeados, mejor espaciado, sombras suaves)
> - Indicadores de validación inline (iconos junto a los campos)
> - Botón con estado hover visible
> - Completamente responsive (mobile-first)
> Mantener la misma estructura de campos que ves en la imagen.
```

#### Criterio de éxito

- Claude analizó la imagen y generó HTML funcional
- El resultado tiene estilos más modernos que el original
- El fichero `formulario-mejorado.html` se puede abrir en el navegador

---

### Parte 2: Documentar un diagrama de arquitectura (5 min)

**Situación:** El equipo tiene un diagrama de arquitectura de la plataforma de e-commerce pero no está documentado en texto. Necesitas generar la documentación.

#### Paso 1: Preparar el directorio

```bash
mkdir -p /tmp/ejercicio-multimodal/parte2/docs
cd /tmp/ejercicio-multimodal/parte2
```

#### Paso 2: Obtener o crear un diagrama

Opción A: Usa cualquier diagrama de arquitectura que tengas a mano (exportado de draw.io, Lucidchart, una foto de una pizarra, etc.). Guárdalo como `arquitectura.png`.

Opción B: Usa este diagrama ASCII como referencia visual simple y crea una imagen de él copiando la pantalla, o dibuja en papel y fotográfialo:

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Cliente │────▶│   Nginx  │────▶│  API     │
│ (Browser)│     │  (proxy) │     │ (FastAPI)│
└──────────┘     └──────────┘     └────┬─────┘
                                        │
                              ┌─────────┼─────────┐
                              ▼         ▼         ▼
                         ┌─────────┐ ┌──────┐ ┌──────┐
                         │Postgres │ │Redis │ │S3    │
                         │(datos)  │ │(caché│ │(imgs)│
                         └─────────┘ └──────┘ └──────┘
```

#### Paso 3: Pedir la documentación

```
> Analiza el diagrama de arquitectura en @arquitectura.png.
> Genera docs/ARQUITECTURA.md con estas secciones:
> - Descripción general del sistema
> - Componentes (tabla: nombre, tecnología, responsabilidad)
> - Flujo de una petición típica (paso a paso)
> - Dependencias entre componentes
> - Consideraciones de escalabilidad
> Si no puedes inferir tecnologías específicas de la imagen, usa placeholders descriptivos.
```

#### Criterio de éxito

- Se generó `docs/ARQUITECTURA.md`
- El fichero tiene las 5 secciones solicitadas
- Los componentes visibles en el diagrama están documentados

---

### Parte 3: Extraer spec de un PDF (5 min)

**Situación:** El product manager envió los requisitos del nuevo módulo de pagos en un PDF. Necesitas convertirlo en una especificación técnica estructurada.

#### Paso 1: Crear un PDF de ejemplo

Si no tienes un PDF de requisitos a mano, crea uno de prueba. Primero genera un fichero de texto con requisitos simulados:

```bash
mkdir -p /tmp/ejercicio-multimodal/parte3
cd /tmp/ejercicio-multimodal/parte3

cat > requisitos-pagos.txt << 'EOF'
REQUISITOS MODULO DE PAGOS - v1.2
Fecha: Marzo 2026

1. INTRODUCCION
El sistema debe permitir a los usuarios realizar pagos con tarjeta de crédito y débito.
Los pagos se procesarán a través del proveedor Stripe.

2. REQUISITOS FUNCIONALES
RF-01: El usuario puede pagar con tarjeta Visa, Mastercard y American Express.
RF-02: El sistema debe validar los datos de tarjeta antes de enviar a Stripe.
RF-03: Tras un pago exitoso, el usuario recibe email de confirmación en menos de 2 minutos.
RF-04: Si el pago falla, el usuario ve un mensaje de error específico (fondos insuficientes, tarjeta caducada, etc.).
RF-05: El historial de pagos es accesible desde el perfil del usuario.
RF-06: Los pagos de más de 500 EUR requieren verificación 3D Secure.

3. REQUISITOS NO FUNCIONALES
RNF-01: El tiempo de respuesta de la API de pagos debe ser menor a 3 segundos.
RNF-02: Los datos de tarjeta nunca se almacenan en nuestros servidores (PCI DSS).
RNF-03: Disponibilidad del 99.9%.

4. FUERA DE ALCANCE (v1)
- Pagos recurrentes / suscripciones
- Wallets digitales (Apple Pay, Google Pay)
- Reembolsos automáticos
EOF
```

Convierte a PDF usando cualquier herramienta disponible (en Linux puedes usar `libreoffice`, `wkhtmltopdf`, o simplemente imprime a PDF desde el navegador abriendo el fichero .txt):

```bash
# Si tienes libreoffice instalado:
libreoffice --convert-to pdf requisitos-pagos.txt

# Si no, en el navegador: abre el .txt, Ctrl+P, guardar como PDF
# Guárdalo como requisitos-pagos.pdf en el mismo directorio
```

Si no puedes generar el PDF, puedes hacer el ejercicio con el fichero `.txt` directamente — el objetivo es practicar la extracción y estructuración.

#### Paso 2: Extraer la spec

```bash
claude
```

```
> Lee las páginas 1-2 de @requisitos-pagos.pdf (o @requisitos-pagos.txt si usaste el txt).
> Genera docs/SPEC-modulo-pagos.md con esta estructura:
> - Contexto y objetivo
> - Requisitos funcionales (tabla: ID, descripción, condición de éxito)
> - Requisitos no funcionales (tabla: ID, descripción, métrica verificable)
> - Dependencias externas (Stripe, otros)
> - Fuera de alcance v1 (lista explícita)
> - Plan de testing (qué tipos de test y qué RF cubre cada uno)
>
> Si un requisito no es verificable tal como está escrito, reescríbelo con
> una condición de éxito medible.
```

#### Criterio de éxito

- Se generó `docs/SPEC-modulo-pagos.md`
- Los requisitos funcionales tienen condición de éxito verificable
- Hay una sección explícita de fuera de alcance
- El plan de testing cubre al menos los RF principales

---

### Parte 4: Mejorar un Jupyter notebook (8 min)

**Situación:** Un analista del equipo creó un notebook de análisis de ventas pero está sin documentar, tiene una celda con error y carece de visualizaciones.

#### Paso 1: Crear el notebook de ejemplo

```bash
mkdir -p /tmp/ejercicio-multimodal/parte4
cd /tmp/ejercicio-multimodal/parte4
```

Crea el fichero `analisis-ventas.ipynb`:

```bash
cat > analisis-ventas.ipynb << 'EOF'
{
  "nbformat": 4,
  "nbformat_minor": 5,
  "metadata": {
    "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
    },
    "language_info": {
      "name": "python",
      "version": "3.10.0"
    }
  },
  "cells": [
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "outputs": [],
      "source": [
        "import pandas as pd\n",
        "import numpy as np"
      ],
      "id": "cell-01"
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "outputs": [],
      "source": [
        "data = {\n",
        "    'mes': ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],\n",
        "    'ventas': [12000, 15000, 11000, 18000, 22000, 19000],\n",
        "    'clientes': [120, 145, 105, 180, 210, 195],\n",
        "    'devolucienes': [8, 12, 6, 15, 18, 14]\n",
        "}\n",
        "df = pd.DataFrame(data)"
      ],
      "id": "cell-02"
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "outputs": [],
      "source": [
        "df['ticket_medio'] = df['ventas'] / df['clienttes']"
      ],
      "id": "cell-03"
    },
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {},
      "outputs": [],
      "source": [
        "print(df.describe())\n",
        "print('\\nMes con más ventas:', df.loc[df['ventas'].idxmax(), 'mes'])\n",
        "print('Total ventas H1:', df['ventas'].sum())"
      ],
      "id": "cell-04"
    }
  ]
}
EOF
```

#### Paso 2: Pedir a Claude que analice y mejore

```bash
claude
```

```
> Lee @analisis-ventas.ipynb.
> Hay al menos dos errores en el notebook: un typo en el nombre de columna y
> un error de KeyError resultante. Identifica y corrige ambos.
>
> Después de corregir los errores:
> 1. Añade celdas markdown explicativas antes de cada bloque de código
>    (qué datos se cargan, qué cálculo se hace, qué resultado se espera)
> 2. Después de la celda de estadísticas, añade una celda de código que genere
>    un gráfico de barras de ventas por mes con matplotlib.
>    El gráfico debe tener título, etiquetas en los ejes y una línea de promedio.
> 3. Añade una celda final con un resumen de los 3 insights principales del análisis.
```

#### Paso 3: Verificar el notebook

Abre el notebook en Jupyter Lab o VS Code y ejecútalo completo para verificar que no hay errores:

```bash
# Si tienes jupyter instalado:
jupyter lab analisis-ventas.ipynb

# O ejecutar en modo no interactivo para verificar:
jupyter nbconvert --to notebook --execute analisis-ventas.ipynb --output analisis-ventas-ejecutado.ipynb
```

#### Criterio de éxito

- Los errores de typo están corregidos
- El notebook se ejecuta sin errores
- Hay celdas markdown explicativas
- Hay un gráfico de barras con título y etiquetas
- Hay una celda de resumen al final

---

### Parte 5: Flujo completo Visual-Driven Development (7 min)

**Situación:** El equipo de diseño entregó el wireframe de la nueva página de perfil de usuario. Debes implementarla en HTML/CSS.

#### Paso 1: Preparar el entorno

```bash
mkdir -p /tmp/ejercicio-multimodal/parte5
cd /tmp/ejercicio-multimodal/parte5
```

#### Paso 2: Crear o conseguir un wireframe

Dibuja (en papel o con cualquier herramienta) un wireframe simple de una tarjeta de perfil de usuario con estos elementos:

- Avatar (círculo con iniciales o foto)
- Nombre de usuario
- Título/rol
- Tres estadísticas (ej: Posts, Seguidores, Siguiendo)
- Botón "Editar perfil"

Haz una foto o captura de pantalla del wireframe y guárdalo como `wireframe-perfil.png`.

Alternativa: crea el wireframe con ASCII y captúralo como imagen:

```
┌─────────────────────────────┐
│                             │
│    ┌────┐   María García    │
│    │ MG │   Desarrolladora  │
│    └────┘   Backend Senior  │
│                             │
│  Posts  Seguid. Siguiendo   │
│   142    1.2k     89        │
│                             │
│    [ Editar perfil ]        │
│                             │
└─────────────────────────────┘
```

#### Paso 3: Implementar desde el wireframe (sesión Writer)

```bash
claude
```

```
> Mira el wireframe en @wireframe-perfil.png.
> Implementa el componente como perfil-usuario.html con HTML y CSS inline (sin frameworks).
> Usa un diseño moderno: colores neutros, tipografía sans-serif, sombra suave en la tarjeta.
> El avatar debe mostrar las iniciales del nombre sobre un fondo de color.
> El resultado debe ser responsive.
```

#### Paso 4: Capturar el resultado

Abre `perfil-usuario.html` en el navegador y captura un screenshot. Guárdalo como `resultado-perfil.png`.

#### Paso 5: Comparar con el wireframe (sesión Reviewer)

Abre una sesión nueva de Claude Code para la revisión:

```bash
# En otra terminal o con /clear
claude
```

```
> Compara el wireframe original @wireframe-perfil.png con el resultado implementado @resultado-perfil.png.
> Lista las diferencias entre lo que pedía el wireframe y lo que se implementó.
> Ordena por prioridad: primero los elementos que faltan, luego los que son distintos,
> luego las mejoras opcionales.
```

#### Paso 6: Aplicar correcciones

De vuelta en la sesión original (o iniciando una nueva si usaste `/clear`):

```
> Aplica las correcciones indicadas por el Reviewer al fichero perfil-usuario.html.
```

#### Criterio de éxito

- Se generó `perfil-usuario.html` con los elementos del wireframe
- La sesión Reviewer identificó al menos una diferencia entre wireframe y resultado
- Se aplicaron las correcciones

---

## Criterios de éxito globales

| Parte | Criterio | Verificado? |
|-------|----------|-------------|
| 1 | Claude analizó la imagen del formulario y generó HTML mejorado | |
| 2 | Se generó ARQUITECTURA.md con las 5 secciones a partir del diagrama | |
| 3 | Se generó SPEC-modulo-pagos.md con requisitos verificables y tabla de testing | |
| 4 | El notebook se ejecuta sin errores, tiene markdown explicativo y gráfico | |
| 5 | Flujo completo VDD: wireframe → implementación → comparación → fix | |

---

## Pistas

**Pista nivel 1 (para parte 3 si el PDF no funciona):**
Si tienes problemas generando el PDF, Claude puede leer el fichero `.txt` directamente. La extracción y estructuración de la spec funciona igual con texto plano.

**Pista nivel 2 (para parte 4 si el notebook tiene más errores de los esperados):**
Pide a Claude: "Lee el notebook y lista todos los problemas que encuentras antes de corregir ninguno." Obtener el diagnóstico completo primero evita correcciones parciales.

**Pista nivel 3 (para parte 5 si el resultado diverge mucho del wireframe):**
Si la primera implementación diverge mucho, es posible que el wireframe no tuviera suficiente detalle. Intenta con un wireframe más detallado, o proporciona un ejemplo de componente similar: "Implementa el componente siguiendo el estilo de @perfil-referencia.png".

---

## Solución de referencia

Para la parte 4, los errores en el notebook son:

1. Celda `cell-02`: `'devolucienes'` debe ser `'devoluciones'` (typo)
2. Celda `cell-03`: `df['clienttes']` debe ser `df['clientes']` (typo que causa `KeyError`)

Para verificar que Claude los identificó correctamente, compara con esta solución antes de revisar el notebook editado.
