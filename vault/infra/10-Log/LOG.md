# LOG — Infraestructura Global

## [2026-07-28] KIMICO | Incidente: backups n8n fallaron 3 días por volumen PostgreSQL mal montado

**Agente:** KIMICO (TRIN)
**Contexto:** Álvaro reportó que no se habían sacado respaldos los últimos 3 días. Revisión mostró que backups Supabase seguían OK, pero backups de n8n workflows y PostgreSQL fallaban desde 2026-07-26.
**Tareas:**
- Diagnosticada causa raíz: servicio `postgres-index-multi-byte-alarm-orbypg` de Dokploy montaba el volumen persistente en `/var/lib/postgresql/18/docker`, pero la imagen `postgres:16` usa `PGDATA=/var/lib/postgresql/data`. PostgreSQL ignoraba el volumen persistente, creaba un volumen anónimo en `/var/lib/postgresql/data`, y ese volumen anónimo se perdió al recrear el container el 2026-07-26.
- Restaurada DB n8n desde dump `n8n-db-20260725.sql` (54 tablas, 8 workflows).
- Corregido `mountPath` en tabla `mount` de Dokploy (`F2uMnR14dUEvYzdYF8WFR`) de `/var/lib/postgresql/18/docker` a `/var/lib/postgresql/data`; redeploy vía API de Dokploy.
- Backup del volumen anónimo previo guardado en `/opt/backups/n8n-postgres-anon-volume-20260728-0947.tar.gz`.
- Re-ejecutado backup manual VPS: Supabase, n8n workflows y n8n PostgreSQL OK; sync a Google Drive OK.
- Corregido script `/opt/scripts/sync-backups.sh` en Dell: eliminadas referencias a Coolify (`/data/coolify/`) y `credentials-*.sqlite`; añadido sync de Dokploy config (`/opt/dokploy-data/`) y verificación de `n8n-db-*.sql`.
- Sync manual Dell OK: backups críticos verificados en `/opt/backups/vps/`.
**Verificación post-cambio:**
- `docker service inspect postgres-index-multi-byte-alarm-orbypg` → mount único en `/var/lib/postgresql/data`.
- n8n responde, 8 workflows activos, API devuelve workflows.
- Backup cron y sync Dell/Google Drive validados.
**Bloqueos:** Ninguno.
**Pendientes:**
- Revisar si otros servicios Postgres de Dokploy tienen mountPath similarmente desalineado.
- Considerar alerta explícita si backup-generate.sh reporta errores.
**Vault lint:** ✅ sin secretos expuestos.

---

## [2026-07-12] KIMICO | Cerrados PRs de Dependabot y reconfigurado para evitar migraciones mayores automáticas

**Agente:** KIMICO (TRIN)
**Contexto:** Dependabot abrió PRs automáticos de actualizaciones mayores (`@angular/*` 21→22, `typescript` 5→7, `@types/node` 22→26, `lint-staged`, `dotenv`, `@ng-icons/lucide`). Álvaro confirmó que no quiere migraciones mayores automáticas ni versiones no-LTS antes del release de producción.
**Tareas:**
- Cerrados 5 PRs en `alvarodevrace/laschubys-app` (#45, #46, #47, #48, #49) y 4 PRs en `alvarodevrace/laschubys-api` (#35, #36, #37, #38) con comentario explicativo.
- Reescritos `.github/dependabot.yml` en front y back:
  - Schedule pasó de `weekly` a `monthly`.
  - Límite de PRs abiertos: 3.
  - Agrupación en un solo grupo `patch-minor-deps`.
  - `ignore` global para `version-update:semver-major`, bloqueando migraciones mayores automáticas.
- Commits pushados a `develop` en ambos repos.
- PR creado para back: `alvarodevrace/laschubys-api#39`.
**PRs:**
- `alvarodevrace/laschubys-api#39` — develop → main con reconfiguración de Dependabot.
**Bloqueos:** Ninguno.
**Vault lint:** ✅ limpio.

---

## [2026-07-12] KIMICO | Fix mensajes "undefined" en bot de infra + monitores internos + CSP Las Chubys

**Agente:** KIMICO (TRIN)
**Tareas:**
- Diagnosticado origen del mensaje con estado/valor `undefined` en el bot `@alvarodevrace_bot`.
- Causa raíz: Uptime Kuma envía el mensaje por defecto `[monitor] [status] {bean.msg}`; cuando `{bean.msg}` no se pobla, JavaScript lo renderiza como la cadena `"undefined"`.
- Aplicado template Liquid defensivo a la notificación `Telegram — AlvaroDevRace (infra)`:
  - `telegramUseTemplate: true`
  - Template: emojis de estado, nombre del monitor y fallback `Sin detalle adicional` si `msg` está vacío/undefined.
  - `telegramTemplateParseMode: plain` (evita escaping de MarkdownV2 en emojis).
- Backup de `/opt/dokploy-data/uptime-kuma/kuma.db` antes del cambio.
- Reiniciado contenedor `uptime-kuma`; configuración leída desde DB.
- Test directo al bot OK (`message_id: 58`).
- Corregidos monitores internos que daban timeout:
  - Causa: Uptime Kuma en VPS no alcanzaba IPs Tailscale `100.88.228.17`.
  - Cloudflare Tunnel (`/etc/cloudflared/config.yml`): `crawl4ai` y `gotenberg` apuntaban a `https://localhost:443` en lugar de `http://100.88.228.17:<puerto>`; reescritos correctamente.
  - Uptime Kuma: URLs de monitores #9 Planka, #11 Crawl4AI, #12 Gotenberg cambiadas a dominios públicos (`https://*.alvarodevrace.tech`).
  - Últimos heartbeats: `200 - OK` para los tres.
- Redeploy forzado de `laschubys-app` vía API de Dokploy para aplicar CSP con Sentry + `worker-src 'self' blob:`:
  - Header actual verificado en producción: incluye `https://o4511020887638016.ingest.us.sentry.io` en `connect-src` y `worker-src 'self' blob:`.
**PRs:**
- `alvarodevrace/laschubys-app#51` — develop → main con CSP Sentry + infra fixes (estado OPEN, a la espera de aprobación de Álvaro).
- `alvarodevrace/laschubys-api#39` — develop → main con reconfiguración de Dependabot.
**Bloqueos:** Ninguno.
**Pendientes:**
- Confirmar formato real en el próximo evento UP/DOWN de cualquier monitor.
**Vault lint:** ✅ sin duplicados, sin referencias obsoletas, sin secretos expuestos, sin archivos vacíos, índices OK, SSOT referenciado.

---

## [2026-07-12] KIMICO | Fix acceso público Planka + dark mode por defecto

**Agente:** KIMICO (TRIN)
**Tareas:**
- Reparado acceso público a https://planka.alvarodevrace.tech: Cloudflare Tunnel apuntaba a `https://localhost:443` sin router en VPS → cambiado a `http://100.88.228.17:3333` (Dell vía Tailscale).
- Config actualizada en `/etc/cloudflared/config.yml`; servicio `cloudflared` reiniciado.
- Verificación: URL pública responde HTTP 200; contenedor Planka healthy en Dell.
- Cambiado tema por defecto a dark mode: imagen custom `planka-planka:latest` construida desde `/opt/planka/Dockerfile` con `DEFAULT_THEME="dark"` en assets JS.
- Actualizada documentación: `vault/INFRA-GLOBAL-2026-06.md` y `vault/infra/20-Tech/CF-Tunnel.md`.
**PRs:** Ninguno
**Bloqueos:** Ninguno
**Pendientes:**
- Limpiar caché del navegador/Cloudflare si el tema no aplica en primera carga.

---

## [2026-07-10] KIMICO | Limpieza n8n + fix notificaciones Uptime Kuma + validación error handler

**Agente:** KIMICO (TRIN / LINK)
**Tareas:**
- Limpieza de workflows n8n: eliminados 4 workflows no usados (`WF-LCH-SEO-01`, `LCH / Reportes / Notify`, `LCH / Infra / Alertas`, `LCH / Notificaciones / Comment notify`).
- Creado repo de backups `alvarodevrace/laschubys-backups` y guardado token en Bitwarden (`global/github-backup-token`).
- Reparados workflows `LCH / Backup / General` y `LCH / Backup / Supabase`: destino GitHub, tablas reales, últimas ejecuciones manuales OK.
- Validado `LCH / Operaciones / Error handler`: reemplazado webhook inicial por `n8n-nodes-base.errorTrigger`; prueba forzada OK, mensaje Telegram entregado por bot Las Chubys.
- Fix notificaciones Uptime Kuma: actualizadas en DB a bots correctos (`Telegram — AlvaroDevRace (infra)` y `Telegram — Las Chubys`), limpiados mapeos huérfanos.
- Corregido token de `global/telegram-bot-laschubys` en Bitwarden al valor real usado por n8n.
**PRs:** Ninguno.
**Bloqueos:** Ninguno.
**Pendientes:**
- Crear skill/recordatorio para revisar monitores con API keys tras rotación de secrets.
- Confirmar que las notificaciones de Kuma llegan sin error tras el próximo evento real.
**Vault lint:** ⚠️ issues históricos en logs append-only (IDs globales y referencia obsoleta); nada nuevo.

---

## [2026-07-10] KIMICO | Incidente: Uptime Kuma monitor Supabase-REST en Down tras rotación de secrets

**Agente:** KIMICO (TRIN)
**Tareas:**
- Detectado monitor `Supabase - REST` (#29) en Down con HTTP 401.
- Causa raíz: header `apikey` del monitor tenía la `supabase-anon-key` rotada el 2026-07-10.
- Actualizado header en DB de Uptime Kuma (`/app/data/kuma.db`) con la anon key vigente de Bitwarden.
- Reiniciado contenedor `uptime-kuma`; último heartbeat: `200 - OK`.
- Revisados otros monitores: solo el #29 usaba Supabase key.
**Bloqueos:** Ninguno
**Pendiente:** ✅ Incluida revisión de monitores con API keys en el checklist de rotación de secrets (`vault/infra/20-Tech/POLITICA-SECRETOS.md` y `vault/INFRA-GLOBAL-2026-06.md`).

---

## [2026-07-10] KIMICO | Resueltos hallazgos #11, #12, #13 de auditoría

**Agente:** KIMICO (TRIN)
**Tareas:**
- `#11`: Añadido `trust proxy` en `LasChubys/LasChubys-Back/src/main.ts`; PR #33 mergeado `develop → main`; deploy automático a Dokploy; `https://api.laschubys.com/api/health` responde 200.
- `#12`: Generada nueva API key JWT de n8n, insertada en `public.user_api_keys`, actualizado `global/n8n-api-key` en Bitwarden; verificado `GET /api/v1/workflows` → 200.
- `#13`: Corregidos 5 workflows con `errorWorkflow` huérfano (`a0KGcLv4yAXBsZAW`) → apuntan a `R8sYRPKvdNBKLEKX`; añadido `N8N_TRUST_PROXY=true` al compose de n8n y redeploy; contenedor healthy sin warnings.
**PRs mergeados:** `alvarodevrace/laschubys-api#33`
**Documentación:** Actualizado `AUDITORIA-ALVARODEVRACE.md` y este LOG.

---

## [2026-07-10] KIMICO | Revisión post-auditoría: certificados OK, nuevos hallazgos en NestJS/n8n

**Agente:** KIMICO (TRIN)
**Tareas:**
- Verificados certificados SSL de todos los dominios críticos: vigentes > 14 días.
- Revisados logs de n8n: detectados warnings de `trust proxy` y error workflow no encontrado.
- Detectado que NestJS no configura `trust proxy`, lo que puede invalidar rate limiting por IP en backend.
- Detectado que la API key de n8n en Bitwarden (`global/n8n-api-key`) está revocada/inválida.
**Hallazgos documentados en AUDITORIA-ALVARODEVRACE.md (#10, #11, #12, #13).**

---

## [2026-07-10] KIMICO | WAF + Rate limiting para endpoints de autenticación en Cloudflare

**Agente:** KIMICO (TRIN)
**Motivación:** Hallazgo #4 de auditoría — faltaban reglas WAF/rate limits documentados en Cloudflare.
**Tareas:**
- Actualizado API token de Cloudflare en Bitwarden (`global/cloudflare-api-token`) con permisos WAF + DNS + Zone + SSL.
- Creada regla de rate limiting en zona `laschubys.com`:
  - Nombre: `Rate limit auth endpoints`
  - Expresión: `(http.host eq "api.laschubys.com" and http.request.uri.path contains "/api/auth/")`
  - Acción: `Block`
  - Límite: 5 requests por IP cada 10 segundos (tope del plan Free)
  - Estado: **Active**
- Desplegado rate limiting adicional en backend NestJS (`laschubys-api`) para `/api/auth/google` y `/api/auth/callback` (5 req/min por IP) vía PR #32.
**Verificación post-cambio:**
- Séptimo request consecutivo a `https://api.laschubys.com/api/auth/csrf` devolvió `429 Too Many Requests`.
- `https://api.laschubys.com/api/health` y `https://laschubys.com` responden 200.

---

## [2026-07-10] KIMICO | Rotación de secrets Supabase tras exposición histórica en `.env` de n8n

**Agente:** KIMICO (TRIN)
**Motivación:** Hallazgo #9 de auditoría — el `.env` de n8n en el VPS expuso históricamente `LCH_SUPABASE_SERVICE_ROLE_KEY`.
**Tareas:**
- Backup previo de todos los `.env` implicados en `/opt/backups/secrets-rotation-20260709-215115/`.
- Generación de nuevos secrets (`JWT_SECRET`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`) con `/opt/scripts/generate-supabase-jwts.py`.
- Actualización y recreación del compose Supabase self-hosted (`compose-synthesize-primary-bus-mbs4hm`).
- Actualización de variables en servicios Swarm `laschubys-api-b9k60b` y `laschubys-app-16uema` vía `docker service update --env-add`.
- Recreación del compose n8n (`compose-input-wireless-pixel-jkzmne`) con `LCH_SUPABASE_SERVICE_ROLE_KEY` y `SUPABASE_SERVICE_ROLE_KEY` actualizados.
- Persistencia en base de datos de Dokploy (`dokploy` → `environment`) para `etvf5Kgui5MzDmy-uUuBr` (apps), `qgweJQzSI_jpZe4xKhc4d` (Supabase compose) e `Ip-oneBcZHUvAdhvQStW0` (n8n compose), mediante contenedor temporal con `psycopg2` dentro de `dokploy-network`.
- Sincronización de Bitwarden: `global/supabase-jwt-secret`, `global/supabase-anon-key`, `global/supabase-service-role-key`.
**Verificación post-cambio:**
- HTTP 200 en `https://api.laschubys.com/api/health`, `https://laschubys.com` y `https://n8n.alvarodevrace.tech`.
- API responde `/api/content/products` con datos reales.
- n8n reportó todos sus workflows activos, incluyendo `WF-LCH-META-SYNC`.
**Pendiente:**
- Ejecutar manualmente `WF-LCH-META-SYNC` y validar escritura en tabla `social_metrics`.
- Revisar ejecuciones recientes de `WF-LCH-SEO-01` (hallazgo #8).

---

## [2026-07-10] KIMICO | Limpieza post-auditoría: Coolify removido del VPS y UFW endurecido

**Agente:** KIMICO (TRIN)
**Tareas:**
- Eliminados contenedores huérfanos de Coolify: `coolify-db`, `coolify-realtime`, `coolify-redis`, `coolify-sentinel`.
- Eliminado portfolio legacy de Coolify: `jsas8iq6o0jr2kv5kalhtnmp-223815702761`.
- Eliminado proxy legacy `dell-proxy` (Coolify) tras verificar que `planka/crawl4ai/gotenberg` devolvían 404 desde internet.
- Backups previos en `/opt/backups/coolify-cleanup-20260709-213322/`.
- Eliminados volúmenes `coolify-db`, `coolify-redis`.
- Eliminados directorios `/data/coolify` y `/artifacts/udlat6coodx9ork4ji125x3w`.
- `docker container prune` e `docker image prune -af`: liberados ~4.48 GB.
- UFW endurecido: eliminadas reglas legacy `10.0.0.0/8:22` y `Anywhere on tailscale0`; añadida regla explícita `3000/tcp on tailscale0 from 100.83.137.17`.
- Identificado que `postgres-index-multi-byte-alarm-orbypg` es la DB PostgreSQL activa de n8n (`DB_TYPE=postgresdb`) — NO eliminado.
- Scripts de ejecución guardados en `/opt/scripts/coolify-cleanup-2026-07-10.sh` y `/opt/scripts/ufw-hardening-2026-07-10.sh`.
**Verificación post-cambio:**
- `docker ps`: todos los servicios críticos healthy (`n8n`, `laschubys-app`, `laschubys-api`, `supabase-db`, `dokploy`, `alvaro-portfolio`, `umami`, `docuseal`, `uptime-kuma`).
- HTTP 200 desde internet para `laschubys.com`, `api.laschubys.com/api/health`, `n8n.alvarodevrace.tech`, `alvarodevrace.tech`.
- Conexión SSH por Tailscale intacta.
**Pendientes:**
- Renombrar service `postgres-index-multi-byte-alarm-orbypg` a `n8n-postgres` para claridad (requiere downtime programado de n8n).
- Revisar/crear token Cloudflare con permisos DNS para `laschubys.com`.
- Documentar WAF/rate limits si existen en Cloudflare.
- Ejecutar checklist mensual TRIN (certificados, backups, workflows con errores).

---

## [2026-06-24] KIMICO | Migración Coolify → Dokploy: día 1

**Agente:** KIMICO (TRIN)
**Tareas:**
- Eliminados todos los backups antiguos (VPS, Dell, Google Drive) por decisión de migrar limpio.
- Instalado Dokploy `v0.29.8` manualmente en Docker Swarm en VPS Hostinger.
- Creada cuenta admin y generada API key de Dokploy; guardada en Bitwarden (`Dokploy Admin API Key`).
- Configurado dominio base `dokploy.alvarodevrace.tech` con Traefik (SSL `none` por Cloudflare Tunnel/proxy).
- Añadido registro DNS CNAME en Cloudflare para `dokploy.alvarodevrace.tech` → túnel.
- Creado proyecto `infra` en Dokploy y migrado **Uptime Kuma** con datos preservados; dominio `status.alvarodevrace.tech` responde.
**Commits:** N/A (trabajo en infra/vault)
**PRs:** Ninguno
**Bloqueos:** Resolución DNS local en la Mac de Álvaro falla (`DNS_PROBE_POSSIBLE`) para `dokploy.alvarodevrace.tech`; acceso por IP Tailscale `http://100.105.133.25:3000` funciona. Posible caché Tailscale/Brave.
**Pendientes mañana:**
- Migrar Docuseal y Umami (infra).
- Migrar n8n + task runners (automation).
- Migrar Supabase self-hosted (database).
- Migrar apps productivas: laschubys-app, laschubys-api, alvaro-portfolio.
- Configurar GitHub App en Dokploy para deploys automáticos.
- Verificar DNS/SSL y apagar Coolify definitivamente.
- Limpiar Docker, redes huérfanas y actualizar documentación global.

---

## [2026-06-10] KIMICO | Cleanup completo: Netdata eliminado del VPS (~200 MB), Penpot eliminado de la Dell (~1.5 GB + 5.68 GB imágenes), DNS Cloudflare limpio (netdata/penpot/evolution), Dell rebooteado y validado (4 containers healthy, Planka HTTP 200, RAM 1.1/7.6 GB). OpenTofu module cloudflare-dns actualizado. Documentación INFRA-GLOBAL-2026-06.md y skills actualizadas.

## [2026-06-05/06] KIMICO | CobrosLatam restablecido. Estado real: contenedor corría pero Coolify reportaba `running:unknown` por falta de healthcheck. Fix vía API de Coolify: habilitado `health_check_enabled: true` (path `/`, return code 200) + restart. Nuevo contenedor `eqkh7yaz4bj2r0jcq0tl6mw5-001516632529` con estado `(healthy)`. https://cobroslatam.com responde 200. INFRA-GLOBAL actualizado de `exited:unhealthy` a `running:healthy`.
## [2026-06-06] KIMICO | Sincronización de memorias post-sesión. Actualizados para reflejar estado real: KIMI.md, agents/KIMI-AGENTS.md, .claude/skills/release-orchestrator.md, .claude/skills/observability-check.md, LasChubys/.claude/skills/observability-check.md, PLAN_MIGRACION.md, vault/laschubys/40-Credentials/INFRA.md (n8n API key rotada → referencia Bitwarden), system/SESSION_LOG.md (pendientes y credenciales). Eliminados falsos positivos restantes sobre CobrosLatam caído, backups fallidos y cron roto.
## [2026-06-05] KIMICO | Diagnóstico backups + alineación Sentry + limpieza exhaustiva de falsos positivos (5 pasadas). INFRA-GLOBAL-2026-06.md: Sentry ✅ CONFIGURADO. Migracion-Estado: 23/25 Done. Backups Dell con paths vacíos y Google Drive sync FALLÓ — detalle en `vault/infra/20-Tech/Backups-Diagnostico-2026-06-05.md`. Sin acceso SSH a Dell en esta sesión (apagado / Tailscale no rutado). Limpieza exhaustiva de memorias y skills: KIMI.md, KIMI-AGENTS.md, alvarodevrace credentials, SOPS-GUIDE, PLAN_MIGRACION, Angular-BFF, vault/INDEX.md (stack LasChubys), INDEX global, observability-check global + LasChubys, sre-runbook global + LasChubys, security-review global + LasChubys, infra-triage, dependency-audit, post-mortem LasChubys, release-orchestrator, angular-senior, angular-v19-patterns, angular-admin-demo-hardening, agents/PIXEL.md, agents/kimi/PIXEL.md, agents/NOVA.md, agents/LINK.md, CLAUDE.md LasChubys + Portfolio, Agrovivas/agents/AGENTS.md, repo-specific-pixel-laschubys SKILL, pixel-playbooks.
## [2026-06-05] KIMICO | Incidente Penpot 502 resuelto. Causa: contenedor `penpot-mcp` había sido eliminado durante cleanup; frontend 2.15 requiere upstream `penpot-mcp` en nginx. Solución: `docker compose up -d penpot-mcp` en Dell + restart frontend. Estado: HTTP 200 en https://penpot.alvarodevrace.tech. Documentación corregida: INFRA-GLOBAL-2026-06.md y Penpot-Self-Hosted.md marcan MCP como requerido obligatorio, no eliminable.
## [2026-06-05/06] KIMICO | Sistema de backups 3-2-1 restablecido. Problemas encontrados y corregidos: (1) API key n8n revocada → reemplazada desde BD. (2) Google Drive lleno (`storageQuotaExceeded`) → vaciada papelera + eliminados credentials `.sqlite` no comprimidos (~8.8 GB). (3) `backup-generate.sh` VPS ahora comprime credentials a `.sqlite.gz` y excluye `.sqlite` del sync a Drive. (4) Dell sync fallaba por permisos root → `chown alvaro:alvaro` en `/opt/backups/vps` y `coolify-config`. (5) Script Dell reescrito: ya no sube a Drive (evita borrados), verifica archivos recientes, notifica Telegram. (6) Cron roto `/opt/zion/backup.sh` eliminado; reemplazado por `0 4 * * * /opt/scripts/sync-backups.sh`. Validado: VPS, Dell y Google Drive contienen backups de 2026-06-05. Documentación actualizada: INFRA-GLOBAL-2026-06.md, Backups-Diagnostico-2026-06-05.md.
## [2026-06-04] EVA | Ingest dump TRIN: CF-Tunnel.md actualizado (analytics+raíz alvarodevrace.tech). laschubys/n8n.md actualizado (WF-LCH-SEO-01). Dump archivado.
## [2026-06-04] TRIN | PR #8 laschubys-app (sitemap/GTM→Umami/JSON-LD/CI) + PR #8 laschubys-api (migrations/CI/Dockerfile) + PR #9 fix sitemap proxy + Portfolio HEALTHCHECK mergeados. WF-LCH-SEO-01 activado. analytics+portfolio online vía Cloudflare Tunnel.
## [2026-05-22] EVA | Ingest dump TRIN: 4 páginas nuevas vault (Cloudflare-DNS, CF-Tunnel, UFW-Fail2ban, Migracion-Estado). Index actualizado. Dump archivado.
## [2026-05-22] TRIN | Migración v2.0 Fase 0+1+2 completa: GTM laschubys, DNS→Cloudflare, CF Tunnel, UFW+fail2ban, Bitwarden+SOPS. 13/25 tickets Done.
## [2026-05-20] TRIN | Penpot 2.15 instalado en Dell, proxy VPS actualizado y HTTPS verificado.
## [2026-05-19] TRIN | Optimización RAM VPS: supabase-analytics detenido (RAM 67% -> 56.3%).
## [2026-05-11] TRIN | Sesión de mejora de infra global: regla DNS corregida y Crawl4AI documentado.

---

## [2026-06-25] TRIN | Migración IDs globales de 20-Tech a INFRA-GLOBAL-2026-06.md

**Agente:** TRIN
**Tareas:**
- Revisados IDs en `vault/infra/20-Tech/` para determinar cuáles son globales/compartidos vs. locales/proyecto.
- Añadidos al SSOT `INFRA-GLOBAL-2026-06.md`:
  - Nameservers Cloudflare de `alvarodevrace.tech`: `aleena.ns.cloudflare.com` / `byron.ns.cloudflare.com`.
  - Tunnel CNAME: ver `vault/INFRA-GLOBAL-2026-06.md` → Cloudflare Tunnel.
- Reemplazados IDs globales por referencias a `INFRA-GLOBAL-2026-06.md` en:
  - `CF-Tunnel.md`: Tunnel ID y path de credentials.
  - `Cloudflare-DNS.md`: Zone ID, nameservers, Tunnel CNAME en tabla.
  - `Migracion-Estado.md`: Planka Board ID, Cloudflare Zone ID, CF Tunnel ID, Age public key, Bitwarden folder ID, SSH VPS.
  - `SOPS-GUIDE.md`: Age public key en cabecera.
- Mantenidos inline (con nota explicativa) por legibilidad operativa:
  - IPs del VPS y comandos SSH en `RUNBOOK-INCIDENTES.md`.
  - Comandos `curl` con Zone ID y Tunnel CNAME en `Cloudflare-DNS.md`.
  - Comandos SOPS con Age public key en `SOPS-GUIDE.md`.
  - GTM Container ID `GTM-KHQH2FT9` en `Migracion-Estado.md` (proyecto Las Chubys).
  - Nombres de servicios Docker Swarm en `RUNBOOK-INCIDENTES.md` (ejemplos del momento).
- Actualizado `vault/infra/00-Index/INDEX.md` con nota del SSOT.
**Commits:** N/A (trabajo en vault)
**PRs:** Ninguno
**Bloqueos:** Ninguno
