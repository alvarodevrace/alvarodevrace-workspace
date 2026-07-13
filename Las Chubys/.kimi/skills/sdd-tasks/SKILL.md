# SDD Tasks

> Descompone el cambio en tareas pequeñas y accionables.

## Cuándo usar

Después de `/sdd:design`, antes de `/sdd:apply`.

## Formato

```markdown
# Tasks: <nombre-del-cambio>

## Fase 1: Fundación
- [ ] 1.1 ...
  - Verificación: `comando`
- [ ] 1.2 ...

## Fase 2: Implementación
- [ ] 2.1 ...

## Fase 3: Verificación
- [ ] 3.1 ...
```

## Reglas

- Cada tarea debe ser < 30 min.
- Incluir comando de verificación.
- Usar `TodoList` para trackear.
- Guardar en `vault/laschubys/30-Product/specs/<change-id>/tasks.md`.
