# Reporte — Task 1: Consolidar `vault/INFRA-GLOBAL-2026-06.md`

## Archivo modificado
- `vault/INFRA-GLOBAL-2026-06.md`

## Ediciones realizadas

1. **Encabezado SSOT** (líneas 3–5):
   - Se reforzó la nota como fuente de verdad única y se agregó la aclaración de que cualquier repetición en otro archivo del vault queda invalidada por este archivo.

2. **Sección Cloudflare unificada** (líneas 8–25):
   - Se unificaron los datos del tunnel, estado, tokens y el hallazgo del token de `laschubys.com` en la sección inicial.
   - Se eliminó el bloque duplicado que estaba al final del archivo (antes líneas ~365–383).

3. **Detalles de Docuseal** (bajo `### Servicios (Compose)`):
   - Se agregó subsección `### Docuseal` con:
     - **Template ID:** 2 | Slug: `mPkXkD7iTpQEWo`

4. **Referencias Bitwarden migradas desde `vault/alvarodevrace/40-Credentials/INFRA.md`**:
   - Se agregaron a la tabla de secretos maestros:
     - `n8n Service Password` → `bitwarden:global/n8n-service-password`
     - `Gemini API Key` → `bitwarden:global/gemini-api-key`
     - `Mistral API Key` → `bitwarden:global/mistral-api-key`
     - `OpenRouter API Key` → `bitwarden:global/openrouter-api-key`
     - `Telegram Chat ID (alvarodevrace)` → `bitwarden:global/telegram-chat-id-alvarodevrace`
   - Se agregaron debajo de la tabla:
     - **Desbloqueo:** `bw unlock` con email `alcarreram@hotmail.com`.
     - **Clave Age pública:** `age19kgpxyhgn8c0tv28lvqe0zws5k0pwhwnp79vsyy0tl2f0hjp0fps734wv6`

5. **Nota DNS huérfano de Evolution API**:
   - Se agregó bajo la sección `## ~~Evolution API — WhatsApp~~ ✅ ELIMINADO 2026-06-06`:
     - `> **Pendiente:** limpiar registro DNS huérfano \`evolution.alvarodevrace.tech\` si aún existe.`

## Validación

Comando ejecutado:

```bash
rg -n "## Cloudflare" vault/INFRA-GLOBAL-2026-06.md
```

Resultado:

```
9:## Cloudflare — DNS + Tunnel
```

- Se encontró exactamente **1** coincidencia de encabezado `## Cloudflare`, lo cual cumple la regla de no tener 3+ y confirma que la sección duplicada fue eliminada.

## Consideraciones
- No se editaron `system/SESSION_LOG.md` ni archivos `vault/*/10-Log/LOG.md`.
- No se introdujeron secretos completos; todas las credenciales nuevas usan referencias `bitwarden:*`.
- El archivo de origen `vault/alvarodevrace/40-Credentials/INFRA.md` no fue modificado.
- Queda una pequeña línea en blanco extra entre Planka y Resend por la eliminación del bloque Cloudflare; no afecta la legibilidad ni la estructura.
