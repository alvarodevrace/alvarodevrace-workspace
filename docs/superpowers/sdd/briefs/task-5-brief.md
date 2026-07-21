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
