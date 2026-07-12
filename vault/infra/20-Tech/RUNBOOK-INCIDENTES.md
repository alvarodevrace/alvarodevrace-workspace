# RUNBOOK-INCIDENTES — AlvaroDevRace Infra

**Actualizado:** 2026-06-25  
**VPS:** 100.105.133.25 (Tailscale) / 72.60.26.201 (público)  
**SSH:** `ssh root@100.105.133.25`  
**Orquestador:** Dokploy (reemplazó a Coolify)

> **Nota:** IPs del VPS y nombres de servicios de ejemplo se mantienen inline por legibilidad operativa. SSOT global: `INFRA-GLOBAL-2026-06.md#nodos`. Los nombres de servicios Docker Swarm (`laschubys-app-16uema`, etc.) son ejemplos del momento; verificar el nombre actual con `docker service ls`.

---

## Runbook 1: Caída de laschubys-app

**Síntoma:** Uptime Kuma alerta `laschubys-app DOWN` o `https://laschubys.com` no responde.

### Diagnóstico (2 min)
```bash
ssh root@100.105.133.25
docker service ls | grep laschubys
docker ps -a | grep -i "laschubys"
```

### Paso a paso

**1. Service down:**
```bash
docker service update --force laschubys-app-16uema
# Esperar 30s, verificar: curl -I https://laschubys.com
```

**2. OOMKilled (exit code 137):**
```bash
free -h                           # ver RAM libre
docker stats --no-stream          # identificar consumidor
# Detener service no crítico temporalmente (ej. crawl4ai)
docker service scale <service-no-critico>=0
docker service update --force laschubys-app-16uema
```

**3. Error en último deploy:**
- Dokploy → proyecto Las Chubys → laschubys-app → Deployments
- Hacer **Rollback** al deployment anterior o redeploy desde la UI/API

**4. Ver logs:**
```bash
docker service logs laschubys-app-16uema --tail 100 -f
```
Buscar: `ECONNREFUSED` (API_URL mal), `Cannot find module` (build roto), `ENOMEM` (RAM).

**5. API_URL no resuelve (`EAI_AGAIN laschubys-api`):**
```bash
# Verificar servicios en red Dokploy
docker network inspect dokploy-network | grep -A3 "laschubys-api"
# Si el alias no aparece, reconectar el service (raro en Swarm):
docker service update --force laschubys-api-b9k60b
```

**Escalar a Álvaro si:** No se resuelve en 10 min o el rollback también falla.

---

## Runbook 2: Caída de Supabase

**Síntoma:** laschubys-api retorna 500, errores en Sentry con `connection refused postgres`, o Uptime Kuma alerta `Supabase DB DOWN`.

### Diagnóstico (2 min)
```bash
ssh root@100.105.133.25
docker ps -a | grep supabase | grep -v healthy
```

### Paso a paso

**1. Container supabase-db exited:**
```bash
docker start supabase-db
sleep 10
docker ps | grep supabase-db   # debe decir "healthy"
```

**2. Ver logs de Postgres:**
```bash
docker logs supabase-db --tail 100 2>&1 | grep -i "error\|fatal\|panic"
```

**3. Disco lleno:**
```bash
df -h /                        # si >90% → problema
du -sh /var/lib/docker/volumes/*/  # identificar volumen gordo
# Limpiar logs viejos:
docker exec supabase-db psql -U postgres -c "SELECT pg_size_pretty(pg_database_size('postgres'));"
# Si WAL acumulado: vacuumdb --all --analyze
docker exec supabase-db vacuumdb -U postgres --all --analyze
```

**4. RAM insuficiente (Postgres OOM):**
```bash
dmesg | grep -i "oom\|killed" | tail -20
free -h
# Reiniciar servicios no críticos para liberar RAM
```

**5. Verificar conexión desde laschubys-api:**
```bash
docker exec $(docker ps -q -f name=laschubys-api-b9k60b) \
  wget -qO- http://laschubys-api-b9k60b:3000/health 2>&1
```

**Restore desde backup si Postgres corrupto:**
```bash
# Ver sección Runbook 4 — Restore drill
BACKUP=$(ls /opt/backups/supabase/laschubys-*.sql | sort -r | head -1)
docker exec -i supabase-db psql -U postgres -c "DROP SCHEMA laschubys CASCADE; CREATE SCHEMA laschubys;"
docker exec -i supabase-db psql -U postgres < $BACKUP
```

**Escalar a Álvaro si:** Postgres corrupto y restore falla, o disco físico del VPS lleno.

---

## Runbook 3: Caída del VPS completo

**Síntoma:** SSH no responde, Uptime Kuma alerta múltiples servicios DOWN, `ping 72.60.26.201` falla.

### Diagnóstico (1 min)
- Verificar Tailscale: `tailscale ping 100.105.133.25`
- Si falla Tailscale también: el VPS está caído.

### Paso a paso

**1. Reiniciar via Hostinger panel:**
- Login: https://hpanel.hostinger.com → VPS → Manage → Restart
- Esperar 2-3 min, reintentar SSH.

**2. VPS arriba pero servicios caídos:**
```bash
ssh root@100.105.133.25
# Ver qué está corriendo
docker ps -a --format "table {{.Names}}\t{{.Status}}" | grep -v Up
# Reiniciar Dokploy (gestiona el resto)
docker service update --force dokploy
sleep 30
# Los services se auto-reinician por Swarm
```

**3. Dokploy no levanta:**
```bash
# Iniciar services críticos manualmente
docker service scale supabase-db=1 supabase-rest=1 supabase-auth=1
docker service update --force laschubys-api-b9k60b   # laschubys-api
docker service update --force laschubys-app-16uema   # laschubys-app
```

**4. Verificar DNS (Cloudflare):**
```bash
# Si IP del VPS cambió tras restart (raro pero posible):
curl -s ifconfig.me   # IP actual del VPS
# Comparar con A record en Cloudflare:
# Dashboard: https://dash.cloudflare.com → alvarodevrace.tech → DNS
```

**5. Recuperación de datos:**
```bash
# Backups en /opt/backups/supabase/ (sobreviven al reboot)
ls -la /opt/backups/supabase/ | tail -5
```

**Escalar a Hostinger si:** VPS no reinicia tras 10 min o disco físico del host con error.

---

## Runbook 4: Restore drill mensual

**Ejecutar el 1ro de cada mes.** Ver log histórico en `vault/laschubys/10-Log/restore-drill-*.md`.

```bash
ssh root@100.105.133.25

# Levantar Postgres temporal
docker rm -f postgres-test 2>/dev/null || true
docker run -d --name postgres-test \
  -e POSTGRES_PASSWORD=testpass \
  -e POSTGRES_USER=postgres \
  -p 5433:5432 postgres:15
sleep 5

# Restaurar backup más reciente
docker exec postgres-test psql -U postgres -c 'CREATE SCHEMA laschubys;'
BACKUP=$(ls /opt/backups/supabase/laschubys-*.sql | sort -r | head -1)
echo "Backup: $BACKUP"
docker exec -i postgres-test psql -U postgres < $BACKUP

# Verificar
docker exec postgres-test psql -U postgres -c '\dt laschubys.*'
docker exec postgres-test psql -U postgres -c 'SELECT COUNT(*) FROM laschubys.blog_posts;'
docker exec postgres-test psql -U postgres -c 'SELECT COUNT(*) FROM laschubys.products;'

# Limpiar
docker stop postgres-test && docker rm postgres-test
```

**Registrar resultado en:** `vault/laschubys/10-Log/restore-drill-YYYY-MM-DD.md`

---

## Checklist post-incidente

- [ ] Servicio restaurado y verificado
- [ ] Causa raíz identificada
- [ ] Uptime Kuma volvió a verde
- [ ] Si fue deploy roto: PR bloqueado hasta fix
- [ ] Actualizar este runbook si el procedimiento cambió
