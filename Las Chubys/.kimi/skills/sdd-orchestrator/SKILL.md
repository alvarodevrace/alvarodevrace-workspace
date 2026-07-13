# SDD Orchestrator — Las Chubys

> Activa este skill cuando Álvaro pida una feature grande, un cambio cross-layer o algo que toque más de 2-3 archivos.

## Qué es SDD

SDD (Structured Design & Development) es un flujo de trabajo con subagentes especializados que separa la planificación de la implementación. Evita "vibe coding" y mantiene el contexto pequeño en cada fase.

## Flujo obligatorio

```
/sdd:explore  → analiza codebase y contexto
/sdd:propose  → escribe proposal.md (por qué, qué, riesgos, rollback)
/sdd:spec     → escribe delta specs con Given/When/Then
/sdd:design   → escribe design.md (cómo, decisiones, impacto)
/sdd:tasks    → descompone en checklist
/sdd:apply    → implementa
/sdd:verify   → valida contra specs
/sdd:archive  → mergea specs y cierra cambio
```

## Reglas

- El orquestador (KIMICO/TRIN) nunca escribe código directamente; delega a subagentes.
- Cada fase debe terminar con aprobación explícita de Álvaro antes de continuar, salvo que diga "sigue" o "continúa".
- Usar `TodoList` para trackear tareas.
- Persistir artifacts en `vault/laschubys/30-Product/specs/<change-id>/` (modo openspec local) o Engram si el cambio es pequeño.
- Nunca persistir secretos, tokens ni IDs de infra en artifacts.

## Subagentes Kimi Code

- `Agent(subagent_type="explore")` para análisis.
- `Agent(subagent_type="coder")` para implementación.
- `AgentSwarm` para tareas paralelas sobre diferentes inputs.

## Persistencia

- **Cambios grandes** (> 3 archivos o impacto arquitectónico): crear carpeta en `vault/laschubys/30-Product/specs/<change-id>/`.
- **Cambios pequeños**: usar Engram con `topic_key`.
- Al cerrar: migrar lo importante del openspec/Engram a `vault/laschubys/20-Tech/decisions/` o `10-Log/LOG.md`.

## Cómo invocar

Cuando Álvaro pida una feature, responder:

```
Voy a usar SDD para esta feature. Primero lanzo explore.
```

Luego ejecutar `/sdd:explore <descripción>`.
