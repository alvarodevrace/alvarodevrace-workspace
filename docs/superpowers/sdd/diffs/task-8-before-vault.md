# KIMI-SKILLS-MASTER — Catálogo Maestro de Skills

> **Fuente de verdad:** skills disponibles para KIMICO y subagentes del enjambre.
> **Vigente:** 2026-06-11
> **Scope:** User skills en `~/.kimi-code/skills/` + skills locales de proyectos.

---

## 1. Propósito

Este archivo es el catálogo único de capacidades que Kimico (TRIN) debe inyectar a los subagentes del swarm según su rol. Ningún subagente debe trabajar sin las skills de su área cargadas en su prompt.

---

## 2. Skills de Usuario — `~/.kimi-code/skills/`

Todas disponibles automáticamente para Kimico. Se invocan por nombre (`kimi-<nombre>`).

### 2.1 KIMI-TRIN (Orquestador / Infra / CRM)

| Skill | Archivo | Uso |
|---|---|---|
| `adr-record` | `kimi-adr-record.md` | Crear ADR en `vault/<proyecto>/20-Tech/ADR/`. |
| `blocker-escalate` | `kimi-blocker-escalate.md` | Protocolo de desbloqueo de agentes. |
| `csrf-csp-hardening` | `kimi-csrf-csp-hardening.md` | Hardening de CSP + CSRF fullstack. |
| `daily-status` | `kimi-daily-status.md` | Standup diario global. |
| `dependency-audit` | `kimi-dependency-audit.md` | Mapear blast radius cross-layer. |
| `infra-triage` | `kimi-infra-triage.md` | Triage de incidentes sin owner. |
| `issue-router` | `kimi-issue-router.md` | Decidir dueño de tarea. |
| `n8n-change-safety` | `kimi-n8n-change-safety.md` | Intervención de emergencia en n8n. |
| `n8n-incident-router` | `kimi-n8n-incident-router.md` | Clasificar incidentes n8n vs otros bordes. |
| `observability-check` | `kimi-observability-check.md` | Auditar monitoreo post-deploy. |
| `planka-workflow` | `kimi-planka-workflow.md` | Gestión de tickets Planka. |
| `post-mortem` | `kimi-post-mortem.md` | Retrospectiva post-incidente. |
| `release-orchestrator` | `kimi-release-orchestrator.md` | Checklist de release y deploy. |
| `security-review` | `kimi-security-review.md` | Auditoría trimestral de seguridad. |
| `security-rotator` | `kimi-security-rotator.md` | Rotación de secretos. |
| `sprint-review` | `kimi-sprint-review.md` | Cierre de sprint semanal. |
| `sre-runbook` | `kimi-sre-runbook.md` | Playbooks operativos de incidentes. |
| `start-of-day` | `kimi-start-of-day.md` | Ritual de boot de sesión. |
| `supabase-contract-verifier` | `kimi-supabase-contract-verifier.md` | Verificar schema real antes de código. |
| `supabase-qa` | `kimi-supabase-qa.md` | Checklist de seguridad antes de SQL/schema. |
| `supabase-schema-governor` | `kimi-supabase-schema-governor.md` | Gobernanza de migraciones Supabase. |
| `supabase-types-sync` | `kimi-supabase-types-sync.md` | Sync de tipos Supabase ↔ TypeScript. |
| `team-handoff` | `kimi-team-handoff.md` | Protocolo de traspaso entre agentes. |
| `tech-debt-tracker` | `kimi-tech-debt-tracker.md` | Descubrir y priorizar deuda técnica. |
| `token-optimizer` | `kimi-token-optimizer.md` | Reglas de eficiencia de contexto. |
| `context-sync` | `kimi-context-sync.md` | Sincronizar vault Karpathy y HANDOFF.md. |

### 2.2 KIMI-PIXEL (Fullstack / Mobile)

| Skill | Archivo | Uso |
|---|---|---|
| `angular-admin-demo-hardening` | `kimi-angular-admin-demo-hardening.md` | Pre-commit hardening Angular 21. |
| `angular-senior` | `kimi-angular-senior.md` | Patrones Angular 19/20/21. |
| `angular-ssr-security` | `kimi-angular-ssr-security.md` | Checklist seguridad Angular SSR. |
| `astro-senior` | `kimi-astro-senior.md` | Patrones Astro 5. |
| `async-loading-fail-safe` | `kimi-async-loading-fail-safe.md` | Async loading seguro en Angular. |
| `crawl4ai-design-scraper` | `kimi-crawl4ai-design-scraper.md` | Scrapear diseños para replicar en Angular. |
| `mutation-idempotency-guard` | `kimi-mutation-idempotency-guard.md` | Prevenir doble-submit y mutaciones duplicadas. |
| `nestjs-security-hardening` | `kimi-nestjs-security-hardening.md` | Checklist seguridad NestJS. |
| `nestjs-senior` | `kimi-nestjs-senior.md` | Patrones NestJS 11 para BFFs. |

### 2.3 KIMI-LINK (n8n Automation)

| Skill | Archivo | Uso |
|---|---|---|
| `link-n8n-master` | `kimi-link-n8n-master.md` | Skill maestra de n8n. |
| `n8n-code-javascript` | `kimi-n8n-code-javascript.md` | JS en nodos Code. |
| `n8n-code-python` | `kimi-n8n-code-python.md` | Python en nodos Code. |
| `n8n-execution-debugger` | `kimi-n8n-execution-debugger.md` | Debug de ejecuciones fallidas. |
| `n8n-expression-syntax` | `kimi-n8n-expression-syntax.md` | Sintaxis de expresiones n8n. |
| `n8n-mcp-tools-expert` | `kimi-n8n-mcp-tools-expert.md` | Uso de herramientas MCP de n8n. |
| `n8n-node-configuration` | `kimi-n8n-node-configuration.md` | Configuración de nodos. |
| `n8n-node-safety` | `kimi-n8n-node-safety.md` | Patrones seguros de nodos n8n. |
| `n8n-validation-expert` | `kimi-n8n-validation-expert.md` | Interpretar errores de validación. |
| `n8n-workflow-patterns` | `kimi-n8n-workflow-patterns.md` | Patrones arquitectónicos de workflows. |

### 2.4 KIMI-NOVA (QA & Testing)

| Skill | Archivo | Uso |
|---|---|---|
| `agent-qa-gate` | `kimi-agent-qa-gate.md` | Gate de calidad antes de Done. |
| `playwright-e2e-angular` | `kimi-playwright-e2e-angular.md` | E2E con Playwright + Angular SSR. |

### 2.5 KIMI-EVA (Docs & Intelligence)

| Skill | Archivo | Uso |
|---|---|---|
| `context-sync` | `kimi-context-sync.md` | Sincronizar vault y HANDOFF.md. |

### 2.6 KIMI-AURA (UI Design)

| Skill | Archivo | Uso |
|---|---|---|
| `crawl4ai-design-scraper` | `kimi-crawl4ai-design-scraper.md` | Scrapear diseños de referencia. |
| `figma-extraction` | `kimi-figma-extraction.md` | Extraer diseños/tokens/assets de Figma. |

### 2.7 Genéricas / Cross-agente

| Skill | Archivo | Uso |
|---|---|---|
| `supabase-contract-verifier` | `kimi-supabase-contract-verifier.md` | Usada por NOVA para validar cambios PIXEL. |
| `sre-runbook` | `kimi-sre-runbook.md` | Cualquier agente puede consultar en incidentes. |

---

## 3. Skills Locales de Proyectos

No están en `~/.kimi-code/skills/`; residen dentro de cada proyecto. Se deben leer directamente cuando el subagente trabaje en ese proyecto.

> **JauriaCrossfit y Agrovivas fueron eliminados del workspace en 2026-06-25.** Sus skills locales ya no aplican.

### 3.1 Portfolio

| Skill | Path | Agente | Uso |
|---|---|---|---|
| `ui-ux-pro-max` | `Portfolio/.kimi/skills/ui-ux-pro-max/SKILL.md` | AURA | Guía UI/UX Portfolio. |

---

## 4. Reglas de Inyección a Subagentes (Swarm)

Cuando Kimico cree un subagente, debe incluir en su prompt inicial:

### 4.1 Prompt mínimo de activación

```
Eres <AGENTE>. Operas en el proyecto <PROYECTO>.
Lee tu rol en `agents/kimi/<AGENTE>.md` y este catálogo.
Skills activas para esta tarea: <lista de skills por nombre>.
Todas las skills están en `~/.kimi-code/skills/kimi-<nombre>.md`.
Si el proyecto tiene skills locales, léelas de `<proyecto>/.kimi/skills/`.
Modo ultra-directo. Solo español. Reporta a Kimico.
```

### 4.2 Skills por defecto por agente

| Agente | Skills base a inyectar siempre |
|---|---|
| **KIMI-TRIN** | `token-optimizer`, `start-of-day`, `sre-runbook`, `issue-router`, `infra-triage`, `release-orchestrator`, `observability-check`, `security-review`, `csrf-csp-hardening` |
| **KIMI-PIXEL** | `angular-admin-demo-hardening`, `angular-senior`, `angular-ssr-security`, `async-loading-fail-safe`, `mutation-idempotency-guard`, `nestjs-security-hardening`, `nestjs-senior`, `crawl4ai-design-scraper` |
| **KIMI-LINK** | `link-n8n-master`, `n8n-node-safety`, `n8n-workflow-patterns`, `n8n-execution-debugger`, `n8n-expression-syntax`, `n8n-code-javascript`, `n8n-code-python`, `n8n-node-configuration`, `n8n-validation-expert`, `n8n-mcp-tools-expert` |
| **KIMI-NOVA** | `agent-qa-gate`, `playwright-e2e-angular`, `supabase-contract-verifier` |
| **KIMI-EVA** | `context-sync`, `token-optimizer` |
| **KIMI-AURA** | `crawl4ai-design-scraper`, `figma-extraction` |

### 4.3 Skills adicionales por tipo de tarea

| Tarea | Skills a añadir |
|---|---|
| Deploy / rollback | `release-orchestrator`, `observability-check` |
| Incidente cross-layer | `sre-runbook`, `infra-triage`, `n8n-incident-router`, `blocker-escalate` |
| Cambio Supabase schema | `supabase-schema-governor`, `supabase-qa`, `supabase-types-sync`, `supabase-contract-verifier` |
| UI nuevo desde cero | `figma-extraction` (AURA), `crawl4ai-design-scraper` (AURA), luego `angular-admin-demo-hardening` (PIXEL) |
| PR develop → main | `agent-qa-gate` (llamar a NOVA), `release-orchestrator` |
| Rotación de secretos | `security-rotator`, `security-review` |

---

## 5. Resolución de Conflictos

- Si una skill existe tanto en User scope (`~/.kimi-code/skills/`) como en proyecto local, **gana la local** para ese proyecto.
- Si dos skills parecen solaparse (ej. `angular-senior` y `angular-admin-demo-hardening`), usar ambas: `angular-senior` para patrones generales, `angular-admin-demo-hardening` para checklist pre-cierre.
- Si una skill no aparece en este catálogo, no se inyecta a subagentes hasta que Kimico la revise y registre.

---

## 6. Skills No Registradas / Obsoletas

No usar:
- `CLAUDE.md.OBSOLETO`
- `ANTIGRAVITY.md.OBSOLETO`
- `agents/AGENTS.md.OBSOLETO`
- `system/STATE.md`
- `system/MEMORY.md`
- `agents/legacy/`
- `kimi-coolify-debugging.md` / `kimi-coolify-manager.md` — obsoletas tras migración Coolify → Dokploy (2026-06-25). Usar soporte Dokploy directo.

---

## 7. Regla de Skills Nuevas (Memoria Viva)

**Si un agente descubre, consulta o necesita una skill que no existe aún → debe crearla inmediatamente.**

### Proceso
1. **Detectar gap:** patrón recurrente, bug nuevo, proceso operativo no documentado, pregunta repetida.
2. **Decidir scope:**
   - **Global** (varios proyectos/agentes) → `~/.kimi-code/skills/kimi-<nombre>.md`
   - **Local** (un proyecto) → `<proyecto>/.kimi/skills/<nombre>/SKILL.md` o `<proyecto>/.kimi/skills/<nombre>.md`
3. **Escribir skill:** instrucciones claras, ejemplos, anti-patrones, cuándo usar.
4. **Registrar:** añadir a este catálogo y a `~/.kimi-code/skills/kimi-all-skills-catalog.md`.
5. **Asignar agente:** decidir quién la usa (TRIN, PIXEL, LINK, NOVA, EVA, AURA).
6. **Reportar:** al cerrar sesión, incluir *"Skill creada: `<nombre>` → agente `<X>`"* en el dump.

### Principios
- Una skill = un conocimiento accionable.
- Nunca dejar un aprendizaje nuevo solo en memoria de sesión.
- El catálogo de skills nunca está terminado.

## 8. Mantenimiento

Cada vez que se cree una skill nueva en `~/.kimi-code/skills/` o `<proyecto>/.kimi/skills/`, se debe:
1. Añadir a este catálogo y a `kimi-all-skills-catalog.md`.
2. Asignar agente owner.
3. Actualizar la sección de inyección si aplica.
4. Notificar a Álvaro en el cierre de sesión.
