# Task 6 — Reporte de limpieza DRY

## Archivo modificado
- `vault/laschubys/40-Credentials/INFRA.md`

## Cambios aplicados

1. **Cloudflare Zone ID**: se reemplazó el ID literal por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
2. **Snippet de purga de caché**: se parametrizó `ZONE_ID` y se eliminó el hardcode del zone ID.
3. **Servicios principales**: las URLs/IDs globales de n8n, Supabase y Dokploy se reemplazaron por referencias a `vault/INFRA-GLOBAL-2026-06.md`.
4. **Tokens y Credenciales**: se redujo la tabla a las referencias específicas de Las Chubys (Sentry DSN e Indexing API OAuth2); el resto se delega a `vault/INFRA-GLOBAL-2026-06.md`.
5. **Uptime Kuma**: se conservaron solo los 3 monitores de Las Chubys; los monitores globales se señalaron en `vault/INFRA-GLOBAL-2026-06.md`.
6. **Infraestructura Física**: se eliminó la sección completa y su tabla de servidores/Tailscale.

## Datos conservados (específicos del proyecto)

- Planka IDs.
- GitHub repos/remotes y GitHub Secrets names.
- Sentry DSN refs.
- Monitores Uptime Kuma de Las Chubys.
- GTM, PayPhone, Printful, MailerSend, Telegram bot de Las Chubys, Umami.
- SEO, stack técnico, git flow, problemas conocidos y TODO backlog.

## Validación

Comando ejecutado:

```bash
rg -n -g 'vault/laschubys/40-Credentials/INFRA.md' 'b1bd4dda49d48900eecb9228673ef1e9|dcZfubBCdj1wno5hroswj|XX0AfFKhYHn9ayErXevJF|GzBwWmUjlYRCgfMK6tzBt|https://n8n\.alvarodevrace\.tech|https://db\.alvarodevrace\.tech'
```

Resultado: salida vacía (código de salida 1 de `rg`, sin coincidencias). ✅

## Estado
**DONE**
