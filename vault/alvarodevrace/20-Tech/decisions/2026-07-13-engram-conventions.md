# Convenciones de memoria: Engram vs Vault

## Principio general

- **Vault** = memoria oficial, estructurada, de fuente única de verdad. Decide qué se sabe y cómo funciona.
- **Engram** = memoria activa, contextual, de recuperación rápida. Ayuda a no perder el hilo entre sesiones y compactaciones de contexto.

Si una información es importante para que cualquier agente la encuentre en el futuro, **debe terminar en el vault**. Engram es un puente temporal, no un destino final.

---

## Qué guardar en Engram

Guardar en Engram cuando:

1. **La sesión está en progreso** y aún no se ha cerrado ni consolidado en vault.
   - Ejemplo: *"Hoy estamos refactorizando el checkout; pendiente probar el flujo de MercadoPago."*

2. **Una decisión o workaround surgió en mitad de la sesión** y se documentará en vault al cerrar.
   - Ejemplo: *"Descubrimos que Dokploy no rebuilda si la imagen `latest` no cambia; workaround: activar `cleanCache` antes del deploy."*

3. **El contexto es muy específico de la conversación actual** y no merece una página de vault propia.
   - Ejemplo: *"Álvaro prefiere que los resúmenes de deploy sean de máximo 5 líneas."*

4. **Hay una compactación de contexto inminente** y se necesita preservar el estado hasta el cierre de sesión.
   - Ejemplo: resumen de lo acordado antes de que el sistema condense la conversación.

5. **Se necesita recuperar algo en la siguiente sesión** antes de que EVA procese el vault.
   - Ejemplo: *"PR #48 pendiente de aprobación; al aprobar, verificar deploy y smoke test."*

---

## Qué NUNCA guardar solo en Engram

Nunca dejar solo en Engram:

- **Secretos** (API keys, passwords, tokens). Van a Bitwarden.
- **IDs de infra** (Dokploy app IDs, Cloudflare zone IDs, IPs). Van a `vault/INFRA-GLOBAL-2026-06.md`.
- **Decisiones arquitectónicas aprobadas**. Van a `vault/<proyecto>/20-Tech/decisions/`.
- **Procedimientos que se repetirán**. Van a skills (`~/.kimi-code/skills/`) o a `KIMI.md` / `AGENTS.md`.
- **Estado oficial de un proyecto**. Va a `vault/<proyecto>/00-Index/INDEX.md`.
- **Logs de actividad**. Van a `vault/<proyecto>/10-Log/LOG.md`.

---

## Flujo de trabajo con Engram

### Al iniciar sesión

1. Leer vault, AGENTS.md y SKILL-REGISTRY.
2. Si el usuario retoma una tarea pendiente, **consultar Engram explícitamente**:
   - *"¿qué teníamos pendiente de la sesión anterior sobre X?"*
   - *"¿hay memorias relevantes para el proyecto Y?"*

### Durante la sesión

1. Cuando se toma una decisión o se descubre un workaround, **guardar en Engram de inmediato** si aún no se va a escribir en vault.
2. Al finalizar una subtarea, **migrar la memoria a vault** (LOG, decision, índice) y dejar Engram como respaldo temporal.

### Al cerrar sesión

1. Revisar memorias de Engram de la sesión.
2. Todo lo que sea permanente → vault.
3. Todo lo que sea temporal de la siguiente sesión → dejar en Engram con un resumen claro.

---

## Cómo interactuar con Engram

### Guardar memoria

```
Guarda en Engram: "[contexto] — [dato clave] — [acción pendiente si aplica]"
```

Ejemplo:
> *Guarda en Engram: Las Chubys — el Dockerfile del back usa `dist/main.js` desde el PR #48; si vuelve a fallar el deploy, revisar `cleanCache` en Dokploy.*

### Consultar memoria

```
Según Engram, ¿[pregunta concreta]?
```

Ejemplo:
> *Según Engram, ¿qué teníamos pendiente de verificar tras el deploy de Las Chubys?*

### Borrar memoria obsoleta

Si una memoria ya está en vault o ya no aplica, borrarla de Engram para no contaminar futuras consultas.

---

## Reglas de oro

1. **Engram nunca reemplaza al vault.** Es un buffer, no un archivo histórico.
2. **Si una memoria tiene más de 7 días y no migró a vault, revisar si aún es relevante.** Si no, borrar.
3. **Las memorias de Engram deben ser breves y accionables.** No guardar ensayos.
4. **Siempre que consultes Engram, cita la fuente.** *"Según Engram, ..."*
5. **Al final de cada sesión, el vault es la prioridad.** Engram es secundario.
