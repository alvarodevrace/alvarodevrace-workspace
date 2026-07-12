# Migración AlvaroDevRace v2.0 — Estado

**Board Planka:** ver `INFRA-GLOBAL-2026-06.md#planka--tickets--kanban` (Infra / Migración)
**Última actualización:** 2026-06-05

## Progreso: 23/25 tickets Done

### ✅ Done (23)

| Ticket | Descripción |
|---|---|
| INF-1 | SSH hardening |
| INF-2 | Jauria + monitoring down |
| INF-3 | n8n limpio |
| INF-4 | rclone VPS |
| INF-5 | Docker log rotation |
| INF-6 | Cleanup DNS + vault |
| INF-7 | laschubys-api /health + Supavisor |
| INF-8 | Dokploy health checks |
| INF-9 | Sentry SaaS |
| INF-10 | GTM laschubys (GTM-KHQH2FT9) |
| INF-11 | Cloudflare Tunnel activo |
| INF-12 | UFW + fail2ban + unattended-upgrades |
| INF-13 | Secretos migrados Bitwarden + SOPS |
| INF-14 | Uptime Kuma (deploy VPS + 7 monitores + Telegram) |
| INF-15 | Netdata métricas host + alertas RAM/disco |
| INF-16 | Husky + lint-staged (frontend laschubys-ng) |
| INF-17 | GitHub Actions CI/CD laschubys-app + laschubys-api |
| INF-18 | Supabase CLI en CI + migrations versionadas |
| INF-19 | SEO JSON-LD server-side (Product, BlogPosting, Organization) |
| INF-20 | Sitemap.xml dinámico desde API |
| INF-21 | n8n Google Indexing API (WF-LCH-SEO-01) |
| INF-22 | Restore drill mensual — ejecutado 2026-06-04 ✅ |
| INF-23 | RUNBOOK-INCIDENTES.md — creado en vault/infra/20-Tech/ |

### 📋 Pendientes (2)

| Ticket | Descripción | Prioridad |
|---|---|---|
| INF-24 | OpenTofu cloudflare-dns (DNS como código, módulo base en infra/tofu/) | Baja |
| INF-25 | Dell: ChromaDB + Browserless + Flowise (eliminados 2026-06-05 por no usarse; ticket cierra como WONTFIX) | Baja |

## IDs críticos de la sesión 2026-05-22

| Recurso | Valor |
|---|---|
| Cloudflare Zone ID | ver `INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel` |
| CF Tunnel ID | ver `INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel` |
| GTM Container ID | `GTM-KHQH2FT9` *(proyecto Las Chubys; se mantiene aquí por contexto)* |
| Age public key | ver `INFRA-GLOBAL-2026-06.md#secretos-maestros--referencias-bitwarden` |
| Age key file Mac | `~/.age/alvarodevrace.txt` *(ruta local)* |
| Bitwarden folder ID | ver `INFRA-GLOBAL-2026-06.md#secretos-maestros--referencias-bitwarden` |
| SSH VPS (Tailscale) | ver `INFRA-GLOBAL-2026-06.md#nodos` |

## Links relacionados

- [[Cloudflare-DNS]] — migración DNS
- [[CF-Tunnel]] — tunnel activo
- [[UFW-Fail2ban]] — hardening
- [[POLITICA-SECRETOS]] — Bitwarden + SOPS
- [[SOPS-GUIDE]] — guía uso SOPS
