# Skill: Generar Migración de Base de Datos

> Archivo de definición para `.claude/skills/generar-migracion/SKILL.md`

## Definición del Skill

```markdown
# Generar Migración

Genera una migración de base de datos a partir de una descripción en lenguaje natural.

## Pasos

1. Analizar la descripción: $ARGUMENTS
2. Leer los modelos actuales en src/models/
3. Leer las migraciones existentes para contexto
4. Generar la migración apropiada:
   - Si el proyecto usa Alembic (Python): `alembic revision --autogenerate -m "$ARGUMENTS"`
   - Si usa Prisma (Node.js): editar prisma/schema.prisma y `npx prisma migrate dev --name "$ARGUMENTS"`
   - Si usa TypeORM: generar archivo de migración manualmente
   - Si usa raw SQL: generar archivo .sql
5. Verificar que la migración es correcta
6. Ejecutar la migración en entorno de desarrollo
7. Verificar que la BD está en estado correcto

## Variables
- $ARGUMENTS: Descripción de la migración (ej: "anadir campo phone a users")

## Restricciones
- Siempre generar migración reversible (up + down)
- No modificar migraciones existentes
- Verificar que no hay conflictos con migraciones pendientes
- No ejecutar en producción
```

## Cómo Usarlo

### Invocar

```bash
claude
> /generar-migracion "anadir campo phone tipo VARCHAR(20) a tabla users"
> /generar-migracion "crear tabla notifications con id, user_id, message, read, created_at"
> /generar-migracion "anadir indice unico en email de users"
```

### Ejemplo: Alembic (Python)

```
> /generar-migracion "anadir campo avatar_url a users"

1. Leyendo modelos actuales...
   - src/models/user.py: id, name, email, created_at
2. Modificando modelo User...
   + avatar_url: String, nullable, default=None
3. Generando migración...
   alembic revision --autogenerate -m "add avatar_url to users"
4. Migración creada: migrations/versions/abc123_add_avatar_url.py
5. Aplicando migración...
   alembic upgrade head
6. Verificando...
   ✓ Columna avatar_url existe en tabla users
```

### Ejemplo: Prisma (Node.js)

```
> /generar-migracion "crear tabla categories con id, name, slug, parent_id"

1. Leyendo schema actual...
2. Añadiendo modelo a prisma/schema.prisma:
   model Category {
     id       Int       @id @default(autoincrement())
     name     String
     slug     String    @unique
     parentId Int?
     parent   Category? @relation("CategoryTree", fields: [parentId], references: [id])
     children Category[] @relation("CategoryTree")
   }
3. Generando migración...
   npx prisma migrate dev --name "create_categories"
4. ✓ Migración aplicada exitosamente
```
