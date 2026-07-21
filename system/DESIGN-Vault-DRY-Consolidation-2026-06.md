# Design Doc — Vault DRY Consolidation 2026-06

**Scope:** Consolidación rápida de infraestructura/credenciales globales para eliminar duplicados DRY en el vault.  
**Aprobado por:** Álvaro Carrera  
**Fecha:** 2026-06-24  
**Owner:** KIMI-TRIN (KIMICO)  

---

## 1. Objetivo

Eliminar redundancias de infraestructura, credenciales y IDs Dokploy/Cloudflare que hoy viven en múltiples archivos. Establecer **una única fuente de verdad (SSOT)** por tema y convertir `KIMI.md` y `agents/KIMI-AGENTS.md` en índices ligeros que referencian, no repiten.

---

## 2. Principios

- **Karpathy:** raw → wiki → schema → index → log. Los datos globales son *wiki* compartida; los schemas (`KIMI.md`, `KIMI-AGENTS.md`) solo indexan.
- **DRY:** un dato global aparece en un solo lugar.
- **No tocar logs históricos:** `SESSION_LOG.md`, `vault/*/10-Log/LOG.md` son append-only.
- **0 secretos completos en `.md`:** cualquier token expuesto encontrado se reemplaza por referencia Bitwarden o se elimina el archivo.
- **No modificar repos git de subproyectos.**

---

## 3. Fuentes únicas de verdad

| Tema | SSOT | ¿Qué contiene? |
|------|------|----------------|
| Infra global, IDs Dokploy, IPs, URLs compartidas, Cloudflare, backups, secretos maestros | `vault/INFRA-GLOBAL-2026-06.md` | Todo lo operativo compartido |
| Catálogo de skills y roles de agentes | `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md` | Skills, inyección a subagentes, mapa de proyectos, flujos |
| Schema maestro de agentes y reglas Git/deploy | `agents/KIMI-AGENTS.md` | Reglas, propiedad, flujo Git, tabla de proyectos (sin IDs repetidos) |
| Entry point del sistema | `KIMI.md` | Orientación, agentes, stack, reglas absolutas, links a SSOT |

---

## 4. Cambios por archivo

### 4.1 `vault/INFRA-GLOBAL-2026-06.md` (SSOT infra)
- Unificar las **dos secciones de Cloudflare** que están duplicadas (líneas ~7-18 y ~365-383). La sección final incluye datos de tokens/hallazgos; se integran en la primera y se elimina la repetición.
- Añadir nota explícita en el header: *"Si otro archivo repite estos datos, la versión vigente es esta."*
- Verificar que no haya referencias a archivos ya borrados (Coolify, Netdata, Evolution ya están marcados como eliminados; se mantienen como histórico de cleanup).

### 4.2 `agents/KIMI-AGENTS.md`
**Eliminar (reemplazar por link a SSOT):**
- Sección "Infraestructura Compartida" (~líneas 67-93).
- Sección "Nodos" (~líneas 96-103).
- Sección "Cloudflare — DNS + Tunnel" (~líneas 230-238).
- Sección "Secretos maestros" (~líneas 242-258).
- Sección "Backups — Sistema 3-2-1" (~líneas 262-283).
- Checklist mensual: reemplazar items que pidan verificar cosas globales por un solo item: *"Revisar INFRA-GLOBAL-2026-06.md"*.

**Mantener:**
- Modo Ultra, Agente líder, agentes del equipo.
- Tabla Maestra de Proyectos (sin columnas de IDs globales; agregar link a SSOT).
- Proyectos eliminados.
- LEY DE MEMORIA / flujo de cierre.
- Protocol RX.
- Flujo Git.
- Propiedad de Agentes.
- Regla Final.

### 4.3 `KIMI.md`
**Eliminar (reemplazar por link a SSOT):**
- Sección "Infraestructura real (viva)" completa (~líneas 69-141).
- Subsección "Secretos — Dónde viven" detallada; dejar solo la regla general de Bitwarden + link a INFRA-GLOBAL.

**Mantener:**
- Modo de trabajo Ultra-Directo.
- Agente líder y agentes del equipo.
- Proyectos activos (sin Dokploy IDs; link a INFRA-GLOBAL).
- Stack técnico oficial.
- Reglas absolutas.
- Memoria muerta.

**Añadir:**
- Línea prominente al inicio: *"Infra/credenciales globales → `vault/INFRA-GLOBAL-2026-06.md`"*.

### 4.4 `vault/alvarodevrace/40-Credentials/INFRA.md`
- **Eliminar después de migrar lo no repetido a SSOT.** Todo su contenido es global o referencias Bitwarden, pero antes de borrar se trasladan a `vault/INFRA-GLOBAL-2026-06.md`:
  - Docuseal template ID/slug (dato operativo, no secreto).
  - Referencias Bitwarden: n8n service password, IA APIs (Gemini/Mistral/OpenRouter), Telegram chat IDs.
  - Clave Age pública para SOPS.
  - Instrucciones de desbloqueo de Bitwarden.
  - Nota DNS huérfano `evolution.alvarodevrace.tech` (pendiente de limpieza).
- En `agents/KIMI-AGENTS.md`, actualizar la frase genérica: *"Credenciales por proyecto: `vault/<proyecto>/40-Credentials/INFRA.md` (si aplica; globales en `vault/INFRA-GLOBAL-2026-06.md`)."*

### 4.5 `vault/portfolio/40-Credentials/INFRA.md`
- **Mantener** datos propios del proyecto: Planka board/lists/labels, stack PIXEL, diseño, GitHub repo, SSH remote, Formspree endpoint, Dokploy environment ID.
- **Eliminar duplicados globales:** Dokploy project/application IDs, Cloudflare zone, URL app (está en INFRA-GLOBAL), referencias a Sentry genéricas.
- **Reescribir** snippet de deploy manual usando variables y referenciando INFRA-GLOBAL para IDs.

### 4.6 `vault/laschubys/40-Credentials/INFRA.md`
- **Mantener** datos propios: Planka IDs, GitHub repos/remotes, GitHub Secrets (nombres), Sentry DSNs por proyecto, monitores de Las Chubys en Uptime Kuma, GTM, integraciones externas (PayPhone, Printful, MailerSend), SEO, stack, git flow, problemas conocidos, TODO backlog.
- **Eliminar/convertir en referencias:**
  - Cloudflare zone ID → INFRA-GLOBAL.
  - Cloudflare cache-purge token de `laschubys.com` → centralizar referencia Bitwarden en INFRA-GLOBAL; el proyecto solo linkea.
  - URLs globales (n8n, Supabase) → INFRA-GLOBAL.
  - Dokploy project/app IDs → INFRA-GLOBAL.
  - Tokens globales (Dokploy, n8n, Cloudflare admin, Telegram bots, Supabase keys) → INFRA-GLOBAL / Bitwarden.
  - Snippet de purge cache usando variable de zona o link a INFRA-GLOBAL.
  - Sección "Infraestructura Física" → INFRA-GLOBAL.
  - Monitores Uptime Kuma que sean globales (Status Page, n8n, Supabase, Dokploy) → INFRA-GLOBAL; dejar solo los de Las Chubys.

### 4.7 `vault/LOG.md`
- **Eliminar.** Ya está deprecado y apunta a `vault/infra/10-Log/LOG.md`.

### 4.8 Catálogo de skills duplicado
- **`vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md` → eliminar.**
- **`~/.kimi-code/skills/KIMI-MASTER-SKILLS.md` → reescribir** con el contenido vigente del vault (más actualizado), limpiando:
  - Referencias a Coolify (reemplazar por Dokploy).
  - Proyectos eliminados (Agrovivas, Jauria, CobrosLatam, UtilBoxes, AgentOffice, Brain).
  - Paths `.codex`/`.claude` obsoletos.
  - Skills obsoletas de Coolify.
- Actualizar referencias internas para que apunten al catálogo global (`kimi-all-skills-catalog.md`).
- **Nota de scope:** esta reescritura es necesaria para que la SSOT de skills no quede desactualizada al borrar el duplicado. No se rediseña el catálogo, solo se sincroniza y limpia.

### 4.9 Actualizar referencias rotas
Antes de dar por terminado, corregir links que apuntan al archivo obsoleto `vault/INFRA-GLOBAL.md` (sin año-mes):
- `vault/laschubys/20-Tech/Supabase.md`
- `agents/NEW-PROJECT-GUIDE.md`

Y actualizar `vault/alvarodevrace/00-Index/INDEX.md` si enlaza a stubs que se eliminarán en esta pasada.

### 4.10 Stubs huérfanos
- **`vault/portfolio/20-Tech/`** → eliminar (vacío).
- **`vault/portfolio/30-Product/`** → eliminar (vacío).
- **`vault/alvarodevrace/20-Tech/Docuseal-Gotenberg.md`** → eliminar. Contiene token Docuseal expuesto; la info pertinente ya está en INFRA-GLOBAL.
- **`vault/alvarodevrace/20-Tech/Notion-Integration.md`** → eliminar. Contiene token Notion expuesto; el sistema freelancer/Notion ya no está activo según logs recientes.
- **`vault/alvarodevrace/20-Tech/n8n-Workflows.md`** → eliminar. Workflows ADR fueron eliminados 2026-06-24; contiene chat ID Telegram.

---

## 5. Criterios de éxito

1. `Grep` de Zone IDs, Tunnel ID y Dokploy project/app IDs no devuelve repeticiones en archivos `.md` del vault fuera de `INFRA-GLOBAL-2026-06.md` (se excluyen archivos de IaC como `infra/tofu/variables.tf`).
2. `agents/KIMI-AGENTS.md` y `KIMI.md` no contienen tablas de infra/secretos; solo links a SSOT.
3. `vault/alvarodevrace/40-Credentials/INFRA.md` eliminado.
4. `vault/LOG.md` eliminado.
5. `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md` eliminado.
6. `vault/portfolio/20-Tech/` y `30-Product/` eliminados.
7. No quedan tokens/secretos completos expuestos en los archivos tocados (se reemplazan por `bitwarden:*` o se eliminan).
8. Logs históricos (`SESSION_LOG.md`, `vault/*/10-Log/LOG.md`) permanecen intactos.
9. `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md` refleja estado vigente: sin Coolify, sin proyectos eliminados, sin paths `.codex`/`.claude`.

---

## 6. Riesgos y mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| Quitar IDs de `KIMI-AGENTS.md` dificulta lookups rápidos | Se deja tabla de proyectos con links a SSOT; Kimico siempre puede leer INFRA-GLOBAL al inicio. |
| Al eliminar `vault/alvarodevrace/.../INFRA.md` se pierde organización | No hay datos propios de alvarodevrace distintos de los globales. |
| `KIMI-MASTER-SKILLS.md` global queda desactualizado | Se fusiona contenido vigente del vault antes de eliminar el duplicado. |
| Archivos con secretos expuestos | Se eliminan; sus datos operativos ya están en INFRA-GLOBAL con referencias Bitwarden. |

---

## 7. Fuera de scope (queda para fase posterior)

- Reescribir `prompts/KIMI-START-OF-DAY.md` y `prompts/KIMI-END-OF-DAY.md`.
- Crear skills de mantenimiento del vault (lint, ingest, update-index).
- Reorganizar `vault/20-Tech/` en estructura por tema.
- Migrar de Karpathy "a medias" a estructura plena de schema/wiki/index.
- Limpieza de `.obsidian/` (config vacía; riesgo de romper Obsidian).

## 8. Validación post-ejecución

Ejecutar antes de cerrar la tarea:

```bash
# 1. IDs globales no deben repetirse en .md del vault (solo en INFRA-GLOBAL)
rg -n -g '*.md' '2a17143e03abfec70bd29db73b74fecf|b1bd4dda49d48900eecb9228673ef1e9|49dc4a63-adb2-4c5e-a53c-07dfecd7ab4a|dcZfubBCdj1wno5hroswj|oSVdXwFYGekg16v18XNW1|aP3P-FbWPbS383qrcKEGm|HTxz4FLFZ-FFasumznhf2' vault/ agents/ KIMI.md \
  | grep -v 'INFRA-GLOBAL-2026-06.md'

# 2. Verificar archivos eliminados
ls vault/alvarodevrace/40-Credentials/INFRA.md vault/LOG.md vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md 2>&1 | grep 'No such file'

# 3. Verificar que no queden tokens completos (patrones de API key, token, password)
rg -n -g '*.md' '[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}|sk-[a-zA-Z0-9]{20,}|ntn_[a-zA-Z0-9]{20,}|p9zi[a-zA-Z0-9]{20,}' vault/ agents/ KIMI.md || true
```

Resultado esperado: el primer comando debe devolver vacío (o solo hits en INFRA-GLOBAL); el segundo debe mostrar los tres archivos como inexistentes; el tercero sirve como revisión manual de secretos expuestos.

## 9. Riesgos aceptados

- **Logs históricos con secretos expuestos:** no se editarán porque son append-only. Los secretos en ellos deben considerarse rotados en la próxima ventana de mantenimiento.
