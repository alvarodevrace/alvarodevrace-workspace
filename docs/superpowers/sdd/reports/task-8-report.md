# Task 8: Sincronizar catálogo de skills — Reporte

## Resumen

Se actualizó la skill global `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md` usando como base el duplicado más reciente del vault `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md`. Se aplicaron las transformaciones de limpieza descritas en el brief y se eliminó el duplicado del vault.

## Transformaciones aplicadas

- Reemplazos generales:
  - `Coolify` → `Dokploy`
  - `coolify` → `dokploy`
  - `coolify-api-token` → `dokploy-api-token`
  - `coolify-manager` → `dokploy-manager`
  - `.codex/` → `.kimi/`
  - `.claude/` → `.kimi/`
- Eliminación de filas de tabla pertenecientes a proyectos eliminados:
  - `agrovivas`, `jauria`, `cobroslatam`, `utilboxes`, `agentoffice`, `brain`
- Limpieza manual posterior:
  - Se reescribió la nota histórica de proyectos eliminados sin nombrar proyectos concretos.
  - Se eliminaron referencias obsoletas a `CLAUDE.md.OBSOLETO`, `ANTIGRAVITY.md.OBSOLETO` y a skills de Coolify ya inexistentes.
  - Se corrigió el texto degenerado tras el reemplazo automático (`migración Dokploy → Dokploy`).

## Archivos modificados / eliminados

- **Modificado:** `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md`
- **Eliminado:** `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md`

## Validación

Comando ejecutado:

```bash
rg -n -i -g '*.md' 'coolify|codex|claude|agrovivas|jauria|cobroslatam|utilboxes|agentoffice|brain' ~/.kimi-code/skills/KIMI-MASTER-SKILLS.md | head -20
```

Resultado: **sin coincidencias**.

## Estado

DONE
