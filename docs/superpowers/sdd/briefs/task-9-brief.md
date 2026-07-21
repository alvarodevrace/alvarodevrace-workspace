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
