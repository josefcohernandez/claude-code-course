---
name: conventional-commits-con-scope
description: Regla de equipo para mensajes de commit con scope obligatorio
type: feedback
---

Usar siempre Conventional Commits con scope obligatorio.

**Why:** El changelog se genera automaticamente y pierde valor cuando los commits no indican
el modulo afectado.

**How to apply:** Preferir formatos como `feat(auth): ...`, `fix(payments): ...` o
`docs(api): ...`. Para cambios transversales usar `chore(...)` o `refactor(...)`.
