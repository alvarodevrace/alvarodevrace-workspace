# Sistema Agentico v2 — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fortalecer el control profesional del flujo de trabajo entre Kimi Code, los agentes KIMI-* y Álvaro como revisor/approver final, creando AGENTS.md por proyecto, Skill Registries y memoria persistente con Engram.

**Architecture:** Configuración declarativa por proyecto (AGENTS.md + Skill Registry) que complementa `KIMI.md` y `agents/KIMI-AGENTS.md`, más una capa de memoria persistente (Engram MCP) para que el contexto sobreviva entre sesiones.

**Tech Stack:** Markdown, Git, Kimi Code CLI, Engram (Go binary + SQLite), vault/Obsidian.

## Global Constraints

- Todo en español.
- 0 secretos completos en archivos `.md`.
- Nunca push directo a `main` ni `develop`.
- KIMI-TRIN nunca aprueba su propio PR.
- Todo cambio pasa por Álvaro como approver final.
- La fuente de verdad es `KIMI.md` + `agents/KIMI-AGENTS.md` + `vault/*/00-Index/INDEX.md`.
- Los skills viven en `~/.kimi-code/skills/` y, si son propios del proyecto, en `.kimi/skills/`.

---

### Task 1: Crear `LasChubys-Front/AGENTS.md`

**Files:**
- Create: `Las Chubys/LasChubys-Front/AGENTS.md`
- Read: `KIMI.md`, `agents/KIMI-AGENTS.md`

**Interfaces:**
- Consumes: reglas globales de `KIMI.md` y `agents/KIMI-AGENTS.md`.
- Produces: instrucciones de proyecto que Kimi Code lee automáticamente al operar en `LasChubys-Front`.

- [ ] **Step 1: Escribir `LasChubys-Front/AGENTS.md`**

```markdown
# AGENTS.md — Las Chubys Frontend

> Instrucciones de proyecto para Kimi Code operando en `LasChubys-Front`.
> Lee siempre `KIMI.md` y `agents/KIMI-AGENTS.md` antes de este archivo.

## Proyecto

| Campo | Valor |
|---|---|
| Nombre | Las Chubys — Frontend |
| Repo | https://github.com/alvarodevrace/laschubys-app |
| Stack | Angular 21 SSR, Tailwind CSS 4, Spartan NG, Lucide Angular, Motion, Sentry |
| Package manager | Bun 1.3.14 |
| Rama default | `develop` |

## Agentes que operan aquí

| Agente | Rol en este proyecto |
|---|---|
| KIMI-PIXEL | Dueño del código Angular. Implementa features, corrige bugs, optimiza performance. |
| KIMI-AURA | Diseña shells visuales nuevos en Figma → Angular. Nunca escribe lógica de negocio. |
| KIMI-NOVA | QA: Playwright, Lighthouse, typecheck, build. Nunca modifica código productivo. |

## Stack y convenciones técnicas

- Angular 21 con SSR (`@angular/ssr`).
- Componentes standalone por defecto. No usar NgModules.
- Signals para estado; `input()` / `output()` functions; `inject()` para DI.
- Zoneless: `provideZonelessChangeDetection()`; no usar `zone.js`.
- Control flow nativo: `@if`, `@for`, `@switch`.
- OnPush obligatorio en componentes.
- No lifecycle hooks (`ngOnInit`, `ngOnChanges`, `ngOnDestroy`). Usar `effect()` + `DestroyRef`.
- Spartan NG para componentes de UI base.
- Tailwind CSS 4 para estilos.
- Estructura actual:
  ```
  src/app/
    core/           # auth, config, content, models, services globales
    features/       # una carpeta por feature: admin, auth, blog, cart, checkout, home, linktree, media-kit, placeholder, shop, static
    shared/         # animations, components, services, shell, ui
  ```
- Scope Rule: código usado por 2+ features vive en `shared/`; lo demás queda en su feature.

## Scripts obligatorios antes de entregar

```bash
bun run typecheck
bun run test:ci
bun run build
```

## Flujo Git (LEY DE RAMAS)

```
rama feature (feature/LCH-N-nombre) → commits locales → build OK → merge local a develop
→ avisa a TRIN: "listo en develop local — rama: feature/LCH-N-nombre"
→ TRIN push develop → llama a NOVA → PR develop → main → Álvaro aprueba → deploy Dokploy
```

- Nunca push directo a `main` ni `develop`.
- Nombres de rama: `feature/LCH-N-nombre-corto`.
- Commits en español, descriptivos, preferiblemente conventional commits.

## Reglas de frontera

- PIXEL no mergea su propio PR sin QA de NOVA.
- AURA entrega shells listos para que PIXEL integre la lógica.
- NOVA solo reporta; si encuentra bug, crea ticket/comentario y asigna a PIXEL.
- No instalar dependencias sin justificar y sin actualizar `bun.lockb`.

## Memoria del proyecto

- Decisiones técnicas: `vault/laschubys/20-Tech/decisions/`.
- Especificaciones de producto: `vault/laschubys/30-Product/specs/`.
- Log diario: `vault/laschubys/10-Log/LOG.md`.
```

- [ ] **Step 2: Verificar que el archivo se creó correctamente**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
ls -la AGENTS.md
```

Expected: archivo existe con el contenido anterior.

- [ ] **Step 3: Commit del archivo**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git add AGENTS.md
git commit -m "docs: agrega AGENTS.md para LasChubys-Front"
```

---

### Task 2: Crear `LasChubys-Back/AGENTS.md`

**Files:**
- Create: `Las Chubys/LasChubys-Back/AGENTS.md`
- Read: `KIMI.md`, `agents/KIMI-AGENTS.md`

**Interfaces:**
- Consumes: reglas globales de `KIMI.md` y `agents/KIMI-AGENTS.md`.
- Produces: instrucciones de proyecto que Kimi Code lee automáticamente al operar en `LasChubys-Back`.

- [ ] **Step 1: Escribir `LasChubys-Back/AGENTS.md`**

```markdown
# AGENTS.md — Las Chubys Backend

> Instrucciones de proyecto para Kimi Code operando en `LasChubys-Back`.
> Lee siempre `KIMI.md` y `agents/KIMI-AGENTS.md` antes de este archivo.

## Proyecto

| Campo | Valor |
|---|---|
| Nombre | Las Chubys — Backend |
| Repo | https://github.com/alvarodevrace/laschubys-api |
| Stack | NestJS 11, Supabase (Postgres 15), JWT, class-validator, cache-manager, throttler, helmet, Sentry |
| Package manager | Bun |
| Rama default | `develop` |

## Agentes que operan aquí

| Agente | Rol en este proyecto |
|---|---|
| KIMI-PIXEL | Dueño del código NestJS. Implementa módulos, servicios, DTOs, guards. |
| KIMI-LINK | Integra workflows de n8n cuando el backend expone webhooks o consume APIs. |
| KIMI-NOVA | QA: tests unitarios/e2e, typecheck, build. Nunca modifica código productivo. |

## Stack y convenciones técnicas

- NestJS 11 con Fastify adapter si está configurado; de lo contrario, seguir el adapter actual.
- Módulos por dominio bajo `src/modules/`.
- DTOs con `class-validator` + `class-transformer`.
- Guards JWT para rutas protegidas.
- Interceptores para logging/errores.
- Servicio de Supabase con service role key solo en backend; nunca exponer al frontend.
- Estructura actual:
  ```
  src/
    modules/     # admin, auth, checkout, comments, contact, content, health, supabase
    shared/      # config, csrf, http, types
  ```
- No lógica de negocio en controllers; controllers delegan a services.
- Manejo de errores centralizado; no devolver stack traces en producción.

## Scripts obligatorios antes de entregar

```bash
bun run typecheck
bun run test
bun run build
```

## Flujo Git (LEY DE RAMAS)

```
rama feature (feature/LCH-N-nombre) → commits locales → build/test OK → merge local a develop
→ avisa a TRIN: "listo en develop local — rama: feature/LCH-N-nombre"
→ TRIN push develop → llama a NOVA → PR develop → main → Álvaro aprueba → deploy Dokploy
```

- Nunca push directo a `main` ni `develop`.
- Nombres de rama: `feature/LCH-N-nombre-corto`.

## Reglas de frontera

- PIXEL no modifica schema de Supabase sin seguir `Protocol RX` de `agents/KIMI-AGENTS.md`.
- LINK no toca lógica de negocio; solo integraciones n8n/webhooks.
- NOVA solo reporta; si encuentra bug, crea ticket/comentario y asigna a PIXEL.
- Cambios RLS/RPC críticos requieren pre-mortem y aprobación de TRIN/Álvaro.

## Memoria del proyecto

- Decisiones técnicas: `vault/laschubys/20-Tech/decisions/`.
- Especificaciones de producto: `vault/laschubys/30-Product/specs/`.
- Log diario: `vault/laschubys/10-Log/LOG.md`.
```

- [ ] **Step 2: Verificar que el archivo se creó correctamente**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
ls -la AGENTS.md
```

Expected: archivo existe con el contenido anterior.

- [ ] **Step 3: Commit del archivo**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
git add AGENTS.md
git commit -m "docs: agrega AGENTS.md para LasChubys-Back"
```

---

### Task 3: Crear `vault/laschubys/20-Tech/SKILL-REGISTRY.md`

**Files:**
- Create: `vault/laschubys/20-Tech/SKILL-REGISTRY.md`
- Read: `agents/KIMI-AGENTS.md`, `KIMI-MASTER-SKILLS.md` o `kimi-all-skills-catalog.md`

**Interfaces:**
- Consumes: lista de skills disponibles en `~/.kimi-code/skills/`.
- Produces: índice de skills que KIMI-TRIN/PIXEL/NOVA deben cargar según el tipo de tarea.

- [ ] **Step 1: Escribir `vault/laschubys/20-Tech/SKILL-REGISTRY.md`**

```markdown
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
```

- [ ] **Step 2: Verificar creación**

Run:
```bash
ls -la "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/vault/laschubys/20-Tech/SKILL-REGISTRY.md"
```

Expected: archivo existe.

- [ ] **Step 3: Commit en el repo del workspace**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro"
git add "vault/laschubys/20-Tech/SKILL-REGISTRY.md"
git commit -m "docs(vault): agrega Skill Registry para Las Chubys"
```

---

### Task 4: Crear `vault/portfolio/20-Tech/SKILL-REGISTRY.md`

**Files:**
- Create: `vault/portfolio/20-Tech/SKILL-REGISTRY.md`
- Read: `agents/KIMI-AGENTS.md`, `Portfolio/AGENTS.md`

**Interfaces:**
- Consumes: lista de skills disponibles en `~/.kimi-code/skills/`.
- Produces: índice de skills para operar en Portfolio.

- [ ] **Step 1: Escribir `vault/portfolio/20-Tech/SKILL-REGISTRY.md`**

```markdown
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
```

- [ ] **Step 2: Verificar creación**

Run:
```bash
ls -la "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/vault/portfolio/20-Tech/SKILL-REGISTRY.md"
```

Expected: archivo existe.

- [ ] **Step 3: Commit en el repo del workspace**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro"
git add "vault/portfolio/20-Tech/SKILL-REGISTRY.md"
git commit -m "docs(vault): agrega Skill Registry para Portfolio"
```

---

### Task 5: Probar Engram como memoria persistente

**Files:**
- Create: `vault/laschubys/20-Tech/decisions/2026-07-12-engram-poc.md`
- Modify: posiblemente `~/.kimi/mcp.json` o equivalente de Kimi Code

**Interfaces:**
- Consumes: binario `engram`, Kimi Code MCP config.
- Produces: nota de decisión sobre si Engram funciona con Kimi Code.

- [ ] **Step 1: Instalar Engram**

Run:
```bash
brew install gentleman-programming/tap/engram
```

Expected: `engram --version` devuelve una versión.

- [ ] **Step 2: Verificar salud de Engram**

Run:
```bash
engram doctor
```

Expected: salida indica que el entorno está OK (o lista problemas reparables).

- [ ] **Step 3: Intentar configurar Engram con Kimi Code**

Run:
```bash
engram setup
```

Si la lista incluye Kimi Code, seleccionarlo. Si no, investigar la ruta de config MCP de Kimi Code (típicamente `~/.kimi/mcp.json` o similar) y agregar manualmente:

```json
{
  "mcpServers": {
    "engram": {
      "command": "engram",
      "args": ["mcp"]
    }
  }
}
```

- [ ] **Step 4: Verificar que Kimi Code carga Engram**

Reiniciar Kimi Code (si es posible) o recargar MCP. Ejecutar:

```bash
engram projects list
```

Luego, dentro de una sesión de Kimi Code en `LasChubys-Front`, pedir: "guarda en memoria que estamos usando Angular 21 SSR con Spartan NG".

Expected: Engram responde con confirmación de guardado.

- [ ] **Step 5: Verificar memoria persistente**

Cerrar la sesión de Kimi Code, abrir una nueva en el mismo proyecto y preguntar: "¿qué framework de UI usamos en Las Chubys?".

Expected: El agente recupera la memoria guardada.

- [ ] **Step 6: Documentar resultado en vault**

Escribir `vault/laschubys/20-Tech/decisions/2026-07-12-engram-poc.md`:

```markdown
# PoC Engram como memoria persistente

## Contexto
Se evaluó Engram (https://github.com/Gentleman-Programming/engram) como sistema de memoria persistente para Kimi Code en Las Chubys.

## Decisión
[Funciona / No funciona / Requiere más trabajo]

## Cómo se configuró
1. `brew install gentleman-programming/tap/engram`
2. `engram doctor`
3. Configuración MCP: [ruta y contenido exacto]

## Problemas encontrados
- [Listar o "Ninguno"]

## Próximos pasos
- [Activar en todos los proyectos / Investigar alternativa / Desactivar]
```

- [ ] **Step 7: Commit de la nota de decisión**

Run:
```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro"
git add "vault/laschubys/20-Tech/decisions/2026-07-12-engram-poc.md"
git commit -m "docs(vault): agrega PoC de Engram como memoria persistente"
```

---

## Self-Review

1. **Spec coverage:**
   - AGENTS.md por proyecto: Task 1 y Task 2.
   - Skill Registry: Task 3 y Task 4.
   - Memoria persistente: Task 5.
   - No hay gaps.

2. **Placeholder scan:**
   - No hay `TBD`, `TODO` ni pasos sin contenido concreto.
   - El Step 3 de Engram tiene una alternativa manual por si Kimi Code no está en la lista oficial de `engram setup`.

3. **Type consistency:**
   - Las rutas de archivos son consistentes entre tasks.
   - No hay firmas de funciones que deban coincidir (es configuración en Markdown).
