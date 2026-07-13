# SDD Archive

> Cierra el cambio y actualiza la fuente de verdad.

## Cuándo usar

Después de `/sdd:verify` con status ok.

## Pasos

1. Mergear delta specs a `vault/laschubys/30-Product/specs/current/`.
2. Mover carpeta del cambio a `vault/laschubys/30-Product/specs/archive/<change-id>/`.
3. Actualizar `vault/laschubys/00-Index/INDEX.md` si cambia arquitectura o estado.
4. Añadir entrada a `vault/laschubys/10-Log/LOG.md`.
5. Crear dump en `vault/laschubys/temp/YYYY-MM-DD-<AGENTE>.md`.
6. Guardar resumen en Engram.
7. Mover ticket Planka a Done si aplica.

## Reglas

- No archivar si verify está blocked.
- Todo lo permanente debe terminar en vault, no solo en Engram.
