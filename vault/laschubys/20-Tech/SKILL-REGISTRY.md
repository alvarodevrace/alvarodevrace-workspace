# Skill Registry — Las Chubys

> Índice de skills que Kimi Code debe cargar según el tipo de tarea en Las Chubys.
> Ubicación global de skills: `~/.kimi-code/skills/`
> Ubicación local de skills: `Las Chubys/.kimi/skills/`
> Los nombres deben coincidir exactamente con el nombre de archivo del skill (sin `.md`).

## Agentes y skills por defecto

### KIMI-TRIN (orquestación / infra)
- `kimi-token-optimizer`
- `kimi-sre-runbook`
- `kimi-coolify-debugging`
- `kimi-csrf-csp-hardening`
- `kimi-supabase-types-sync`
- `kimi-vault-lint`
- `kimi-n8n-incident-router`
- `sdd-orchestrator` (local) — feature grande / cambio cross-layer
- `sdd-explore` (local)
- `sdd-propose` (local)
- `sdd-spec` (local)
- `sdd-design` (local)
- `sdd-tasks` (local)
- `sdd-apply` (local)
- `sdd-verify` (local)
- `sdd-archive` (local)

### KIMI-PIXEL (Angular + NestJS)
- `kimi-angular-admin-demo-hardening`
- `kimi-angular-senior`
- `kimi-async-loading-fail-safe`
- `kimi-mutation-idempotency-guard`
- `kimi-nestjs-senior`
- `kimi-crawl4ai-design-scraper` (solo para tareas de UI/scraping)

### KIMI-LINK (n8n)
- `kimi-link-n8n-master`
- `kimi-n8n-workflow-patterns`
- `kimi-n8n-node-safety`
- `kimi-n8n-expression-syntax`
- `kimi-n8n-execution-debugger`
- `kimi-n8n-incident-router`

### KIMI-NOVA (QA)
- `kimi-playwright-e2e-angular`
- `kimi-supabase-contract-verifier`
- `kimi-agent-qa-gate`
- `superpowers-verification-before-completion`

### KIMI-EVA (docs/vault)
- `kimi-vault-ingest`
- `kimi-vault-lint`
- `kimi-vault-writing-guide`

### KIMI-AURA (UI)
- `kimi-figma-extraction`
- `kimi-crawl4ai-design-scraper`

## Triggers por tipo de tarea

| Tarea | Skills a cargar |
|---|---|
| Nuevo componente Angular | `kimi-angular-senior`, `kimi-async-loading-fail-safe` |
| Formulario con async | `kimi-angular-senior`, `kimi-async-loading-fail-safe`, `kimi-mutation-idempotency-guard` |
| Endpoint NestJS nuevo | `kimi-nestjs-senior`, `kimi-supabase-contract-verifier` |
| Cambio RLS/RPC/Auth | `kimi-csrf-csp-hardening`, `kimi-supabase-contract-verifier`, `kimi-sre-runbook` |
| Workflow n8n nuevo | `kimi-link-n8n-master`, `kimi-n8n-workflow-patterns`, `kimi-n8n-node-safety`, `kimi-n8n-expression-syntax` |
| PR a main (front) | `superpowers-verification-before-completion`, `kimi-angular-admin-demo-hardening` |
| PR a main (back) | `superpowers-verification-before-completion`, `kimi-nestjs-senior` |
| Incidente post-deploy | `kimi-sre-runbook`, `kimi-n8n-incident-router` |
| Actualización de vault | `kimi-vault-ingest`, `kimi-vault-lint`, `kimi-vault-writing-guide` |
| Feature grande / cambio cross-layer | `sdd-orchestrator`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive` |

## Cómo usar este registro

Al iniciar una sesión en Las Chubys, TRIN lee este archivo y decide qué agente/skills activar.
Si la tarea no está en la tabla, TRIN elige los skills más cercanos y justifica la elección.
Todos los nombres de skill deben existir como archivos `.md` en `~/.kimi-code/skills/` o en `Las Chubys/.kimi/skills/` según su scope.
