# Skill Registry — AlvaroDevRace Workspace

> Índice de skills que Kimi Code debe cargar según el tipo de tarea en el workspace raíz (`alvarodevrace-workspace`).
> Ubicación global de skills: `~/.kimi-code/skills/`

## Stack y ámbito

- Workspace raíz: rituales (`prompts/`), agentes (`agents/`), vault global (`vault/`), infra como código (`infra/tofu/`).
- Proyectos activos: Las Chubys, Portfolio.
- Herramientas: Git, GitHub Actions, Dokploy, Bitwarden, Engram MCP, Cloudflare, n8n, Supabase.

## Agentes y skills por defecto

### KIMI-TRIN (orquestación / infra / CRM)
- `kimi-token-optimizer`
- `kimi-sre-runbook`
- `kimi-coolify-debugging`
- `kimi-csrf-csp-hardening`
- `kimi-supabase-types-sync`
- `kimi-vault-lint`
- `kimi-vault-ingest`
- `kimi-vault-writing-guide`
- `superpowers-brainstorming`
- `superpowers-writing-plans`
- `superpowers-subagent-driven-development`
- `superpowers-verification-before-completion`

### KIMI-EVA (docs / vault)
- `kimi-vault-ingest`
- `kimi-vault-lint`
- `kimi-vault-writing-guide`

### KIMI-LINK (n8n / automatizaciones)
- `kimi-n8n-workflow-patterns`
- `kimi-n8n-node-safety`
- `kimi-n8n-expression-syntax`
- `kimi-n8n-execution-debugger`
- `kimi-n8n-incident-router`

## Triggers por tipo de tarea

| Tarea | Skills a cargar |
|---|---|
| Actualizar rituales de inicio/cierre | `vault-writing-guide`, `verification-before-completion` |
| Modificar `agents/KIMI-AGENTS.md` o `KIMI.md` | `vault-writing-guide`, `verification-before-completion` |
| Infra como código (`infra/tofu/`) | `sre-runbook`, `coolify-debugging` |
| Incidente cross-proyecto | `sre-runbook`, `n8n-incident-router` |
| Actualización de vault global | `vault-lint`, `vault-writing-guide`, `vault-ingest` |
| Revisar/adaptar repo externo | `kimi-repo-evaluator` |
| PR a `main` en workspace root | `verification-before-completion`, `vault-lint` |
| Configuración de nuevo proyecto | `sre-runbook`, `vault-writing-guide`, `supabase-types-sync` |

## Memoria persistente (Engram)

- Antes de tomar decisiones arquitectónicas cross-proyecto, consultar Engram por memorias previas.
- Después de cerrar incidentes o definir procesos nuevos, guardar en Engram para que perduren entre sesiones.
- Ver convenciones completas en `vault/alvarodevrace/20-Tech/decisions/2026-07-13-engram-conventions.md`.
