# Skill Registry — Las Chubys

> Índice de skills que Kimi Code debe cargar según el tipo de tarea en Las Chubys.
> Ubicación global de skills: `~/.kimi-code/skills/`

## Agentes y skills por defecto

### KIMI-TRIN (orquestación / infra)
- `kimi-token-optimizer`
- `kimi-sre-runbook`
- `kimi-coolify-debugging`
- `kimi-csrf-csp-hardening`
- `kimi-supabase-types-sync`
- `kimi-vault-lint`

### KIMI-PIXEL (Angular + NestJS)
- `kimi-angular-admin-demo-hardening`
- `kimi-async-loading-fail-safe`
- `kimi-mutation-idempotency-guard`
- `kimi-nestjs-senior`
- `kimi-crawl4ai-design-scraper` (solo para tareas de UI/scraping)

### KIMI-LINK (n8n)
- `kimi-n8n-workflow-patterns`
- `kimi-n8n-node-safety`
- `kimi-n8n-expression-syntax`
- `kimi-n8n-execution-debugger`

### KIMI-NOVA (QA)
- `kimi-playwright-e2e-angular`
- `kimi-supabase-contract-verifier`
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
| Nuevo componente Angular | `angular/core`, `angular/architecture` (de Gentleman-Skills adaptados), `async-loading-fail-safe` |
| Formulario con async | `angular/forms`, `async-loading-fail-safe`, `mutation-idempotency-guard` |
| Endpoint NestJS nuevo | `nestjs-senior`, `supabase-contract-verifier` |
| Cambio RLS/RPC/Auth | `csrf-csp-hardening`, `supabase-contract-verifier`, `sre-runbook` |
| Workflow n8n nuevo | `n8n-workflow-patterns`, `n8n-node-safety`, `n8n-expression-syntax` |
| PR a main | `verification-before-completion`, `angular-admin-demo-hardening` (front) o `nestjs-senior` (back) |
| Incidente post-deploy | `sre-runbook`, `n8n-incident-router` |
| Actualización de vault | `vault-ingest`, `vault-lint`, `vault-writing-guide` |

## Cómo usar este registro

Al iniciar una sesión en Las Chubys, TRIN lee este archivo y decide qué agente/skills activar.
Si la tarea no está en la tabla, TRIN elige los skills más cercanos y justifica la elección.
