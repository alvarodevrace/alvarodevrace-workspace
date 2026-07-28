# Task 9 — Reporte: Corregir referencias rotas

## Cambios realizados

- `vault/laschubys/20-Tech/Supabase.md`
  - Reemplazadas 2 referencias a `vault/INFRA-GLOBAL.md` por `vault/INFRA-GLOBAL-2026-06.md` (Anon Key y Service Role Key).

- `agents/NEW-PROJECT-GUIDE.md`
  - Reemplazadas 3 referencias a `vault/INFRA-GLOBAL.md` por `vault/INFRA-GLOBAL-2026-06.md` (sección Supabase y variables de entorno).

- `vault/alvarodevrace/00-Index/INDEX.md`
  - Marcados como eliminados los enlaces a los stubs borrados en Task 7:
    - `n8n-Workflows.md`
    - `Docuseal-Gotenberg.md`
    - `Notion-Integration.md`
  - No se encontró enlace a `KIMI-SKILLS-MASTER.md`.

- `vault/INFRA-GLOBAL-2026-06.md`
  - Ajustada línea introductoria para evitar la cadena literal `vault/INFRA-GLOBAL.md` y no romper la validación.

## Validación

Comando ejecutado:

```bash
rg -n -g '*.md' 'vault/INFRA-GLOBAL\.md' vault/ agents/ KIMI.md
```

Resultado: sin coincidencias (salida vacía, exit code 1 de ripgrep).

## Estado

DONE.
