# Plantilla CLAUDE.md - Proyecto Frontend

> Copia este archivo como `CLAUDE.md` en la raíz de tu proyecto frontend
> y adáptalo a tu stack específico.

---

```markdown
# [Nombre del Proyecto]

SPA de [descripción breve] con React y TypeScript.

## Stack
- Framework: React 19 + TypeScript 5
- Build: Vite 6
- State: Zustand
- Routing: React Router v7
- Styles: Tailwind CSS 4
- Tests: Vitest + React Testing Library
- Lint: ESLint + Prettier

## Comandos
- `npm run dev` - Dev server (http://localhost:5173)
- `npm test` - Tests con Vitest
- `npm run build` - Build de producción
- `npm run lint` - ESLint + Prettier check
- `npm run lint:fix` - Auto-fix lint issues

## Estructura
src/
  components/   - Componentes reutilizables
  pages/        - Páginas y rutas principales
  hooks/        - Custom hooks
  stores/       - Zustand stores
  utils/        - Utilidades
  types/        - TypeScript types/interfaces
  api/          - Llamadas a API (fetch wrappers)

## Convenciones
- Componentes: PascalCase (UserProfile.tsx)
- Hooks: camelCase con el prefijo use (useAuth.ts)
- Utils: camelCase (formatDate.ts)
- Types: PascalCase con suffix (UserType, OrderResponse)
- Imports absolutos con el prefijo @/
- Un componente por archivo
- Test junto al componente: Component.test.tsx

## Reglas
- Solo componentes funcionales con hooks
- TypeScript estricto: no usar `any`
- No usar useEffect para data fetching (usar React Query o SWR)
- CSS con Tailwind; no usar archivos CSS separados (salvo globals)
- Componentes < 150 líneas; extraer si crecen
- Props con interface, no type alias

## Restricciones
- No modificar vite.config.ts sin confirmar
- No instalar dependencias sin confirmar
- No usar `console.log` en producción
- Ejecutar tests antes de dar tarea por completa

## Respuestas
- Concisas, sin explicaciones innecesarias
- Mostrar solo código que cambia
- No generar comentarios obvios
```
