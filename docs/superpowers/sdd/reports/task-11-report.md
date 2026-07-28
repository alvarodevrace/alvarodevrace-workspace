# Task 11 — Reporte de limpieza de IDs globales en wiki de Las Chubys

## Estado
✅ Completado

## Archivos modificados
- `vault/laschubys/20-Tech/Supabase.md`
- `vault/laschubys/20-Tech/Angular-BFF.md`

## Cambios aplicados

### `vault/laschubys/20-Tech/Supabase.md`
- Sección **Referencias**:
  - Reemplazada URL `https://db.alvarodevrace.tech` por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
  - Reemplazado Dokploy compose ID `KmZPDb3xeY_wZqNjpIAOT` por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
  - Reemplazado Dokploy project `database` (`HTxz4FLFZ-FFasumznhf2`) por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
- Sección **Credenciales**:
  - Reemplazada URL `https://db.alvarodevrace.tech` por referencia a `vault/INFRA-GLOBAL-2026-06.md`.

### `vault/laschubys/20-Tech/Angular-BFF.md`
- Tabla **Dokploy — Deploy**:
  - Reemplazado ID de `laschubys-app` (`XX0AfFKhYHn9ayErXevJF`) por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
  - Reemplazado ID de `laschubys-api` (`GzBwWmUjlYRCgfMK6tzBt`) por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
  - Reemplazado ID de proyecto Dokploy `laschubys` (`dcZfubBCdj1wno5hroswj`) por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
- Sección **Lecciones aprendidas**:
  - Reemplazada mención residual al ID real `XX0AfFKhYHn9ayErXevJF` por referencia a `vault/INFRA-GLOBAL-2026-06.md`.

## Validación

Comando ejecutado:

```bash
rg -n -g '*.md' 'HTxz4FLFZ-FFasumznhf2|KmZPDb3xeY_wZqNjpIAOT|XX0AfFKhYHn9ayErXevJF|GzBwWmUjlYRCgfMK6tzBt|dcZfubBCdj1wno5hroswj|https://db\.alvarodevrace\.tech' vault/laschubys/20-Tech/
```

Resultado: salida vacía (exit code 1 de ripgrep, sin coincidencias). ✅

## Restricciones globales respetadas
- No se editó `system/SESSION_LOG.md` ni `vault/*/10-Log/LOG.md`.
- No se introdujeron secretos completos en archivos `.md`; solo referencias al SSOT.
- No se modificaron repositorios git dentro de subproyectos.
- Todo el texto se mantuvo en español.
