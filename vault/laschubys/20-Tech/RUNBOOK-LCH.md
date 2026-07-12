# Runbook — Las Chubys Production

Guía de respuesta a incidentes para `laschubys.com` y `api.laschubys.com`.

## Referencias rápidas

| Recurso | URL / Comando |
|---|---|
| App | https://laschubys.com |
| API | https://api.laschubys.com/api/health |
| Status | https://status.alvarocarreramontalvo.space |
| Dokploy | http://100.105.133.25:3000 |
| n8n | https://n8n.alvarodevrace.tech |
| Vault infra | `vault/INFRA-GLOBAL-2026-06.md` |
| Backups | `vault/laschubys/20-Tech/n8n.md` → `LCH / Backup / *` |

---

## 1. Deploy fallido / rollback

### Síntomas
- Dokploy muestra deploy `failed` o `running:unhealthy`.
- `https://laschubys.com` devuelve 502/503.

### Diagnóstico

```bash
# Ver estado de servicios Swarm
ssh root@100.105.133.25 \
  'docker service ls | grep laschubys && docker service ps laschubys-app-16uema laschubys-api-b9k60b --no-trunc'

# Logs del contenedor fallido
ssh root@100.105.133.25 \
  'docker service logs laschubys-api-b9k60b --tail 100'
```

### Acciones
1. Si el fallo es de build, revisar `.github/workflows/ci.yml` y logs de GitHub Actions.
2. Si el contenedor no arranca, verificar variables de entorno en Dokploy.
3. **Rollback inmediato:** redeployar el último commit estable desde Dokploy UI o forzar redeploy.
4. Si el problema es de schema de BD, revisar migraciones de Supabase y aplicar manualmente si es necesario.

---

## 2. API devuelve 500

### Síntomas
- `GET /api/health` no responde `{ status: "ok" }`.
- Sentry reporta errores.

### Diagnóstico

```bash
ssh root@100.105.133.25 \
  'docker service logs laschubys-api-b9k60b --tail 200 -f'
```

### Checklist
1. **Supabase:** verificar que `supabase-db` esté healthy (`docker ps`).
2. **Env vars:** confirmar `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `SENTRY_DSN`.
3. **Rate limiting:** si muchos 500 vienen acompañados de 429, revisar `ThrottlerModule` y headers `X-Forwarded-For`.
4. **Reinicio:** si el contenedor está stuck, forzar redeploy en Dokploy.

---

## 3. Checkout no crea pedidos

### Síntomas
- El usuario completa el formulario pero no aparece el pedido.
- Respuesta 400/429/500 en `POST /api/checkout`.

### Checklist
1. Validar DTO en logs: campos `customer`, `items`, `total`.
2. Revisar rate limit: máximo 5 pedidos/minuto por IP (`@Throttle({ checkout: { limit: 5, ttl: 60000 } })`).
3. Verificar tabla `orders`/`order_items` en Supabase y políticas RLS (`service_role` para INSERT).
4. Revisar Sentry para trazas del error.

---

## 4. Contacto no llega

### Síntomas
- Formulario de contacto envía 201 pero no hay notificación en Telegram.
- No se guarda en `contacts`.

### Checklist
1. Verificar que `ContactService` postee a `N8N_WEBHOOK_URL` correcto (`https://n8n.alvarodevrace.tech/webhook/lch-contact-notify`).
2. Revisar ejecuciones del workflow `LCH / Contact / Notify` en n8n.
3. Comprobar credencial `telegram-bot-laschubys` y env var `TELEGRAM_LCH_CHAT_ID`.
4. Verificar RLS de `contacts`: INSERT vía `service_role`.
5. Probar manualmente:

```bash
curl -X POST https://n8n.alvarodevrace.tech/webhook/lch-contact-notify \
  -H 'Content-Type: application/json' \
  -d '{"source":"test","name":"Test","email":"test@test.com","message":"Hola","timestamp":"2026-07-12T00:00:00Z"}'
```

---

## 5. Auth OAuth falla

### Síntomas
- Login con Google redirige a error.
- No se crea sesión.

### Checklist
1. Verificar `SUPABASE_URL` y `SUPABASE_ANON_KEY` en el backend.
2. Confirmar que `ALLOWED_ORIGINS` incluye `https://laschubys.com`.
3. Revisar configuración OAuth de Google en Supabase Auth (URLs de redirección).
4. Verificar cookies `httpOnly` y políticas CORS.
5. Revisar logs de `laschubys-api` y `supabase-auth`.

---

## 6. RLS 403

### Síntomas
- Peticiones públicas devuelven 403 en tablas que deberían ser legibles.
- El BFF no puede escribir.

### Diagnóstico

```bash
ssh root@100.105.133.25 \
  'docker exec supabase-db psql -U supabase_admin -d postgres -c "SELECT tablename, policyname, cmd FROM pg_policies WHERE schemaname = '\''laschubys'\'' ORDER BY tablename, policyname;"'
```

### Acciones
1. Revisar matriz de RLS en `Supabase.md`.
2. Asegurar que el BFF use `service_role` para INSERT/UPDATE/DELETE; esa clave tiene `bypassrls`.
3. Si una tabla pública devuelve 403, verificar que tenga política `FOR SELECT USING (true)`.
4. Para `categories`: solo SELECT pública; escrituras vía `service_role`.

---

## Escalado

1. Revisar este runbook y `Architecture.md`.
2. Si el incidente persiste >30 min, ejecutar restore drill (`vault/laschubys/10-Log/restore-drill-2026-06-04.md`) y considerar rollback de BD.
3. Notificar por Telegram vía bot `telegram-bot-alvarodevrace`.
