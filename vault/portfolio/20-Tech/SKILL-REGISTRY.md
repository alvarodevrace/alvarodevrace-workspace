# Skill Registry — Portfolio

> Índice de skills que Kimi Code debe cargar según el tipo de tarea en Portfolio.
> Ubicación global de skills: `~/.kimi-code/skills/`

## Stack

- Angular 18 (objetivo migrar a 21).
- TypeScript 5.5.
- GSAP.
- Karma/Jasmine.

## Agentes y skills por defecto

### KIMI-PIXEL (Angular)
- `kimi-angular-admin-demo-hardening`
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
| Migración Angular 18 → 21 | `angular/core`, `angular/architecture`, `angular-admin-demo-hardening` |
| Nueva sección / componente | `angular/core`, `crawl4ai-design-scraper` (si hay referencia visual) |
| Animación GSAP | Ningún skill específico; seguir mejores prácticas del proyecto |
| Deploy / CI | `verification-before-completion`, `sre-runbook` |
| Replicar diseño externo | `crawl4ai-design-scraper`, `figma-extraction` |

## Notas especiales

- Portfolio está en Angular 18; no aplicar reglas de Angular 21 que rompan compatibilidad hasta completar la migración.
- Antes de cualquier deploy, ejecutar: `npm run build` (no hay tests/typecheck actualmente; el objetivo es agregarlos).
