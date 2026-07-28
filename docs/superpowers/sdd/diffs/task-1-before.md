# Infraestructura Global — Estado Real 2026-06-05

> Fuente de verdad para infra compartida entre todos los proyectos.
> Reemplaza a `vault/INFRA-GLOBAL.md` (versión desactualizada).

---

## Cloudflare — DNS + Tunnel

**Zonas:**
| Dominio | Zone ID |
|---------|---------|
| alvarodevrace.tech | `2a17143e03abfec70bd29db73b74fecf` |
| laschubys.com | `b1bd4dda49d48900eecb9228673ef1e9` |

**Tunnel VPS:** `alvarodevrace-vps` | ID: `49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a`

**Regla DNS:** Todo DNS en Cloudflare. No tocar Hostinger hPanel.

---

## Nodos

| Nodo | IP pública | Tailscale | RAM | Disco | Rol | Horario |
|------|-----------|-----------|-----|-------|-----|---------|
| VPS Hostinger | 72.60.26.201 | `100.105.133.25` | 7.8 GB | 96 GB | Producción 24/7 | 24/7 |
| Dell zion-node | 192.168.1.20 | `100.88.228.17` | 7.6 GB | 457 GB SSD | Herramientas internas | Solo jornada laboral |
| MacBook | — | `100.83.137.17` | — | — | Desarrollo local | Cuando Álvaro trabaja |

**SSH:**
```bash
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25        # VPS
ssh -i ~/.ssh/id_ed25519 alvaro@100.88.228.17       # Dell
```

**Tailscale:** Cuenta `alpepito93@` — plan gratuito.

---

## VPS Hostinger — Servicios y Apps (Dokploy)

### Proyectos Dokploy

| Proyecto | ID | Contenido |
|----------|------|-----------|
| infra | `aP3P-FbWPbS383qrcKEGm` | Uptime Kuma, Docuseal, Umami, n8n |
| database | `HTxz4FLFZ-FFasumznhf2` | Supabase self-hosted |
| laschubys | `dcZfubBCdj1wno5hroswj` | Angular SSR + NestJS BFF |
| portfolio | `oSVdXwFYGekg16v18XNW1` | alvaro-portfolio |

### Apps

| App | URL | ID | Status |
|-----|-----|------|--------|
| laschubys-app | https://laschubys.com | `XX0AfFKhYHn9ayErXevJF` | ✅ done |
| laschubys-api | https://api.laschubys.com | `GzBwWmUjlYRCgfMK6tzBt` | ✅ done |
| alvaro-portfolio | https://alvarodevrace.tech | `r9HA2pNx6Uiip1sYJ8ubg` | ✅ done |

### Servicios (Compose)

| Servicio | URL | ID | Status |
|----------|-----|------|--------|
| n8n | https://n8n.alvarodevrace.tech | `a5ghK4hsUufVj1FOt-eiD` | ✅ done |
| Supabase self-hosted | https://db.alvarodevrace.tech | `KmZPDb3xeY_wZqNjpIAOT` | ✅ done |
| Docuseal | https://docuseal.alvarodevrace.tech | `5Q882tFXpDH9hzWph0Y_S` | ✅ done |
| Uptime Kuma | https://status.alvarodevrace.tech | `KDRlcDa9e8vPHgzXUE0a3` | ✅ done |
| Umami | https://analytics.alvarodevrace.tech | `WBBWfwBAiodpR9CpfVBPM` | ✅ done |

> **Netdata:** servicio eliminado 2026-06-10. No se usaba; Uptime Kuma cubre monitoreo.
> **Coolify:** migrado a Dokploy y desinstalado del VPS 2026-06-25.

### ❌ Eliminados / Caídos

| Servicio | Estado | Razón |
|----------|--------|-------|
| GlitchTip | Eliminado 2026-06-05 | Reemplazado por Sentry SaaS ✅ activo en laschubys-app y laschubys-api |
| ~~Evolution API~~ | ✅ **ELIMINADO** 2026-06-06 | Todos los rastros borrados del VPS |
| Netdata | Eliminado 2026-06-10 | No se usaba; Uptime Kuma cubre monitoreo |
| Coolify | ✅ **ELIMINADO** 2026-06-25 | Migrado a Dokploy; contenedores, volúmenes y servicio systemd eliminados |
| Jauria containers | Eliminados de Dokploy | Cliente en standby |
| UtilBoxes | Eliminado 2026-06-24 | Proyecto descartado; repo y Coolify limpiados |
| CobrosLatam | Eliminado 2026-06-24 | Proyecto descartado; repo y Coolify limpiados |

---

## Dell zion-node — Servicios (solo jornada laboral)

**Estado real auditado 2026-06-05:**
- **RAM:** 7.6 GB total, 53% usado (~3.8 GB usado, ~3.8 GB available)
- **Disco:** 457 GB, 14% usado (58 GB / 376 GB libre)
- **OS:** Ubuntu 24.04.4 LTS
- **Actualizaciones:** 68 pendientes (23 de seguridad)

### Servicios activos (post-cleanup 2026-06-05)

| Servicio | URL / Puerto | Deploy | Status | RAM | Quién lo usa |
|----------|-------------|--------|--------|-----|-------------|
| Planka | https://planka.alvarodevrace.tech | `/opt/planka/` | ✅ HTTP 200 | ~140 MB | Tickets agentes |
| Planka DB | — | — | ✅ | ~28 MB | — |
| Crawl4AI | :11235 | `/opt/crawl4ai/` | ✅ | ~324 MB | PIXEL/TRIN scraping |
| Gotenberg | :3010 | `/opt/gotenberg/` | ✅ | ~12 MB | PDF cotizaciones/contratos |

**Eliminados 2026-06-05 (no se usaban):**
| Servicio | RAM liberada | Razón eliminación |
|----------|-------------|-------------------|
| Flowise | ~614 MB | DB vacía, 0 flows, creado ayer |
| Browserless | ~400 MB | Logs vacíos, 0 requests, creado ayer |
| ChromaDB | ~11 MB | 0 colecciones, creado ayer |
| Coolify Dell completo | ~460 MB | 0 proyectos, experimento abandonado |
| **TOTAL LIBERADO** | **~1.5 GB** | — |

**Eliminados 2026-06-10:**
| Servicio | RAM liberada | Razón eliminación |
|----------|-------------|-------------------|
| Penpot completo | ~1.5 GB | Pasamos a Figma (gratis). Frontend + backend + exporter + DB + Valkey + MCP. |
| **TOTAL LIBERADO** | **~1.5 GB** | — |

**Post-cleanup:** RAM usada ~1.2 GB / 7.6 GB (~16%). 6.4 GB disponibles.

**Riesgos Dell:**
- Planka no disponible fuera de horario laboral.
- Backups 3-2-1 validado 2026-06-05: VPS genera, comprime credentials a `.sqlite.gz`, sube a Drive; Dell sync local 04:00.

---

## Supabase Self-Hosted

**Proyecto Dokploy:** `database` (`HTxz4FLFZ-FFasumznhf2`)
**Compose ID:** `KmZPDb3xeY_wZqNjpIAOT`
**Dominio:** https://db.alvarodevrace.tech

**Endpoints internos (red Docker):**
| Servicio | URL interna |
|----------|-------------|
| Kong API Gateway | `http://supabase-kong:8000` |
| Studio (dashboard) | `http://supabase-studio:3000` |
| PostgREST | `http://supabase-rest:3000` |
| Auth (GoTrue) | `http://supabase-auth:9999` |
| Postgres DB | `supabase-db:5432` |

**Schemas por proyecto:**
| Proyecto | Schema |
|----------|--------|
| Las Chubys | `laschubys` (activo) |
| Jauria CrossFit | ~~`jauria`~~ (eliminado de Supabase) |
| Agrovivas | ~~`agrovivas`~~ (no creado) |
| ~~Brain~~ | ~~`brain` (eliminado)~~ |

**Archivos config en VPS:**
```
/opt/dokploy-data/supabase/.env
/opt/dokploy-data/supabase/docker-compose.yml
```

---

## Backups — Sistema 3-2-1 ✅

```
VPS (cron 03:00) → /opt/backups/
    ├── rclone sync (excluye *.sqlite) → Google Drive: Backups-AlvaroDevRace/  [offsite]
    └── rsync (cron Dell 04:00) → Dell /opt/backups/vps/                     [copia secundaria]
```

> **Regla de oro:** El offsite a Google Drive lo realiza el VPS directamente. El Dell **nunca** debe hacer `rclone sync` a Drive para evitar borrados accidentales.

**Qué se respalda:**
| Dato | Tamaño | Frecuencia | Archivo local | Offsite Drive |
|------|--------|-----------|---------------|---------------|
| Schema laschubys | ~28 KB | Diario | `supabase/laschubys-YYYYMMDD.sql` | ✅ `.sql` |
| Schema jauria | ~124 KB | Mensual (día 1) | `supabase/jauria-YYYYMMDD.sql` | ✅ `.sql` |
| n8n workflows | ~100 KB | Diario | `n8n/workflows-YYYYMMDD.json` | ✅ `.json` |
| n8n SQLite | ~549 MB → ~116 MB gz | Diario | `n8n/credentials-YYYYMMDD.sqlite` | ✅ `.sqlite.gz` |
| Dokploy config | ~1 MB | Diario | `dokploy-config/` | ❌ No (VPS + Dell) |

**Scripts:**
- VPS `/opt/scripts/backup-generate.sh` — cron `0 3 * * *`
  - Genera dumps Supabase.
  - Exporta workflows n8n (API key desde BD).
  - Copia SQLite n8n y lo comprime con `gzip -9`.
  - Sube a Drive excluyendo `*.sqlite`.
- Dell `/opt/scripts/sync-backups.sh` — cron `0 4 * * *`
  - Espera Tailscale.
  - `rsync` desde VPS a `/opt/backups/vps/`.
  - `rsync` Dokploy config a `/opt/backups/dokploy-config/`.
  - Verifica archivos recientes (<2 días).
  - Notifica por Telegram.

**Retención:**
- VPS: 30 días (`find ... -mtime +30 -delete`).
- Dell: ilimitada (hasta llenar disco; monitorizar).
- Google Drive: 30 días efectivos (~3.5 GB con `.gz`). Espacio total Drive: 15 GB; libre actual: ~9.66 GB.

### Estado backups 2026-06-05

| Ubicación | Estado |
|-----------|--------|
| VPS `/opt/backups/supabase/` | ✅ Diarios |
| VPS `/opt/backups/n8n/` | ✅ Diarios (workflows + SQLite + `.gz`) |
| VPS → Google Drive | ✅ Sync con `.sqlite.gz` |
| Dell `/opt/backups/vps/` | ✅ Sync diario a las 04:00 |
| Dell `/opt/backups/dokploy-config/` | ✅ Sync diario |
| Dell cron roto `/opt/zion/backup.sh` | ✅ Eliminado y reemplazado por cron `sync-backups.sh` |

---

## Secretos maestros — Referencias Bitwarden

| Secreto | Referencia |
|---------|-----------|
| Dokploy API Key | `bitwarden:global/dokploy-api-token` |
| Cloudflare API Token | `bitwarden:global/cloudflare-api-token` |
| Supabase JWT Secret | `bitwarden:global/supabase-jwt-secret` |
| Supabase Anon Key | `bitwarden:global/supabase-anon-key` |
| Supabase Service Role | `bitwarden:global/supabase-service-role-key` |
| Supabase Postgres Pass | `bitwarden:global/supabase-postgres-password` |
| Supabase Dashboard Pass | `bitwarden:global/supabase-dashboard-password` |
| Google OAuth Client ID | `bitwarden:global/google-oauth-client-id` |
| Google OAuth Secret | `bitwarden:global/google-oauth-client-secret` |
| Planka Password | `bitwarden:global/planka-password` |
| Telegram Bot Generic | `bitwarden:global/telegram-bot-generic` |
| Telegram Bot AlvaroDevRace | `bitwarden:global/telegram-bot-alvarodevrace` |
| Telegram Bot LasChubys | `bitwarden:global/telegram-bot-laschubys` |
| Docuseal API Key | `bitwarden:global/docuseal-api-key` |
| Minio User | `bitwarden:global/minio-user` |
| SSH root VPS | `bitwarden:global/ssh-root-vps` (key-based) |
| SSH alvaro Dell | `bitwarden:global/ssh-alvaro-dell` |

**Bitwarden folder:** `AlvaroDevRace - Global` (ID: `e5771472-4552-4de0-8962-b452012b1d69`)

> **Eliminado 2026-06-24:** `s3s.casabaca.com` (carpeta Personal, obsoleto). Total de items: 19.

---

## Checklist mensual de infra (TRIN)

- [ ] Revisar apps con status `error` o unhealthy en Dokploy
- [ ] n8n: workflows con errores recientes
- [ ] Supabase: espacio disco, WAL, vacuum
- [ ] VPS: RAM libre, disco >80%, CPU spikes
- [ ] Backups: existen y tamaño razonable
- [ ] Dell: enciende, servicios responden
- [ ] Restore drill: schema laschubys en container temporal
- [ ] Secretos: rotar si cumple fecha (semestral)
- [ ] Dominios: SSL no expira en <14 días
- [x] ~~Evolution API~~: ✅ Eliminado 2026-06-06. No queda rastro.

---

## Política de secretos (vigente)

1. **0 secretos completos en archivos .md**
2. SSH: solo key-based
3. VPS: conectar por Tailscale `root@100.105.133.25`
4. `service_role` key: solo backend server-side, nunca Angular
5. `anon key`: única key usable en frontend
6. Nuevos proyectos: día 1 → Bitwarden + GitHub Secrets + Dokploy env vars

**Rotación:**
| Secreto | Frecuencia |
|---------|-----------|
| SSH keys | Al cambio de equipo / sospecha |
| Cloudflare API Token | Semestral |
| Supabase Service Role | Semestral |
| Dokploy API Key | Semestral |
| Telegram bot tokens | Anual o si comprometidos |

---

---

## n8n — Automatización

**URL:** https://n8n.alvarodevrace.tech  
**Dokploy compose ID:** `a5ghK4hsUufVj1FOt-eiD`  
**Estado:** ✅ done  
**API Key:** `bitwarden:global/n8n-api-key`

**Workflows:** 10 activos (total 10)

| Workflow | ID | Estado | Notas |
|----------|-----|--------|-------|
| LCH / Backup / General | `7MVk9RSekCVvyhCT` | ✅ active | Backup diario |
| OPS / Infra / Alertas | `BFsLIVWRC0B3IP6K` | ✅ active | Alertas infra |
| LCH / Reportes / Notify | `DwdkXeS9Dkm2Hqr1` | ✅ active | Reportes |
| LCH / Infra / Alertas | `NBsFITIdL1F1mlgV` | ✅ active | Alertas Las Chubys |
| LCH / Operaciones / Error handler | `R8sYRPKvdNBKLEKX` | ✅ active | Manejo errores |
| WF-LCH-SEO-01: Google Indexing API | `bsXIbJoH6urG7ty7` | ⚠️ active con errores | Falla ejecuciones recientes — revisar env vars |
| LCH / Backup / Supabase | `bzhKoL4anHcO0ysE` | ✅ active | Backup Supabase |
| WF-LCH-META-SYNC | `ljRaQeAsfs43Mkme` | ✅ active | Sync Meta/Facebook para Las Chubys |
| LCH / Infra / Keepalive | `nmqhJawyIvV8aOIt` | ✅ active | Keepalive |
| LCH / Notificaciones / Comment notify | `wIfG0qs1S6J1OdJN` | ✅ active | Notificaciones |

> **Eliminados 2026-06-24:** 4 workflows inactivos del sistema freelance (WF-ADR-*).

**✅ Problema resuelto 2026-06-06:** El fallo masivo de WF-LCH-SEO-01 (y todos los workflows) era causado por `SQLITE_READONLY` en la DB de n8n. La DB pertenecía a `root:root` en lugar de `node` (UID 1000). Se corrigieron permisos y se limpiaron archivos WAL/SHM inconsistentes.

**Env vars residuales:** ✅ Limpias 2026-06-06. Eliminadas `EVOLUTION_API_URL`, `EVOLUTION_API_KEY`, `BENEFICIARIO` de n8n .env.

---

## GitHub — Repositorios

**Usuario:** `alvarodevrace` | **Acceso:** `gh` CLI autenticado (keyring) + SSH `~/.ssh/id_ed25519_alvarodevrace`

### Públicos (4)

| Repo | CI/CD | Último update | Estado |
|------|-------|---------------|--------|
| `alvaro-portfolio` | Deploy to Dokploy | 2026-06-25 | ✅ Activo |
| `alvarodevrace` | Ninguno | 2026-03-20 | Legacy README |
| `laschubys-api` | CI | 2026-06-04 | ✅ Activo |
| `laschubys-app` | CI | 2026-06-04 | ✅ Activo |

### Privados (0)

> **Eliminados 2026-06-24:** `jauria-admin`, `jauria-admin-back`, `jauria-landingpage`, `jauria-backups`, `agrovivas`, `agrovivas-app`, `agrovivas-api`, `agrovivas-landing-page`.
> Si se retoma Agrovivas o Jauria, se crearán repos nuevos.

---

## ~~Evolution API — WhatsApp~~ ✅ ELIMINADO 2026-06-06

**URL:** ~~https://evolution.alvarodevrace.tech~~ → DNS limpio (NXDOMAIN)

**Investigación VPS (auditoría final 2026-06-06):**
- ❌ No hay container Docker evolution corriendo
- ❌ No existe `/opt/evolution/`
- ❌ No hay servicio systemd `evolution`
- ✅ Cron roto `*/2 * * * * /opt/evolution/autoheal.sh` — **ELIMINADO 2026-06-05**
- ✅ Log `/var/log/evolution-autoheal.log` — **BORRADO 2026-06-06**
- ✅ Env vars residuales en n8n (`EVOLUTION_API_URL`, `EVOLUTION_API_KEY`, `BENEFICIARIO`) — **LIMPIADAS 2026-06-06**

**Conclusión:** Evolution API fue eliminado del VPS durante cleanup de Jauria (2026-06-04). **Álvaro confirmó que NO quiere reinstalarlo.** Todos los rastros eliminados.

**Instancias archivadas (NO reinstalar sin autorización explícita de Álvaro):**
| Instancia | Proyecto | Estado |
|-----------|----------|--------|
| `agrovivas` | AgroVivas | ❌ Eliminado |
| `jauria` | Jauria CrossFit | ❌ Eliminado |

---

## Planka — Tickets / Kanban

**URL:** https://planka.alvarodevrace.tech  
**Deploy:** Dell `/opt/planka/` (solo jornada laboral)  
**Estado:** ✅ Login funciona, API responde  
**Admin:** `alvaro@alvarodevrace.tech` — password en `bitwarden:global/planka-password`

**Boards:**
| Proyecto | Board ID | Estado |
|----------|----------|--------|
| Las Chubys | `1762811413849441959` | ✅ Activo |
| Portfolio | `1739527870750917748` | ✅ Activo |
| Infra / Migración | `1780675948073452736` | ✅ Activo |
| AgroVivas | `1771553311741183089` | ⏳ Standby |

> **Eliminados 2026-06-24:** Jauria CrossFit, Brain, CobrosLatam, UtilBoxes.

**⚠️ Limitación:** Planka no disponible fuera de horario laboral (Dell apagado).

---

## Cloudflare — DNS + Tunnel

**Zonas:**
| Dominio | Zone ID |
|---------|---------|
| alvarodevrace.tech | `2a17143e03abfec70bd29db73b74fecf` |
| laschubys.com | `b1bd4dda49d48900eecb9228673ef1e9` |

**Tunnel VPS:** `alvarodevrace-vps` | ID: `49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a`  
**Estado Tunnel:** ✅ Activo

**Tokens:**
| Token | Permisos | Ubicación |
|-------|----------|-----------|
| Cache Purge (laschubys.com) | Zone:Cache Purge | `vault/laschubys/40-Credentials/INFRA.md` → Bitwarden |
| Admin (alvarodevrace.tech) | Account + Zone edit | `bitwarden:global/cloudflare-api-token` |

**⚠️ Hallazgo:** El token de `laschubys.com` solo tiene permisos de cache purge. No puede leer zona vía API. Para admin DNS completo se necesita el token global en Bitwarden.

---

## Resend — Email Transaccional

**Dominio:** alvarodevrace.tech  
**Status:** Verified ✅ (DKIM+SPF+MX)  
**Domain ID:** `bitwarden:global/resend-domain-id`  
**API Key:** `bitwarden:global/resend-api-key`

**Estado:** No encontré API key en archivos del vault. Verificar en Bitwarden.

**Uso actual:**
- Las Chubys: MailerSend SMTP (según credenciales antiguas)
- AgroVivas: propuesta original usaba Resend, luego cambió a Brevo
- Global: Resend configurado 2026-05-19 para dominio alvarodevrace.tech

---

## Sentry — Error Tracking

**URL:** https://sentry.io  
**Estado:** ✅ **CONFIGURADO** (actualizado 2026-06-05)

**Proyectos activos:**
| Proyecto | DSN | Referencia |
|---|---|---|
| laschubys-app (Angular) | `bitwarden:global/sentry-dsn-laschubys-app` | Código: `LasChubys/apps/laschubys-ng/src/main.ts` |
| laschubys-api (NestJS) | `bitwarden:global/sentry-dsn-laschubys-api` | Código: `LasChubys/apps/laschubys-api/src/instrument.ts` |

**Verificación:**
- Frontend: `Sentry.init()` en `main.ts` con `browserTracingIntegration` + `replayIntegration`.
- Backend: `Sentry.init()` en `instrument.ts` importado en `main.ts`; `SentryModule` + `SentryGlobalFilter` en `app.module.ts`.
- Endpoint debug: `GET /api/health/debug-sentry` lanza error de prueba.
- Dashboard: https://alvarodevrace.sentry.io/projects/laschubys-app y /laschubys-api.

**Nota:** La contradicción documental anterior (INFRA-GLOBAL decía "NO CONFIGURADO" mientras SESSION_LOG y código decían configurado) se resuelve: Sentry está vivo. Fuente de verdad es el código + GitHub Secrets + Bitwarden.

---

## Hallazgos de Seguridad — Credenciales Expuestas (LIMPIADAS 2026-06-05)

Durante auditoría se encontraron y limpiaron los siguientes secretos en archivos .md/.json:

| Archivo | Secreto expuesto | Acción |
|---------|-----------------|--------|
| `vault/alvarodevrace/40-Credentials/INFRA.md` | n8n API key, Docuseal token, Telegram token | ✅ Reemplazado por referencias Bitwarden |
| `vault/laschubys/40-Credentials/INFRA.md` | Cloudflare cache purge token completo | ✅ Reemplazado por referencia Bitwarden |
| `infra/10-Log/archive/2026-05-19-TRIN.md` | Planka password | ✅ Archivo eliminado |
| `Agrovivas/.claude/settings.local.json` | n8n API key, Evolution API key, Supabase anon key, PGPASSWORD | ✅ **Archivo eliminado** con carpeta Agrovivas. |
| `Agrovivas/.codex/AGENTS.md` | Evolution API key, Supabase service key, n8n API key | ✅ **Archivo eliminado** con carpeta Agrovivas. |
| VPS n8n .env (Dokploy) | LCH_SUPABASE_SERVICE_ROLE_KEY, EVOLUTION_API_KEY | ⚠️ Visible en servidor — rotar recomendado |

**Recomendación:** Rotar los siguientes tokens que estuvieron expuestos:
1. `n8n-api-key` — expuesta en múltiples archivos
2. `cloudflare-cache-purge-token` — expuesta en vault
3. `evolution-api-key` — expuesta en múltiples archivos
4. `telegram-bot-alvarodevrace` — expuesta en vault
5. `docuseal-api-key` — expuesta en vault

---

## Notas de auditoría 2026-06-05

- Glitchtip eliminado (libera RAM).
- ~~Evolution API~~ — **ELIMINADO 2026-06-06**. Todos los rastros borrados del VPS.
- ❌ **CobrosLatam y UtilBoxes eliminados 2026-06-24**: repos de GitHub y proyectos de Coolify borrados. Proyectos descartados.
- ✅ **Coolify migrado a Dokploy 2026-06-25**: todos los servicios y apps productivos migrados; Coolify desinstalado del VPS.
- Uptime Kuma, Docuseal, Umami, n8n y Supabase migrados a Dokploy en el proyecto `infra`/`database`.
- Jauria cleanup completo: containers eliminados.
- **n8n:** 10 workflows activos. WF-LCH-SEO-01 con errores recientes. 4 workflows del sistema freelance eliminados 2026-06-24.
- **GitHub:** 4 repos activos. Repos de CobrosLatam, UtilBoxes, Jauria y Agrovivas eliminados 2026-06-24.
- **Planka:** 4 proyectos. Activos: Las Chubys, Portfolio, Infra/Migración. Standby: AgroVivas. Jauria, Brain, CobrosLatam, UtilBoxes eliminados 2026-06-24.
- **Cloudflare:** Token admin funciona. Tunnel activo. Certificados SSL via Let's Encrypt gestionados por Traefik de Dokploy.
- **Resend:** Dominio verificado con registros SPF/DKIM de Amazon SES. API key no encontrada en vault.
- **Sentry:** ✅ Configurado en laschubys-app y laschubys-api. DSNs en GitHub Secrets + Bitwarden.
- **Backups Dell:** ✅ Funcionando. Dell encendido, rsync sincronizado 2026-06-24.
- **Cron roto eliminado:** `/opt/evolution/autoheal.sh` ya no existe en crontab.
- **Credenciales expuestas limpiadas** en 6 archivos. Recomendado rotar tokens.
- **Supabase:** Solo schema `laschubys` activo. Schemas `jauria`/`agrovivas` no existen.
- **VPS:** ✅ Actualizado y reiniciado 2026-06-24. Netdata eliminado. Zombies limpiados. Swap ~0-1%.
- **Dell:** ✅ Actualizado y reiniciado 2026-06-24. Servicios OK.
- **Bitwarden:** 19 items. Eliminado `s3s.casabaca.com` 2026-06-24.
