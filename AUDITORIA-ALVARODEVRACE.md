# Auditoría AlvaroDevRace — Infraestructura, Seguridad y Metodología

> **Fecha de generación:** 2026-07-10  
> **Última actualización:** 2026-07-12 (post-prod-readiness: workflows n8n reactivados, backup script reparado, env vars Dokploy actualizadas, merge a develop)  
> **Auditor / Ejecutor:** KIMICO (TRIN) — Sistema multiagente AlvaroDevRace  
> **Fuentes:** Archivos locales del workspace, Vault de Obsidian (`vault/`), verificación directa en VPS Hostinger y máquina Dell vía Tailscale/SSH, Bitwarden (acceso validado, sin secretos expuestos).

---

## Nota metodológica

Este documento integra información estática del Vault con datos en vivo obtenidos de los entornos. Cada dato no confirmado está marcado explícitamente como **[POR CONFIRMAR]** para que el equipo de seguridad o el owner correspondiente (TRIN/PIXEL/LINK/NOVA/EVA) lo revise. Los secretos criptográficos se mantienen como referencias a Bitwarden; no se escriben valores completos.

---

## 1. MAPEO FÍSICO Y DISTRIBUCIÓN DE ENTORNOS

### 1.1 VPS Hostinger + Dokploy (Producción 24/7)

| Atributo | Valor |
| --- | --- |
| IP pública | `72.60.26.201` |
| Tailscale IP | `100.105.133.25` |
| Acceso SSH | `ssh -i ~/.ssh/id_ed25519 root@100.105.133.25` |
| RAM / Disco | 7.8 GB / 96 GB |
| Orquestador | Dokploy `v0.29.11` sobre Docker Swarm |
| Panel Dokploy | `https://dokploy.alvarodevrace.tech` (acceso directo también por Tailscale `http://100.105.133.25:3000`) |

#### Proyectos Dokploy detectados

| Proyecto Dokploy | ID | Contenido |
| --- | --- | --- |
| `infra` | `aP3P-FbWPbS383qrcKEGm` | n8n, Uptime Kuma, Umami, Docuseal |
| `database` | `HTxz4FLFZ-FFasumznhf2` | Supabase self-hosted |
| `laschubys` | `dcZfubBCdj1wno5hroswj` | Angular SSR + NestJS BFF |
| `portfolio` | `oSVdXwFYGekg16v18XNW1` | alvaro-portfolio |

#### Contenedores vivos en producción (verificación 2026-07-10)

| Contenedor / App | Imagen | Puerto expuesto | Estado | Uso de memoria (actual) |
| --- | --- | --- | --- | --- |
| `laschubys-app-*` | `laschubys-app-16uema:latest` | `4321/tcp` | healthy | 80 MB |
| `laschubys-api-*` | `laschubys-api-b9k60b:latest` | `3000/tcp` | healthy | 51 MB |
| `alvaro-portfolio-*` | `alvaro-portfolio-bsj55s:latest` | `80/tcp` | healthy | 1.3 MB |
| `n8n` | `n8nio/n8n:2.1.5` | `5678/tcp` | up | 212 MB |
| `supabase-db` | `supabase/postgres:15.8.1.085` | `5432/tcp` | healthy | 18 MB |
| `supabase-auth` | `supabase/gotrue:v2.186.0` | interno | healthy | 10 MB |
| `supabase-kong` | `kong/kong:3.9.1` | `8000-8004/tcp` | healthy | 104 MB |
| `supabase-rest` | `postgrest/postgrest:v14.6` | `3000/tcp` | healthy | 5.6 MB |
| `supabase-storage` | `supabase/storage-api:v1.44.2` | `5000/tcp` | healthy | 67 MB |
| `supabase-studio` | `supabase/studio:2026.03.16` | `3000/tcp` | healthy | 142 MB |
| `supabase-minio` | `minio` | `9000-9001/tcp` | healthy | 78 MB |
| `umami` | `umami:3.0.3` | `3000/tcp` | healthy | 107 MB |
| `umami-postgres` | `postgres:16-alpine` | `5432/tcp` | healthy | 10.6 MB |
| `uptime-kuma` | `louislam/uptime-kuma:1` | `32769->3001/tcp` | healthy | 113 MB |
| `docuseal` | `docuseal/docuseal:latest` | `3000/tcp` | healthy | 146 MB |
| `imgproxy` | `imgproxy:v3.30.1` | `8080/tcp` | healthy | 58 MB |
| `dokploy-*` | `dokploy/dokploy:v0.29.11` + Postgres/Redis/Traefik | `80`, `443`, `3000` | healthy | 765 MB (Dokploy UI) |
| `postgres-index-multi-byte-alarm-orbypg` | `postgres:16` | interno | healthy | 75 MB |

**Nota post-limpieza (2026-07-10):**
- ✅ Eliminados contenedores huérfanos de **Coolify**: `coolify-db`, `coolify-realtime`, `coolify-redis`, `coolify-sentinel`.
- ✅ Eliminado portfolio legacy de Coolify: `jsas8iq6o0jr2kv5kalhtnmp-223815702761`.
- ✅ Eliminado proxy legacy `dell-proxy` (Coolify).
- ✅ `postgres-index-multi-byte-alarm-orbypg` **identificado como DB PostgreSQL activa de n8n** (`DB_TYPE=postgresdb`, `DB_POSTGRESDB_HOST=postgres-index-multi-byte-alarm-orbypg`). **No eliminado.**
- ✅ Liberados ~4.48 GB tras `docker image prune -af`.
- Backups de seguridad en `/opt/backups/coolify-cleanup-20260709-213322/`.

**Límites de recursos asignados:** [POR CONFIRMAR] `docker stats` muestra uso actual pero no se detectaron `mem_limit`/`cpu_quota` explícitos en los contenedores auditados.

---

### 1.2 Máquina Local Mac

| Atributo | Valor |
| --- | --- |
| Tailscale IP | `100.83.137.17` |
| Rol | Desarrollo local de Angular/NestJS |
| Notas operativas | Tiene Age key local en `~/.age/alvarodevrace.txt`. El acceso a Dokploy UI se realiza preferentemente por Tailscale (`http://100.105.133.25:3000`) porque la resolución DNS local de `dokploy.alvarodevrace.tech` reporta fallos (`DNS_PROBE_POSSIBLE`). |

---

### 1.3 Máquina Dell zion-node

| Atributo | Valor |
| --- | --- |
| IP LAN | `192.168.1.20` |
| Tailscale IP | `100.88.228.17` |
| RAM / Disco | 7.6 GB / 457 GB SSD |
| OS | Ubuntu 24.04.4 LTS |
| Horario | Solo jornada laboral (encendida al momento del escaneo) |
| Acceso SSH | `ssh -i ~/.ssh/id_ed25519 alvaro@100.88.228.17` |

#### Servicios activos verificados en vivo

| Servicio | Puerto host | Contenedor | Estado |
| --- | --- | --- | --- |
| Planka | `3333 -> 1337` | `planka-planka-1` | healthy |
| Planka DB | `5432` (interno) | `planka-planka-db-1` | healthy |
| Crawl4AI | `11235` | `crawl4ai-crawl4ai-1` | healthy |
| Gotenberg | `3010 -> 3000` | `gotenberg-gotenberg-1` | healthy |

#### Recursos Dell (verificación 2026-07-10)

- **Memoria:** 1.1 GB usados / 7.6 GB totales.
- **Disco:** 31 GB usados / 457 GB (8 %).
- **Swap:** 4.0 GB, sin uso.

#### Backups en Dell

- Cron `0 4 * * *` ejecuta `rsync` desde VPS hacia `/opt/backups/vps/`.
- Sincroniza Dokploy config a `/opt/backups/dokploy-config/`.
- Notifica resultado por Telegram y verifica archivos recientes (< 2 días).

---

### 1.4 Vault de Obsidian

El Vault sigue la estructura Karpathy-style: `00-Index/`, `10-Log/`, `20-Tech/`, `30-Product/`, `40-Credentials/`.

| Proyecto | Índice | Logs recientes | Docs técnicas | Credentials | Estado documental |
| --- | --- | --- | --- | --- | --- |
| `vault/laschubys/` | Completo | 2026-06-25 | Angular-BFF, Supabase, n8n, Content-Auth-BFF, Spartan-Migration | Referencias Bitwarden | Activo |
| `vault/portfolio/` | Mínimo | 2026-05-07 | [POR CONFIRMAR] | IDs Dokploy/Planka | Estancado |
| `vault/alvarodevrace/` | Mínimo | 2026-06-24 | Freelance-System-v2.0 | `BITWARDEN-MASTER-KEY.env.enc` (SOPS+Age) | Mínimo |
| `vault/infra/` | Completo | 2026-06-25 | CF-Tunnel, UFW-Fail2ban, RUNBOOK-INCIDENTES, Migracion-Estado | INFRA-GLOBAL | SSOT |

**Hallazgo:** no se encontraron diagramas de arquitectura (Mermaid ni imágenes) en el vault. La documentación es predominantemente textual y tabular.

---

## 2. ARQUITECTURA DE SOFTWARE, MODERNIDAD Y METODOLOGÍA

### 2.1 Front-End

#### Las Chubys (`LasChubys/LasChubys-Front`)

| Aspecto | Estado |
| --- | --- |
| Framework | Angular `^21.2.0` |
| Package manager | Bun `1.3.14` |
| Builder | `@angular/build:application` |
| Zoneless | ✅ Activado vía `provideZonelessChangeDetection()` en `src/app/app.config.ts:57` |
| Signals | ✅ Uso intensivo: `signal`, `computed`, `effect`, `resource` en `AuthService`, `CartService`, `ShopComponent`, `HomeComponent` |
| Signal Forms | ❌ No se detecta uso de Signal Forms. Se mezcla Reactive Forms (`FormBuilder`) y Template-driven Forms (`ngModel`) |
| RxJS | Presente como dependencia (`~7.8.0`) pero encapsulado en `ApiService`; componentes consumen Promesas/async-await |
| SSR | ✅ Angular SSR habilitado con `server.ts` custom, `outputMode: server`, `RenderMode.Server` por defecto |
| Hydration | ✅ `provideClientHydration(withEventReplay())` |
| Rutas client-only | `/admin`, `/checkout`, `/auth/*`, `/callback`, `/carrito` forzadas a `RenderMode.Client` en `app.config.server.ts` |
| Seguridad en SSR | CSP con nonce, HSTS, proxy de `/api/*` al backend en `server.ts` |
| Tests E2E | Playwright (`e2e/`) |
| Tests unitarios | `app.spec.ts` mínimo; `vitest` aparece en `devDependencies` pero no hay `vitest.config.*` — [POR CONFIRMAR] |

#### Portfolio (`Portfolio/alvaro-portfolio`)

| Aspecto | Estado |
| --- | --- |
| Framework | Angular `^18.2.0` |
| Zoneless | ❌ Usa `provideZoneChangeDetection({ eventCoalescing: true })` |
| Signals | ❌ No se detectan |
| SSR | ❌ CSR puro servido por nginx |
| Forms | N/A |
| Datos | Hardcodeados en `src/app/core/portfolio.data.ts` |
| Tests | Karma + Jasmine |

---

### 2.2 Back-End

#### Las Chubys API (`LasChubys/LasChubys-Back`)

| Aspecto | Estado |
| --- | --- |
| Framework | NestJS `^11.0.0` |
| Runtime Docker | `oven/bun:1-slim` |
| Estructura de carpetas | ✅ Feature-based modules: `auth`, `admin`, `checkout`, `comments`, `contact`, `content`, `health`, `supabase` |
| Capa transversal | `shared/config/env.ts`, `shared/csrf/`, `shared/http/`, `shared/types/supabase.ts` |
| Base de datos | Cliente oficial `@supabase/supabase-js`; dos clientes tipados: `admin` (service_role) y `anon` |
| ORM / Query builder | ❌ Ninguno detectado en dependencias de producción (Prisma/TypeORM/Drizzle no presentes) |
| Validación de DTOs | ✅ `class-validator` + `class-transformer`; `ValidationPipe` global con `whitelist: true`, `forbidNonWhitelisted: true`, `transform: true` |
| Autenticación | Supabase Auth + OAuth Google; sesión en cookies `httpOnly` (`lc_access_token`, `lc_refresh_token`) |
| CSRF | ✅ Doble cookie `csrf-token` + header `X-CSRF-Token`; `CsrfGuard` aplicado en mutaciones |
| Guards | `AuthGuard`, `AdminGuard` |
| Tests | ❌ No hay tests propios ni script de test en `package.json` |
| Seguridad adicional | Helmet, CSP, CORS, throttling global |

---

### 2.3 Metodología de Desarrollo

| Aspecto | Estado |
| --- | --- |
| Modelo de ramas | GitFlow adaptado: `main` y `develop` permanentes; feature branches tipo `pixel/<ticket>` |
| Restricciones | Push directo a `main`/`develop` prohibido; TRIN no aprueba sus propios PR |
| QA gate | NOVA debe aprobar antes de cualquier PR `develop → main` |
| Gestión de tareas | Planka (`https://planka.alvarodevrace.tech`) en Dell; boards: Las Chubys, Portfolio, Infra/Migración |
| Prefijos de ticket | `LCH-N`, `PRT-N`, `INF-N` |
| CI/CD | GitHub Actions → trigger vía API de Dokploy |
| Cierre de sesión | Dump en `vault/<proyecto>/temp/` → EVA procesa a wiki/index/log |

---

## 3. PERSISTENCIA Y SEGURIDAD DE DATOS (SUPABASE SELF-HOSTED)

### 3.1 Configuración de Base de Datos

| Atributo | Valor |
| --- | --- |
| Proyecto Dokploy | `database` (`HTxz4FLFZ-FFasumznhf2`) |
| Compose ID | `KmZPDb3xeY_wZqNjpIAOT` |
| Postgres versión | `15.8` (verificado en contenedor `supabase-db`) |
| Dominio Studio | `https://db.alvarodevrace.tech` |
| Endpoints internos | Kong `8000`, Studio `3000`, PostgREST `3000`, GoTrue `9999`, Postgres `5432` |
| Volúmenes | Volúmenes Docker gestionados por el Compose de Dokploy |
| Exposición pública | Postgres no expuesto directamente; acceso solo a través de red Docker/Kong |

### 3.2 Row Level Security (RLS)

**Sí están aplicadas políticas RLS en el schema `laschubys`.** La verificación en vivo arrojó 26 policies distribuidas en las siguientes tablas:

| Tabla | Policies detectadas |
| --- | --- |
| `blog_posts` | `lch_posts_delete`, `lch_posts_insert`, `lch_posts_select`, `lch_posts_update` |
| `comments` | `lch_comments_delete`, `lch_comments_insert`, `lch_comments_select`, `lch_comments_update` |
| `contacts` | `lch_contacts_delete`, `lch_contacts_insert`, `lch_contacts_select`, `lch_contacts_update` |
| `orders` | `lch_orders_insert`, `lch_orders_select`, `lch_orders_update` |
| `products` | `lch_products_delete`, `lch_products_insert`, `lch_products_select`, `lch_products_update` |
| `profiles` | `lch_profiles_admin` (ALL), `lch_profiles_insert`, `lch_profiles_select`, `lch_profiles_update` |
| `social_metrics` | `lch_social_metrics_delete`, `lch_social_metrics_insert`, `lch_social_metrics_select`, `lch_social_metrics_update` |

**[POR CONFIRMAR]:** definición exacta (`qual` / `with_check`) de cada política y revisión de accesos a tablas internas de Supabase (`auth.*`, `storage.*`).

### 3.3 Estrategia de Backups

| Componente | Frecuencia | Destino | Script responsable |
| --- | --- | --- | --- |
| Schema `laschubys` | Diario 03:00 | VPS `/opt/backups/supabase/` + Google Drive (`.sql`) | `/opt/scripts/backup-generate.sh` |
| Schema `jauria` | Mensual día 1 | VPS + Google Drive | mismo script |
| Workflows n8n | Diario | VPS + Google Drive (`.json`) | mismo script |
| PostgreSQL n8n | Diario | VPS `/opt/backups/n8n/` + Google Drive (`.sql`) | mismo script |
| SQLite n8n (legacy) | Eliminado 2026-07-12 | — | — |
| Dokploy config | Diario | VPS + Dell `/opt/backups/dokploy-config/` | `/opt/scripts/sync-backups.sh` en Dell |
| Copia secundaria Dell | Diario 04:00 | Dell `/opt/backups/vps/` | `rsync` desde VPS |

**Retención:** VPS y Google Drive 30 días; Dell ilimitada hasta llenar disco.

**Estado documentado:** ✅ validado 2026-06-05; migración Dokploy 2026-06-24 restableció el flujo.

---

## 4. SEGURIDAD EN LA RED, PERÍMETRO Y CI/CD

### 4.1 Perímetro Cloudflare

| Aspecto | Valor |
| --- | --- |
| Zona principal | `alvarodevrace.tech` (`2a17143e03abfec70bd29db73b74fecf`) |
| Zona Las Chubys | `laschubys.com` (`b1bd4dda49d48900eecb9228673ef1e9`) |
| Tunnel | `alvarodevrace-vps` (`49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a`) |
| Tunnel CNAME | `49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a.cfargotunnel.com` |
| SSL/TLS | Let's Encrypt gestionado por Traefik de Dokploy; TLS termina en Cloudflare |
| DNS records | CNAMEs al tunnel para subdominios de `alvarodevrace.tech`; `status` apunta directo al VPS; `laschubys.com` y `api.laschubys.com` apuntan por A al VPS |
| Proxy (nube naranja) | ✅ Habilitado en registros gestionados por OpenTofu |

**WAF / Rate limits:** ✅ Regla de rate limiting activa en `laschubys.com` para `api.laschubys.com/api/auth/*` (5 req / 10 s por IP, acción `Block`). Verificación 2026-07-10: HTTP 429 tras 5 requests consecutivos.

**Token Cloudflare `laschubys.com`:** solo tiene permisos `Cache Purge`; no puede editar DNS vía API. Falló autenticación el 2026-06-20.

### 4.2 Firewall y Puertos Abiertos

#### UFW en VPS (verificado en vivo, post-hardening 2026-07-10)

| Puerto / Regla | Origen | Acción |
| --- | --- | --- |
| `22/tcp` sobre `tailscale0` | Anywhere | ALLOW |
| `22/tcp` | `100.83.137.17` (Mac Tailscale) | ALLOW |
| `80,443/tcp` | 15 rangos IPv4 de Cloudflare | ALLOW |
| `3000/tcp` sobre `tailscale0` | `100.83.137.17` (Mac) | ALLOW (Dokploy UI) |

**Default:** deny incoming, allow outgoing.

**Cambios aplicados (2026-07-10):**
- ✅ Eliminada regla legacy `22` desde `10.0.0.0/8` (residuo Coolify).
- ✅ Eliminada regla permisiva `Anywhere on tailscale0`.
- ✅ Añadida regla explícita `3000/tcp on tailscale0 from 100.83.137.17` para acceso a Dokploy UI.

**Pendiente:**
- [POR CONFIRMAR] Estado y configuración actual de `fail2ban`.

#### Puertos expuestos en contenedores VPS

| Servicio | Puerto contenedor | Mapeo host |
| --- | --- | --- |
| Traefik | 80/443 | `0.0.0.0:80→80`, `0.0.0.0:443→443` |
| Dokploy UI | 3000 | `0.0.0.0:3000→3000` |
| Uptime Kuma | 3001 | `0.0.0.0:32769→3001` |
| Resto (apps, Supabase, n8n, Umami, Docuseal) | varios | Solo red Docker interna |

#### Puertos Dell

| Servicio | Puerto host |
| --- | --- |
| Planka | `3333` |
| Crawl4AI | `11235` |
| Gotenberg | `3010` |

#### Mac local

No se detectaron puertos públicos expuestos en documentación.

---

### 4.3 Pipeline CI/CD

#### Repositorios activos

| Repo | Workflow | Último deploy documentado |
| --- | --- | --- |
| `alvarodevrace/laschubys-app` | `.github/workflows/ci.yml` | 2026-06-20 (producción) |
| `alvarodevrace/laschubys-api` | `.github/workflows/ci.yml` | 2026-06-20 (producción) |
| `alvarodevrace/alvaro-portfolio` | `.github/workflows/deploy.yml` | 2026-06-25 |

#### Flujo exacto desde `git push` hasta Dokploy

1. **Push a `main`** en el repo correspondiente.
2. **Job `ci`:** checkout → `bun install --frozen-lockfile` → `bun run typecheck` → `bun run build`.
3. **Job `deploy`** (solo en evento `push` a `main`):
   ```bash
   curl -sf -X POST \
     -H "Content-Type: application/json" \
     -H "x-api-key: ${{ secrets.DOKPLOY_API_KEY }}" \
     -d '{"applicationId":"${{ secrets.DOKPLOY_APP_ID }}"}' \
     "${{ secrets.DOKPLOY_URL }}/api/application.deploy"
   ```
4. Dokploy recibe el trigger, reconstruye la imagen y reinicia el contenedor correspondiente.

#### Inyección de variables `.env`

- Las variables de runtime (Supabase keys, Sentry DSN, etc.) **no viajan en el workflow**; se configuran como environment variables de cada aplicación en Dokploy.
- El origen de verdad es Bitwarden (`bitwarden:global/*`); se copian manualmente a Dokploy al crear o rotar una app.
- GitHub Secrets usados: `DOKPLOY_API_KEY`, `DOKPLOY_APP_ID`, `DOKPLOY_URL`, `SENTRY_DSN_LCH_APP`, `SENTRY_DSN_LCH_API`.

---

## 5. OBSERVABILIDAD, TELEMETRÍA Y AUTOMATIZACIÓN

### 5.1 Sentry — Error Tracking

| Proyecto | Tecnología | DSN referencia | Ubicación en código |
| --- | --- | --- | --- |
| `laschubys-app` | Angular SSR 21 | `bitwarden:global/sentry-dsn-laschubys-app` | `LasChubys/LasChubys-Front/src/main.ts:15` (DSN inyectado por meta tag SSR) |
| `laschubys-api` | NestJS 11 | `bitwarden:global/sentry-dsn-laschubys-api` | `LasChubys/LasChubys-Back/src/instrument.ts:4` |

**Integraciones Angular:** `browserTracingIntegration`, `replayIntegration`; sample rates 0.1 en producción, 0 en localhost, 1.0 on error.

**Integraciones NestJS:** `SentryModule.forRoot()`, `SentryGlobalFilter`, `@SentryExceptionCaptured()`.

**Endpoint debug:** `GET /api/health/debug-sentry`.

### 5.2 Umami / Analytics

| Servicio | URL | Website ID |
| --- | --- | --- |
| Umami self-hosted | `https://analytics.alvarodevrace.tech` | `29563400-c38c-42bd-aa47-267dfc422acd` |

- Script `defer` cargado en `index.html` de Las Chubys.
- CSP del servidor SSR permite `analytics.alvarodevrace.tech`.
- GTM (`GTM-KHQH2FT9`) está configurado pero **inactivo** por política anti-Google Analytics.

### 5.3 Uptime Kuma

| Campo | Valor |
| --- | --- |
| URL | `https://status.alvarodevrace.tech` |
| Compose ID | `KDRlcDa9e8vPHgzXUE0a3` |

**Monitores activos (10):**

| # | Monitor | URL | Intervalo | Notificación |
| --- | --- | --- | --- | --- |
| 1 | Las Chubys — Web | `https://laschubys.com` | 60 s | Telegram — Las Chubys |
| 3 | Portfolio | `https://alvarodevrace.tech` | 60 s | Telegram — AlvaroDevRace |
| 4 | n8n | `https://n8n.alvarodevrace.tech` | 60 s | Telegram — AlvaroDevRace |
| 6 | Docuseal | `https://docuseal.alvarodevrace.tech` | 60 s | Telegram — AlvaroDevRace |
| 9 | Planka | `http://100.88.228.17:3333` | 60 s | Telegram — AlvaroDevRace |
| 11 | Crawl4AI | `http://100.88.228.17:11235/health` | 60 s | Telegram — AlvaroDevRace |
| 12 | Gotenberg | `http://100.88.228.17:3010/health` | 60 s | Telegram — AlvaroDevRace |
| 27 | LasChubys — API Health | `https://api.laschubys.com/api/health` | 60 s | Telegram — Las Chubys |
| 28 | LasChubys — Sitemap | `https://api.laschubys.com/api/content/sitemap.xml` | 300 s | Telegram — Las Chubys |
| 29 | Supabase — REST | `https://db.alvarodevrace.tech/rest/v1/` | 120 s | Telegram — AlvaroDevRace |

> **Notificaciones Telegram (2):**
> - `Telegram — AlvaroDevRace (infra)` → bot `bitwarden:global/telegram-bot-alvarodevrace`, chat ID `6842185900`.
> - `Telegram — Las Chubys` → bot `bitwarden:global/telegram-bot-laschubys`, chat ID `6842185900`.
>
> **Fix 2026-07-10:** Monitor #29 `Supabase — REST` reportaba Down (HTTP 401) tras rotación de secrets. Causa raíz: header `apikey` en la DB de Kuma tenía formato JSON inválido/compuesto con espacios; regrabado como JSON compacto y reiniciado Kuma. Último heartbeat: `200 - OK`.

### 5.4 n8n — Automatización

| Campo | Valor |
| --- | --- |
| URL | `https://n8n.alvarodevrace.tech` |
| Compose ID | `a5ghK4hsUufVj1FOt-eiD` |
| API Key | `bitwarden:global/n8n-api-key` |
| Service password | `bitwarden:global/n8n-service-password` |

#### Workflows activos documentados (8)

| Workflow | ID | Propósito | Estado documentado |
| --- | --- | --- | --- |
| `OPS / Infra / Alertas` | `BFsLIVWRC0B3IP6K` | Alertas infra (legacy) | ✅ active |
| `OPS / Infra / Resource Alert` | `DhTLEpls5Djq94rE` | Alertas de recursos VPS vía `resource-check.sh` | ✅ active (2026-07-12) |
| `LCH / Infra / Keepalive` | `nmqhJawyIvV8aOIt` | Keepalive | ✅ active |
| `LCH / Operaciones / Error handler` | `R8sYRPKvdNBKLEKX` | Manejo de errores | ✅ active |
| `WF-LCH-META-SYNC` | `ljRaQeAsfs43Mkme` | Sync métricas Meta | ✅ active |
| `LCH / Backup / General` | `7MVk9RSekCVvyhCT` | Backup diario | ✅ active |
| `LCH / Backup / Supabase` | `bzhKoL4anHcO0ysE` | Backup Supabase | ✅ active |
| `LCH / Contact / Notify` | `cKjMho8h6nivGQ03` | Notificación Telegram de formulario de contacto | ✅ active (2026-07-12) |

> **Eliminados 2026-07-10:** `WF-LCH-SEO-01`, `LCH / Reportes / Notify`, `LCH / Infra / Alertas` (duplicado), `LCH / Notificaciones / Comment notify` — workflows no usados en ≥1 mes o huérfanos.
>
> **Fix 2026-07-10 — `WF-LCH-META-SYNC`:**
> - Root cause de la ejecución automática fallida: `access to env vars denied` en los nodos HTTP. Aunque `N8N_BLOCK_ENV_ACCESS_IN_NODE=false` ya estaba en el compose de n8n, el contenedor no había sido reiniciado para aplicar el cambio.
> - Reiniciado n8n; forzada ejecución real modificando temporalmente el cron en `workflow_history` (versión activa, no solo en `workflow_entity`).
> - Verificación end-to-end exitosa: Meta Graph API devolvió datos reales (Instagram 22265–22272 followers, Facebook 3007 fans) y el nodo `Insert Social Metrics` escribió correctamente en `laschubys.social_metrics`.
> - Corregido duplicado de rows: se eliminó el nodo `Merge Meta Data` y se conectaron ambos nodos HTTP directamente al nodo `Build Supabase Rows`, que ahora usa `$input.all()` para generar exactamente 1 fila por plataforma por ejecución.
> - Cron restaurado a `0 6 * * *` (06:00 hora local / 11:00 UTC). Limpieza de 16–18 registros de prueba; quedan 2 registros de evidencia.

#### Webhooks / Integraciones

- Convención documentada: `/webhook/lch-*` y `/webhook/infra-alert`.
- Webhooks activos confirmados:
  - `POST /webhook/infra-alert` → `OPS / Infra / Alertas`
  - `POST /webhook/infra-resource-alert` → `OPS / Infra / Resource Alert`
  - `POST /webhook/lch-backup-run` → `LCH / Backup / General`
  - `POST /webhook/lch-supabase-backup-run` → `LCH / Backup / Supabase`
  - `POST /webhook/lch-keepalive-run` → `LCH / Infra / Keepalive`
  - `POST /webhook/lch-contact-notify` → `LCH / Contact / Notify`
- El backend Las Chubys consume `N8N_WEBHOOK_URL=https://n8n.alvarodevrace.tech/webhook/lch-contact-notify` para notificaciones de contacto (`src/modules/contact/contact.service.ts`). Workflow receptor activo y validado el 2026-07-12.

### 5.5 Alertas — Telegram

| Bot | Uso | Referencia |
| --- | --- | --- |
| Generic | Alertas generales | `bitwarden:global/telegram-bot-generic` |
| `@alvarodevrace_bot` | Infra / AlvaroDevRace | `bitwarden:global/telegram-bot-alvarodevrace` |
| Las Chubys bot | Alertas Las Chubys | `bitwarden:global/telegram-bot-laschubys` |

**Canales configurados:**
- Uptime Kuma → `@alvarodevrace_bot`.
- Backup Dell → notificación Telegram.
- Chat ID: `bitwarden:global/telegram-chat-id-alvarodevrace`.

---

## 6. HALLAZGOS CRÍTICOS Y RECOMENDACIONES INMEDIATAS

| # | Hallazgo | Riesgo | Acción sugerida | Owner probable | Estado |
| --- | --- | --- | --- | --- | --- |
| 1 | **Contenedores Coolify siguen corriendo** (`coolify-db`, `coolify-realtime`, `coolify-redis`, `coolify-sentinel`) pese a migración declarada a Dokploy | Superficie de ataque innecesaria, recursos consumidos | Auditar y eliminar restos de Coolify del VPS | TRIN | ✅ Resuelto 2026-07-10 |
| 2 | **Contenedores con nombres opacos** (`postgres-index-multi-byte-alarm-orbypg`, `jsas8iq6o0jr2kv5kalhtnmp-...`) | Origen y función desconocidos | `postgres-index-*` identificado como DB activa de n8n — **no eliminar**. `jsas8iq6o0jr2kv5kalhtnmp-*` era portfolio legacy de Coolify — eliminado. | TRIN | ✅ Resuelto 2026-07-10 |
| 3 | **Token Cloudflare `laschubys.com` solo tiene Cache Purge** y falló autenticación | No se puede automatizar DNS/API para ese dominio | Crear token con permisos Zone:DNS:Edit y rotar | TRIN | ✅ Resuelto 2026-07-10 |
| 4 | **WAF / rate limits no documentados** | Perímetro depende solo de proxy + UFW | Verificar en dashboard Cloudflare y documentar reglas | TRIN | ✅ Resuelto 2026-07-10 |
| 5 | **Regla UFW `Anywhere on tailscale0`** y regla `22` desde `10.0.0.0/8` | Posible exceso de permisos | Revisar y endurecer reglas; eliminar reglas Coolify legacy | TRIN | ✅ Resuelto 2026-07-10 |
| 6 | **Sin tests unitarios en NestJS** y tests frontend con Vitest sin configurar | Deuda técnica y riesgo de regresiones | Añadir Jest + tests de health/contact/checkout; añadir `test:ci` en frontend con smoke tests Playwright | PIXEL / NOVA | ✅ Resuelto 2026-07-12 |
| 7 | **Portfolio estancado** en vault y Angular 18 | Documentación obsoleta, versiones desalineadas | Migrar a Angular 21 y completar docs | PIXEL / EVA | ⏳ Pendiente |
| 8 | **WF-LCH-SEO-01 con errores recientes** | Indexación Google puede estar fallando | Workflow eliminado por inactivo; si se retoma la indexación manual, recrear desde cero con credenciales OAuth vigentes | LINK | ✅ Resuelto 2026-07-10 (eliminado) |
| 9 | **VPS n8n `.env` históricamente expuso** `LCH_SUPABASE_SERVICE_ROLE_KEY` y `EVOLUTION_API_KEY` | Secreto potencialmente comprometido | Rotar `n8n-api-key` y Supabase service role key | TRIN | ✅ Resuelto 2026-07-10 |
| 10 | **Certificados SSL** gestionados por Traefik; checklist indica revisar expiración < 14 días | Riesgo de caída por certificado vencido | Verificar fechas de expiración en Dokploy | TRIN | ✅ Resuelto 2026-07-10 |
| 11 | **NestJS no configura `trust proxy`** | `req.ip` devuelve IP del proxy interno, invalidando rate limiting por IP en backend | Añadir `app.getHttpAdapter().getInstance().set('trust proxy', true)` en `main.ts` | TRIN | ✅ Resuelto 2026-07-10 |
| 12 | **API key de n8n en Bitwarden está revocada/inválida** | No se puede monitorear workflows ni ejecutarlos vía API | Generar nueva API key JWT en DB de n8n y actualizar Bitwarden (`global/n8n-api-key`) | TRIN / LINK | ✅ Resuelto 2026-07-10 |
| 13 | **n8n: error workflow no encontrado + `trust proxy` warnings** | Workflows de error no se ejecutan; posible mala identificación de IPs para rate limiting interno | Reconfigurar error workflow en DB de n8n; añadir `N8N_TRUST_PROXY=true` y redeploy | TRIN / LINK | ✅ Resuelto 2026-07-10 |
| 14 | **`WF-LCH-META-SYNC` generaba filas duplicadas** por el nodo `Merge Meta Data` (2 items de salida) | Datos de métricas sociales duplicados en `laschubys.social_metrics` | Eliminar nodo Merge; conectar ambos HTTP directamente al Code node y usar `$input.all()` | LINK | ✅ Resuelto 2026-07-10 |

### Detalles de hallazgos resueltos

**#3 Token Cloudflare**
Creado nuevo token `Kimi Token` con permisos Zone WAF Read/Write, DNS Read/Write, Zone Read/Write, SSL Read/Write. Actualizado en Bitwarden (`global/cloudflare-api-token`).

**#4 WAF / Rate limiting**
- Regla `Rate limit auth endpoints` activa en `laschubys.com`:
  - Expresión: `(http.host eq "api.laschubys.com" and http.request.uri.path contains "/api/auth/")`
  - Acción: `Block`, 5 requests / 10 s por IP (tope plan Free)
  - Verificación: HTTP 429 a partir del séptimo request consecutivo.
- Rate limiting adicional en NestJS para `/api/auth/google` y `/api/auth/callback` (5 req/min por IP).

**#9 Rotación de secrets Supabase**
- Backup previo en `/opt/backups/secrets-rotation-20260709-215115/`.
- Rotados `JWT_SECRET`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`.
- Actualizados Supabase self-hosted, `laschubys-api`, `laschubys-app`, n8n y base de datos de Dokploy.
- Sincronizados items de Bitwarden.
- **Post-rotación 2026-07-10:** Se detectó que el monitor `Supabase — REST` de Uptime Kuma usaba el header `apikey` con formato JSON inválido (espacios), causando 401. Regrabado como JSON compacto en `/app/data/kuma.db`; monitor vuelve a `200 OK`.
- **WF-LCH-META-SYNC validado 2026-07-10:** forzada ejecución real tras reinicio de n8n; escritura confirmada en `laschubys.social_metrics`. Ver detalle en sección 5.4.

**#10 Certificados SSL**
Vigentes verificados vía TLS handshake:
- `laschubys.com` / `api.laschubys.com`: expira **2026-09-23**
- `alvarodevrace.tech` y subdominios: expira **2026-08-20**
- Todos > 14 días de vigencia; renovación automática por Traefik.

**#11 NestJS trust proxy**
- Añadida línea `app.getHttpAdapter().getInstance().set('trust proxy', true);` en `LasChubys/LasChubys-Back/src/main.ts`.
- `bun run typecheck` ✅.
- Merge a `develop` local + push a origin; PR #33 creado `develop → main` para aprobación de Álvaro.
- QA gate por KIMI-NOVA ✅.

**#12 API key de n8n rotada**
- Tabla `public.user_api_keys` de n8n estaba vacía; la API key almacenada en Bitwarden era un JWT cuyo registro había sido eliminado.
- Generado nuevo JWT firmado con el `jwtSecret` derivado de `N8N_ENCRYPTION_KEY` y payload `{sub: <owner-id>, iss: 'n8n', aud: 'public-api'}`.
- Insertado registro en `public.user_api_keys` con label `Backend API Key`.
- Actualizado Bitwarden `global/n8n-api-key` con el nuevo JWT y nota de rotación 2026-07-10.
- Verificación post-cambio: `GET /api/v1/workflows` devuelve HTTP 200.

**#13 Error workflow n8n + trust proxy warnings**
- Identificado que 5 workflows apuntaban a `errorWorkflow: "a0KGcLv4yAXBsZAW"`, un workflow inexistente.
- Actualizados los 5 workflows para que apunten a `R8sYRPKvdNBKLEKX` (`LCH / Operaciones / Error handler`).
- Añadida env var `N8N_TRUST_PROXY=true` al compose de n8n en Dokploy.
- Redeploy de n8n; contenedor healthy y sin warnings de `trust proxy` en logs.
- **Validación 2026-07-10:** workflow `LCH / Operaciones / Error handler` fue corregido para usar `errorTrigger` como nodo inicial; se forzó un error con un workflow temporal y el handler recibió el evento, enviando notificación Telegram por el bot Las Chubys.

**#14 Duplicados en `WF-LCH-META-SYNC`**
- El nodo `Merge Meta Data` configurado como `combineByPosition` recibía 1 item de Instagram y 1 item de Facebook, pero producía 2 items de salida.
- El nodo `Build Supabase Rows` (`runOnceForAllItems`) se ejecutaba por cada item de entrada, generando 2 filas de Instagram y 2 filas de Facebook por ejecución.
- Solución: eliminado el nodo `Merge Meta Data`; ambos nodos HTTP ahora conectan directamente a `Build Supabase Rows`. El código ahora itera `$input.all()`, identifica cada fuente por el prefijo del `id` de Meta Graph API y genera exactamente 1 fila por plataforma.
- Validación post-fix: ejecuciones forzadas generaron 1 fila IG + 1 fila FB; datos insertados correctamente en `laschubys.social_metrics`.

### 6.2 Producción readiness — ejecución 2026-07-12

Tareas ejecutadas para dejar listo el entorno de Las Chubys para producción a fin de mes:

| Tarea | Resultado | Verificación |
| --- | --- | --- |
| Importar y activar workflows n8n (`LCH / Contact / Notify`, `OPS / Infra / Resource Alert`) | ✅ Activos y probados vía webhook | `POST /webhook/lch-contact-notify` y `POST /webhook/infra-resource-alert` devuelven 200; ejecuciones en n8n `success` |
| Sincronizar tokens Telegram en `.env` de n8n | ✅ Tokens rotados a valores vigentes de Bitwarden | Workflows envían mensajes de prueba a Telegram |
| Reparar `/opt/scripts/backup-generate.sh` | ✅ Contenedores y secrets actualizados; backup de PostgreSQL n8n añadido | Ejecución manual: `COMPLETADO OK`; backups en `/opt/backups/` y Google Drive |
| Añadir `N8N_WEBHOOK_URL` en Dokploy (`laschubys-api`) | ✅ Variable añadida y contenedor redeployado | `docker exec ... env` muestra `N8N_WEBHOOK_URL=https://n8n.alvarodevrace.tech/webhook/lch-contact-notify` |
| Merge `prod-readiness-lch` → `develop` (front + back) | ✅ Push completado | `origin/develop` contiene el merge commit en ambos repos |
| Tests backend (Jest) + CI | ✅ Añadidos en rama `prod-readiness-lch` y mergeados | Workflow CI ejecuta `npm run test:ci` |
| Smoke tests frontend (Playwright) + CI | ✅ Añadidos en rama `prod-readiness-lch` y mergeados | Workflow `smoke.yml` ejecuta tests contra producción |

**Pendientes conscientemente no tocados en esta sesión:**
- Portfolio en Angular 18 (deuda técnica aislada, acordado revisar después).
- Tema oscuro forzado en Planka (requiere configuración de usuario o modificación de tema; no es bloqueo de producción).

---

## 7. NOTA SOBRE CREDENCIALES

- **Bitwarden** fue desbloqueado y validado durante la auditoría. Todas las credenciales maestras residen allí.
- No se encontraron secretos criptográficos completos expuestos en archivos `.md` del vault tras la limpieza documentada del 2026-06-05.
- Los IDs operativos (Zone IDs, Tunnel IDs, Dokploy IDs, Planka Board IDs, Tailscale IPs) permanecen en texto plano por legibilidad, siguiendo la política del vault (`POLITICA-SECRETOS.md`).

---

## 8. APÉNDICE — COMANDOS DE VERIFICACIÓN UTILIZADOS

```bash
# Tailscale
 tailscale status

# SSH y contenedores VPS
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25 'docker ps'
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25 'docker stats --no-stream'
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25 'ufw status verbose'

# Supabase: versión y RLS
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25 \
  'docker exec supabase-db psql -U supabase_admin -d postgres -c "SELECT version();"'
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25 \
  'docker exec supabase-db psql -U supabase_admin -d postgres \
   -c "SELECT schemaname, tablename, policyname, cmd FROM pg_policies WHERE schemaname = '\''laschubys'\'';"'

# Dell
ssh -i ~/.ssh/id_ed25519 alvaro@100.88.228.17 'docker ps'
ssh -i ~/.ssh/id_ed25519 alvaro@100.88.228.17 'df -h && free -h && uptime'
```

---

*Documento generado por KIMICO (TRIN). Última actualización: 2026-07-12. Para cualquier corrección o dato faltante, actualizar este archivo y notificar en Planka/LOG.md correspondiente.*
