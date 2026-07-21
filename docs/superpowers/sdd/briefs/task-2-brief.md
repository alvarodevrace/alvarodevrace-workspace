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
