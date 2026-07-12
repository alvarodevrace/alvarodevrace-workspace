# Skill Registry — Portfolio

> Índice de skills que Kimi Code debe cargar según el tipo de tarea en Portfolio.
> Ubicación global de skills: `~/.kimi-code/skills/`
> Los nombres deben coincidir exactamente con el nombre de archivo del skill (sin `.md`).

## Stack

- Angular 18 (objetivo migrar a 21).
- TypeScript 5.5.
- GSAP.
- Karma/Jasmine (configuración pendiente; actualmente no hay tests ejecutables).

## Agentes y skills por defecto

### KIMI-PIXEL (Angular)
- `kimi-angular-admin-demo-hardening`
- `kimi-angular-senior`
- `kimi-async-loading-fail-safe`
- `kimi-crawl4ai-design-scraper` (para replicar diseños de referencia)

### KIMI-AURA (UI)
- `kimi-figma-extraction`
- `kimi-crawl4ai-design-scraper`

### KIMI-NOVA (QA)
- `superpowers-verification-before-completion`

### KIMI-TRIN (infra/deploy)
- `kimi-token-optimizer`
- `kimi-sre-runbook`
- `kimi-coolify-debugging`

## Triggers por tipo de tarea

| Tarea | Skills a cargar |
|---|---|
| Migración Angular 18 → 21 | `kimi-angular-senior`, `kimi-angular-admin-demo-hardening` |
| Nueva sección / componente | `kimi-angular-senior`, `kimi-crawl4ai-design-scraper` (si hay referencia visual) |
| Animación GSAP | Ningún skill específico; seguir mejores prácticas del proyecto |
| Deploy / CI | `superpowers-verification-before-completion`, `kimi-sre-runbook` |
| Replicar diseño externo | `kimi-crawl4ai-design-scraper`, `kimi-figma-extraction` |

## Notas especiales

- Portfolio está en Angular 18; no aplicar reglas de Angular 21 que rompan compatibilidad hasta completar la migración.
- Antes de cualquier deploy, ejecutar: `npm run build` (no hay tests/typecheck ejecutables actualmente; el objetivo es agregarlos).

## Cómo usar este registro

Al iniciar una sesión en Portfolio, TRIN lee este archivo y decide qué agente/skills activar.
Si la tarea no está en la tabla, TRIN elige los skills más cercanos y justifica la elección.
