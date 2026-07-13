# SDD Spec

> Escribe delta specs usando RFC 2119 keywords y Given/When/Then.

## Cuándo usar

Después de que Álvaro apruebe el proposal.

## Formato

```markdown
# Specs: <nombre-del-cambio>

## ADDED Requirements

### Requirement: ...
#### Scenario: ...
- GIVEN ...
- WHEN ...
- THEN ...
- AND ...

## MODIFIED Requirements

### Requirement: ...
**Anterior**: ...
**Nuevo**: ...

## REMOVED Requirements
...
```

## Keywords

- **MUST / SHALL**: requisito absoluto.
- **SHOULD**: recomendado, con excepciones justificadas.
- **MAY**: opcional.

## Reglas

- No incluir implementación.
- Cada scenario debe ser verificable.
- Guardar en `vault/laschubys/30-Product/specs/<change-id>/specs.md`.
