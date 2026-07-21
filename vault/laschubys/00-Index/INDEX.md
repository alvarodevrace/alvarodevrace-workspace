# Las Chubys — Índice Wiki

> **Estado Infra**: ✅ VPS recuperado — 2026-07-21: VPS Hostinger estuvo caído desde 2026-07-12 por hypervisor-initiated shutdown; encendido manualmente y todos los servicios responden 200. Watchdog local macOS implementado para detectar futuras caídas (`scripts/vps-health-check.sh`). Entorno local dev estabilizado — 2026-07-13: `.env` del back apunta a Supabase develop, SSR front carga `.env` vía `dotenv`, throttle global desactivado en dev. Cambios locales unstaged pendientes de commit.
> **Listo para**: Validar en browser real errores de CSP; validar ejecución automática del backup script (cron 03:00); monitorear workflows n8n; commit local de fixes dev y crear PRs.
> **Último trabajo**: Recuperación VPS caído + watchdog local macOS. Registrado en [LOG.md](../10-Log/LOG.md).

---

Catálogo de páginas. Para buscar: `grep -r "Keyword" vault/laschubys/`

## 00-Meta (contexto del proyecto)

| Página | Contenido |
|---|---|
| [MOC-Las-Chubys.md](../00-Meta/MOC-Las-Chubys.md) | Map of Contents — visión general |
| [Tags.md](../00-Meta/Tags.md) | Taxonomía de tags del vault |

## 10-Log (historial de sesiones)

| Página | Contenido |
|---|---|
| [LOG.md](../10-Log/LOG.md) | Log principal de sesiones |
| [restore-drill-2026-06-04.md](../10-Log/restore-drill-2026-06-04.md) | Drills de restauración |
| [archive/](../10-Log/archive/) | Logs históricos por agente y fecha |

## 20-Tech (arquitectura y decisiones técnicas)

| Página | Contenido |
|---|---|
| [Angular-BFF.md](../20-Tech/Angular-BFF.md) | **Stack actual** — Angular 21 SSR + NestJS BFF, Dokploy IDs, cut-over completado |
| [Content-Auth-BFF.md](../20-Tech/Content-Auth-BFF.md) | Endpoints de contenido + auth backend con cookies httpOnly |
| [Motion-Animations.md](../20-Tech/Motion-Animations.md) | Sistema de animaciones Motion SSR-safe (directivas + componentes reutilizables) |
| [Spartan-Migration.md](../20-Tech/Spartan-Migration.md) | **Migración UI** del frontend a spartan.ng — componentes, mapeos, build status y pendientes |
| [Supabase.md](../20-Tech/Supabase.md) | Schema, RLS, Auth Google OAuth |
| [n8n.md](../20-Tech/n8n.md) | Workflows WF-LCH-*, webhooks |
| [Resource-Limits.md](../20-Tech/Resource-Limits.md) | Límites de memoria/CPU y reinicio de contenedores |
| [RUNBOOK-LCH.md](../20-Tech/RUNBOOK-LCH.md) | Runbook de incidentes de producción |
| [Architecture.md](../20-Tech/Architecture.md) | Diagrama de arquitectura y flujos críticos |
| [n8n/workflows/](../20-Tech/n8n/workflows/) | JSON exportable de workflows n8n |
| [decisions/](../20-Tech/decisions/) | Decisiones técnicas recientes (Engram, Gentleman, local dev fixes) |

## 30-Product (features y roadmap)

| Página | Contenido |
|---|---|
| [Ecommerce-Logic.md](../30-Product/Ecommerce-Logic.md) | Lógica de compras, PayPhone, Printful |
| [SEO-Strategy.md](../30-Product/SEO-Strategy.md) | Estrategia SEO, contenido |
| [SEO-Blueprint.md](../30-Product/SEO-Blueprint.md) | Blueprint SEO detallado |
| [Landing-Copy.md](../30-Product/Landing-Copy.md) | Copy para la Landing Page |
| [Blog-Batch-1/](../30-Product/Blog-Batch-1/) | Primer lote de 5 artículos |

## 40-Credentials (infra y accesos)

| Página | Contenido |
|---|---|
| [INFRA.md](../40-Credentials/INFRA.md) | **Credenciales actualizadas**, IDs Planka, Dokploy IDs, Supabase ID, tokens, Sentry DSNs, Uptime Kuma |

---

## Convenciones

- Tickets: `LCH-XXX` (Planka board `1762811413849441959`)
- n8n prefix: `WF-LCH-*`
- Webhooks: `/webhook/lch-*`
- Git: `develop` → PR → `main` → auto-deploy Dokploy
- Branch protection: 1 review requerido, enforce admins, no force push

## Workflow y calidad

| Herramienta | Estado | Nota |
|---|---|---|
| GGA pre-commit | ❌ | Descartado: requiere provider externo; no compatible con "solo Kimi" |
| SDD skills | ✅ | Skills locales `sdd-*` adaptadas a Kimi Code en `Las Chubys/.kimi/skills/` |
| Auto-delete branch | ✅ | Habilitado en GitHub para `laschubys-app` y `laschubys-api` |
| Ramas mergeadas | ✅ | Limpieza realizada 2026-07-13 |
| Engram ritual | ✅ | Documentado en `agents/KIMI-AGENTS.md` y AGENTS.md de front/back |
| Worktrees | ⏳ | Pendiente fase 2 |

## Estado Rápido

| Servicio | URL | Estado |
|---|---|---|
| App | https://laschubys.com | ✅ Healthy |
| API | https://api.laschubys.com/api/health | ✅ {"status":"ok"} |
| Sitemap (funcional) | https://api.laschubys.com/api/content/sitemap.xml | ✅ Dinámico (15 URLs) |
| Sitemap (canonical) | https://laschubys.com/sitemap.xml | ✅ Proxy a API (15 URLs) |
| robots.txt | https://laschubys.com/robots.txt | ✅ Cache Cloudflare expira ~23:50 UTC |
| Uptime Kuma | https://status.alvarodevrace.tech | ✅ v2.4.0 — 10 monitores activos |
| Dokploy | http://100.105.133.25:3000 | ✅ v0.29.11 |
| ~~Netdata~~ | — | 🚫 Eliminado 2026-06-10 |
| n8n | https://n8n.alvarodevrace.tech | ✅ Healthy |
