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
