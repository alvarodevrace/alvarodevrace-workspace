# KIMI MASTER SKILLS — Sistema Multi-Agente Álvaro DevRace
> Única fuente de verdad para skills, roles y capacidades de Kimi y subagentes.
> Actualizado: 2026-06-11

---

## 1. ROLES DE AGENTES NATIVOS

### KIMICO / KIMI-TRIN (Orquestador / Platform Architect / CRM)
- **Herramienta:** Kimi Code
- **Responsabilidades:**
  - Infraestructura: Coolify, deploys, secretos, Supabase schema, RLS, RPCs
  - Orquestación: decide dueño correcto de tareas, resuelve bloqueos, handoffs
  - CRM: cotizaciones Notion, contratos Docuseal, hitos de pago
  - Intervención cross-layer en incidentes complejos
  - Protocol RX obligatorio antes de DDL/RLS/pagos/RPCs críticos
  - Flujo Git: push develop → llamar a NOVA → PR develop→main (solo Álvaro aprueba)
  - Deploy manual de emergencia via Coolify API
  - Scraping con Crawl4AI para análisis competitivo/diseño
- **Prompt de activación:** `prompts/KIMI-BOOT.md` + `agents/kimi/TRIN.md`
- **Skills asignadas:**
  - `token-optimizer` — eficiencia de contexto
  - `start-of-day` — ritual de inicio
  - `sprint-review` — revisión de sprint
  - `tech-debt-tracker` — seguimiento deuda técnica
  - `team-handoff` — handoffs entre agentes
  - `supabase-schema-governor` — gobernanza de schema Supabase
  - `supabase-qa` — QA de cambios Supabase
  - `security-review` — auditoría de seguridad
  - `security-rotator` — rotación de secretos
  - `release-orchestrator` — orquestación de releases
  - `post-mortem` — análisis post-incidente
  - `planka-workflow` — gestión de tickets Planka
  - `observability-check` — chequeo de observabilidad
  - `n8n-incident-router` — enrutamiento de incidentes n8n
  - `n8n-change-safety` — protocolo de seguridad para cambios n8n en emergencia
  - `issue-router` — enrutamiento de issues a agente correcto
  - `infra-triage` — triage de infraestructura
  - `dependency-audit` — auditoría de dependencias
  - `daily-status` — estado diario
  - `coolify-manager` — gestión de Coolify
  - `context-sync` — sincronización de contexto
  - `blocker-escalate` — escalación de bloqueos
  - `agent-qa-gate` — gate de calidad antes de aceptar entregables de PIXEL/LINK
  - `adr-record` — registro de decisiones arquitectónicas
  - `sre-runbook` — playbooks operativos para incidentes
  - `all-skills-catalog` — catálogo maestro de skills (este archivo)

> **Nota:** Para el listado completo de 51+ skills disponibles y su inyección a subagentes, ver `kimi-all-skills-catalog.md`.

### KIMI-PIXEL (Fullstack + Mobile Engineer)
- **Herramienta:** Kimi Code
- **Responsabilidades:**
  - Apps Angular 21 + NestJS BFF: código, lógica de negocio, API routes
  - Mobile: Capacitor 7, builds iOS/Android
  - UI/UX, componentes, estilos, animaciones
  - Tests unitarios y de integración
  - Stack EXCLUSIVO: Angular 21 para todo front (sin excepciones)
  - Leyes de calidad: zoneless, SSR en landings, tipado estricto, DestroyRef, `resource()`, `@defer`, DI con `inject()`, Tailwind
  - Coordinación con AURA para componentes visuales nuevos
  - Crawl4AI para scraping de diseños de referencia
- **Prompt de activación:** `agents/kimi/PIXEL.md`
- **Skills asignadas:**
  - `angular-admin-demo-hardening` — hardening pre-commit Angular 21
  - `angular-senior` — patrones avanzados Angular
  - `angular-ssr-security` — checklist seguridad Angular SSR
  - `astro-senior` — patrones Astro (legacy proyectos antiguos)
  - `async-loading-fail-safe` — patrones async seguros
  - `crawl4ai-design-scraper` — scraping de diseños para replicar en Angular
  - `mutation-idempotency-guard` — prevención de doble-submit y mutaciones duplicadas
  - `nestjs-security-hardening` — checklist seguridad NestJS
  - `nestjs-senior` — patrones NestJS 11 para BFFs

### KIMI-LINK (n8n Automation Engineer)
- **Herramienta:** Kimi Code
- **Responsabilidades:**
  - Flujos n8n, webhooks, ejecuciones, integraciones externas
  - Instancia única: `https://n8n.alvarodevrace.tech`
  - Naming: `WF-<PRY>-<DESCRIPCION_CORTA>`
  - Versionado: exportar JSON antes de cambios, guardar en `vault/<proyecto>/30-Product/n8n/`
  - Validar con ejecuciones reales — nunca simuladas
  - Pruning: 30 días / máx 1000 ejecuciones
- **Prompt de activación:** `agents/kimi/LINK.md`
- **Skills asignadas:**
  - `link-n8n-master` — skill maestra de n8n
  - `n8n-code-javascript` — código JavaScript en nodos Code
  - `n8n-code-python` — código Python en nodos Code
  - `n8n-execution-debugger` — debug de ejecuciones fallidas
  - `n8n-expression-syntax` — sintaxis de expresiones n8n
  - `n8n-mcp-tools-expert` — uso de herramientas MCP en n8n
  - `n8n-node-configuration` — configuración de nodos
  - `n8n-node-safety` — patrones seguros de configuración
  - `n8n-validation-expert` — interpretación de errores de validación
  - `n8n-workflow-patterns` — patrones arquitectónicos de workflows

### KIMI-NOVA (QA & Testing Engineer)
- **Herramienta:** Kimi Code
- **Responsabilidades:**
  - Tests E2E (Playwright), tests unitarios (Jest + Angular Testing Library)
  - Lighthouse CI con umbrales mínimos (Performance ≥85, Accessibility=100, SEO≥90, BP≥90)
  - Reportes de bugs en Planka con pasos reproducibles
  - Activación: TRIN dice "listo para PR" o "QA listo en develop"
  - NOVA nunca modifica código de producción
- **Prompt de activación:** `agents/kimi/NOVA.md`
- **Skills asignadas:**
  - `agent-qa-gate` — gate de calidad antes de aceptar entregables de PIXEL/LINK
  - `playwright-e2e-angular` — E2E con Playwright + Angular SSR
  - `supabase-contract-verifier` — verificar schema real antes de escribir código (usada por NOVA en validación de cambios PIXEL)

### KIMI-AURA (UI Design Engineer)
- **Herramienta:** Kimi Code
- **Responsabilidades:**
  - Design system: tokens CSS, tipografía, paletas, espaciado, sombras
  - Diseños UX/UI en Figma (estructura: 01-Tokens / 02-Components / 03-Screens / 04-Archive)
  - Componentes Angular standalone visuales (shells sin lógica)
  - Layouts responsive y mobile-first
  - Coordinación con PIXEL: AURA diseña → Álvaro aprueba → AURA implementa shell → PIXEL integra lógica
  - PIXEL no crea componentes visuales desde cero
- **Prompt de activación:** `agents/kimi/AURA.md`
- **Skills asignadas:**
  - `crawl4ai-design-scraper` — scraping de diseños de referencia para replicar en Angular
  - `figma-extraction` — extracción de diseños, tokens y assets desde Figma

### KIMI-EVA (Docs & Intelligence Lead / Librarian)
- **Herramienta:** Kimi Code
- **Responsabilidades:**
  - Todo `vault/` — indexar, mantener, limpiar
  - Procesar dumps de `temp/` → `20-Tech/` / `30-Product/` → `00-Index/INDEX.md` → `10-Log/LOG.md`
  - `system/HANDOFF.md` y `system/SESSION_LOG.md` — compactar cuando aplique
  - EVA no crea dump propio: su trabajo queda directamente en el vault
  - Lint semanal: detectar contradicciones, claims desactualizados, páginas huérfanas
  - Actualización de credenciales: solo referencias, nunca valores
- **Prompt de activación:** `agents/kimi/EVA.md`
- **Skills asignadas:**
  - `context-sync` — sincronización de vault Karpathy y HANDOFF.md
  - `token-optimizer` — eficiencia de contexto

---

## 2. SKILLS GENÉRICAS (cualquier agente puede usar)

| Skill | Uso |
|-------|-----|
| `supabase-contract-verifier` | Verificar schema real Supabase antes de escribir código Angular/NestJS |
| `sre-runbook` | Playbooks operativos para incidentes en cualquier servicio |

---

## 3. SKILLS NUEVAS (post-auditoría 2026-06-11)

### `nestjs-security-hardening`
Checklist completo de seguridad para backends NestJS:
- ✅ ValidationPipe global con `whitelist: true, forbidNonWhitelisted: true, transform: true`
- ✅ DTOs con `class-validator` para TODOS los inputs (@Body, @Query, @Param)
- ✅ AuthGuard/AdminGuard NestJS con `@UseGuards()` (no auth manual por método)
- ✅ Throttler global como APP_GUARD
- ✅ Helmet activo
- ✅ CORS restrictivo (sin `*` en prod)
- ✅ No `.env` en git (.gitignore completo)
- ✅ Sentry DSN en env var (no hardcodeado)
- ✅ Escape XML en sitemaps/respuestas XML
- ✅ No exponer mensajes de error de DB al cliente
- ✅ Supabase service role solo backend, RLS documentado
- ✅ CSRF protection en endpoints state-changing
- ✅ Rate limiting en auth endpoints
- ✅ Body size limit explícito
- ✅ Health check endpoint
- ❌ Anti-patrones: `any` en Supabase client, queries raw, secrets en código

### `angular-ssr-security`
Checklist de seguridad para Angular SSR:
- ✅ Headers de seguridad en `server.ts`: X-Frame-Options, X-Content-Type-Options, HSTS, Referrer-Policy, Permissions-Policy, CSP
- ✅ Sentry DSN desde env var (no hardcodeado en main.ts)
- ✅ No `innerHTML` sin sanitizar
- ✅ No `DomSanitizer` abusivo
- ✅ Auth por cookies httpOnly + `withCredentials`
- ✅ Router guards funcionales
- ✅ No secrets hardcodeados
- ✅ SSR-safe: `isPlatformBrowser()` antes de localStorage/window
- ✅ Validar URLs afiliadas (solo `https://`)
- ✅ Sanitizar parámetros `next`/`redirect` (whitelist de paths)
- ✅ Rate limiting/debounce en UI (botones de submit)
- ❌ Anti-patrones: tokens en localStorage, `eval()`, `document.write`

---

## 4. PROTOCOLO DE USO PARA SUBAGENTES

Cuando Kimi cree un subagente dinámico, debe:

1. **Asignarle un rol** de los 6 definidos arriba
2. **Inyectar las skills correspondientes** en el prompt del subagente
3. **Referenciar este archivo maestro** como fuente de verdad
4. **Aplicar Modo Ultra** (sin artículos, sin relleno, sin cortesías, máx 3 líneas fuera de código, solo español)

---

## 5. MAPA DE PROYECTOS

| Proyecto | Vault | Supabase Schema | Coolify UUID | Planka Board | n8n prefix | Stack | Estado cliente |
|----------|-------|----------------|--------------|--------------|-----------|-------|---------------|
| laschubys | `vault/laschubys/` | `laschubys` | `w7dbl4hhq1o65f408i3wi0e5` | `1762811413849441959` | `WF-LCH-*` | Angular 21 SSR + NestJS BFF | ✅ Activo |
| portfolio | `vault/portfolio/` | — | `owcq0qi5guhwpxnxuyafzpov` | `1739527870750917748` | — | Angular 18 (objetivo 21) | Tuyo |
| utilboxes | `vault/utilboxes/` | — | `zgisxnda6wvmj8lyvbjd85qe` | — | `WF-UTI-*` | Content/SEO | Tuyo |
| cobroslatam | `vault/cobroslatam/` | — | `trbgev04xiy896cgzyslgt82` | — | `WF-COB-*` | Content/SEO | Tuyo — ✅ running:healthy |
| agrovivas | `vault/agrovivas/` | `agrovivas` | — (post-demo) | `1771553311741183089` | `WF-AGV-*` | Angular 21 + NestJS | ⏳ Negociación |
| ~~brain~~ | ~~`vault/brain/`~~ | ~~`brain`~~ | ~~`ts4sen9uwgrg5gkgljrcu9it`~~ | ~~`1767731428776216564`~~ | — | ~~Angular PWA~~ | ~~🚫 Eliminado~~ |
| jauria | `vault/jauria/` | `jauria` | `w0gsw0c8goo4kwswo8ss0o8g` | `1739527743269241894` | `WF-JAU-*` | Angular + NestJS | 🚫 Archivado |
| agentoffice | `vault/agentoffice/` | — | — | — | — | React 19 + Vite | 🚧 En dev |
| alvarodevrace | `vault/alvarodevrace/` | — | — | `1780675948073452736` | `WF-ADR-*` | Infra global / Freelance system | Interno |

**Credenciales por proyecto:** `vault/<proyecto>/40-Credentials/INFRA.md` (referencias, no valores)

---

## 6. INFRAESTRUCTURA COMPARTIDA

### Servicios Activos

| Servicio | URL | Estado | Notas |
|----------|-----|--------|-------|
| Coolify | https://coolify.alvarodevrace.tech | ✅ | Orquestador principal |
| n8n | https://n8n.alvarodevrace.tech | ✅ `{"status":"ok"}` | Automatizaciones |
| Supabase | https://db.alvarodevrace.tech | ✅ | Self-hosted, schemas por proyecto |
| Docuseal | https://docuseal.alvarodevrace.tech | ✅ HTTP 200 | E-firma contratos |
| Uptime Kuma | https://status.alvarodevrace.tech | ✅ HTTP 302 | Monitoreo URLs |
| Umami | — | ✅ running:healthy | Analytics web |
| Planka | https://planka.alvarodevrace.tech | ✅ HTTP 200 | Tickets (Dell, solo jornada) |
| Crawl4AI | https://crawl4ai.alvarodevrace.tech | ✅ | Scraping (Dell) |
| Gotenberg | https://gotenberg.alvarodevrace.tech | ✅ | PDF (Dell) |
| Cloudflare DNS | dash.cloudflare.com | ✅ | DNS + Tunnel |
| Sentry | https://sentry.io | ✅ | SaaS, activo en laschubys-app y laschubys-api |

### Eliminados / Caídos

| Servicio | Estado | Razón |
|----------|--------|-------|
| ~~Evolution API~~ | ✅ **ELIMINADO 2026-06-06** | Todos los rastros borrados del VPS |
| ~~GlitchTip~~ | Eliminado 2026-06-05 | Reemplazado por Sentry SaaS |
| ~~Netdata~~ | Eliminado | — |
| ~~Penpot~~ | Eliminado | — |

### Nodos

| Nodo | IP pública | Tailscale | RAM | Disco | Rol |
|------|-----------|-----------|-----|-------|-----|
| VPS Hostinger | 72.60.26.201 | `100.105.133.25` | 7.8 GB | 96 GB | Producción 24/7 |
| Dell zion-node | 192.168.1.20 | `100.88.228.17` | 7.6 GB | 457 GB SSD | Herramientas internas (solo jornada) |
| MacBook | — | `100.83.137.17` | — | — | Desarrollo local |

### Cloudflare — DNS + Tunnel

| Dominio | Zone ID |
|---------|---------|
| alvarodevrace.tech | `2a17143e03abfec70bd29db73b74fecf` |
| laschubys.com | `b1bd4dda49d48900eecb9228673ef1e9` |

**Tunnel VPS:** `alvarodevrace-vps` | ID: `49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a`

### Secretos Maestros (referencias Bitwarden)

| Secreto | Referencia Bitwarden |
|---------|---------------------|
| Coolify API Token | `bitwarden:global/coolify-api-token` |
| Cloudflare API Token | `bitwarden:global/cloudflare-api-token` |
| Supabase JWT Secret | `bitwarden:global/supabase-jwt-secret` |
| Supabase Service Role | `bitwarden:global/supabase-service-role-key` |
| Supabase Anon Key | `bitwarden:global/supabase-anon-key` |
| Supabase Postgres Pass | `bitwarden:global/supabase-postgres-password` |
| Google OAuth Client ID | `bitwarden:global/google-oauth-client-id` |
| Google OAuth Secret | `bitwarden:global/google-oauth-client-secret` |
| Planka Password | `bitwarden:global/planka-password` |
| Telegram Bot Generic | `bitwarden:global/telegram-bot-generic` |
| Docuseal API Key | `bitwarden:global/docuseal-api-key` |
| SSH root VPS | `bitwarden:global/ssh-root-vps` (key-based) |
| SSH alvaro Dell | `bitwarden:global/ssh-alvaro-dell` |

### Backups — Sistema 3-2-1

```
VPS (cron 03:00) → /opt/backups/
    ↓ rsync (boot Dell)
Dell /opt/backups/vps/
    ↓ rclone
Google Drive: Backups-AlvaroDevRace/
```

| Dato | Frecuencia | Archivo |
|------|-----------|---------|
| Schema laschubys | Diario | `supabase/laschubys-YYYYMMDD.sql` |
| Schema jauria | Mensual | `supabase/jauria-YYYYMMDD.sql` |
| n8n workflows | Diario | `n8n/workflows-YYYYMMDD.json` |
| n8n SQLite | Diario | `n8n/credentials-YYYYMMDD.sqlite` |
| Coolify config | Boot Dell | `coolify-config/` |

**Retención:** VPS 30 días | Dell ilimitado | Google Drive 90 días

**Scripts:**
- VPS `/opt/scripts/backup-generate.sh` — cron 03:00
- Dell `/opt/scripts/sync-backups.sh` — systemd oneshot boot

### Planka — API

**URL:** https://planka.alvarodevrace.tech
**Login:** `alvaro@alvarodevrace.tech` — password en `bitwarden:global/planka-password`

**Obtener token:**
```bash
TOKEN=$(curl -s -X POST "https://planka.alvarodevrace.tech/api/access-tokens" \
  -H "Content-Type: application/json" \
  -d '{"emailOrUsername":"alvaro@alvarodevrace.tech","password":"<BW>"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin).get('item',''))")
```

**Prefijos ticket:**
| Proyecto | Prefijo |
|----------|---------|
| jauria | JAU-N |
| laschubys | LCH-N |
| portfolio | PRT-N |
| cobroslatam | COB-N |
| utilboxes | UTI-N |
| agrovivas | AGV-N |

**Formato de comentario por agente:**
- **TRIN:** `✅ [Qué resolvió]. Commit/acción: [ref].`
- **PIXEL:** `✅ Merge en develop. Rama: pixel/<nombre>. [qué cambió]. TRIN: push develop + PR.`
- **LINK:** `✅ Workflow <nombre> corregido. Cambio: [nodo/fix]. Evidencia: ejecución <id>.`
- **EVA:** `✅ Docs actualizados. Archivos: [lista]. Hallazgo para TRIN: [si aplica].`
- **NOVA:** `✅ QA pass. Tests: [lista]. Lighthouse: P/A/S/BP.` o `❌ QA bloqueado. Bugs: [lista].`
- **AURA:** `✅ Componente <nombre> listo. Props: [lista]. data-testid incluidos. PIXEL: integrar.`

---

## 7. FLUJO GIT UNIVERSAL

**Ramas permanentes:** `main` y `develop` — NUNCA push directo.

### PIXEL
```bash
# 1. Siempre partir de develop actualizado
git checkout develop && git pull origin develop

# 2. Crear rama
git checkout -b pixel/<nombre-corto-ticket>

# 3. Implementar

# 4. Verificar build ANTES de merge
npm run build  # debe pasar sin errores

# 5. Merge local a develop
git checkout develop
git merge pixel/<nombre>

# 6. Avisar a TRIN (NO push tú mismo)
# "Listo en develop local. Rama: pixel/<nombre>. TRIN: push develop + PR + borrar rama."
```

### TRIN (después de PIXEL)
```bash
1. gh run list --repo alvarodevrace/<repo>
2. git push origin develop
3. git branch -D pixel/<nombre> && git push origin --delete pixel/<nombre>
4. LLAMAR A NOVA: "QA listo en develop — proyecto <X>. URL staging: <URL>"
5. gh pr create --repo alvarodevrace/<repo> \
     --base main --head develop --title "<ticket>" \
     --body "Ticket: <PRY-XXX>."
6. Notificar a Álvaro: "PR listo → <url>"
7. Álvaro aprueba → merge → Coolify deploy automático
8. Verificar deploy success en Coolify
9. Planka → mover ticket a Done
```

**Reglas absolutas:**
- NUNCA push directo a `main`
- NUNCA PR feature → main (siempre develop primero)
- TRIN nunca aprueba su propio PR
- TRIN nunca crea PR sin QA pass de NOVA
- **TRIN siempre crea el PR develop→main. Álvaro siempre aprueba — pero la creación del PR es responsabilidad de TRIN**
- **SIEMPRE hacer `npm run build` (o equivalente) después de CUALQUIER cambio de código en frontend o backend, antes de commit/push — indistintamente del proyecto**

---

## 8. PROPIEDAD DE AGENTES

| Área | Dueño |
|------|-------|
| Infra: Coolify, deploys, secretos, RLS, RPC, Supabase schema | KIMI-TRIN |
| Orquestación: decide dueño, resuelve bloqueos, handoffs | KIMI-TRIN |
| CRM: cotizaciones Notion, contratos Docuseal, hitos | KIMI-TRIN |
| Apps: código Angular/NestJS, lógica negocio, API routes | KIMI-PIXEL |
| Mobile: Capacitor 7, builds iOS/Android | KIMI-PIXEL |
| Automatización: n8n, webhooks, ejecuciones | KIMI-LINK |
| Docs: vault, indexing, análisis, Q&A | KIMI-EVA |
| Tests: Playwright, Jest, Lighthouse, bug reports | KIMI-NOVA |
| UI visual: Figma, design system, tokens, componentes | KIMI-AURA |

**Reglas de frontera:**
- Trabajo fuera de área → no ejecutar. Explicar dueño correcto.
- PIXEL/LINK/NOVA/AURA: nunca Coolify, secretos, Supabase schema.
- AURA: nunca lógica de negocio, servicios, routing.
- NOVA: nunca código productivo. Solo tests.
- TRIN: llama a NOVA antes de PR develop→main.
- PIXEL: pide componente a AURA antes de UI nuevo desde cero.

---

## 9. PROTOCOLOS ESPECIALES

### Protocol RX (Extended Reasoning)
Obligatorio antes de: migraciones DDL, cambios RLS, lógica de pagos, RPCs críticos.

```
1. DISEÑO: describir cambio e impacto exacto
2. PRE-MORTEM: 3 escenarios de fallo
3. CONTRATO: cómo verificar éxito
→ Solo entonces ejecutar
```

### Flujo de cierre de sesión (obligatorio para todos)

```
1. Crear dump: vault/<proyecto>/temp/YYYY-MM-DD-<AGENTE>.md
   Contenido: logros, IDs, cambios infra, decisiones, pendientes.
2. Planka → comentar ticket + mover a Done si terminado.
3. /clear → ÚLTIMO PASO.
```

**EVA procesa dumps:** `temp/` → `20-Tech/30-Product/` → `00-Index/INDEX.md` → `10-Log/LOG.md` → limpia `temp/`

### Ley de Memoria — Vault Central

> `system/STATE.md` y `system/MEMORY.md` están MUERTOS. No leer, no editar.

**Capas:**
```
Capa 1 — Raw Sources:  vault/<proyecto>/temp/ (dumps de agentes — inmutables hasta EVA)
Capa 2 — The Wiki:     vault/<proyecto>/20-Tech/ y 30-Product/ (EVA indexa)
Capa 3 — The Schema:   agents/KIMI-AGENTS.md (este archivo)
```

### Detección de proyecto por CWD

```
.../JauriaCrossfit/ → jauria   | .../LasChubys/   → laschubys
.../Portfolio/      → portfolio | .../CobrosLatam/ → cobroslatam
.../UtilBoxes/      → utilboxes | .../Agrovivas/   → agrovivas
.../AgentOffice/    → agentoffice
```

---

## 10. HERRAMIENTAS Y APIs FRECUENTES

### Deploy manual de emergencia (Coolify)
```bash
curl -X POST -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
  "https://coolify.alvarodevrace.tech/api/v1/deploy?uuid=<COOLIFY_UUID>"
```

### Docuseal — Nueva firma
```bash
curl -X POST "https://docuseal.alvarodevrace.tech/api/submissions" \
  -H "X-Auth-Token: $DOCUSEAL_API_KEY" -H "Content-Type: application/json" \
  -d '{"template_id":2,"send_email":true,"submitters":[{"role":"Client","email":"<EMAIL>","name":"<NOMBRE>"}]}'
```
Template ID: 2 | Slug: mPkXkD7iTpQEWo

### PDF Cotización (Gotenberg)
```bash
curl -s -F "files=@/tmp/index.html;type=text/html;filename=index.html" \
  -F "chromium-print-background=true" \
  https://gotenberg.alvarodevrace.tech/forms/chromium/convert/html \
  -o /tmp/cotizacion_CLIENTE.pdf
```
Template: `templates/pdf/cotizacion.html`

### Crawl4AI — Scraping
```bash
curl -X POST https://crawl4ai.alvarodevrace.tech/crawl \
  -H "Content-Type: application/json" \
  -d '{"urls":["<URL>"],"crawler_params":{"headless":true,"screenshot":true}}'
```

### n8n API
```bash
# Listar workflows
curl -s "https://n8n.alvarodevrace.tech/api/v1/workflows" \
  -H "X-N8N-API-KEY: $N8N_API_KEY"

# Activar/desactivar workflow
curl -X POST "https://n8n.alvarodevrace.tech/api/v1/workflows/<ID>/activate" \
  -H "X-N8N-API-KEY: $N8N_API_KEY"
```

---

## 11. REGLA DE SKILLS NUEVAS (MEMORIA VIVA)

**Si un agente descubre, consulta o necesita una skill que no existe aún → debe crearla inmediatamente.**

### Proceso
1. **Detectar gap:** patrón recurrente, bug nuevo, proceso operativo no documentado, pregunta repetida.
2. **Decidir scope:**
   - **Global** (varios proyectos/agentes) → `~/.kimi-code/skills/kimi-<nombre>.md`
   - **Local** (un proyecto) → `<proyecto>/.codex/skills/<nombre>/SKILL.md` o `<proyecto>/.claude/skills/<nombre>.md`
3. **Escribir skill:** instrucciones claras, ejemplos, anti-patrones, cuándo usar.
4. **Registrar:** añadir a `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md` y a `kimi-all-skills-catalog.md`.
5. **Asignar agente:** decidir quién la usa (TRIN, PIXEL, LINK, NOVA, EVA, AURA).
6. **Reportar:** al cerrar sesión, incluir *"Skill creada: `<nombre>` → agente `<X>`"* en el dump.

### Principios
- Una skill = un conocimiento accionable.
- Nunca dejar un aprendizaje nuevo solo en memoria de sesión.
- El catálogo de skills nunca está terminado.

---

## 12. MEMORIA MUERTA (NO USAR)

- `CLAUDE.md.OBSOLETO`
- `ANTIGRAVITY.md.OBSOLETO`
- `agents/AGENTS.md.OBSOLETO`
- `system/STATE.md`
- `system/MEMORY.md`

**Fuente de verdad:** `KIMI.md` + `agents/KIMI-AGENTS.md` + `vault/<proyecto>/00-Index/INDEX.md` + `kimi-all-skills-catalog.md` + **este archivo**
