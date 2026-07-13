# KIMI-END-OF-DAY — Ritual de Cierre de Sesión (TRIN)

> **Cuándo usar:** Cuando Álvaro dice "cerramos", "terminamos", "end of day", "EOD", o al finalizar cualquier sesión de trabajo en un proyecto.
> **Duración objetivo:** 1-3 minutos de escritura antes de despedirse.
> **Salida:** Resumen ejecutivo + confirmación de vault actualizado.

---

## 0. IDENTIDAD INMEDIATA

Eres **KIMICO** (TRIN). Estás cerrando la jornada. Tu trabajo ahora es **persistir todo el contexto** para que la siguiente sesión retome sin pérdida de información.

Modo: Ultra-directo. Sin relleno. Solo español.

---

## 1. DETERMINAR PROYECTO(S) TRABAJADO(S)

1. Revisa el historial de esta sesión para identificar en qué proyecto(s) se trabajó.
2. Si fueron múltiples proyectos → ejecutar el ritual para cada uno.
3. Si no hubo trabajo en proyecto específico (solo planificación, CRM, infra general) → usar `vault/alvarodevrace/10-Log/LOG.md`.

---

## 2. ACTUALIZAR VAULT DEL PROYECTO — OBLIGATORIO

**El vault es la memoria persistente. Si no queda escrito en el vault, la sesión no terminó.**

Antes de cerrar, asegúrate de que el contexto relevante esté persistido en:

- `vault/<proyecto>/10-Log/LOG.md` — resumen de la sesión.
- `vault/<proyecto>/00-Index/INDEX.md` — estado actualizado del proyecto.
- `vault/<proyecto>/20-Tech/` — decisiones técnicas nuevas o cambios importantes.
- `vault/<proyecto>/30-Product/` — cambios de producto/negocio.
- `vault/<proyecto>/40-Credentials/INFRA.md` — cambios de infra/credenciales **propios** del proyecto (sin secretos en texto plano).
- `vault/INFRA-GLOBAL-2026-06.md` — si cambió infra global (IPs, IDs, URLs, Cloudflare, backups).

> **Regla de oro:** Si te preguntas "¿esto lo debería escribir en el vault?" → la respuesta es sí.

### 2.1 Vault lint antes de cerrar

Antes de escribir cualquier cambio, invoca `kimi-vault-lint` y corrige:
- IDs globales duplicados fuera de `INFRA-GLOBAL-2026-06.md`.
- Referencias rotas a `vault/INFRA-GLOBAL.md` (obsoleto).
- Secretos expuestos en archivos `.md`.
- Stubs vacíos o huérfanos.

Si no puedes corregir algo → inclúyelo en el resumen como pendiente.

### 2.2 Log de sesión (`vault/<proyecto>/10-Log/LOG.md`)

Añadir una entrada con este formato:

```markdown
## YYYY-MM-DD — <título corto>

**Agente:** <TRIN|PIXEL|LINK|EVA|NOVA|AURA>
**Ambiente:** <dev|prod>
**Tareas:** <lista bullet de 3-5 items máx>
**Commits:** <hashes o descripciones>
**PRs:** <números y estados>
**Deploys:** <ok | fallido | N/A>
**Smoke test:** <ok | fallido | N/A>
**Bloqueos:** <ninguno | descripción>
**Pendientes mañana:** <lista>
**Vault lint:** <✅ sin issues | ⚠️ N corregidos | ❌ N pendientes>
```

> Si el LOG.md no existe → créalo.
> **Nunca edites entradas pasadas.**

### 2.3 Índice del proyecto (`vault/<proyecto>/00-Index/INDEX.md`)

Actualizar la sección **Estado Rápido** si cambió algo relevante:
- URLs nuevas o caídas
- Cambios de stack
- Nuevos servicios
- Estado de deploy cambió

Actualizar la sección **Estado Infra** si hubo cambios de infra.

### 2.4 Tech docs (`vault/<proyecto>/20-Tech/`)

Si se tomó una decisión técnica importante (nueva arquitectura, cambio de pattern, nuevo endpoint):
- Actualizar o crear el documento relevante.
- Ejemplos: `Angular-BFF.md`, `Supabase.md`, `n8n.md`.
- Aplica `kimi-vault-writing-guide`: links a SSOT, 0 secretos, español, ultra-directo.

### 2.5 Product docs (`vault/<proyecto>/30-Product/`)

Si cambió lógica de negocio, flujos de usuario o requisitos:
- Actualizar o crear documento relevante.
- Aplica `kimi-vault-writing-guide`.

### 2.6 Credenciales (`vault/<proyecto>/40-Credentials/`)

Si cambió alguna credencial, UUID, token, o configuración sensible **propia del proyecto**:
- Actualizar `INFRA.md` (pero **nunca** escribir secretos completos — referencias a Bitwarden únicamente).
- Si el cambio es global (Dokploy IDs, Cloudflare, URLs compartidas) → actualiza `vault/INFRA-GLOBAL-2026-06.md`, no el INFRA del proyecto.

### 2.7 PULL REQUESTS Y DEPLOYS

Si durante la sesión se crearon o mergearon PRs:

1. Listar en el LOG los PRs creados, aprobados o mergeados con su estado.
2. Confirmar que no quedan ramas `feature/*` huérfanas sin propósito.
3. Si se mergeó a `main`:
   - Verificar en Dokploy que el deploy terminó correctamente.
   - Confirmar que el smoke test de producción pasó.
   - Si falló, reportar inmediatamente como incidente y activar `kimi-sre-runbook`.
4. Si detectaste un PR de dependabot u otro bot → anotarlo en el LOG como pendiente de cierre/deshabilitación.

---

## 3. PROCESAR DUMPS (`kimi-vault-ingest`)

Si durante la sesión se crearon dumps en `vault/<proyecto>/temp/`:

1. Invoca `kimi-vault-ingest`.
2. Clasifica el contenido de cada dump.
3. Actualiza wiki (`20-Tech/` / `30-Product/`), índice (`00-Index/`) y log (`10-Log/`).
4. **Elimina los dumps originales** una vez confirmado que su información está en wiki/index/log.
5. `vault/<proyecto>/temp/` debe quedar vacío al final del día.

> `temp/` es un **buffer de ingest**, no un archivo histórico. Si se deja crecer, se duplica conocimiento y se pierde el orden.
> **Excepción:** un dump que sea un borrador activo de la siguiente sesión puede quedar temporalmente, pero debe migrarse a wiki/index/log en el próximo cierre.

---

## 4. ACTUALIZAR SKILLS

Si durante la sesión:
- Descubriste un nuevo patrón o workaround importante
- Corregiste un error recurrente que debería documentarse
- Aprendiste algo sobre Dokploy, Supabase, Angular, NestJS, n8n, etc. que podría reutilizarse

→ **Actualiza o crea una skill** en `/Users/alvarocarreramontalvo/.kimi-code/skills/`:

```
kimi-<tema>-<accion>.md
```

> **Regla:** Si la información aplica a **todos los proyectos** → skill global. Si aplica solo a un proyecto → documentar en el vault del proyecto.

También actualiza `KIMI-MASTER-SKILLS.md` y `kimi-all-skills-catalog.md` si:
- Cambió la asignación de skills a agentes
- Cambió un protocolo operativo
- Se creó una skill que todos los agentes deberían conocer

---

## 5. ACTUALIZAR MEMORIAS Y CONTEXTO

### 5.0 Revisión de memoria completa

Antes de escribir el resumen final, verifica que el vault de memoria esté completo y actualizado:

1. **Revisa `vault/<proyecto>/00-Index/INDEX.md`** — ¿el estado refleja la realidad actual del proyecto?
2. **Revisa `vault/<proyecto>/10-Log/LOG.md`** — ¿la entrada de hoy está escrita y es comprensible sin contexto adicional?
3. **Revisa `vault/<proyecto>/20-Tech/`** — ¿hay decisiones técnicas de hoy que deban quedar documentadas?
4. **Revisa `vault/<proyecto>/30-Product/`** — ¿hay cambios de producto por documentar?
5. **Revisa `vault/INFRA-GLOBAL-2026-06.md`** — ¿cambió infra global y está actualizada?
6. **Revisa skills creadas o actualizadas** — ¿están registradas en `KIMI-MASTER-SKILLS.md` y `kimi-all-skills-catalog.md`?

Si algo falta → escríbelo ahora. **No dejes memoria solo en el contexto de la sesión.**

### 5.1 Archivos de agentes (`agents/kimi/*.md`)

Si un agente específico (PIXEL, LINK, etc.) trabajó en algo que deba recordar para futuras sesiones:
- Añadir una nota en la sección de "Contexto persistente" o "Último estado" del archivo de ese agente.

### 5.2 ENGRAM — MEMORIA PERSISTENTE

Antes de cerrar, revisa si hay contextos que deban sobrevivir a la siguiente sesión:

1. Listar memorias del proyecto en Engram (`mcp__engram__mem_search` o `mcp__engram__mem_context`).
2. Migrar a vault todo lo que sea permanente (decisiones, estado, bloqueos).
3. Guardar en Engram lo que sea útil para retomar mañana pero que aún no va al vault:
   - Tareas en progreso.
   - Workarounds o descubrimientos recientes.
   - Recordatorios de acciones pendientes inmediatas.
4. Borrar memorias de Engram que ya estén obsoletas o duplicadas en vault.

Ver convenciones en `vault/alvarodevrace/20-Tech/decisions/2026-07-13-engram-conventions.md`.

---

## 6. RESUMEN EJECUTIVO PARA ÁLVARO

Entregar **máximo 8 líneas**:

```
✅ Cierre de sesión — <proyecto>

Hecho hoy:
- <item 1>
- <item 2>
- <item 3>

PRs: <#22 merged, #44 pendiente> | Deploy: <ok|fallido|N/A> | Smoke: <ok|fallido|N/A>
Pendientes mañana: <lista corta>
Bloqueos: <ninguno | descripción>
Vault actualizado: <sí | archivos modificados>
```

> Si hubo múltiples proyectos → un bloque por proyecto, máx 3 líneas cada uno.

---

## 7. LIMPIEZA

1. **Procesar archivos temporales** en `vault/<proyecto>/temp/` (ver sección 3).
2. **Eliminar logs de debug** generados durante la sesión (ej: `debug-storybook.log`).
3. **Verificar que no quedaron `.env` expuestos** en ningún diff o archivo nuevo.
4. **Confirmar que `main` y `develop` están sincronizados** si hubo merges.

---

## 8. COMANDO DE INVOCACIÓN

Álvaro puede invocar este ritual diciendo:
- "Cerramos"
- "Terminamos"
- "End of day"
- "EOD"
- "Ritual de cierre"
- "Actualiza el vault"

---

## 9. CHECKLIST RÁPIDO (auto-verificación)

Antes de despedirse, confirma mentalmente:

- [ ] Vault del proyecto actualizado (LOG.md + INDEX.md + 20-Tech/30-Product si aplica)
- [ ] Infra global actualizada si cambió (`vault/INFRA-GLOBAL-2026-06.md`)
- [ ] Dumps procesados con `kimi-vault-ingest`
- [ ] `kimi-vault-lint` ejecutado y sin issues críticos
- [ ] PRs creados/mergeados documentados en el LOG
- [ ] Deploy verificado si se mergeó a `main` (Dokploy + smoke test)
- [ ] PRs de bots (dependabot) reportados como pendientes
- [ ] Memoria revisada y completa
- [ ] Skills creadas/actualizadas registradas en catálogos
- [ ] Resumen entregado a Álvaro
- [ ] Sin secretos expuestos
- [ ] Sin archivos temporales olvidados
- [ ] Git limpio (no hay cambios sin commitear importantes)
