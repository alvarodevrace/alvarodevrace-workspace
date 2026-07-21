# Sentry → Telegram Alerts para Las Chubys

## Objetivo
Recibir alertas del bot de Las Chubys en Telegram cuando Sentry detecte errores en `laschubys-app` o `laschubys-api`, sin saturar el chat.

## Alcance
- Workflow n8n: `LCH / Sentry / Alert`.
- Webhook: `POST /webhook/lch-sentry-alert`.
- Notificaciones al bot `telegram-bot-laschubys` en `TELEGRAM_LCH_CHAT_ID`.
- Reglas de alerta en Sentry (UI):
  1. Issue nuevo.
  2. Regresión.
  3. ≥5 eventos del mismo issue en 15 minutos.
  4. ≥10 eventos totales en 15 minutos.

## Arquitectura
```
Sentry Issue Alert
  → POST https://n8n.alvarodevrace.tech/webhook/lch-sentry-alert
    → n8n: parsea payload, filtra duplicados ruido
      → Telegram bot Las Chubys
```

## Payload esperado de Sentry
Sentry envía JSON con campos como:
- `action`: `created`, `resolved`, etc.
- `data.issue.id`, `data.issue.title`, `data.issue.shortId`
- `data.issue.status`, `data.issue.level`
- `data.event.title`, `data.event.culprit`, `data.event.web_url`
- `data.event.tags[]`, `data.event.environment`

## Mensaje Telegram
Formato MarkdownV2:
```
🚨 *Sentry — Las Chubys*

*Issue:* `{title}`
*Nivel:* `{level}`
*Proyecto:* `{project}`
*Ambiente:* `{environment}`
*URL:* {sentry_url}

`{culprit}`
```

## Manejo de ruido
- No enviar alertas por eventos individuales repetidos (la regla de Sentry ya agrupa).
- Si `action` es `resolved`, enviar notificación de recuperación opcional (v2).
- Incluir `environment` para distinguir producción de otros entornos.

## Credenciales
- Bot token: variable de workflow `TELEGRAM_LCH_BOT_TOKEN`.
- Chat ID: variable de workflow `TELEGRAM_LCH_CHAT_ID`.

## Testing
1. Forzar error con `GET /api/health/debug-sentry`.
2. Verificar que Sentry reciba el evento.
3. Verificar que la alerta dispare el webhook.
4. Confirmar mensaje en Telegram Las Chubys.

## Out of scope
- Alertas por performance (pueden agregarse luego).
- Dashboard de Sentry en admin.
