# SDD Design

> Escribe `design.md` con decisiones técnicas y arquitectura.

## Cuándo usar

Después de `/sdd:spec`, antes de `/sdd:tasks`.

## Estructura

```markdown
# Design: <nombre-del-cambio>

## Decisiones
1. **Decisión**: ...
   - **Por qué**: ...
   - **Impacto**: ...

## Diagrama
```mermaid
...
```

## Archivos afectados
- `path/1` — cambio X
- `path/2` — cambio Y

## APIs/DB/Deploy
- Cambios en schema: ...
- Cambios en env vars: ...
- Consideraciones de deploy: ...

## Alternativas rechazadas
- **Alternativa A**: ... (rechazada porque ...)
```

## Reglas

- Justificar cada decisión técnica.
- Si cambia RLS/RPC/Auth, requiere Protocol RX.
- Guardar en `vault/laschubys/30-Product/specs/<change-id>/design.md`.
