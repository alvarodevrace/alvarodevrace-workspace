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
