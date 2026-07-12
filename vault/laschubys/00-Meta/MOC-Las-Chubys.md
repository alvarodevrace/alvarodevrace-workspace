# 🗺️ MOC Las Chubys (Map of Content)

> **Estado**: ✅ INFRA ESTABLE — 2026-06-25
> **Próximo foco**: Desarrollo de features
> **Nota**: Migración Coolify → Dokploy completada. Deploys gestionados por Dokploy + GitHub Actions.

---

## 📌 Acceso Rápido

| Recurso | URL / Archivo |
|---|---|
| Tags | [[Tags]] |
| Credenciales | [[INFRA]] — Tokens, UUIDs, DSNs, IPs |
| Índice Wiki | [[INDEX]] — Catálogo completo del vault |
| Log principal | [[LOG]] |

---

## 🌐 URLs de Producción

| Servicio | URL | Estado |
|---|---|---|
| 🐱 LasChubys App | https://laschubys.com | ✅ Healthy |
| 🔌 API Health | https://api.laschubys.com/api/health | ✅ ok |
| 🗺️ Sitemap XML | https://api.laschubys.com/api/content/sitemap.xml | ✅ Dinámico (15 URLs) |
| 🗺️ Sitemap (canonical) | https://laschubys.com/sitemap.xml | ✅ Proxy a API (15 URLs) |
| 📊 Uptime Kuma | https://status.alvarodevrace.tech | ✅ 7 monitores |
| ~~Netdata~~ | — | 🚫 Eliminado 2026-06-10 — Uptime Kuma cubre monitoreo |
| ⚙️ n8n | https://n8n.alvarodevrace.tech | ✅ Healthy |
| 🗄️ Supabase | https://db.alvarodevrace.tech | ✅ Online |
| 🐛 Sentry | https://alvarodevrace.sentry.io | ✅ Frontend + Backend |

---

## 🛠️ Infraestructura & Tech

| Componente | Documento | Estado |
|---|---|---|
| Angular 21 + NestJS BFF | [[Angular-BFF]] | ✅ Stack actual |
| Supabase DB + Auth | [[Supabase]] | ✅ RLS + OAuth |
| Content + Auth BFF | [[Content-Auth-BFF]] | ✅ httpOnly cookies |
| n8n Workflows | [[n8n]] | ✅ WF-LCH-* activos |
| Credenciales | [[INFRA]] | ✅ Actualizado 2026-06-09 |

### Infra Checklist ✅

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
- [x] JSON-LD service (Angular)
- [x] Sitemap.xml dinámico (API) — `/api/content/sitemap.xml` ✅
- [x] Sitemap.xml canonical — `/sitemap.xml` ✅ proxy a API
- [x] Google Indexing API (n8n schedule)

---

## 🐱 Producto & Marketing

| Componente | Documento | Estado |
|---|---|---|
| User Personas | [[User-Personas]] | Iris & Rubi |
| SEO Strategy | [[SEO-Strategy]] | Posicionamiento Ecuador |
| SEO Blueprint | [[SEO-Blueprint]] | Detallado |
| Landing Copy | [[Landing-Copy]] | Textos web |
| Ecommerce Logic | [[Ecommerce-Logic]] | Carrito + Checkout |
| Design System | Figma | Tokens + Pantallas |
| Blog Batch 1 | [[Blog-Batch-1]] | 5 artículos listos |

---

## 🔄 Git Flow

```
develop → PR → main → auto-deploy Dokploy
```

- **Repos**: `alvarodevrace/laschubys-app` (frontend) + `alvarodevrace/laschubys-api` (backend)
- **Branch protection**: 1 review, dismiss stale, enforce admins, no force push
- **Truco merge propio**: Bajar temporalmente `required_approving_review_count` a 0

---

## 📂 Logs de Agentes

- [[TRIN-Memory]]
- [[PIXEL-Memory]]
- [[LINK-Memory]]
- [[EVA-Memory]]

---

## 📝 Notas Importantes

- **VPN trabajo**: Bloquea conexiones externas desde Mac. Usar Tailscale.
- **Dell (zion-node)**: `100.88.228.17` — Planka, Crawl4AI, Gotenberg, fail2ban
- **VPS (Hostinger)**: `100.105.133.25` — Dokploy, Supabase, n8n
- **Dokploy deploy**: ✅ auto-deploy vía GitHub Actions (`DOKPLOY_API_KEY` + `DOKPLOY_APP_ID`)
- **Analytics**: Umami (self-hosted). GTM inactivo por política anti-Google.
- **robots.txt**: Agregado 2026-06-09 apuntando a `/api/content/sitemap.xml` (sitemap funcional).
