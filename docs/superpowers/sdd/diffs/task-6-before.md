# Las Chubys — Credenciales e Infraestructura

> **Última actualización**: 2026-06-25 por KIMICO (migración Coolify → Dokploy)
> **Estado**: ✅ Migrado a Dokploy

---

## Cloudflare

| Campo | Valor |
|---|---|
| Dominio | `laschubys.com` |
| Zone ID | `b1bd4dda49d48900eecb9228673ef1e9` |
| API Token | `bitwarden:global/cloudflare-api-token` |

```bash
# Purgar cache laschubys.com
CF_TOKEN=$(bw get password cloudflare-api-token)
curl -X POST "https://api.cloudflare.com/client/v4/zones/b1bd4dda49d48900eecb9228673ef1e9/purge_cache" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"purge_everything": true}'
```

---

## Servicios Principales

| Servicio | URL / ID | Estado |
|---|---|---|
| App Producción | https://laschubys.com | ✅ Healthy |
| Staging | https://laschubys.alvarodevrace.tech | ✅ Healthy |
| n8n | https://n8n.alvarodevrace.tech | ✅ Healthy |
| Supabase (self-hosted) | https://db.alvarodevrace.tech / schema: `laschubys` | ✅ Online |
| Dokploy project `laschubys` | `dcZfubBCdj1wno5hroswj` | ✅ |
| Dokploy `laschubys-app` (Angular 21 SSR) | `XX0AfFKhYHn9ayErXevJF` | ✅ done |
| Dokploy `laschubys-api` (NestJS BFF) | `GzBwWmUjlYRCgfMK6tzBt` | ✅ done |
| GitHub repo frontend | `alvarodevrace/laschubys-app` | ✅ |
| GitHub repo backend | `alvarodevrace/laschubys-api` | ✅ |
| SSH remote frontend | `git@github-alvarodevrace:alvarodevrace/laschubys-app.git` | ✅ |
| SSH remote backend | `git@github-alvarodevrace:alvarodevrace/laschubys-api.git` | ✅ |

---

## Tokens y Credenciales

| Servicio | Referencia |
|---|---|
| Dokploy API Key | `bitwarden:global/dokploy-api-token` |
| n8n API Key | `bitwarden:global/n8n-api-key` |
| Telegram @alvarodevrace_bot | `bitwarden:global/telegram-bot-alvarodevrace` |
| Telegram @LasChubysbot | `bitwarden:global/telegram-bot-laschubys` |
| Cloudflare API Token | `bitwarden:global/cloudflare-api-token` |
| Sentry Frontend DSN | `bitwarden:global/sentry-dsn-laschubys-app` |
| Sentry Backend DSN | `bitwarden:global/sentry-dsn-laschubys-api` |
| Supabase URL | `https://db.alvarodevrace.tech` |
| Supabase Anon Key | `bitwarden:global/supabase-anon-key` |
| Supabase Service Role Key | `bitwarden:global/supabase-service-role-key` |
| Indexing API OAuth2 | `alpepito93@gmail.com` |

---

## GitHub Secrets (Repos)

| Secret | Repos | Uso |
|---|---|---|
| `SENTRY_DSN_LCH_APP` | `laschubys-app` | Sentry Angular |
| `SENTRY_DSN_LCH_API` | `laschubys-api` | Sentry NestJS |
| `DOKPLOY_API_KEY` | Ambos | Deploy automático |
| `DOKPLOY_APP_ID` | `laschubys-app` / `laschubys-api` | ID para deploy |
| `DOKPLOY_URL` | Ambos | URL del panel Dokploy |

---

## Sentry

| Proyecto | Referencia | URL Dashboard |
|---|---|---|
| laschubys-app (frontend) | `bitwarden:global/sentry-dsn-laschubys-app` | https://alvarodevrace.sentry.io/projects/laschubys-app |
| laschubys-api (backend) | `bitwarden:global/sentry-dsn-laschubys-api` | https://alvarodevrace.sentry.io/projects/laschubys-api |

**Endpoint debug**: `GET /api/health/debug-sentry` → lanza error de prueba intencional

---

## Observabilidad

### Uptime Kuma (https://status.alvarodevrace.tech)
| Monitor | URL | Intervalo |
|---|---|---|
| LasChubys Homepage | `https://laschubys.com` | 60s |
| LasChubys API Health | `https://api.laschubys.com/api/health` | 60s |
| LasChubys Sitemap | `https://api.laschubys.com/sitemap.xml` | 300s |
| Supabase REST API | `https://db.alvarodevrace.tech/rest/v1/` | 60s |
| n8n Health | `https://n8n.alvarodevrace.tech/healthz` | 60s |
| Status Page (meta) | `https://status.alvarodevrace.tech` | 300s |
| Dokploy | `https://dokploy.alvarodevrace.tech` | 300s |

**Notificaciones**: Telegram @alvarodevrace_bot

### ~~Netdata~~ — ELIMINADO 2026-06-10
**Estado**: 🚫 Eliminado. No se usaba; Uptime Kuma cubre monitoreo de URLs.
**Reemplazo**: Uptime Kuma + Sentry para métricas y alertas.

---

## n8n Workflows Activos

| Workflow | ID | Estado | Descripción |
|---|---|---|---|
| WF-LCH-SEO-01 | - | ✅ Active | Google Indexing API — Schedule cada hora |
| Telegram bots | - | ✅ Active | Alertas y notificaciones |

---

## Google Tag Manager

| Campo | Valor |
|---|---|
| Container ID | `GTM-KHQH2FT9` |
| Cuenta | AlvaroDevRace |
| Contenedor | laschubys.com |
| Estado | ⏸️ Inactivo — política anti-Google Analytics |

> **Nota**: Umami (self-hosted) es el analytics activo. GTM solo se usaría para estructuras técnicas (JSON-LD, meta tags) si es necesario.

---

## Integraciones Externas

| Servicio | Uso | Estado |
|---|---|---|
| PayPhone | Pagos Ecuador | ✅ Configurado |
| Printful API | Merch / productos | ✅ Configurado |
| MailerSend SMTP | Email (sender `laschubys.com`) | ✅ Configurado |
| Telegram bot | Alertas (bot dedicado Las Chubys) | ✅ Activo |
| Umami Analytics | Analytics self-hosted | ✅ Activo |

---

## Planka

| Campo | Valor |
|---|---|
| Board ID | `1762811413849441959` |
| Lista Todo | `1762811656850638513` |
| Lista In Progress | `1762811660558403250` |
| Lista Done | `1762811663838348979` |
| Lista Backlog | `1763529198758004570` |
| Label TRIN | `1762811429510973099` |
| Label PIXEL | `1762811432765753004` |
| Label LINK | `1762816252952184534` |
| Label EVA | `1762811436188305069` |
| Label Álvaro | `1762811894902556342` |

---

## Dokploy — Deploy

### Automático (GitHub Actions)
Push a `main` en cualquier repo → GitHub Actions → Dokploy API deploy

```bash
# Manual (si GitHub Actions falla)
APP_ID="<DOKPLOY_APP_ID>"
curl -sf -X POST \
  -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d "{\"applicationId\":\"$APP_ID\"}" \
  "https://dokploy.alvarodevrace.tech/api/application.deploy"
```

---

## Stack Técnico (PIXEL)

- `alvarodevrace/laschubys-app` — Angular 21 SSR, puerto 4321
- `alvarodevrace/laschubys-api` — NestJS 11 BFF, puerto 3000
- Package manager: **Bun 1.2+** (`bun.lock` formato texto)
- Astro SSR (legacy) — pausar post cut-over de dominio
- UI referencia: https://wisprflow.ai/

---

## Infraestructura Física

| Servidor | Tailscale IP | Rol | fail2ban | UFW |
|---|---|---|---|---|
| VPS (Hostinger) | `100.105.133.25` | Producción (Dokploy, Supabase, n8n) | ✅ | ✅ |
| Dell (zion-node) | `100.88.228.17` | Staging/Backup (Planka, Crawl4AI, Gotenberg) | ✅ | ✅ |

---

## Git Flow

```
develop → PR → main → auto-deploy Dokploy
```

- **Branch protection `main`**: Requiere 1 review, dismiss stale reviews, enforce admins, no force push
- **Truco para merge propio**: Temporalmente bajar `required_approving_review_count` a 0, mergear, restaurar a 1

---

## SEO — Estado

| Componente | Estado | URL |
|---|---|---|
| Sitemap.xml dinámico | ✅ | `https://api.laschubys.com/api/content/sitemap.xml` |
| JSON-LD Service | ✅ | Inyectado en componentes Angular |
| Google Indexing API | ✅ | n8n WF-LCH-SEO-01, schedule cada hora |
| Meta tags | ✅ | Title, description, canonical, OG, Twitter |
| robots.txt | ✅ | `/robots.txt` |

---

## Checklist de Infra — Estado al 100%

- [x] Sentry SaaS (frontend + backend)
- [x] n8n healthy + variables corregidas
- [x] Telegram bots rotados
- [x] Git flow (develop + main)
- [x] Branch protection main
- [x] GitHub Actions CI/CD
- [x] GitHub Secrets configurados
- [x] Husky + lint-staged (frontend)
- [x] SOPS (.sops.yaml)
- [x] node_modules limpiados del tracking
- [x] Dell fail2ban + UFW
- [x] VPS UFW + fail2ban
- [x] Cache + Throttler (backend)
- [x] Health check (Dokploy)
- [x] Uptime Kuma (7 monitores + Telegram)
- [x] JSON-LD service
- [x] Sitemap.xml dinámico
- [x] Google Indexing API (n8n)
- [x] Migración Coolify → Dokploy completada

## Problemas Conocidos

| Problema | Severidad | Detalle | Próximo paso |
|---|---|---|---|
| Cloudflare API token laschubys.com | 🔴 ALTO | El token devolvió `Authentication error` al intentar purge (2026-06-20). Se purgó manualmente por UI. Rotar token en Cloudflare y actualizar Bitwarden/vault. | Rotar token en Cloudflare + Bitwarden |

**TODO Backlog**:
- [x] Migración Coolify → Dokploy ✅ 2026-06-25
- [ ] Rotar Cloudflare API token laschubys.com
- [ ] Portfolio Angular 21
