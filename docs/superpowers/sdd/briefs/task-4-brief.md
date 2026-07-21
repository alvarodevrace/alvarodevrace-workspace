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
