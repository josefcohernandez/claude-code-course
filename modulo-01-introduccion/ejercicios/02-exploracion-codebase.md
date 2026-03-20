# Ejercicio 02: Exploracion de un Codebase Existente

## Objetivo

Aprender a usar Claude Code para comprender rapidamente un proyecto existente,
practicando la tecnica de "entrevista" al codigo.

---

## Preparacion

Clona un proyecto de ejemplo (o usa uno propio):

```bash
# Opcion A: Proyecto Node.js
git clone https://github.com/expressjs/express.git ~/proyecto-prueba
cd ~/proyecto-prueba

# Opcion B: Proyecto Python
git clone https://github.com/tiangolo/fastapi.git ~/proyecto-prueba
cd ~/proyecto-prueba

# Opcion C: Cualquier proyecto tuyo
cd ~/tu-proyecto-existente
```

---

## Parte 1: Primer Contacto (10 min)

Inicia Claude Code en el proyecto:

```bash
claude
```

Haz estas preguntas en orden:

1. "Describe la estructura general de este proyecto en un parrafo"
2. "Cuales son las dependencias principales?"
3. "Cual es el punto de entrada de la aplicacion?"
4. "Como se ejecutan los tests?"

**Observa**: Claude Code lee archivos automaticamente (package.json, README, estructura).
No necesitas copiar-pegar nada.

---

## Parte 2: Investigacion Dirigida (15 min)

Ahora profundiza con preguntas mas especificas:

```
"Busca donde se definen las rutas/endpoints principales"
"Que patron de diseno usa este proyecto para manejar errores?"
"Hay algun archivo de configuracion de CI/CD?"
"Que base de datos usa y como se conecta?"
```

### Tecnica: La Entrevista

En lugar de leer todo el codigo, haz preguntas progresivas:

| Fase | Tipo de pregunta | Ejemplo |
|------|-----------------|---------|
| 1. Vista general | Estructura | "Que hace este proyecto?" |
| 2. Arquitectura | Patrones | "Que patron usa para X?" |
| 3. Detalle | Implementacion | "Como funciona la funcion Y?" |
| 4. Relaciones | Dependencias | "Que archivos se ven afectados si cambio Z?" |

---

## Parte 3: Encontrar un Bug Potencial (10 min)

Pide a Claude que analice:

```
"Busca posibles problemas de seguridad en el manejo de autenticacion"
"Hay algun endpoint que no valide los parametros de entrada?"
"Busca funciones que no manejen errores correctamente"
```

---

## Parte 4: Documentar lo Aprendido (5 min)

Pide a Claude que genere documentacion:

```
"Genera un resumen tecnico de este proyecto en formato Markdown,
incluyendo: stack tecnologico, estructura, como ejecutar,
y decisiones de arquitectura principales"
```

---

## Criterios de Completitud

- [ ] Proyecto clonado/seleccionado y Claude Code iniciado en el
- [ ] Estructura general del proyecto comprendida
- [ ] Al menos 3 preguntas de investigacion dirigida respondidas
- [ ] Analisis de seguridad o bugs ejecutado
- [ ] Documento resumen generado
- [ ] Observado como Claude navega el codebase automaticamente

---

## Reflexion

1. Cuanto tiempo te hubiera tomado entender este proyecto sin Claude Code?
2. Claude Code leyo archivos que tu no hubieras pensado en mirar?
3. Que tipo de preguntas generaron respuestas mas utiles?
4. Revisaste `/cost` para ver cuantos tokens consumio la exploracion?
