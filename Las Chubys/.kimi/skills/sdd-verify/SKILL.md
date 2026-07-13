# SDD Verify

> Valida que la implementación cumple las specs.

## Cuándo usar

Después de `/sdd:apply`, antes de `/sdd:archive`.

## Output

```json
{
  "status": "ok|warning|blocked",
  "critical": [],
  "warnings": [],
  "suggestions": []
}
```

## Checklist

- [ ] Todos los scenarios de specs tienen cobertura.
- [ ] Build pasa.
- [ ] Tests pasan.
- [ ] No hay secretos expuestos.
- [ ] Cumple AGENTS.md (Scope Rule, signals, zoneless, etc.).

## Reglas

- NOVA es el dueño natural de este rol.
- Si hay findings critical, bloquear archive hasta que se corrijan.
