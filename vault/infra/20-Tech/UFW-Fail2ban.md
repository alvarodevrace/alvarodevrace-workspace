# UFW + fail2ban + unattended-upgrades

**Fecha instalación:** 2026-05-22
**Estado:** Activo

## UFW

| Regla | Detalle |
|---|---|
| Default incoming | DENY |
| Default outgoing | ALLOW |
| SSH (22/tcp) | Solo interfaz `tailscale0` |
| Dokploy UI (3000/tcp) | Solo interfaz `tailscale0` y origen `100.83.137.17` (Mac) |
| 80/443 | Solo 15 rangos IP IPv4 de Cloudflare |
| Resto | BLOQUEADO |

**CRÍTICO:** SSH público bloqueado. Acceso VPS SIEMPRE por Tailscale:
```bash
ssh -i ~/.ssh/id_ed25519 root@100.105.133.25
```

**Estado actual (2026-07-10):**
```
To                         Action      From
--                         ------      ----
22/tcp on tailscale0       ALLOW IN    Anywhere
80,443/tcp                 ALLOW IN    15 rangos Cloudflare
3000/tcp on tailscale0     ALLOW IN    100.83.137.17
22/tcp (v6) on tailscale0  ALLOW IN    Anywhere (v6)
```

Notas:
- Reglas legacy eliminadas: `22` desde `10.0.0.0/8` (Coolify) y `Anywhere on tailscale0`.
- La regla `22/tcp` desde `100.83.137.17` se mantiene por redundancia, aunque la regla por interfaz `tailscale0` ya cubre el acceso.

## fail2ban

| Parámetro | Valor |
|---|---|
| Jail | sshd |
| maxretry | 3 |
| bantime | 24h |
| Estado | Activo |

```bash
# Ver bans activos
fail2ban-client status sshd

# Desbanear IP
fail2ban-client set sshd unbanip <IP>
```

## unattended-upgrades

Parches de seguridad automáticos. Sin reboot automático.

```bash
# Ver log
cat /var/log/unattended-upgrades/unattended-upgrades.log | tail -20
```

## Links relacionados

- [[CF-Tunnel]] — único ingreso tráfico web
- [[Cloudflare-DNS]] — IPs Cloudflare autorizadas en UFW
