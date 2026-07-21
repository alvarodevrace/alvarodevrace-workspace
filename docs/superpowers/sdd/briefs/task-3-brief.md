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
