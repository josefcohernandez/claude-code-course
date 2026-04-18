---
name: merge-freeze-marzo
description: Congelacion temporal de merges a main por release critica
type: project
---

No mergear a `main` hasta el 10 de marzo de 2026.

**Why:** El equipo mobile tiene una release critica el 9 de marzo y no puede absorber cambios
de API antes de pasar QA final.

**How to apply:** Si el usuario pide mergear a `main`, recordar la restriccion y proponer una
rama intermedia o esperar a que termine la ventana de freeze.
