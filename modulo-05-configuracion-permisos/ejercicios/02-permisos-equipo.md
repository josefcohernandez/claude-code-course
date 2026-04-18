# Ejercicio 02: Configurar Permisos para un Equipo

## Objetivo

Disenar e implementar una configuración de permisos para un equipo de 4 personas
con diferentes roles.

---

## Escenario

Tu equipo tiene 4 miembros:
- **Ana**: Backend developer (Python/FastAPI)
- **Carlos**: Frontend developer (React/TypeScript)
- **Díana**: DevOps (Docker, CI/CD, Terraform)
- **Eduardo**: QA (Tests automatizados, Playwright)

Proyecto: Aplicación fullstack en monorepo.

---

## Parte 1: Configuración Compartida (10 min)

Crea `.claude/settings.json` (proyecto, compartido por todos):

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Bash(git status)",
      "Bash(git diff*)",
      "Bash(git log*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(npm publish*)",
      "Bash(pip install*)",
      "Write(.env*)",
      "Write(*secret*)",
      "Write(*credential*)"
    ]
  }
}
```

---

## Parte 2: Configuraciónes por Rol (15 min)

Cada miembro crea su `.claude/settings.local.json`:

### Ana (Backend)

```json
{
  "permissions": {
    "allow": [
      "Bash(pytest*)",
      "Bash(python -m pytest*)",
      "Bash(make test*)",
      "Bash(make lint*)",
      "Edit(src/api/**)",
      "Edit(src/services/**)",
      "Edit(src/models/**)",
      "Write(tests/unit/**)",
      "Write(tests/integration/**)"
    ],
    "deny": [
      "Edit(src/frontend/**)",
      "Write(infra/**)",
      "Bash(alembic downgrade*)"
    ]
  }
}
```

### Carlos (Frontend)

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test*)",
      "Bash(npm run lint*)",
      "Bash(npx vitest*)",
      "Edit(src/frontend/**)",
      "Edit(src/components/**)",
      "Write(src/frontend/**)"
    ],
    "deny": [
      "Edit(src/api/**)",
      "Edit(src/models/**)",
      "Write(infra/**)",
      "Bash(npm install*)"
    ]
  }
}
```

### Díana (DevOps)

```json
{
  "permissions": {
    "allow": [
      "Bash(docker build*)",
      "Bash(docker-compose*)",
      "Bash(terraform plan*)",
      "Bash(kubectl get*)",
      "Bash(kubectl describe*)",
      "Edit(infra/**)",
      "Edit(.github/**)",
      "Edit(Dockerfile*)"
    ],
    "deny": [
      "Bash(terraform apply*)",
      "Bash(kubectl delete*)",
      "Bash(docker push*)",
      "Edit(src/**)"
    ]
  }
}
```

### Eduardo (QA)

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test*)",
      "Bash(pytest*)",
      "Bash(npx playwright*)",
      "Edit(tests/**)",
      "Write(tests/**)"
    ],
    "deny": [
      "Edit(src/**)",
      "Write(src/**)",
      "Edit(infra/**)"
    ]
  }
}
```

---

## Parte 3: Verificar (10 min)

Para cada rol, verifica que:

1. Los comandos allow funcionan sin preguntar
2. Los comandos deny están bloqueados
3. El resto pide confirmacion (ask)

```bash
# Simular como Ana
cp ana-settings.json .claude/settings.local.json
claude
> /permissions
> "Ejecuta pytest tests/"      # Debería funcionar
> "Modifica src/frontend/App.tsx"  # Debería estar bloqueado
```

---

## Parte 4: Documento de Política (5 min)

Crea un documento que explique la política de permisos:

| Rol | Puede editar | Puede ejecutar | Bloqueado |
|-----|-------------|---------------|-----------|
| Backend | src/api/, src/services/, src/models/ | pytest, make test/lint | Frontend, infra |
| Frontend | src/frontend/, src/components/ | npm test, vitest | Backend, infra |
| DevOps | infra/, .github/, Dockerfile | docker, terraform plan | src/, apply, push |
| QA | tests/ | npm test, pytest, playwright | src/, infra/ |

---

## Criterios de Completitud

- [ ] settings.json compartido creado
- [ ] 4 settings.local.json creados (uno por rol)
- [ ] Verificado allow funciona para cada rol
- [ ] Verificado deny bloquea para cada rol
- [ ] Documento de política creado
