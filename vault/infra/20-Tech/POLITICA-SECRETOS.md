# POLÍTICA DE SECRETOS — AlvaroDevRace

**Vigente desde:** 2026-05-22 | **Responsable:** TRIN

## Reglas absolutas

1. **0 secretos completos en archivos .md** — nunca, ningún agente, ninguna excepción
2. **SSH:** solo key-based (`~/.ssh/id_ed25519`) para VPS y Dell
3. **VPS:** conectar siempre por Tailscale `root@100.105.133.25`, no por IP pública
4. **`service_role` key:** solo en backend server-side, nunca en Angular/frontend
5. **`anon key`:** la única key usable en frontend
6. **Nuevos proyectos:** día 1 → Bitwarden + GitHub Secrets + Dokploy env vars. Nunca `.env` commiteado

## Dónde vive cada secreto

| Tipo de secreto | Dónde |
|---|---|
| Secretos maestros (SSH, JWT, passwords) | **Bitwarden** carpeta `AlvaroDevRace/global` |
| Variables CI/CD (deploy tokens, DSNs) | **GitHub Secrets** por repo |
| Variables runtime de app | **Dokploy** env vars por servicio |
| Archivos `.env` encriptados en repo | **SOPS** con clave Age |

## Rotación

| Secreto | Frecuencia |
|---|---|
| SSH keys | Al cambio de equipo / sospecha de compromiso |
| Cloudflare API Token | Semestral |
| Supabase Service Role Key | Semestral |
| Supabase Anon Key | Semestral |
| Telegram bot tokens | Anual o si se comprometen |
| Dokploy API key | Semestral |
| n8n API key | Semestral o si se revoca |

## Checklist de rotación de secretos

Aplicar cada vez que se rote un secreto compartido:

1. Generar nuevo valor en el servicio origen.
2. Guardar en Bitwarden (`AlvaroDevRace/global`).
3. Actualizar **GitHub Secrets** de los repos afectados.
4. Actualizar **Dokploy env vars** de apps/composes afectados.
5. **Revisar monitores de Uptime Kuma** que usen el secreto rotado (ej. `apikey` de Supabase) y actualizarlos. Verificar en la DB de Kuma (`/app/data/kuma.db`, tabla `monitor`, columna `headers`) que el JSON del header sea válido y compacto; un header mal formateado puede causar 401 silencioso pese a que `curl` manual funcione.
6. Verificar health checks y ejecuciones críticas post-rotación.
7. Documentar en `vault/infra/10-Log/LOG.md` con fecha y servicios afectados.

## Qué hacer si se compromete un secreto

1. Revocar inmediatamente en el servicio origen
2. Regenerar y guardar en Bitwarden
3. Actualizar en GitHub Secrets y Dokploy env vars
4. Actualizar referencias en vault (solo la referencia, no el valor)
5. Notificar en LOG.md con fecha y acción tomada
