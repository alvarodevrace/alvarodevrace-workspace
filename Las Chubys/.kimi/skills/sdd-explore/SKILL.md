# SDD Explore

> Analiza codebase y contexto antes de proponer una solución.

## Cuándo usar

Al inicio de un cambio SDD, cuando aún no se sabe qué tocar.

## Input

- Descripción del problema o feature.
- Repos afectados: `LasChubys-Front`, `LasChubys-Back`, infra, n8n.

## Pasos

1. Leer `AGENTS.md`, `SKILL-REGISTRY.md` y `vault/laschubys/00-Index/INDEX.md`.
2. Explorar archivos relevantes con `Grep`/`Glob` o subagente `explore`.
3. Identificar archivos que probablemente cambien.
4. Detectar riesgos: impacto en DB, auth, SSR, deploy.

## Output obligatorio

```json
{
  "status": "ok|warning|blocked",
  "executive_summary": "1-2 frases de decisión",
  "detailed_report": "análisis más largo si aplica",
  "artifacts": [{"name": "exploration", "store": "engram|openspec", "ref": "..."}],
  "next_recommended": ["propose"],
  "risks": ["riesgo 1", "riesgo 2"],
  "files_to_touch": ["path/1", "path/2"]
}
```

## Reglas

- No escribir código ni modificar archivos.
- Si el cambio toca Supabase schema/auth/RLS, avisar que se requiere Protocol RX.
- Si es UI nuevo desde cero, sugerir involucrar a KIMI-AURA.
