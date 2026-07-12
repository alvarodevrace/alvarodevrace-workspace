# Restore Drill — 2026-07-12

## Objetivo

Validar que un backup SQL del schema `laschubys` puede restaurarse en un contenedor PostgreSQL temporal y que los datos son coherentes.

## Backup utilizado

No se encontraron backups automáticos en `/opt/backups/supabase/laschubys-*.sql`. Se usó el backup manual creado previamente a los cambios DDL del día:

```
/opt/backups/supabase/manual/laschubys-pre-rls-20260712-113313.sql
```

> **Acción derivada:** revisar el job de backups automáticos (`/opt/scripts/backup-generate.sh`) para confirmar que genera archivos en `/opt/backups/supabase/laschubys-*.sql`.

## Procedimiento

```bash
# Contenedor temporal
docker run --rm --name laschubys-restore-drill \
  -e POSTGRES_USER=drill -e POSTGRES_PASSWORD=drill -e POSTGRES_DB=drill \
  -v /opt/backups/supabase/manual:/backups:ro \
  -v laschubys-restore-drill-data:/var/lib/postgresql/data \
  -d postgres:16-alpine

# Roles requeridos por Supabase (vacíos, solo para evitar errores de GRANT)
docker exec laschubys-restore-drill psql -U drill -d drill -c "CREATE ROLE anon NOLOGIN;"
docker exec laschubys-restore-drill psql -U drill -d drill -c "CREATE ROLE authenticated NOLOGIN;"
docker exec laschubys-restore-drill psql -U drill -d drill -c "CREATE ROLE service_role NOLOGIN;"
docker exec laschubys-restore-drill psql -U drill -d drill -c "CREATE ROLE postgres NOLOGIN SUPERUSER;"

# Restore
docker exec laschubys-restore-drill psql -U drill -d drill -f "/backups/laschubys-pre-rls-20260712-113313.sql"

# Verificación
docker exec laschubys-restore-drill psql -U drill -d drill -c \
  "SELECT schemaname, relname, n_live_tup FROM pg_stat_user_tables WHERE schemaname = 'laschubys' ORDER BY n_live_tup DESC;"

# Limpieza
docker stop laschubys-restore-drill
docker volume rm laschubys-restore-drill-data
```

## Resultado

El restore finalizó sin errores críticos (después de crear los roles dummy necesarios para los `GRANT` de Supabase). Las tablas y filas se recuperaron correctamente:

| Tabla | Filas |
|---|---|
| `social_metrics` | 38 |
| `products` | 9 |
| `categories` | 8 |
| `blog_posts` | 5 |
| `profiles` | 2 |
| `comments` | 1 |
| `orders` | 1 |
| `contacts` | 1 |

## Estado

✅ Drill exitoso. Procedimiento de restore verificado.

## Pendientes / Seguimiento

1. Corregir o verificar el job de backups automáticos para que escriba en `/opt/backups/supabase/laschubys-*.sql`.
2. Considerar incluir la creación de roles en un script de restore formal si se requiere un RTO más bajo.
