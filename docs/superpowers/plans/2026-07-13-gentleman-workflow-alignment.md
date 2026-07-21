# Alineación con Gentleman Programming — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Profesionalizar el workflow de Las Chubys instalando GGA como gate de commits, adoptando SDD para features grandes, limpiando ramas Git y normalizando configuración de memoria/skills.

**Architecture:** Mejoras incrementales sobre infra existente (Engram, skills Kimi, AGENTS.md, flujo Git). No se reescribe nada; se añaden gates, skills locales y limpieza. Worktrees quedan para fase posterior por riesgo de cambios locales activos.

**Tech Stack:** Kimi Code CLI, GitHub CLI, GGA, Engram MCP, Markdown skills.

## Global Constraints
- No tocar VSCode; Zed solo es visor.
- Todo en español; commits en español/conventional commits.
- Nunca push directo a `main` ni `develop`.
- No escribir secretos completos en archivos `.md`.
- Cualquier cambio en skills debe registrarse en `vault/laschubys/20-Tech/SKILL-REGISTRY.md`.

---

### Task 1: Instalar GGA en front y back con provider GitHub Models

**Files:**
- Create: `Las Chubys/LasChubys-Front/.gga`
- Create: `Las Chubys/LasChubys-Back/.gga`
- Modify: `Las Chubys/LasChubys-Front/.git/hooks/pre-commit`
- Modify: `Las Chubys/LasChubys-Back/.git/hooks/pre-commit`

**Interfaces:**
- Consumes: `gh auth token` (ya autenticado), `brew`, `AGENTS.md` de cada repo.
- Produces: Hook pre-commit funcional que revisa staged files contra `AGENTS.md`.

- [ ] **Step 1: Instalar GGA**

```bash
brew install gentleman-programming/tap/gga
```

- [ ] **Step 2: Verificar instalación**

```bash
gga version
```

Expected: muestra versión (ej. `2.10.1`).

- [ ] **Step 3: Inicializar GGA en front**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
gga init
```

- [ ] **Step 4: Configurar provider GitHub Models en front**

Sobrescribir `.gga` generado con:

```bash
cat > .gga <<'EOF'
PROVIDER="github:gpt-4o-mini"
STRICT_MODE=true
AGENTS_FILE="AGENTS.md"
EOF
```

- [ ] **Step 5: Instalar hook pre-commit en front**

```bash
gga install
```

- [ ] **Step 6: Verificar hook en front**

```bash
gga config
ls -la .git/hooks/pre-commit
```

Expected: `PROVIDER=github:gpt-4o-mini`, hook existe y no es sample.

- [ ] **Step 7: Repetir steps 3-6 en back**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
gga init
cat > .gga <<'EOF'
PROVIDER="github:gpt-4o-mini"
STRICT_MODE=true
AGENTS_FILE="AGENTS.md"
EOF
gga install
gga config
ls -la .git/hooks/pre-commit
```

- [ ] **Step 8: Commit de configuración GGA**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git add .gga .git/hooks/pre-commit
git commit -m "chore: instala GGA pre-commit con provider github:gpt-4o-mini"
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
git add .gga .git/hooks/pre-commit
git commit -m "chore: instala GGA pre-commit con provider github:gpt-4o-mini"
```

---

### Task 2: Crear skills locales SDD adaptadas a Kimi Code

**Files:**
- Create: `Las Chubys/.kimi/skills/sdd-orchestrator/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-explore/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-propose/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-spec/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-design/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-tasks/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-apply/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-verify/SKILL.md`
- Create: `Las Chubys/.kimi/skills/sdd-archive/SKILL.md`
- Modify: `vault/laschubys/20-Tech/SKILL-REGISTRY.md`

**Interfaces:**
- Consumes: Patrón Agent Teams Lite de Gentleman Programming, herramientas Kimi Code (`Agent`, `AgentSwarm`, `TodoList`, `AskUserQuestion`).
- Produces: Skills locales invocables por nombre en Las Chubys.

- [ ] **Step 1: Crear directorio de skills locales**

```bash
mkdir -p "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/.kimi/skills"
```

- [ ] **Step 2: Escribir sdd-orchestrator/SKILL.md**

Contenido mínimo:

```markdown
# SDD Orchestrator — Las Chubys

> Activa este skill cuando Álvaro pida una feature grande o se detecte cambio cross-layer.

## Flujo

1. `/sdd:explore <idea>` → subagente explore analiza codebase y retorna resumen.
2. `/sdd:propose <idea>` → subagente propose escribe `proposal.md` (por qué, qué, riesgos, rollback).
3. `/sdd:spec` → subagente spec escribe delta specs con Given/When/Then.
4. `/sdd:design` → subagente design escribe `design.md` (cómo, decisiones, impacto).
5. `/sdd:tasks` → subagente tasks descompone en checklist.
6. `/sdd:apply` → subagente apply implementa tareas.
7. `/sdd:verify` → subagente verify valida contra specs.
8. `/sdd:archive` → subagente archive mergea specs y cierra cambio.

## Persistencia

- Si el cambio es grande: usar `vault/laschubys/30-Product/specs/<change-id>/` (modo openspec local).
- Si es pequeño: usar Engram como buffer.
- Nunca persistir secretos.

## Subagentes

Usar `Agent(subagent_type="coder")` para implementación y `Agent(subagent_type="explore")` para análisis.
Siempre inyectar skills base del agente según SKILL-REGISTRY.
```

- [ ] **Step 3: Escribir sdd-explore/SKILL.md**

```markdown
# SDD Explore

> Analiza codebase y contexto antes de proponer una solución.

## Input

- Idea o problema del usuario.
- Repos afectados (front/back/infra).

## Output

```json
{
  "status": "ok|warning|blocked",
  "executive_summary": "...",
  "detailed_report": "...",
  "artifacts": [{"name":"exploration","store":"engram|openspec","ref":"..."}],
  "next_recommended": ["propose"],
  "risks": ["..."]
}
```

## Reglas

- No escribir código.
- Leer AGENTS.md, SKILL-REGISTRY y vault relevante.
- Identificar archivos que cambiarían.
```

- [ ] **Step 4: Escribir sdd-propose/SKILL.md**

```markdown
# SDD Propose

> Escribe `proposal.md` con intent, scope, rollback plan.

## Estructura

1. **Intent**: qué problema resuelve.
2. **Scope**: qué entra y qué queda fuera.
3. **Approach**: enfoque de alto nivel.
4. **Rollback**: cómo revertir.
5. **Riesgos**: 3 escenarios de fallo.

## Output

- Archivo `proposal.md` en `vault/laschubys/30-Product/specs/<change-id>/`.
```

- [ ] **Step 5: Escribir sdd-spec/SKILL.md**

```markdown
# SDD Spec

> Escribe delta specs con RFC 2119 keywords.

## Formato

```markdown
## ADDED Requirements
### Requirement: ...
#### Scenario: ...
- GIVEN ...
- WHEN ...
- THEN ...

## MODIFIED Requirements
...

## REMOVED Requirements
...
```

## Reglas

- Usar SHALL/MUST/SHOULD/MAY.
- Especificar escenarios con Given/When/Then.
- No incluir implementación.
```

- [ ] **Step 6: Escribir sdd-design/SKILL.md**

```markdown
# SDD Design

> Escribe `design.md` con decisiones técnicas.

## Estructura

1. **Decisiones**: qué se decide y por qué.
2. **Diagrama/diagramas**: texto o mermaid.
3. **Impacto**: archivos, DB, API, deploy.
4. **Alternativas rechazadas**: por qué.
```

- [ ] **Step 7: Escribir sdd-tasks/SKILL.md**

```markdown
# SDD Tasks

> Descompone en checklist accionable.

## Formato

- Fase 1: Fundación
  - [ ] 1.1 ...
  - [ ] 1.2 ...
- Fase 2: ...

## Reglas

- Cada tarea < 30 min.
- Incluye comando de verificación.
- Marcar con TodoList.
```

- [ ] **Step 8: Escribir sdd-apply/SKILL.md**

```markdown
# SDD Apply

> Implementa tareas de atraso adelante.

## Reglas

- Seguir specs y design.
- Usar TDD cuando aplique.
- Ejecutar scripts obligatorios del repo (typecheck, test, build).
- Marcar tareas done en TodoList.
- No mergear; avisar a TRIN cuando esté listo.
```

- [ ] **Step 9: Escribir sdd-verify/SKILL.md**

```markdown
# SDD Verify

> Valida implementación contra specs.

## Output

```json
{
  "status": "ok|warning|blocked",
  "critical": [],
  "warnings": [],
  "suggestions": []
}
```

## Reglas

- Revisar que todos los scenarios están cubiertos.
- Verificar build/test pasan.
- NOVA puede ejecutar este rol.
```

- [ ] **Step 10: Escribir sdd-archive/SKILL.md**

```markdown
# SDD Archive

> Cierra cambio y mergea deltas a specs principales.

## Pasos

1. Mergear delta specs a `vault/laschubys/30-Product/specs/current/`.
2. Mover carpeta del cambio a `archive/`.
3. Actualizar LOG.md e INDEX.md.
4. Guardar resumen en Engram.
```

- [ ] **Step 11: Actualizar SKILL-REGISTRY.md**

Añadir bajo KIMI-TRIN:

```markdown
- `sdd-orchestrator` (local) — para features grandes y cambios cross-layer
- `sdd-explore` (local)
- `sdd-propose` (local)
- `sdd-spec` (local)
- `sdd-design` (local)
- `sdd-tasks` (local)
- `sdd-apply` (local)
- `sdd-verify` (local)
- `sdd-archive` (local)
```

Añadir trigger:

```markdown
| Feature grande / cambio cross-layer | `sdd-orchestrator`, `sdd-explore`, `sdd-propose`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive` |
```

- [ ] **Step 12: Commit de skills locales**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys"
git add .kimi/skills vault/laschubys/20-Tech/SKILL-REGISTRY.md
git commit -m "chore(skills): añade skills locales SDD adaptadas a Kimi Code"
```

> Nota: `Las Chubys/` no es un repo git, así que este commit debe hacerse en el repo que contiene estos archivos si aplica. Si `Las Chubys/` no es repo, dejar el paso como verificación manual y documentar.

---

### Task 3: Git hygiene — auto-delete y limpieza de ramas

**Files:**
- No files; cambios en GitHub + repos locales.

**Interfaces:**
- Consumes: `gh` CLI autenticado.
- Produces: Repos sin ramas mergeadas huérfanas.

- [ ] **Step 1: Habilitar auto-delete branch on merge en front**

```bash
gh repo edit alvarodevrace/laschubys-app --enable-delete-branch-on-merge
```

- [ ] **Step 2: Habilitar auto-delete branch on merge en back**

```bash
gh repo edit alvarodevrace/laschubys-api --enable-delete-branch-on-merge
```

- [ ] **Step 3: Verificar cambio en GitHub**

```bash
gh repo view alvarodevrace/laschubys-app --json deleteBranchOnMerge
gh repo view alvarodevrace/laschubys-api --json deleteBranchOnMerge
```

Expected: `{"deleteBranchOnMerge":true}`.

- [ ] **Step 4: Listar ramas mergeadas en front**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git fetch --prune origin
git branch --merged develop | grep -vE "^\*|develop|main"
git branch -r --merged develop | grep -vE "HEAD|develop|main"
```

- [ ] **Step 5: Borrar ramas locales mergeadas en front**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git branch --merged develop | grep -vE "^\*|develop|main" | xargs -r git branch -d
```

- [ ] **Step 6: Borrar ramas remotas mergeadas en front**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git branch -r --merged develop | sed 's/origin\///' | grep -vE "^HEAD$|develop$|main$" | xargs -r git push origin --delete
```

- [ ] **Step 7: Repetir steps 4-6 en back**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
git fetch --prune origin
git branch --merged develop | grep -vE "^\*|develop|main" | xargs -r git branch -d
git branch -r --merged develop | sed 's/origin\///' | grep -vE "^HEAD$|develop$|main$" | xargs -r git push origin --delete
```

- [ ] **Step 8: Verificación final**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git branch -a
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
git branch -a
```

Expected: solo `main`, `develop` y ramas activas no mergeadas.

---

### Task 4: Normalizar MCP y memoria sin VSCode

**Files:**
- Create: `.kimi-code/mcp.json`
- Modify: `agents/KIMI-AGENTS.md`
- Modify: `Las Chubys/LasChubys-Front/AGENTS.md`
- Modify: `Las Chubys/LasChubys-Back/AGENTS.md`

**Interfaces:**
- Consumes: Configuración actual `~/.kimi-code/mcp.json` con Engram.
- Produces: Configuración de proyecto portátil y ritual de cierre documentado.

- [ ] **Step 1: Crear `.kimi-code/mcp.json` a nivel workspace**

```bash
mkdir -p "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/.kimi-code"
cat > "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/.kimi-code/mcp.json" <<'EOF'
{
  "mcpServers": {
    "engram": {
      "command": "engram",
      "args": ["mcp"]
    }
  }
}
EOF
```

- [ ] **Step 2: Añadir ritual de cierre a `agents/KIMI-AGENTS.md`**

Bajo "Flujo de cierre (obligatorio)", añadir:

```markdown
4. **Engram → vault:** revisar memorias de la sesión; migrar decisiones/bugs/workarounds a vault; borrar obsoletas.
```

- [ ] **Step 3: Añadir ritual de cierre a `LasChubys-Front/AGENTS.md`**

Añadir sección:

```markdown
## Ritual de cierre

1. Crear dump en `vault/laschubys/temp/YYYY-MM-DD-<AGENTE>.md`.
2. Migrar memorias relevantes de Engram a `vault/laschubys/10-Log/LOG.md` o `20-Tech/decisions/`.
3. Comentar ticket en Planka y mover a Done si aplica.
```

- [ ] **Step 4: Añadir ritual de cierre a `LasChubys-Back/AGENTS.md`**

Igual que front.

- [ ] **Step 5: Verificar config Engram**

```bash
cat "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/.kimi-code/mcp.json"
engram doctor
```

Expected: MCP server config presente; doctor OK.

- [ ] **Step 6: Commit de cambios de memoria**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro"
git add .kimi-code/mcp.json agents/KIMI-AGENTS.md "Las Chubys/LasChubys-Front/AGENTS.md" "Las Chubys/LasChubys-Back/AGENTS.md"
git commit -m "chore(docs): normaliza MCP workspace y ritual Engram → vault"
```

> Si `Alvaro/` no es repo git, aplicar cambios y documentar.

---

### Task 5: Documentar decisión y actualizar índice del proyecto

**Files:**
- Create: `vault/laschubys/20-Tech/decisions/2026-07-13-gentleman-workflow-alignment.md`
- Modify: `vault/laschubys/00-Index/INDEX.md`

**Interfaces:**
- Consumes: Resultados de tasks 1-4.
- Produces: Decisión técnica archivada y estado del proyecto actualizado.

- [ ] **Step 1: Crear archivo de decisión**

Contenido:

```markdown
# 2026-07-13 — Alineación con Gentleman Programming

## Contexto

Álvaro pidió auditar la infra/workflow de Las Chubys contra los repos de Gentleman Programming.

## Decisiones

1. Adoptar GGA como gate de pre-commit en front y back (provider GitHub Models `gpt-4o-mini`).
2. Adoptar SDD para features grandes mediante skills locales `sdd-*` adaptadas a Kimi Code.
3. Habilitar auto-delete branch on merge y limpiar ramas huérfanas.
4. Normalizar MCP workspace y ritual Engram → vault en AGENTS.md.

## Estado

- ✅ GGA instalado y configurado.
- ✅ Skills SDD locales creadas y registradas.
- ✅ Git hygiene aplicado.
- ✅ MCP y ritual documentados.

## Próximos pasos

- Fase 2: migrar front/back a git worktrees.
- Validar GGA en el próximo commit real.
- Validar flujo SDD en la próxima feature grande.
```

- [ ] **Step 2: Actualizar `vault/laschubys/00-Index/INDEX.md`**

Añadir al bloque de estado infra o crear sección "Workflow y calidad":

```markdown
## Workflow y calidad

| Herramienta | Estado | Nota |
|---|---|---|
| GGA pre-commit | ✅ | Provider `github:gpt-4o-mini` en front/back |
| SDD skills | ✅ | Skills locales `sdd-*` adaptadas a Kimi Code |
| Auto-delete branch | ✅ | Habilitado en GitHub |
| Ramas mergeadas | ✅ | Limpias |
| Engram ritual | ✅ | Documentado en AGENTS.md |
```

- [ ] **Step 3: Commit**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro"
git add vault/laschubys/20-Tech/decisions/2026-07-13-gentleman-workflow-alignment.md vault/laschubys/00-Index/INDEX.md
git commit -m "docs: documenta alineación Gentleman Programming y estado workflow"
```

---

## Self-Review

**1. Spec coverage:**
- GGA ✅ Task 1
- SDD skills ✅ Task 2
- Git hygiene ✅ Task 3
- MCP/memoria ✅ Task 4
- Documentación ✅ Task 5

**2. Placeholder scan:**
- Sin TBD/TODO.
- Código/configuración completa en steps.

**3. Type consistency:**
- Nombres de skills consistentes (`sdd-*`).
- Paths absolutos consistentes.

**Nota de riesgo:** `Las Chubys/` contiene dos repos separados (`LasChubys-Front`, `LasChubys-Back`) y no es un repo git por sí mismo. Los commits de skills locales y `.kimi-code/` deben aplicarse en el repo correspondiente si `Las Chubys/` no es tracked. Si `Las Chubys/` es parte del workspace root git, un solo commit basta. Verificar con `git status` en cada nivel antes de commitear.
