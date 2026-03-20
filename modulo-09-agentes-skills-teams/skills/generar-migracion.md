# Skill: Generar Migracion de Base de Datos

> Archivo de definicion para `.claude/skills/generar-migracion/SKILL.md`

## Definicion del Skill

```markdown
# Generar Migracion

Genera una migracion de base de datos a partir de una descripcion en lenguaje natural.

## Pasos

1. Analizar la descripcion: $ARGUMENTS
2. Leer los modelos actuales en src/models/
3. Leer las migraciones existentes para contexto
4. Generar la migracion apropiada:
   - Si el proyecto usa Alembic (Python): `alembic revision --autogenerate -m "$ARGUMENTS"`
   - Si usa Prisma (Node.js): editar prisma/schema.prisma y `npx prisma migrate dev --name "$ARGUMENTS"`
   - Si usa TypeORM: generar archivo de migracion manualmente
   - Si usa raw SQL: generar archivo .sql
5. Verificar que la migracion es correcta
6. Ejecutar la migracion en entorno de desarrollo
7. Verificar que la BD esta en estado correcto

## Variables
- $ARGUMENTS: Descripcion de la migracion (ej: "anadir campo phone a users")

## Restricciones
- Siempre generar migracion reversible (up + down)
- No modificar migraciones existentes
- Verificar que no hay conflictos con migraciones pendientes
- No ejecutar en produccion
```

## Como Usarlo

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
3. Generando migracion...
   alembic revision --autogenerate -m "add avatar_url to users"
4. Migracion creada: migrations/versions/abc123_add_avatar_url.py
5. Aplicando migracion...
   alembic upgrade head
6. Verificando...
   ✓ Columna avatar_url existe en tabla users
```

### Ejemplo: Prisma (Node.js)

```
> /generar-migracion "crear tabla categories con id, name, slug, parent_id"

1. Leyendo schema actual...
2. Anadiendo modelo a prisma/schema.prisma:
   model Category {
     id       Int       @id @default(autoincrement())
     name     String
     slug     String    @unique
     parentId Int?
     parent   Category? @relation("CategoryTree", fields: [parentId], references: [id])
     children Category[] @relation("CategoryTree")
   }
3. Generando migracion...
   npx prisma migrate dev --name "create_categories"
4. ✓ Migracion aplicada exitosamente
```
