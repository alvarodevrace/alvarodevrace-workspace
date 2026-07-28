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
