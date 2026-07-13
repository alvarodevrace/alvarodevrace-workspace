# SDD Propose

> Escribe `proposal.md` con el intent, scope y rollback plan.

## Cuándo usar

Después de `/sdd:explore`, cuando se entiende el problema.

## Estructura de `proposal.md`

```markdown
# Proposal: <nombre-del-cambio>

## Intent
Qué problema resuelve y por qué importa.

## Scope
- **Dentro**: ...
- **Fuera**: ...

## Approach
Enfoque de alto nivel.

## Rollback
Cómo revertir si algo falla.

## Riesgos
1. ...
2. ...
3. ...

## Aprobación
- [ ] Álvaro aprueba
```

## Reglas

- Máximo 1 página.
- Incluir 3 escenarios de fallo.
- No incluir detalles de implementación.
- Guardar en `vault/laschubys/30-Product/specs/<change-id>/proposal.md`.
