# Vault DRY Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eliminar duplicados DRY de infraestructura, credenciales y IDs Dokploy/Cloudflare del vault, estableciendo `vault/INFRA-GLOBAL-2026-06.md` como única fuente de verdad global.

**Architecture:** Consolidar datos globales en `vault/INFRA-GLOBAL-2026-06.md`; convertir `agents/KIMI-AGENTS.md` y `KIMI.md` en índices ligeros que referencian; eliminar archivos duplicados, stubs huérfanos y secretos expuestos; sincronizar el catálogo de skills global.

**Tech Stack:** Markdown, Bash (`rg`, `ls`, `rm`), Kimi Code CLI.

## Global Constraints

- No editar logs históricos (`system/SESSION_LOG.md`, `vault/*/10-Log/LOG.md`).
- 0 secretos completos en archivos `.md`; reemplazar por referencias `bitwarden:*` o eliminar el archivo.
- No modificar repos git de subproyectos (`LasChubys/`, `Portfolio/`, etc.).
- Todo el texto en español.
- Fuentes de verdad: `vault/INFRA-GLOBAL-2026-06.md` (infra) y `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md` (skills).

---

## Task 1: Consolidar `vault/INFRA-GLOBAL-2026-06.md`

**Files:**
- Modify: `vault/INFRA-GLOBAL-2026-06.md`

**Interfaces:**
- Consumes: datos faltantes de `vault/alvarodevrace/40-Credentials/INFRA.md`.
- Produces: archivo SSOT unificado y sin secciones duplicadas.

- [ ] **Step 1: Read current INFRA-GLOBAL**

  Run: `Read vault/INFRA-GLOBAL-2026-06.md`

- [ ] **Step 2: Unify duplicated Cloudflare section**

  Replace the standalone Cloudflare section near the end (around lines 365-383) with a single section at the top. Add the token/hallazgo details to the first section.

  Edit `vault/INFRA-GLOBAL-2026-06.md` replacing:
  ```markdown
  ## Cloudflare — DNS + Tunnel

  **Zonas:**
  | Dominio | Zone ID |
  |---------|---------|
  | alvarodevrace.tech | `2a17143e03abfec70bd29db73b74fecf` |
  | laschubys.com | `b1bd4dda49d48900eecb9228673ef1e9` |

  **Tunnel VPS:** `alvarodevrace-vps` | ID: `49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a`

  **Regla DNS:** Todo DNS en Cloudflare. No tocar Hostinger hPanel.
  ```
  with:
  ```markdown
  ## Cloudflare — DNS + Tunnel

  **Zonas:**
  | Dominio | Zone ID |
  |---------|---------|
  | alvarodevrace.tech | `2a17143e03abfec70bd29db73b74fecf` |
  | laschubys.com | `b1bd4dda49d48900eecb9228673ef1e9` |

  **Tunnel VPS:** `alvarodevrace-vps` | ID: `49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a`
  **Estado Tunnel:** ✅ Activo

  **Regla DNS:** Todo DNS en Cloudflare. No tocar Hostinger hPanel.

  **Tokens:**
  | Token | Permisos | Ubicación |
  |-------|----------|-----------|
  | Admin (alvarodevrace.tech) | Account + Zone edit | `bitwarden:global/cloudflare-api-token` |
  | Cache Purge (laschubys.com) | Zone:Cache Purge | `bitwarden:global/cloudflare-cache-purge-token` |

  **⚠️ Hallazgo:** El token de `laschubys.com` solo tiene permisos de cache purge. No puede leer zona vía API. Para admin DNS completo se necesita el token global en Bitwarden.
  ```

  Then delete the second duplicate Cloudflare block (lines ~365-383).

- [ ] **Step 3: Add Docuseal template details**

  In the Docuseal section (or create one under VPS services), add:
  ```markdown
  **Template ID:** 2 | Slug: `mPkXkD7iTpQEWo`
  ```

- [ ] **Step 4: Migrate non-repeated Bitwarden references from alvarodevrace INFRA**

  Add under `## Secretos maestros — Referencias Bitwarden`:
  ```markdown
  | n8n Service Password | `bitwarden:global/n8n-service-password` |
  | Gemini API Key | `bitwarden:global/gemini-api-key` |
  | Mistral API Key | `bitwarden:global/mistral-api-key` |
  | OpenRouter API Key | `bitwarden:global/openrouter-api-key` |
  | Telegram Chat ID (alvarodevrace) | `bitwarden:global/telegram-chat-id-alvarodevrace` |
  ```

  Add under Bitwarden section:
  ```markdown
  **Desbloqueo:** `bw unlock` con email `alcarreram@hotmail.com`.
  **Clave Age pública:** `age19kgpxyhgn8c0tv28lvqe0zws5k0pwhwnp79vsyy0tl2f0hjp0fps734wv6`
  ```

- [ ] **Step 5: Add Evolution DNS orphan note**

  Under `## ~~Evolution API~~` section (or create a DNS cleanup note):
  ```markdown
  > **Pendiente:** limpiar registro DNS huérfano `evolution.alvarodevrace.tech` si aún existe.
  ```

- [ ] **Step 6: Add SSOT notice to header**

  Replace the header note:
  ```markdown
  > Fuente de verdad para infra compartida entre todos los proyectos.
  > Reemplaza a `vault/INFRA-GLOBAL.md` (versión desactualizada).
  ```
  with:
  ```markdown
  > **Fuente de verdad única (SSOT)** para infra compartida entre todos los proyectos.
  > Si otro archivo del vault repite estos datos, la versión vigente es este archivo.
  > Reemplaza a `vault/INFRA-GLOBAL.md` (versión desactualizada).
  ```

- [ ] **Step 7: Validate no duplicate Cloudflare sections**

  Run:
  ```bash
  rg -n "## Cloudflare" vault/INFRA-GLOBAL-2026-06.md
  ```
  Expected: exactly 2 matches (the H2 and any reference), not 3+.

---

## Task 2: Limpiar `agents/KIMI-AGENTS.md`

**Files:**
- Modify: `agents/KIMI-AGENTS.md`

**Interfaces:**
- Consumes: `vault/INFRA-GLOBAL-2026-06.md`.
- Produces: schema maestro sin tablas de infra/secretos repetidos.

- [ ] **Step 1: Read file**

  Run: `Read agents/KIMI-AGENTS.md`

- [ ] **Step 2: Remove duplicated shared-infra table**

  Delete the section starting with `## Infraestructura Compartida — Estado Real` through the table and `### ❌ Eliminados / Caídos` subsection.

- [ ] **Step 3: Remove duplicated Nodos table**

  Delete the section `## Nodos` and its table.

- [ ] **Step 4: Remove duplicated Cloudflare section**

  Delete the section `## Cloudflare — DNS + Tunnel` and its content.

- [ ] **Step 5: Remove duplicated secretos maestros table**

  Delete the section `## Secretos maestros (referencias)` and its table.

- [ ] **Step 6: Remove duplicated backups section**

  Delete the section `## Backups — Sistema 3-2-1` and its content.

- [ ] **Step 7: Add global reference link**

  After the `## Tabla Maestra de Proyectos` heading, add a note:
  ```markdown
  > IDs Dokploy, URLs e IPs globales: `vault/INFRA-GLOBAL-2026-06.md`
  ```

- [ ] **Step 8: Update project table to avoid duplicate IDs**

  Replace the table header/columns so Dokploy IDs are not repeated. Keep only project, vault, Supabase schema, Planka board, n8n prefix, stack, estado.

- [ ] **Step 9: Update credentials-by-project line**

  Replace:
  ```markdown
  **Credenciales por proyecto:** `vault/<proyecto>/40-Credentials/INFRA.md` (referencias, no valores)
  ```
  with:
  ```markdown
  **Credenciales por proyecto:** `vault/<proyecto>/40-Credentials/INFRA.md` (solo si hay datos propios; globales en `vault/INFRA-GLOBAL-2026-06.md`).
  ```

- [ ] **Step 10: Validate no global IDs remain**

  Run:
  ```bash
  rg -n -g 'agents/KIMI-AGENTS.md' '2a17143e03abfec70bd29db73b74fecf|b1bd4dda49d48900eecb9228673ef1e9|49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a|72\.60\.26\.201|100\.105\.133\.25'
  ```
  Expected: empty output.

---

## Task 3: Limpiar `KIMI.md`

**Files:**
- Modify: `KIMI.md`

**Interfaces:**
- Consumes: `vault/INFRA-GLOBAL-2026-06.md`.
- Produces: entry point sin sección de infra repetida.

- [ ] **Step 1: Read file**

  Run: `Read KIMI.md`

- [ ] **Step 2: Add SSOT link to header**

  After the first paragraph, add:
  ```markdown
  **Infra/credenciales globales:** `vault/INFRA-GLOBAL-2026-06.md`  
  **Schema maestro de agentes:** `agents/KIMI-AGENTS.md`
  ```

- [ ] **Step 3: Remove infraestructure section**

  Delete the entire section `## Infraestructura real (viva)` including all subsections up to `## Secretos — Dónde viven`.

- [ ] **Step 4: Simplify secrets section**

  Replace the detailed secrets table with:
  ```markdown
  ## Secretos — Dónde viven

  | Tipo | Ubicación |
  |------|-----------|
  | Secretos maestros | Bitwarden carpeta `AlvaroDevRace/global` |
  | CI/CD tokens | GitHub Secrets por repo |
  | Runtime env vars | Dokploy env vars por servicio |
  | Encriptados en repo | SOPS + Age |

  Ver referencias completas en `vault/INFRA-GLOBAL-2026-06.md`.
  ```

- [ ] **Step 5: Update active projects table**

  Remove the `Dokploy project ID` column; keep project, vault, stack, estado.

- [ ] **Step 6: Validate**

  Run:
  ```bash
  rg -n -g 'KIMI.md' '2a17143e03abfec70bd29db73b74fecf|b1bd4dda49d48900eecb9228673ef1e9|49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a|72\.60\.26\.201|100\.105\.133\.25'
  ```
  Expected: empty output.

---

## Task 4: Eliminar `vault/alvarodevrace/40-Credentials/INFRA.md`

**Files:**
- Delete: `vault/alvarodevrace/40-Credentials/INFRA.md`

**Interfaces:**
- Consumes: Task 1 completed (data migrated).
- Produces: no output file.

- [ ] **Step 1: Verify migration already done in Task 1**

  Confirm that Docuseal template, Bitwarden refs, Age key, and Evolution DNS note were added to `vault/INFRA-GLOBAL-2026-06.md`.

- [ ] **Step 2: Delete file**

  Run:
  ```bash
  rm vault/alvarodevrace/40-Credentials/INFRA.md
  ```

- [ ] **Step 3: Validate deletion**

  Run:
  ```bash
  ls vault/alvarodevrace/40-Credentials/INFRA.md 2>&1 | grep 'No such file'
  ```
  Expected: match found.

---

## Task 5: Limpiar `vault/portfolio/40-Credentials/INFRA.md`

**Files:**
- Modify: `vault/portfolio/40-Credentials/INFRA.md`

**Interfaces:**
- Consumes: `vault/INFRA-GLOBAL-2026-06.md`.
- Produces: proyecto portfolio con solo datos propios.

- [ ] **Step 1: Read file**

  Run: `Read vault/portfolio/40-Credentials/INFRA.md`

- [ ] **Step 2: Remove Dokploy project/application IDs and Cloudflare zone**

  Edit the services table. Replace:
  ```markdown
  | Dokploy project ID | `oSVdXwFYGekg16v18XNW1` |
  | Dokploy environment ID | `6aSWtCz4LWWvtHfYJXXMG` |
  | Dokploy application ID | `r9HA2pNx6Uiip1sYJ8ubg` |
  | Cloudflare zone | `alvarodevrace.tech` |
  ```
  with:
  ```markdown
  | Dokploy IDs | Ver `vault/INFRA-GLOBAL-2026-06.md` → proyecto `portfolio` |
  | Cloudflare zone | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  ```

- [ ] **Step 3: Rewrite deploy snippet to use variables**

  Replace the deploy snippet with:
  ```markdown
  ## Dokploy — Deploy manual

  ```bash
  APP_ID="<ver INFRA-GLOBAL-2026-06.md>"
  curl -X POST -H "Content-Type: application/json" \
    -H "x-api-key: $DOKPLOY_API_KEY" \
    -d "{\"applicationId\":\"$APP_ID\"}" \
    "https://dokploy.alvarodevrace.tech/api/application.deploy"
  ```
  ```

- [ ] **Step 4: Validate**

  Run:
  ```bash
  rg -n -g 'vault/portfolio/40-Credentials/INFRA.md' 'oSVdXwFYGekg16v18XNW1|r9HA2pNx6Uiip1sYJ8ubg|2a17143e03abfec70bd29db73b74fecf'
  ```
  Expected: empty output.

---

## Task 6: Limpiar `vault/laschubys/40-Credentials/INFRA.md`

**Files:**
- Modify: `vault/laschubys/40-Credentials/INFRA.md`

**Interfaces:**
- Consumes: `vault/INFRA-GLOBAL-2026-06.md`.
- Produces: proyecto Las Chubys con solo datos propios.

- [ ] **Step 1: Read file**

  Run: `Read vault/laschubys/40-Credentials/INFRA.md`

- [ ] **Step 2: Replace Cloudflare zone ID with reference**

  In the Cloudflare table, replace the literal zone ID with:
  ```markdown
  | Zone ID | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  ```

- [ ] **Step 3: Update purge-cache snippet**

  Replace the hardcoded zone ID in the curl snippet with a variable:
  ```bash
  ZONE_ID="<ver INFRA-GLOBAL-2026-06.md>"
  CF_TOKEN=$(bw get password cloudflare-api-token)
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache" \
    -H "Authorization: Bearer $CF_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"purge_everything": true}'
  ```

- [ ] **Step 4: Replace global service URLs/IDs with references**

  In the main services table, replace Dokploy project/app IDs, n8n URL, Supabase URL with:
  ```markdown
  | n8n | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  | Supabase | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  | Dokploy project `laschubys` | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  | Dokploy `laschubys-app` | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  | Dokploy `laschubys-api` | Ver `vault/INFRA-GLOBAL-2026-06.md` |
  ```

- [ ] **Step 5: Replace tokens table with reference**

  Replace the Tokens y Credenciales table (global tokens) with:
  ```markdown
  ## Tokens y Credenciales

  Ver referencias globales en `vault/INFRA-GLOBAL-2026-06.md`.

  | Servicio | Referencia específica de Las Chubys |
  |---|---|
  | Sentry Frontend DSN | `bitwarden:global/sentry-dsn-laschubys-app` |
  | Sentry Backend DSN | `bitwarden:global/sentry-dsn-laschubys-api` |
  | Indexing API OAuth2 | `alpepito93@gmail.com` |
  ```

- [ ] **Step 6: Move global Uptime Kuma monitors to INFRA-GLOBAL**

  Keep only Las Chubys monitors (`LasChubys Homepage`, `LasChubys API Health`, `LasChubys Sitemap`). Move the rest (Supabase REST, n8n, Status Page, Dokploy) to a note: *"Monitores globales → `vault/INFRA-GLOBAL-2026-06.md`"*.

- [ ] **Step 7: Remove Infraestructura Física section**

  Delete the section `## Infraestructura Física` and its table.

- [ ] **Step 8: Validate**

  Run:
  ```bash
  rg -n -g 'vault/laschubys/40-Credentials/INFRA.md' 'b1bd4dda49d48900eecb9228673ef1e9|dcZfubBCdj1wno5hroswj|XX0AfFKhYHn9ayErXevJF|GzBwWmUjlYRCgfMK6tzBt|https://n8n\.alvarodevrace\.tech|https://db\.alvarodevrace\.tech'
  ```
  Expected: empty output.

---

## Task 7: Eliminar archivos huérfanos

**Files:**
- Delete: `vault/LOG.md`
- Delete: `vault/portfolio/20-Tech/` directory
- Delete: `vault/portfolio/30-Product/` directory
- Delete: `vault/alvarodevrace/20-Tech/Docuseal-Gotenberg.md`
- Delete: `vault/alvarodevrace/20-Tech/Notion-Integration.md`
- Delete: `vault/alvarodevrace/20-Tech/n8n-Workflows.md`

**Interfaces:**
- Consumes: Tasks 1-6 completed.
- Produces: workspace sin archivos vacíos/duplicados.

- [ ] **Step 1: Delete vault/LOG.md**

  Run:
  ```bash
  rm vault/LOG.md
  ```

- [ ] **Step 2: Delete empty portfolio directories**

  Run:
  ```bash
  rmdir vault/portfolio/20-Tech vault/portfolio/30-Product
  ```

- [ ] **Step 3: Delete alvarodevrace stubs with exposed secrets**

  Run:
  ```bash
  rm vault/alvarodevrace/20-Tech/Docuseal-Gotenberg.md
  rm vault/alvarodevrace/20-Tech/Notion-Integration.md
  rm vault/alvarodevrace/20-Tech/n8n-Workflows.md
  ```

- [ ] **Step 4: Validate deletions**

  Run:
  ```bash
  ls vault/LOG.md vault/portfolio/20-Tech vault/portfolio/30-Product vault/alvarodevrace/20-Tech/Docuseal-Gotenberg.md vault/alvarodevrace/20-Tech/Notion-Integration.md vault/alvarodevrace/20-Tech/n8n-Workflows.md 2>&1 | grep 'No such file'
  ```
  Expected: 6 matches.

---

## Task 8: Sincronizar catálogo de skills

**Files:**
- Modify: `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md`
- Delete: `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md`

**Interfaces:**
- Consumes: `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md`.
- Produces: skill global actualizada y duplicado vault eliminado.

- [ ] **Step 1: Read both files**

  Run:
  ```bash
  Read ~/.kimi-code/skills/KIMI-MASTER-SKILLS.md
  Read vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md
  ```

- [ ] **Step 2: Write updated global skill**

  Create a Python script to transform the vault file into the new global file:

  ```python
  #!/usr/bin/env python3
  import re, pathlib
  src = pathlib.Path('vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md').read_text()
  # Replace obsolete references
  src = src.replace('Coolify', 'Dokploy')
  src = src.replace('coolify', 'dokploy')
  src = src.replace('coolify-api-token', 'dokploy-api-token')
  src = src.replace('coolify-manager', 'dokploy-manager')
  # Remove eliminated projects and their rows
  eliminated = ['agrovivas', 'jauria', 'cobroslatam', 'utilboxes', 'agentoffice', 'brain']
  for p in eliminated:
      src = re.sub(r'\|\s*~~?' + p + r'~~?\s*\|.*?\n', '', src, flags=re.IGNORECASE)
      src = re.sub(r'\|\s*' + p + r'\s*\|.*?\n', '', src, flags=re.IGNORECASE)
  # Remove obsolete paths
  src = src.replace('.codex/', '.kimi/')
  src = src.replace('.claude/', '.kimi/')
  # Update outdated deployment note
  src = src.replace('Coolify deploy automático', 'Dokploy deploy automático')
  src = src.replace('Coolify API Token', 'Dokploy API Key')
  src = src.replace('Deploy manual de emergencia (Coolify)', 'Deploy manual de emergencia (Dokploy)')
  src = re.sub(r'https://coolify\.alvarodevrace\.tech/api/v1/deploy\?uuid=<COOLIFY_UUID>', 'https://dokploy.alvarodevrace.tech/api/application.deploy', src)
  # Write output
  pathlib.Path('~/.kimi-code/skills/KIMI-MASTER-SKILLS.md').expanduser().write_text(src)
  print('done')
  ```

  Run:
  ```bash
  python3 /tmp/sync_skills.py
  ```

- [ ] **Step 3: Delete vault duplicate**

  Run:
  ```bash
  rm vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md
  ```

- [ ] **Step 4: Validate global skill**

  Run:
  ```bash
  rg -n -i -g '*.md' 'coolify|codex|claude|agrovivas|jauria|cobroslatam|utilboxes|agentoffice|brain' ~/.kimi-code/skills/KIMI-MASTER-SKILLS.md | head -20
  ```
  Expected: no hits for eliminated projects; possibly "coolify" only inside historical notes if any remain.

---

## Task 9: Corregir referencias rotas

**Files:**
- Modify: `vault/laschubys/20-Tech/Supabase.md`
- Modify: `agents/NEW-PROJECT-GUIDE.md`
- Modify: `vault/alvarodevrace/00-Index/INDEX.md`

**Interfaces:**
- Consumes: `vault/INFRA-GLOBAL-2026-06.md`.
- Produces: referencias actualizadas al SSOT correcto.

- [ ] **Step 1: Read files**

  Run:
  ```bash
  Read vault/laschubys/20-Tech/Supabase.md
  Read agents/NEW-PROJECT-GUIDE.md
  Read vault/alvarodevrace/00-Index/INDEX.md
  ```

- [ ] **Step 2: Replace `vault/INFRA-GLOBAL.md` with SSOT**

  In each file, replace all occurrences of `vault/INFRA-GLOBAL.md` with `vault/INFRA-GLOBAL-2026-06.md`.

- [ ] **Step 3: Update alvarodevrace index if it links to deleted stubs**

  If `vault/alvarodevrace/00-Index/INDEX.md` links to `Docuseal-Gotenberg.md`, `Notion-Integration.md`, or `n8n-Workflows.md`, remove those links or mark them as eliminados.

- [ ] **Step 4: Validate**

  Run:
  ```bash
  rg -n -g '*.md' 'vault/INFRA-GLOBAL\.md' vault/ agents/ KIMI.md
  ```
  Expected: empty output.

---

## Task 10: Validación final

**Files:**
- All modified `.md` files.

**Interfaces:**
- Consumes: all previous tasks.
- Produces: reporte de cumplimiento.

- [ ] **Step 1: Check global IDs do not repeat outside INFRA-GLOBAL**

  Run:
  ```bash
  rg -n -g '*.md' '2a17143e03abfec70bd29db73b74fecf|b1bd4dda49d48900eecb9228673ef1e9|49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a|dcZfubBCdj1wno5hroswj|oSVdXwFYGekg16v18XNW1|aP3P-FbWPbS383qrcKEGm|HTxz4FLFZ-FFasumznhf2|XX0AfFKhYHn9ayErXevJF|GzBwWmUjlYRCgfMK6tzBt|r9HA2pNx6Uiip1sYJ8ubg' vault/ agents/ KIMI.md \
    | grep -v 'INFRA-GLOBAL-2026-06.md'
  ```
  Expected: empty output.

- [ ] **Step 2: Check deleted files are gone**

  Run:
  ```bash
  ls vault/alvarodevrace/40-Credentials/INFRA.md vault/LOG.md vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md vault/portfolio/20-Tech vault/portfolio/30-Product vault/alvarodevrace/20-Tech/Docuseal-Gotenberg.md vault/alvarodevrace/20-Tech/Notion-Integration.md vault/alvarodevrace/20-Tech/n8n-Workflows.md 2>&1 | grep 'No such file'
  ```
  Expected: 7 matches.

- [ ] **Step 3: Check for exposed secrets (manual review)**

  Run:
  ```bash
  rg -n -g '*.md' '[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}|ntn_[a-zA-Z0-9]{20,}|p9zi[a-zA-Z0-9]{20,}|sk-[a-zA-Z0-9]{20,}' vault/ agents/ KIMI.md || true
  ```
  Expected: no hits. If any, move to Bitwarden reference or delete file.

- [ ] **Step 4: Confirm KIMI.md and KIMI-AGENTS.md only reference INFRA-GLOBAL**

  Run:
  ```bash
  rg -n -g 'agents/KIMI-AGENTS.md' -g 'KIMI.md' 'INFRA-GLOBAL-2026-06\.md'
  ```
  Expected: at least one match in each file.

- [ ] **Step 5: Commit / report to user**

  Since the workspace root is not a git repo, do not run `git commit` here. Instead, append a summary entry to `system/SESSION_LOG.md` with the changes made and files touched.
