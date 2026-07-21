# Credenciales AlvaroDevRace — Global

> ⚠️ **Política vigente:** 0 secretos completos en archivos .md. Todos los valores reales están en Bitwarden.
> 
> Bitwarden: `alcarreram@hotmail.com` | Desbloquear: `bw unlock`

---

## n8n
- **URL:** https://n8n.alvarodevrace.tech
- **API Key:** `bitwarden:global/n8n-api-key`
- **Service Password (internal):** `bitwarden:global/n8n-service-password`
- **Env file:** `/opt/dokploy-data/n8n/.env` (VPS)

## Cloudflare
- **Zone ID (laschubys.com):** `b1bd4dda49d48900eecb9228673ef1e9`
- **API Token (global):** `bitwarden:global/cloudflare-api-token`
- **Cache Purge Token:** `bitwarden:global/cloudflare-cache-purge-token`

## Dokploy
- **URL:** http://100.105.133.25:3000
- **API Key:** `bitwarden:global/dokploy-api-token`
- **Panel domain:** `dokploy.alvarodevrace.tech` (acceso local puede requerir flush DNS/Tailscale)

## Supabase (Self-Hosted)
- **URL:** https://db.alvarodevrace.tech
- **Anon Key:** `bitwarden:global/supabase-anon-key`
- **Service Role Key:** `bitwarden:global/supabase-service-role-key`
- **JWT Secret:** `bitwarden:global/supabase-jwt-secret`
- **Postgres Password:** `bitwarden:global/supabase-postgres-password`
- **Dokploy service ID:** consultar panel Dokploy o Bitwarden

## Telegram
- **@alvarodevrace_bot Token:** `bitwarden:global/telegram-bot-alvarodevrace`
- **@laschubys_bot Token:** `bitwarden:global/telegram-bot-laschubys`
- **Chat ID (alvarodevrace):** `bitwarden:global/telegram-chat-id-alvarodevrace`

## Resend
- **Domain ID:** `bitwarden:global/resend-domain-id`
- **API Key:** `bitwarden:global/resend-api-key`
- **Status:** Verified ✅

## Docuseal
- **URL:** https://docuseal.alvarodevrace.tech
- **API Token:** `bitwarden:global/docuseal-api-key`
- **Template ID:** 2 | Slug: `mPkXkD7iTpQEWo`

## IA / LLM APIs
- **Gemini API Key:** `bitwarden:global/gemini-api-key`
- **Mistral API Key:** `bitwarden:global/mistral-api-key`
- **OpenRouter API Key:** `bitwarden:global/openrouter-api-key`

## Bitwarden
- **Email:** `alcarreram@hotmail.com`
- **Master password:** cifrada con SOPS + Age en `vault/alvarodevrace/40-Credentials/BITWARDEN-MASTER-KEY.env.enc`
- **Instrucciones:** `vault/alvarodevrace/40-Credentials/BITWARDEN-MASTER-KEY.md`
- **Clave Age pública:** `age19kgpxyhgn8c0tv28lvqe0zws5k0pwhwnp79vsyy0tl2f0hjp0fps734wv6`
- **Clave Age privada:** `bitwarden:global/sops-age-key`

## Planka
- **URL:** https://planka.alvarodevrace.tech
- **Credentials:** `bitwarden:global/planka`

## GitHub
- **User:** alvarodevrace
- **SSH Key:** `~/.ssh/id_ed25519_alvarodevrace`
- **gh CLI:** Autenticado (token en keyring)

## VPS (Hostinger)
- **IP Pública:** 72.60.26.201
- **Tailscale:** 100.105.133.25
- **SSH:** `ssh root@100.105.133.25` (Tailscale) o `ssh root@72.60.26.201`
- **Password:** `bitwarden:global/ssh-root-vps`

## Dell (Desarrollo Local)
- **Tailscale:** 100.88.228.17
- **SSH:** `bitwarden:global/ssh-alvaro-dell`
- **Servicios:** Planka, Crawl4AI (solo jornada)

## Sentry
- **Status:** ✅ Configurado (actualizado 2026-06-05)
- **Proyectos:**
  - `laschubys-app` (Angular): DSN en `bitwarden:global/sentry-dsn-laschubys-app`
  - `laschubys-api` (NestJS): DSN en `bitwarden:global/sentry-dsn-laschubys-api`
- **Dashboards:** https://alvarodevrace.sentry.io/projects/laschubys-app | /laschubys-api

## Evolution API
- **Status:** 🚫 Deprecado / Eliminado del VPS (2026-06-05)
- **DNS:** `evolution.alvarodevrace.tech` apunta a 503 — huérfano. Pendiente limpiar registro DNS.

---

## Tokens Expuestos Detectados — Estado Post-Rotación (2026-06-05)

| Token | Ubicación expuesta | Estado | Acción |
|---|---|---|---|
| n8n API Key | `.env` n8n, logs comandos | ✅ Rotado 2026-06-05 | — |
| Cloudflare API token (global) | `.env` n8n / vault | ✅ Rotado 2026-06-05 | — |
| Cloudflare cache purge token | `.env` n8n (anterior) | 🚫 Eliminado 2026-06-05 (no se usaba) | — |
| Telegram @alvarodevrace_bot | `.env` n8n | ✅ Rotado 2026-06-05 | — |
| Telegram @LasChubysbot | `.env` n8n | ✅ Rotado 2026-06-05 | — |
| Gemini / Mistral / OpenRouter | `.env` n8n | 🚫 Eliminados 2026-06-05 (no se usaban) | — |
| Evolution API tokens | `.env` n8n / Jauria | 🚫 Eliminados 2026-06-05 (servicio deprecado) | — |
| Supabase service role / anon | `.env` n8n (VPS) | ⚠️ Visible en servidor — rotar en próxima ventana de mantenimiento | Rotar en Supabase dashboard |
| Dokploy API key | GitHub Actions / `.env` local | ✅ Rotado 2026-06-25 | Guardado en Bitwarden |

> **Nota:** El `.env` de n8n fue limpiado de variables obsoletas de Jauria el 2026-06-05. Revisar rotación semestral de Supabase y Dokploy según `POLITICA-SECRETOS.md`.
