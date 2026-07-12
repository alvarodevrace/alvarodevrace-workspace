# Resource Limits — Las Chubys + Infra VPS

Límites de recursos y políticas de reinicio aplicados el 2026-07-12.

## Servicios Swarm (Dokploy)

| Servicio | Mem límite | CPU límite | Mem reserva | CPU reserva | Reinicio |
|---|---|---|---|---|---|
| `laschubys-app-16uema` | 512 MB | 1.0 | 128 MB | 0.25 | `any` |
| `laschubys-api-b9k60b` | 512 MB | 1.0 | 128 MB | 0.25 | `any` |

### Comandos aplicados

```bash
docker service update \
  --limit-memory 512M --limit-cpu 1.0 \
  --reserve-memory 128M --reserve-cpu 0.25 \
  --restart-condition any \
  laschubys-app-16uema

docker service update \
  --limit-memory 512M --limit-cpu 1.0 \
  --reserve-memory 128M --reserve-cpu 0.25 \
  --restart-condition any \
  laschubys-api-b9k60b
```

### Verificación

```bash
docker service inspect --format \
  "{{.Spec.Name}} mem={{.Spec.TaskTemplate.Resources.Limits.MemoryBytes}} cpu={{.Spec.TaskTemplate.Resources.Limits.NanoCPUs}} restart={{.Spec.TaskTemplate.RestartPolicy.Condition}}" \
  laschubys-app-16uema laschubys-api-b9k60b
```

Resultado esperado:

```
laschubys-app-16uema mem=536870912 cpu=1000000000 restart=any
laschubys-api-b9k60b mem=536870912 cpu=1000000000 restart=any
```

## Contenedores standalone

| Contenedor | Mem límite / swap | CPU límite | Reinicio |
|---|---|---|---|
| `supabase-db` | 2 GB / 2 GB | 1.0 | `unless-stopped` |
| `n8n` | 1 GB / 1 GB | 0.5 | `unless-stopped` |
| `uptime-kuma` | 256 MB / 256 MB | 0.25 | `unless-stopped` |

### Comandos aplicados

```bash
docker update --memory 2g --memory-swap 2g --cpus 1.0 --restart unless-stopped supabase-db
docker update --memory 1g --memory-swap 1g --cpus 0.5 --restart unless-stopped n8n
docker update --memory 256m --memory-swap 256m --cpus 0.25 --restart unless-stopped uptime-kuma
```

### Verificación

```bash
docker inspect --format \
  "{{.Name}} mem={{.HostConfig.Memory}} swap={{.HostConfig.MemorySwap}} restart={{.HostConfig.RestartPolicy.Name}}" \
  supabase-db n8n uptime-kuma
```

Resultado esperado:

```
/supabase-db mem=2147483648 swap=2147483648 restart=unless-stopped
/n8n mem=1073741824 swap=1073741824 restart=unless-stopped
/uptime-kuma mem=268435456 swap=268435456 restart=unless-stopped
```

## Notas

- Los servicios Swarm reconvergieron sin downtime detectable.
- Los contenedores standalone no se reiniciaron; `docker update` aplica la configuración para el próximo arranque, excepto los límites de memoria/CPU que son en caliente.
- El contenedor `supabase-db` requiere monitoreo adicional de I/O de disco; no se aplicó límite de IOPS por no estar soportado de forma portable.
