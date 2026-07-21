# LOG — AlvaroDevRace (Sistema Freelancer)

## [2026-07-21] TRIN | Incidente VPS Hostinger caído + watchdog local macOS

**Agente:** TRIN
**Tareas:**
- Detectado VPS Hostinger (`72.60.26.201`) caído desde 2026-07-12T21:35-05:00. Root cause: hypervisor-initiated shutdown. No hubo notificación previa de Hostinger.
- Recuperación manual: VPS encendido, Tailscale y Cloudflare Tunnel reconectados, todos los servicios públicos responden 200.
- Acceso SSH root al VPS recuperado con password `@lv4r0C4rr3r4`; guardada en Bitwarden (`global/ssh-root-vps`).
- Implementado watchdog local en macOS para detectar caídas del VPS: script de health check + LaunchAgent + installer en `scripts/`.
- Verificación: script silencioso en estado healthy, notificación nativa de macOS al simular falla, anti-spam de 60 min.
**Commits:** `73b63d3`, `161436b`, `2b855bc`, `f567f91`, `a04824f`, `df4e57f`, `ade9dbd`.
**PRs:** Ninguno — a espera de Álvaro.
**Deploys:** N/A.
**Smoke test:** ✅ Todas las URLs críticas responden 200.
**Bloqueos:** Ninguno.
**Pendientes mañana:**
- Definir si se añade watchdog secundario 24/7 (Dell o servicio externo).
- Revisar panel Hostinger para entender por qué el hypervisor forzó el shutdown.
**Vault lint:** ✅ sin issues.

---

## [2026-07-10] TRIN | Mantenimiento infra global: Dokploy + Uptime Kuma + Planka

**Agente:** TRIN
**Tareas:**
- Actualizar Dokploy `v0.29.8` → `v0.29.11` en VPS; verificar servicio convergido y apps healthy.
- Actualizar Uptime Kuma `1.23.17` → `2.4.0`; migración de DB exitosa; resetear password del usuario `alvaro`.
- Limpiar monitores obsoletos de Uptime Kuma (Coolify, Evolution API, Penpot, Netdata, UtilBoxes, CobrosLatam, duplicados).
- Corregir URLs de monitores activos: Planka → `http://100.88.228.17:3333`, Crawl4AI → `:11235/health`, Gotenberg → `:3010/health`, Sitemap Las Chubys, Supabase REST con `apikey`.
- Detectar que Planka público (`https://planka.alvarodevrace.tech`) devuelve 404; servicio local en Dell OK.
- Actualizar `vault/INFRA-GLOBAL-2026-06.md` con versiones y estado de Planka.

**Commits:** Ninguno.
**PRs:** Ninguno.
**Bloqueos:** Ninguno.
**Pendientes mañana:**
- Revisar notificación Telegram de Uptime Kuma (token 401).
- Arreglar proxy público de Planka si se requiere acceso remoto.
**Vault lint:** ⚠️ 1 referencia obsoleta en log histórico (no editado por regla append-only).

## [2026-06-25] TRIN | Consolidación DRY del vault + prompts y skills de mantenimiento

**Agente:** TRIN
**Tareas:**
- Consolidar infra/credenciales globales en `vault/INFRA-GLOBAL-2026-06.md` como única SSOT.
- Limpiar `KIMI.md` y `agents/KIMI-AGENTS.md` de tablas de infra/secretos duplicados.
- Eliminar `vault/alvarodevrace/40-Credentials/INFRA.md`, `vault/LOG.md`, duplicado ~~`KIMI-SKILLS-MASTER.md`~~, stubs vacíos y stubs con secretos expuestos.
- Limpiar credenciales por proyecto en `vault/portfolio/.../INFRA.md` y `vault/laschubys/.../INFRA.md` (solo datos propios).
- Limpiar IDs globales duplicados en `vault/laschubys/20-Tech/Supabase.md` y `Angular-BFF.md`.
- Corregir referencias rotas a `vault/INFRA-GLOBAL-2026-06.md`.
- Reescribir `prompts/KIMI-START-OF-DAY.md` y `prompts/KIMI-END-OF-DAY.md` con SSOT y skills de vault.
- Crear skills `kimi-vault-writing-guide`, `kimi-vault-lint`, `kimi-vault-ingest`.
- Registrar nuevas skills en `KIMI-MASTER-SKILLS.md` y `kimi-all-skills-catalog.md`.
- Limpiar `kimi-all-skills-catalog.md` de referencias obsoletas a Coolify y Jauria.
- Design doc: `system/DESIGN-Vault-DRY-Consolidation-2026-06.md`.
**Commits:** Ninguno (tareas de documentación y skills).
**PRs:** Ninguno.
**Bloqueos:** Ninguno.
**Pendientes resueltos en misma jornada:**
- ✅ Procesados 4 dumps de PIXEL sobre migración spartan → `vault/laschubys/20-Tech/Spartan-Migration.md`; dumps originales eliminados.
- ✅ Eliminados todos los archivos Penpot obsoletos (`PENPOT_WORKFLOW.ARCHIVADO.md`, `Penpot-Self-Hosted.ARCHIVADO.md`, `Penpot-Design-System.ARCHIVADO.md`) y archivado `DESIGN_SYSTEM.md` a `Design-System-Penpot.ARCHIVADO.md` (ya no se usa Penpot; Figma es la herramienta oficial).
- ✅ Revisados `vault/infra/20-Tech/`: IDs técnicos globales migrados a `vault/INFRA-GLOBAL-2026-06.md`; docs locales ahora referencian SSOT; se mantiene nota de excepción para valores inline en ejemplos/runbooks por legibilidad operativa.
**Vault lint:** ✅ PASS — 0 archivos vacíos, 0 dumps residuales, 0 archivos Penpot activos.

## [2026-06-24] TRIN | Auditoría y limpieza global de infraestructura

**Agente:** TRIN
**Tareas:**
- Auditoría completa de infra: VPS, Dell, Coolify, n8n, Bitwarden, GitHub, Planka.
- Limpieza workspace: eliminados AgentOffice, CobrosLatam, UtilBoxes, docs/, node_modules/ y vaults obsoletos.
- Limpieza GitHub: eliminados repos de UtilBoxes, CobrosLatam, Jauria y Agrovivas.
- Limpieza Coolify: eliminados proyectos UtilBoxes y CobrosLatam.
- Limpieza Planka: eliminados proyectos Jauria, Brain, CobrosLatam, UtilBoxes.
- Limpieza n8n: eliminados 4 workflows inactivos del sistema freelance.
- Limpieza Bitwarden: eliminado item obsoleto `s3s.casabaca.com`.
- Actualización VPS/Dell: paquetes, reinicios, netdata eliminado, zombies limpiados.
- Documentación: actualizados `INFRA-GLOBAL-2026-06.md`, `KIMI.md`, `KIMI-AGENTS.md`, prompts y generado informe de auditoría.
**Commits:** Ninguno (tareas de infra y documentación).
**PRs:** Ninguno.
**Bloqueos:** Ninguno.
**Pendientes mañana:** Ninguno crítico. Monitorear certificado `laschubys.com` (32 días) y `WF-LCH-SEO-01`.

## [2026-06-18] TRIN | Análisis de Engram.so / Gentleman-Programming/engram como capa de memoria. Conclusión: Engram.so oficial descartado por dependencia Anthropic/OpenAI. Engram de Gentleman viable (Go + SQLite + FTS5, offline, sin API keys). Ticket creado en Planka Las Chubys (LCH-N, #1799834192289203652) con opciones y plan de acción. Se añadió acceso cifrado a Bitwarden master key en vault.

## [2026-06-10] TRIN | Migración herramienta diseño: Penpot → Figma (gratis). Roles AURA actualizados en KIMI.md, agents/kimi/AURA.md, agents/AURA.md, prompts/KIMI-AURA-BOOT.md, agents/KIMI-AGENTS.md, agents/kimi/PIXEL.md. Stack técnico oficial: Figma reemplaza Penpot self-hosted.

## [2026-05-19] TRIN | Prueba E2E completa. WF-ADR-05 activo. AgroVivas Deal v2 documentado. Bot Telegram migrado a @alvarodevrace_bot.
## [2026-05-18] TRIN | Configuración inicial Docuseal + Gotenberg + PDF Templates.

## 2026-07-13 — TRIN | Cierre sistema agentico v2 + Engram integrado

**Agente:** TRIN
**Ambiente:** prod/dev
**Tareas:**
- Completar SKILL-REGISTRY para workspace root (`vault/alvarodevrace/20-Tech/SKILL-REGISTRY.md`).
- Definir convenciones de memoria Engram vs vault (`vault/alvarodevrace/20-Tech/decisions/2026-07-13-engram-conventions.md`).
- Actualizar rituales `KIMI-START-OF-DAY.md` y `KIMI-END-OF-DAY.md` para consultar/guardar Engram.
- Actualizar `agents/KIMI-AGENTS.md` con Engram como Capa 0 de memoria.
- Mergear PR #1 del workspace (`docs/start-end-day-ambientes` → `develop`).
- Verificar Engram: `engram doctor` OK, guardado y búsqueda funcionan.
**Commits:**
- Workspace: `274d871` (docs: rituales, Engram, Skill Registry alvarodevrace).
**PRs:** #1 ✅ merged (workspace).
**Deploys:** N/A.
**Smoke test:** N/A.
**Bloqueos:** Ninguno.
**Pendientes mañana:**
- Probar que Kimi Code invoque herramientas MCP de Engram en una sesión nueva.
- Migrar memorias temporales de Engram a vault al cerrar próximas sesiones.
**Vault lint:** ✅ sin issues.
