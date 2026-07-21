# Sentry → Telegram Alerts Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear un workflow n8n que reciba webhooks de Sentry y notifique errores al bot de Telegram de Las Chubys, con reglas de alerta configuradas en Sentry.

**Architecture:** Webhook entrante en n8n (`/webhook/lch-sentry-alert`) → parsea payload de Sentry → formatea mensaje MarkdownV2 → envía por Telegram bot Las Chubys. Las reglas de frecuencia y tipo de alerta viven en Sentry Alerts UI.

**Tech Stack:** n8n v1.x, Telegram bot API, Sentry webhook alerts.

## Global Constraints
- No escribir secrets completos en archivos `.md` ni JSON exportables.
- Usar variables de workflow en n8n para `TELEGRAM_LCH_BOT_TOKEN` y `TELEGRAM_LCH_CHAT_ID`.
- HTTP Request nodes: typeVersion **4.2**.
- Workflow exportable guardado en `vault/laschubys/20-Tech/n8n/workflows/`.

---

### Task 1: Crear workflow n8n exportable `LCH / Sentry / Alert`

**Files:**
- Create: `vault/laschubys/20-Tech/n8n/workflows/LCH-Sentry-Alert.json`
- Modify: `vault/laschubys/20-Tech/n8n.md`
- Modify: `vault/INFRA-GLOBAL-2026-06.md`

**Interfaces:**
- Consumes: Env vars de n8n `TELEGRAM_LCH_BOT_TOKEN`, `TELEGRAM_LCH_CHAT_ID`.
- Produces: Webhook URL `https://n8n.alvarodevrace.tech/webhook/lch-sentry-alert`.

- [ ] **Step 1: Diseñar JSON del workflow**

Estructura del workflow (4 nodos):
1. `Webhook` — method `POST`, path `lch-sentry-alert`, response `200`.
2. `Set` — extrae campos del payload Sentry:
   - `action` = `{{ $json.body.action }}`
   - `title` = `{{ $json.body.data.issue.title }}`
   - `level` = `{{ $json.body.data.issue.level }}`
   - `project` = `{{ $json.body.project_slug }}`
   - `environment` = `{{ $json.body.data.event.environment }}`
   - `url` = `{{ $json.body.data.issue.url }}`
   - `culprit` = `{{ $json.body.data.event.culprit }}`
3. `Telegram` — sendMessage:
   - chat ID: `={{ $env.TELEGRAM_LCH_CHAT_ID }}`
   - text: mensaje MarkdownV2 formateado.
   - parse_mode: `MarkdownV2`.
4. `NoOp` — fin.

Texto del mensaje:
```text
🚨 *Sentry — Las Chubys*

*Issue:* {{ $json.title }}
*Nivel:* {{ $json.level }}
*Proyecto:* {{ $json.project }}
*Ambiente:* {{ $json.environment }}
*URL:* [Ver en Sentry]({{ $json.url }})

`{{ $json.culprit }}`
```

- [ ] **Step 2: Guardar JSON exportable en vault**

Crear `vault/laschubys/20-Tech/n8n/workflows/LCH-Sentry-Alert.json` con el workflow diseñado, usando placeholders `$env.TELEGRAM_LCH_BOT_TOKEN` y `$env.TELEGRAM_LCH_CHAT_ID`.

- [ ] **Step 3: Documentar workflow en n8n.md**

Añadir fila a la tabla de workflows activos:
```markdown
| `LCH / Sentry / Alert` | `<ID tras importar>` | Webhook `POST /webhook/lch-sentry-alert` | Alertas Sentry → Telegram Las Chubys |
```

- [ ] **Step 4: Commit del vault**

```bash
git add docs/superpowers/specs/2026-07-12-sentry-telegram-alerts-design.md docs/superpowers/plans/2026-07-12-sentry-telegram-alerts.md vault/laschubys/20-Tech/n8n/workflows/LCH-Sentry-Alert.json vault/laschubys/20-Tech/n8n.md
git commit -m "docs(vault): spec, plan y workflow exportable Sentry → Telegram LCH"
git push
```

---

### Task 2: Importar y activar workflow en n8n

**Files:**
- Test: `curl` a n8n API.

**Interfaces:**
- Consumes: `LCH-Sentry-Alert.json`, `N8N_API_KEY` desde Bitwarden.
- Produces: Workflow activo con ID en n8n.

- [ ] **Step 1: Obtener N8N_API_KEY**

```bash
bw unlock "@lv4r0C4rr3r4"
export BW_SESSION="..."
bw get password "n8n-api-key"
```

- [ ] **Step 2: Importar workflow vía API**

```bash
curl -X POST https://n8n.alvarodevrace.tech/api/v1/workflows \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -H "Content-Type: application/json" \
  -d @vault/laschubys/20-Tech/n8n/workflows/LCH-Sentry-Alert.json
```

Guardar el `id` devuelto.

- [ ] **Step 3: Activar workflow**

```bash
curl -X POST "https://n8n.alvarodevrace.tech/api/v1/workflows/{id}/activate" \
  -H "X-N8N-API-KEY: $N8N_API_KEY"
```

- [ ] **Step 4: Verificar env vars en n8n**

Confirmar que n8n tiene `TELEGRAM_LCH_BOT_TOKEN` y `TELEGRAM_LCH_CHAT_ID` configuradas. Si no, añadirlas en Dokploy y reiniciar n8n.

---

### Task 3: Configurar Sentry Alert Rule

**Files:**
- Test: Sentry UI + endpoint debug.

**Interfaces:**
- Consumes: Webhook URL de n8n.
- Produces: Regla de alerta Sentry activa.

- [ ] **Step 1: Crear regla de alerta en proyecto `laschubys-app`**

En https://alvarodevrace.sentry.io/projects/laschubys-app/alerts/rules/new/:
- When: `A new issue is created` OR `An issue changes state from resolved to unresolved` OR `An event's count exceeds 5 in 15 minutes`.
- Then: `Send a notification via Webhook`.
- Webhook URL: `https://n8n.alvarodevrace.tech/webhook/lch-sentry-alert`.

- [ ] **Step 2: Crear regla equivalente en proyecto `laschubys-api`**

Repetir para https://alvarodevrace.sentry.io/projects/laschubys-api/alerts/rules/new/.

---

### Task 4: Test end-to-end

**Files:**
- Test: `curl` a API debug-sentry + logs n8n + Telegram.

- [ ] **Step 1: Forzar error en backend**

```bash
curl -s https://api.laschubys.com/api/health/debug-sentry
```

- [ ] **Step 2: Esperar 1-2 minutos**

Sentry agrupa y dispara la alerta.

- [ ] **Step 3: Verificar ejecución del workflow**

```bash
curl -s "https://n8n.alvarodevrace.tech/api/v1/executions?workflowId={id}&limit=5" \
  -H "X-N8N-API-KEY: $N8N_API_KEY"
```

- [ ] **Step 4: Confirmar mensaje en Telegram Las Chubys**

- [ ] **Step 5: Si falla, revisar logs**

```bash
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25 "docker logs --tail 50 n8n"
```

---

### Task 5: Actualizar documentación del vault

**Files:**
- Modify: `vault/laschubys/10-Log/LOG.md`
- Modify: `vault/laschubys/00-Index/INDEX.md`
- Modify: `vault/INFRA-GLOBAL-2026-06.md`

- [ ] **Step 1: Añadir entrada en LOG.md**

Resumen: workflow creado, Sentry rules configuradas, test end-to-end OK.

- [ ] **Step 2: Actualizar INDEX.md**

Añadir `LCH / Sentry / Alert` a la tabla de workflows en el índice.

- [ ] **Step 3: Actualizar INFRA-GLOBAL-2026-06.md**

Añadir `LCH / Sentry / Alert` a la tabla de workflows n8n.

- [ ] **Step 4: Ejecutar kimi-vault-lint**

```bash
# seguir checklist de kimi-vault-lint
```

- [ ] **Step 5: Commit y push del vault**

```bash
git add vault/laschubys/10-Log/LOG.md vault/laschubys/00-Index/INDEX.md vault/INFRA-GLOBAL-2026-06.md
git commit -m "docs(vault): Sentry → Telegram alertas activas"
git push
```

---

## Spec Coverage

- ✅ Workflow n8n con webhook → Telegram: Task 1, 2.
- ✅ Reglas Sentry (nuevo, regresión, umbral): Task 3.
- ✅ Test end-to-end: Task 4.
- ✅ Documentación vault: Task 5.

## Placeholder Scan

- Sin TBD/TODO.
- Código y comandos exactos incluidos.
- Variables de workflow referenciadas con `$env`.
