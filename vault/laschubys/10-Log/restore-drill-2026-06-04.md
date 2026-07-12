# Restore Drill 2026-06-04

- Schema restaurado: laschubys
- Backup usado: laschubys-20260604.sql
- Tamaño del backup: 28K
- Tiempo de restore: <1s (datos pequeños)
- Tiempo total (docker pull incluido): 23s

## Row counts
| Tabla | Count |
|---|---|
| blog_posts | 5 |
| products | 4 |
| comments | 3 |
| orders | 0 |
| order_items | 0 |
| profiles | 0 |

## Resultado: OK ✅

## Notas
- Errores de roles `authenticated`, `anon`, `service_role` esperados — son roles propios de Supabase, no existen en Postgres vanilla. No afectan integridad de datos.
- Imagen postgres:15 descargada en VPS (disponible para próximos drills).
- Próximo drill: 2026-07-01.
