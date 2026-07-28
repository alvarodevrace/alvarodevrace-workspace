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
