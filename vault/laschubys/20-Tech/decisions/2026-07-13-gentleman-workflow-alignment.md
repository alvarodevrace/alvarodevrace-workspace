# 2026-07-13 — Alineación con Gentleman Programming

## Contexto

Álvaro pidió auditar la infra/workflow de Las Chubys contra los repos de Gentleman Programming (engram, agent-teams-lite, Gentleman-Skills, Scope Rule, GGA) y mejorar todo lo que hiciera falta para tener un sistema profesional.

## Decisiones

1. **Adoptar GGA** como gate de pre-commit en front y back.
   - Provider: `github:gpt-4o-mini` vía GitHub Models.
   - Workaround macOS: bash 3.2 no soporta `source <(...)` usado por GGA; se instaló `bash` 5.3 vía Homebrew y se creó wrapper `~/.local/bin/gga` que invoca el script original con `/opt/homebrew/bin/bash`.
   - Hook integrado en `.husky/pre-commit` junto a `lint-staged`.

2. **Adoptar SDD** para features grandes mediante skills locales.
   - Skills creadas en `Las Chubys/.kimi/skills/sdd-*/SKILL.md`.
   - Adaptadas a Kimi Code: usan `Agent`, `AgentSwarm`, `TodoList`, `AskUserQuestion`.
   - Registradas en `vault/laschubys/20-Tech/SKILL-REGISTRY.md`.

3. **Habilitar auto-delete branch on merge** y limpiar ramas mergeadas.
   - `gh repo edit alvarodevrace/laschubys-app --delete-branch-on-merge`
   - `gh repo edit alvarodevrace/laschubys-api --delete-branch-on-merge`
   - Ramas mergeadas eliminadas locales y remotas.

4. **Normalizar ritual Engram → vault**.
   - Añadido al flujo de cierre de `agents/KIMI-AGENTS.md`.
   - Añadido a `LasChubys-Front/AGENTS.md` y `LasChubys-Back/AGENTS.md`.
   - La config MCP de Engram sigue en `~/.kimi-code/mcp.json` (gitignored por política de no versionar config local).

## Estado

- ✅ GGA instalado y configurado en front/back.
- ✅ Skills SDD locales creadas y registradas.
- ✅ Git hygiene aplicado.
- ✅ Ritual Engram → vault documentado.

## Ramas de trabajo

- Workspace: `feature/LCH-gentleman-workspace`
- Frontend: `feature/LCH-gentleman-frontend`
- Backend: `feature/LCH-gentleman-backend`

## Próximos pasos

- Fase 2: migrar `LasChubys-Front` y `LasChubys-Back` a git worktrees sobre un bare repo.
- Validar GGA en el próximo commit real con archivos de código.
- Validar flujo SDD en la próxima feature grande.
- Evaluar si añadir skills de `Gentleman-Skills` (ej. `github-pr`) sin duplicar las existentes.
