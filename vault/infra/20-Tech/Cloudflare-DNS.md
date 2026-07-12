# Cloudflare DNS — alvarodevrace.tech

**Fecha migración:** 2026-05-22
**Estado:** Activo — DNS completamente en Cloudflare

## Datos clave

| Campo | Valor |
|---|---|
| Zone ID | ver `INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel` |
| Nameservers | ver `INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel` |
| API Token | `bitwarden:global/cloudflare-api-token` |
| Zona | `alvarodevrace.tech` |

## Decisión arquitectónica

Migrado desde Hostinger 2026-05-22. Hostinger ahora **solo sirve para renovar dominio**.
TRIN administra DNS vía API Cloudflare con token en Bitwarden.
15 registros migrados: A, CNAME, TXT, MX.

## Registros críticos

Todos los hostnames (`dokploy`, `n8n`, `planka`, `db`, etc.) → CNAME al tunnel Cloudflare:
ver `INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel` (Tunnel CNAME).

> **Nota:** Los valores concretos de Zone ID y Tunnel CNAME se mantienen en los ejemplos de comandos a continuación por legibilidad; el SSOT es `INFRA-GLOBAL-2026-06.md`.

## Cómo gestionar

```bash
# Listar registros
curl -s "https://api.cloudflare.com/client/v4/zones/2a17143e03abfec70bd29db73b74fecf/dns_records" \
  -H "Authorization: Bearer $CF_TOKEN" | jq '.result[] | {name, type, content}'

# Crear registro
curl -X POST "https://api.cloudflare.com/client/v4/zones/2a17143e03abfec70bd29db73b74fecf/dns_records" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type":"CNAME","name":"nuevo","content":"49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a.cfargotunnel.com","proxied":true}'
```

## Links relacionados

- [[CF-Tunnel]] — tráfico enrutado por tunnel, no IP directa
- [[UFW-Fail2ban]] — IP pública bloqueada
- [[POLITICA-SECRETOS]] — token en Bitwarden
