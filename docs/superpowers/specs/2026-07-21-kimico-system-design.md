# Kimico System — Portable Multi-IA Dev Kit

**Fecha:** 2026-07-21  
**Estado:** Especificación de diseño (pendiente de aprobación)  
**Owner:** KIMI-TRIN  
**Repo objetivo:** `github.com/alvarodevrace/kimico-system` (público)

---

## 1. Resumen ejecutivo

Crear un kit portable de desarrollo multiagente/multi-IA que permita a Álvaro (y eventualmente otros usuarios de Kimi/Claude) descargar un repo de GitHub, ejecutar un instalador, y tener un entorno de agentes, memoria persistente, skills y vault funcionando en minutos en macOS o Windows.

El kit es **infra-optional**: funciona sin VPS, Dokploy ni Supabase, pero puede "anclarse" al workspace `AlvaroDevRace` privado cuando se instala en la Mac de Álvaro.

**Primera fase obligatoria:** limpiar y consolidar el sistema actual en `AlvaroDevRace` antes de exportar nada portable.

---

## 2. Contexto y motivación

### 2.1 Sistema actual (AlvaroDevRace)
- **Agentes:** KIMICO/TRIN, PIXEL, LINK, EVA, NOVA, AURA.
- **Memoria:** Engram MCP (SQLite local, FTS5).
- **Skills:** 51 skills globales en `~/.kimi-code/skills/`, más skills locales.
- **Vault:** Karpathy-style en `vault/`, SSOT de infra en `vault/INFRA-GLOBAL-2026-06.md`.
- **Infra:** VPS Hostinger, Dokploy, Supabase self-hosted, n8n, Cloudflare, Tailscale.
- **Problemas detectados:**
  - Catálogo de skills duplicado (`KIMI-MASTER-SKILLS.md` vs `kimi-all-skills-catalog.md`).
  - Superpowers y SDD locales no registrados en catálogo maestro.
  - Referencias obsoletas (`Evolution API`, `CLAUDE.md.OBSOLETO`, etc.).
  - Cambios locales sin commitear en Las Chubys.
  - Portfolio estancado con AGENTS.md obsoleto.
  - Sistema atado a esta Mac y a infra específica; no es descargable en una máquina nueva.

### 2.2 Sistema Gentleman Programming AI
- **Repo raíz:** https://github.com/Gentleman-Programming
- **Componentes clave:**
  - `gentle-ai`: instalador/configurador multi-agente.
  - `engram`: memoria persistente (Go + SQLite + MCP) — **mismo motor** que usamos.
  - `gentle-pi`: harness para Pi con SDD/TDD.
  - `Gentleman-Skills`: skills curadas de comunidad.
- **Fortalezas:**
  - Instalador unificado para 16 IDEs/agentes.
  - Portabilidad (Homebrew, Scoop, npm).
  - SDD file-backed y reglas de delegación.
- **Debilidades:**
  - Complejidad multi-agente alta.
  - Dependencia de mecanismos nativos de cada agente.
  - Documentación dispersa.

### 2.3 Diferencial de Kimico System
- No intenta soportar 16 agentes; se enfoca en **Kimi Code + Claude Code**.
- Mantiene los **roles de agentes de AlvaroDevRace** (TRIN/PIXEL/LINK/EVA/NOVA/AURA), que están mejor definidos que los genéricos de Gentleman.
- Usa **Engram** como memoria común (ya funciona en ambos agentes via MCP).
- Es **infra-optional**: el usuario puede tener solo agentes+memoria+skills, o anclar infra privada.

---

## 3. Objetivos

1. **Consolidar AlvaroDevRace:** eliminar duplicados, obsoletos e inconsistencias.
2. **Crear `kimico-system`:** repo público portable con agentes, skills, prompts, vault template e instalador.
3. **Soportar Kimi Code y Claude Code** con la misma experiencia de agentes/memoria/vault.
4. **Permitir instalación rápida** en macOS y Windows sin infra obligatoria.
5. **Mantener 0 secretos en el repo público.**

---

## 4. Alcance

### 4.1 Incluye
- Agentes KIMICO, PIXEL, LINK, EVA, NOVA, AURA (versiones Kimi y Claude).
- Skills genéricas/portables:
  - Superpowers (brainstorming, writing-plans, subagent-driven-development, systematic-debugging, test-driven-development, verification-before-completion).
  - Core Kimi (start-of-day, end-of-day, vault-ingest, vault-lint, vault-writing-guide, token-optimizer).
  - Técnicas generales (angular-senior, nestjs-senior, async-loading-fail-safe, mutation-idempotency-guard).
- Prompts de boot/cierre.
- Vault template Karpathy-style vacío.
- Configuración MCP para Engram.
- Instaladores bash (macOS/Linux) y PowerShell (Windows).
- Documentación de setup.

### 4.2 No incluye
- Credenciales ni secretos.
- Configuración específica de infra (Dokploy, Supabase, Cloudflare, Tailscale).
- Skills específicas de proyectos privados (Las Chubys, Portfolio).
- Código fuente de proyectos de cliente.

### 4.3 Anclaje opcional de infra
- Cuando el usuario elige modo "AlvaroDevRace", el instalador:
  - Clona el repo privado `AlvaroDevRace` via SSH.
  - Carga `vault/INFRA-GLOBAL-2026-06.md`.
  - Configura Tailscale, Bitwarden, etc.

---

## 5. Arquitectura del kit

```text
kimico-system/
├── README.md                         # quickstart + badges
├── LICENSE                           # MIT
├── install/
│   ├── install.sh                    # macOS/Linux
│   ├── install.ps1                   # Windows
│   └── check-env.sh / check-env.ps1  # prerequisitos
├── agents/
│   ├── kimi/                         # roles para Kimi Code
│   │   ├── KIMICO.md
│   │   ├── PIXEL.md
│   │   ├── LINK.md
│   │   ├── EVA.md
│   │   ├── NOVA.md
│   │   └── AURA.md
│   └── claude/                       # roles equivalentes para Claude Code
│       ├── KIMICO.md
│       ├── PIXEL.md
│       ├── LINK.md
│       ├── EVA.md
│       ├── NOVA.md
│       └── AURA.md
├── skills/
│   ├── superpowers/                  # metodología SDD/TDD/debugging
│   ├── kimi-core/                    # start-of-day, vault-*, token-optimizer
│   └── tech/                         # angular-senior, nestjs-senior, etc.
├── prompts/
│   ├── KIMI-START-OF-DAY.md
│   ├── KIMI-END-OF-DAY.md
│   ├── CLAUDE-START-OF-DAY.md
│   └── CLAUDE-END-OF-DAY.md
├── vault-template/
│   ├── 00-Index/INDEX.md
│   ├── 10-Log/LOG.md
│   ├── 20-Tech/
│   ├── 30-Product/
│   └── 40-Credentials/INFRA.md.template
├── mcp/
│   └── engram.json
├── harness/
│   └── kimico                        # script CLI: `kimico use kimi|claude|both`
└── docs/
    ├── SETUP.md
    ├── WINDOWS.md
    ├── MACOS.md
    └── MULTI_IA.md
```

### 5.1 Instalador

El instalador es interactivo:

1. Detecta OS.
2. Pregunta IA primaria: `kimi` | `claude` | `both`.
3. Pregunta modo: `minimal` (solo skills+agentes+memoria) | `full` (más vault template) | `alvarodevrace` (anclar infra privada).
4. Verifica/instala:
   - Kimi Code CLI (si se elige Kimi).
   - Claude Code CLI (si se elige Claude).
   - Engram MCP.
5. Copia skills a `~/.kimi-code/skills/` y/o `~/.claude/skills/`.
6. Copia agentes a `~/.kimi-code/agents/` y/o `~/.claude/agents/`.
7. Crea vault en `~/Documents/Kimico/` o ruta configurable.
8. Configura MCP (`~/.kimi-code/mcp.json`, `~/.claude/mcp.json`).
9. Opcional: clona `AlvaroDevRace` privado via SSH.
10. Ejecuta `kimico doctor` para verificar instalación.

### 5.2 Harness `kimico`

Script CLI ligero para cambiar de IA activa:

```bash
kimico use kimi          # activa agentes/prompts de Kimi
kimico use claude        # activa agentes/prompts de Claude
kimico use both          # sincroniza ambos
kimico doctor            # verifica estado
kimico update            # pull de skills desde el repo
```

### 5.3 Multi-IA

- **Memoria:** Engram MCP es compartida. Cualquier observación guardada desde Kimi o Claude es visible para ambos.
- **Agentes:** mismos nombres y roles, pero prompts adaptados a las convenciones de cada IDE.
- **Skills:**
  - `common/`: markdown puro, usable por ambos.
  - `kimi/`: invoca tools nativas de Kimi (`Agent`, `Bash`, `Read`, etc.).
  - `claude/`: invoca tools nativas de Claude (`Task`, `Bash`, `Read`, etc.).
- **Vault:** compartido. Los paths se adaptan según OS.

---

## 6. Fase 1 — Limpieza y consolidación de AlvaroDevRace

Antes de exportar nada a `kimico-system`, se debe dejar AlvaroDevRace en estado limpio.

### 6.1 Skills
- [ ] Elegir fuente única de catálogo: `KIMI-MASTER-SKILLS.md`.
- [ ] Migrar contenido relevante de `kimi-all-skills-catalog.md` y eliminar el duplicado.
- [ ] Registrar skills Superpowers en el catálogo maestro.
- [ ] Registrar skills SDD locales de Las Chubys o moverlas a `~/.kimi-code/skills/`.
- [ ] Revisar las 51 skills: archivar obsoletas, marcar portables vs específicas.
- [ ] Eliminar referencias a `CLAUDE.md.OBSOLETO`, `ANTIGRAVITY.md.OBSOLETO`, `agents/legacy/`.

### 6.2 Agentes
- [ ] Quitar `Evolution API` de checklists mensuales.
- [ ] Unificar convención de ramas: `feature/<ticket>-<nombre>` para todos.
- [ ] Revisar `agents/kimi/*.md` para eliminar IPs/IDs hardcodeados; usar refs a `vault/INFRA-GLOBAL-2026-06.md`.
- [ ] Asegurar que todos los agentes tengan límites claros.

### 6.3 Vault
- [ ] Mover proyectos eliminados a anexo histórico (`vault/00-Archive/` o similar).
- [ ] Actualizar `Portfolio/AGENTS.md` a estándar Kimi.
- [ ] Corregir `dotenv` a versión estable (`16.x`) en Las Chubys front.
- [ ] Limpiar `debug-storybook.log` y `.antigravitycli/`.
- [ ] Gobernar Engram: definir ciclo de vida, retención y migración obligatoria a vault.

### 6.4 Repos
- [ ] Commitear/descartar cambios locales en Las Chubys front/back.
- [ ] Revisar estado de `Portfolio`: decidir si se migra a Angular 21 o se documenta backlog.
- [ ] Recrear workflow n8n `LCH / Sentry / Alert` (perdido en recuperación PostgreSQL).

### 6.5 Infra
- [ ] Verificar estado post-incidente VPS (recuperado 2026-07-20).
- [ ] Validar backups 3-2-1.
- [ ] Documentar pendientes en `vault/infra/10-Log/LOG.md`.

---

## 7. Fase 2 — Creación de `kimico-system`

### 7.1 Repo y CI
- [ ] Crear repo público `github.com/alvarodevrace/kimico-system`.
- [ ] Configurar README, LICENSE MIT, CODE_OF_CONDUCT.
- [ ] Configurar GitHub Actions:
  - Lint de skills (validar frontmatter, links rotos).
  - Test de instalador en Ubuntu/macOS/Windows runners.
  - Check de secretos (`trufflehog` o similar).

### 7.2 Migración de skills
- [ ] Copiar skills genéricas desde `~/.kimi-code/skills/`.
- [ ] Dividir en `common/`, `kimi/`, `claude/` según dependencia de tools.
- [ ] Asegurar que no haya referencias a infra específica.

### 7.3 Agentes
- [ ] Crear versiones Kimi y Claude de cada agente.
- [ ] Adaptar ejemplos de invocación de tools a cada plataforma.

### 7.4 Vault template
- [ ] Crear estructura Karpathy vacía.
- [ ] `INFRA.md.template` con placeholders, sin datos reales.

### 7.5 Instaladores
- [ ] `install.sh` para macOS/Linux.
- [ ] `install.ps1` para Windows.
- [ ] Scripts de verificación (`kimico doctor`).

### 7.6 Documentación
- [ ] `SETUP.md`: instalación paso a paso.
- [ ] `WINDOWS.md`: particularidades de Windows.
- [ ] `MACOS.md`: particularidades de macOS.
- [ ] `MULTI_IA.md`: cómo alternar Kimi/Claude.

---

## 8. Seguridad

- **0 secretos en repo público.**
- Credenciales via Bitwarden; el instalador puede pedir `bw unlock`.
- SSH keys no se distribuyen; el usuario las genera/configura.
- Templates con placeholders claros (`bitwarden:global/...`).
- CI con detección de secretos en cada push.
- No incluir datos de clientes ni código de proyectos privados.

---

## 9. Roadmap y fases

| Fase | Entregable | Tiempo estimado |
|---|---|---|
| 1.1 | Limpieza de skills y catálogo | 1 sesión |
| 1.2 | Limpieza de agentes y vault | 1 sesión |
| 1.3 | Commits, QA y validación | 1 sesión |
| 2.1 | Crear repo `kimico-system` + CI | 1 sesión |
| 2.2 | Migrar skills/agentes/vault template | 1-2 sesiones |
| 2.3 | Instaladores bash/PowerShell | 1-2 sesiones |
| 2.4 | Documentación y tests | 1 sesión |
| 3 | Uso real en Windows (trabajo) y validación | 1 sesión |

---

## 10. Métricas de éxito

- [ ] `kimico-system` se instala en macOS y Windows en < 10 minutos.
- [ ] Engram funciona con Kimi y Claude desde el primer uso.
- [ ] Los agentes responden con los roles correctos en ambas IAs.
- [ ] 0 secretos filtrados en el repo público.
- [ ] AlvaroDevRace queda limpio, sin duplicados ni obsoletos.
- [ ] El kit puede usarse sin infra, o anclarse a AlvaroDevRace cuando aplica.

---

## 11. Notas abiertas

- ¿Se incluye `ui-ux-pro-max` en el kit? Es pesada y con assets; podría ser un add-on opcional.
- ¿Se mantiene `Portfolio` como proyecto activo o se archiva?
- ¿Se crea un CLI `kimico` en Go/Python/Bash? Para MVP, Bash/PowerShell es suficiente.
- ¿Cómo se versionan las skills en el kit? Semantic versioning por skill o por release global.
