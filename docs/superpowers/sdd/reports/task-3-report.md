# Reporte — Task 3: Limpiar `KIMI.md`

## Cambios aplicados

- Se añadió el enlace a la fuente única de verdad tras el primer párrafo:
  - `vault/INFRA-GLOBAL-2026-06.md` para infra/credenciales globales.
  - `agents/KIMI-AGENTS.md` para el schema maestro de agentes.
- Se eliminó la sección completa `## Infraestructura real (viva)` y todas sus subsecciones.
- Se simplificó la sección `## Secretos — Dónde viven` a una tabla resumen y una referencia a `vault/INFRA-GLOBAL-2026-06.md`.
- Se eliminó la columna `Dokploy project ID` de la tabla de proyectos activos.

## Validación

```bash
rg -n -g 'KIMI.md' '2a17143e03abfec70bd29db73b74fecf|b1bd4dda49d48900eecb9228673ef1e9|49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a|72\.60\.26\.201|100\.105\.133\.25'
```

**Resultado:** salida vacía (exit code 1 de `rg` al no encontrar coincidencias), como se esperaba.

## Estado

DONE.
