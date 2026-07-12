# Cloudflare Tunnel — alvarodevrace-vps

**Fecha instalación:** 2026-05-22
**Estado:** Activo — 4 conexiones al edge Cloudflare

## Datos clave

| Campo | Valor |
|---|---|
| Nombre | `alvarodevrace-vps` |
| Tunnel ID | ver `INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel` |
| Credentials VPS | `/root/.cloudflared/<TUNNEL_ID>.json` (ver SSOT) |
| Config VPS | `/etc/cloudflared/config.yml` |
| Versión cloudflared | `2026.5.0` |
| Servicio | `systemd: cloudflared` |

## Comportamiento

Todo el tráfico externo → Cloudflare edge → Tunnel → VPS `localhost:443` (noTLSVerify).
**Excepción:** servicios alojados en la Dell (`planka.alvarodevrace.tech`) se rutean directo a su IP Tailscale (`http://100.88.228.17:3333`) sin pasar por Traefik del VPS.
**La IP pública del VPS no es accesible directamente** — UFW bloquea 80/443 excepto IPs Cloudflare.

## Config (resumen)

```yaml
# /etc/cloudflared/config.yml
# IDs reales en INFRA-GLOBAL-2026-06.md#cloudflare--dns--tunnel
tunnel: <TUNNEL_ID>
credentials-file: /root/.cloudflared/<TUNNEL_ID>.json
ingress:
  - hostname: "analytics.alvarodevrace.tech"
    service: https://localhost:443
    originRequest:
      noTLSVerify: true
  - hostname: "alvarodevrace.tech"
    service: https://localhost:443
    originRequest:
      noTLSVerify: true
  - hostname: "*.alvarodevrace.tech"
    service: https://localhost:443
    originRequest:
      noTLSVerify: true
  - service: http_status:404
```

> **2026-06-04:** añadidas entradas explícitas para `analytics.alvarodevrace.tech` y `alvarodevrace.tech` (el wildcard no cubre el dominio raíz automáticamente).

## Gestión

```bash
# Estado
systemctl status cloudflared

# Reiniciar
systemctl restart cloudflared

# Ver logs
journalctl -u cloudflared -f
```

## Links relacionados

- [[Cloudflare-DNS]] — todos los hostnames CNAME al tunnel
- [[UFW-Fail2ban]] — tráfico directo bloqueado, solo tunnel pasa
