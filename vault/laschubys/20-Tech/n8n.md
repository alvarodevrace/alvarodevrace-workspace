# n8n — Automatización Las Chubys

Automatizaciones y flujos de trabajo activos para Las Chubys.

## 🔗 Referencias

- URL: https://n8n.alvarodevrace.tech
- MOC: [[MOC-Las-Chubys]]
- Schema: `laschubys` (PostgREST: `Accept-Profile: laschubys`)
- Infra global: `vault/INFRA-GLOBAL-2026-06.md`

## 🛠️ Workflows Activos (8)

| Workflow | ID | Trigger | Propósito | Estado |
| --- | --- | --- | --- | --- |
| `OPS / Infra / Alertas` | `BFsLIVWRC0B3IP6K` | Webhook `POST /webhook/infra-alert` | Alertas de infra hacia Telegram AlvaroDevRace | ✅ |
| `OPS / Infra / Resource Alert` | `DhTLEpls5Djq94rE` | Webhook `POST /webhook/infra-resource-alert` | Alertas de recursos del VPS hacia Telegram AlvaroDevRace | ✅ |
| `LCH / Sentry / Alert` | `75uNLt9LI5PHLUiG` | Webhook `POST /webhook/lch-sentry-alert` | Alertas Sentry app/api → Telegram Las Chubys | ⏳ Pendiente recrear |
| `LCH / Infra / Keepalive` | `nmqhJawyIvV8aOIt` | Cron + webhook `lch-keepalive-run` | Ping a `laschubys.com` | ✅ |
| `LCH / Operaciones / Error handler` | `R8sYRPKvdNBKLEKX` | `n8n-nodes-base.errorTrigger` | Recibe fallos de workflows LCH y notifica por Telegram Las Chubys | ✅ |
| `WF-LCH-META-SYNC` | `ljRaQeAsfs43Mkme` | Schedule diario 06:00 UTC | Sync followers Meta (IG + FB) → `laschubys.social_metrics` | ✅ |
| `LCH / Backup / General` | `7MVk9RSekCVvyhCT` | Schedule diario + webhook `lch-backup-run` | Backup workflows n8n a GitHub `alvarodevrace/laschubys-backups` | ✅ |
| `LCH / Backup / Supabase` | `bzhKoL4anHcO0ysE` | Schedule diario + webhook `lch-supabase-backup-run` | Backup schema `laschubys` a GitHub + Google Drive | ✅ |

> **Eliminados 2026-07-10:** `WF-LCH-SEO-01`, `LCH / Reportes / Notify`, `LCH / Infra / Alertas` (duplicado), `LCH / Notificaciones / Comment notify`. No se usaban en ≥1 mes o estaban huérfanos.

## Workflows exportados en vault (pendientes de importar)

| Workflow | Archivo | Trigger | Propósito |
|---|---|---|---|
| `LCH / Contact / Notify` | [n8n/workflows/LCH-Contact-Notify.json](n8n/workflows/LCH-Contact-Notify.json) | Webhook `POST /webhook/lch-contact-notify` | Notificar contactos del formulario vía bot Las Chubys |
| `OPS / Infra / Resource Alert` | [n8n/workflows/OPS-Resource-Alert.json](n8n/workflows/OPS-Resource-Alert.json) | Webhook `POST /webhook/infra-resource-alert` | Alertas de recursos del VPS vía bot AlvaroDevRace |

> **Pendiente:** importar a n8n con `N8N_API_KEY` y vincular credenciales Telegram (`telegram-bot-laschubys`, `telegram-bot-alvarodevrace`).

## WF-LCH-META-SYNC — Meta Graph API followers

- **Trigger:** Schedule diario a las 6:00 AM UTC.
- **Lógica:**
  1. HTTP GET Instagram Business Account `17841438018214431` followers + media count.
  2. HTTP GET Facebook Page `1131865923345617` followers.
  3. Merge y build de filas `laschubys.social_metrics`.
  4. Insert vía PostgREST con `Accept-Profile: laschubys` y `Prefer: resolution=merge-duplicates`.
- **Credencial:** Token System User Meta (`global/meta-laschubys`), env var `META_TOKEN`.
- **Última verificación:** 2026-07-10 — ejecuciones recientes `success`.

## Backups

- **Repo destino:** `alvarodevrace/laschubys-backups`.
- **Token GitHub:** `bitwarden:global/github-backup-token`.
- **Rutas en repo:**
  - `infra/n8n/INVENTORY-YYYY-MM-DD.json`
  - `supabase/laschubys-YYYY-MM-DD.sql`
- **Notificación:** Telegram AlvaroDevRace / Las Chubys según corresponda.

## 🚀 Decisiones Vigentes

- **HTTP Request:** typeVersion **4.2** (nunca 4.4).
- **Supabase INSERT:** usar nodo HTTP Request a PostgREST, no el nodo Supabase INSERT.
- **Supabase UPDATE:** usar `fieldsUi.fieldValues`, no `fieldsUi.values`.
- **Env vars:** `TELEGRAM_BOT_TOKEN` (AlvaroDevRace), `TELEGRAM_LCH_BOT_TOKEN` (Las Chubys), `TELEGRAM_LCH_CHAT_ID`/`TELEGRAM_CHAT_ID`.
- **Error handling:** workflows críticos apuntan a `errorWorkflow: R8sYRPKvdNBKLEKX`; el handler usa `errorTrigger`.

## ⚠️ Hallazgos Resueltos

- **2026-07-10:** `LCH / Operaciones / Error handler` fue corregido a `errorTrigger` y validado con ejecución forzada.
- **2026-07-10:** 5 workflows apuntaban a un `errorWorkflow` inexistente; se redirigieron a `R8sYRPKvdNBKLEKX`.
- **2026-06-06:** Fallo masivo por `SQLITE_READONLY` en DB n8n; corregido con permisos `node:node` (UID 1000).
- **2026-05-09:** URLs hardcodeadas a Supabase Cloud saneadas a `db.alvarodevrace.tech` + `Accept-Profile: laschubys`.
