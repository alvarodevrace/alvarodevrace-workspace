# Task 2 — Reporte de limpieza `agents/KIMI-AGENTS.md`

**Fecha:** 2026-06-25  
**Archivo modificado:** `agents/KIMI-AGENTS.md`  
**Fuente de verdad:** `vault/INFRA-GLOBAL-2026-06.md`

## Cambios aplicados

1. Eliminada sección `## Infraestructura Compartida — Estado Real` y subsección `### ❌ Eliminados / Caídos`.
2. Eliminada sección `## Nodos` y su tabla.
3. Eliminada sección `## Cloudflare — DNS + Tunnel`.
4. Eliminada sección `## Secretos maestros (referencias)` y su tabla.
5. Eliminada sección `## Backups — Sistema 3-2-1` y su contenido.
6. Añadida nota de referencia global tras el encabezado `## Tabla Maestra de Proyectos`.
7. Actualizada la tabla maestra: eliminada la columna `Dokploy project ID` para evitar duplicación con `vault/INFRA-GLOBAL-2026-06.md`.
8. Actualizada la tabla de proyectos eliminados: eliminada la columna `Dokploy project ID` por consistencia.
9. Actualizada línea de credenciales por proyecto para indicar que los datos globales viven en `vault/INFRA-GLOBAL-2026-06.md`.

## Validación

Comando ejecutado:

```bash
rg -n -g 'agents/KIMI-AGENTS.md' '2a17143e03abfec70bd29db73b74fecf|b1bd4dda49d48900eecb9228673ef1e9|49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a|72\.60\.26\.201|100\.105\.133\.25'
```

**Resultado:** salida vacía (código de salida `1` de ripgrep = sin coincidencias). ✅

## Estado

DONE. `agents/KIMI-AGENTS.md` ahora contiene solo el schema maestro de agentes y proyectos, sin tablas de infra/secretos/IDs repetidos.
