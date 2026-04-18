# Ejercicio 03: Tu Primera Feature con Claude Code

## Objetivo

Implementar una funcionalidad nueva desde cero usando Claude Code,
prácticando el flujo completo: planificar → implementar → testear → documentar.

---

## El Proyecto: CLI de Gestion de Tareas

Vamos a crear un gestor de tareas por línea de comandos.

### Paso 1: Inicializar el Proyecto (5 min)

```bash
mkdir -p ~/task-manager && cd ~/task-manager
git init
```

Inicia Claude Code:

```bash
claude
```

### Paso 2: Planificar (5 min)

Usa modo Plan para diseñar la feature:

```
Shift+Tab (para activar Plan Mode)

Necesito crear un gestor de tareas CLI en Python con estas funciones:
- Agregar tarea (título, prioridad: alta/media/baja)
- Listar tareas (opcionalmente filtrar por prioridad)
- Marcar tarea como completada
- Eliminar tarea
- Guardar/cargar tareas de un archivo JSON

Disena la estructura del proyecto y las clases/funciones necesarias.
```

**Revisa** el plan que propone. Si te parece bien:

```
Shift+Tab (para volver a modo Normal)
Apruebo el plan. Implementa.
```

### Paso 3: Implementar (15 min)

Claude creara los archivos. Observa como:
- Crea la estructura de archivos
- Implementa la lógica
- Maneja errores
- Formatea el output

### Paso 4: Probar Manualmente (5 min)

```
Ejecuta el programa para verificar que funciona:
1. Agrega 3 tareas con diferentes prioridades
2. Lista todas las tareas
3. Filtra por prioridad alta
4. Marca una como completada
5. Elimina una
6. Verifica que se guardo en el archivo JSON
```

### Paso 5: Añade Tests (5 min)

```
Añade tests unitarios con pytest para las funciones principales.
Ejecuta los tests y verifica que pasan.
```

### Paso 6: Documentar (5 min)

```
Genera un README.md con:
- Descripción del proyecto
- Como instalar
- Como usar (con ejemplos)
- Estructura del proyecto
```

---

## Variante para Otros Roles

### Si eres Frontend
En lugar de CLI Python, crea una app React con:
- Componente TodoList
- Estado con useState
- LocalStorage para persistencia
- Estilos CSS basícos

### Si eres DevOps
En lugar de CLI, crea un script bash que:
- Gestione una lista de servidores (agregar/eliminar/listar)
- Haga ping a cada servidor
- Genere un reporte de estado
- Guarde config en YAML

### Si eres QA
En lugar de implementar, genera:
- Plan de pruebas para un gestor de tareas
- Tests automatizados con pytest
- Tests de integración
- Reporte de cobertura

---

## Criterios de Completitud

- [ ] Plan revisado y aprobado
- [ ] Código implementado y funcionando
- [ ] Al menos 5 operaciones probadas manualmente
- [ ] Tests unitarios creados y pasando
- [ ] README.md generado
- [ ] Commit realizado con mensaje descriptivo

---

## Reflexión

1. El plan de Claude era razonable? Lo hubieras hecho diferente?
2. Cuantas iteraciones necesito Claude para que todo funcionara?
3. Revisaste el código generado o lo aceptaste directamente?
4. Comparando `/cost`: ¿qué parte consumió más tokens?
5. ¿Cuánto tiempo te hubiera tomado sin Claude Code?
