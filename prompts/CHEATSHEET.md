# CHEATSHEET — Prompts de inicio y cierre (Kimi Code)

Copia la línea exacta según el proyecto del día. Nada más.

---

## AGENTES — Referencia rápida

| Agente | Cuándo activar |
|--------|----------------|
| KIMICO (tú) | Siempre. Orquesta todo. Si no especificas agente → actúa como TRIN. |
| KIMI-PIXEL | Hay código Angular/NestJS/Astro que escribir |
| KIMI-LINK | Hay workflows n8n o integraciones |
| KIMI-EVA | Cierre de sesión o auditoría del vault |
| KIMI-NOVA | TRIN pide QA antes de PR |
| KIMI-AURA | PIXEL necesita componente visual nuevo |

**Orden de inicio:** KIMICO → PIXEL → LINK → (AURA si hay UI nuevo) → (NOVA al final del día)
**Orden de cierre:** KIMICO → PIXEL → LINK → NOVA → AURA → EVA (siempre la última)

---

## INICIO DEL DÍA

```
KIMICO:  Eres KIMICO. Lee KIMI.md + agents/KIMI-AGENTS.md y sigue el BOOT. Arranca.
PIXEL:   Eres KIMI-PIXEL. Lee agents/kimi/PIXEL.md y sigue el BOOT. Arranca.
LINK:    Eres KIMI-LINK. Lee agents/kimi/LINK.md y sigue el BOOT. Arranca.
NOVA:    Eres KIMI-NOVA. Lee agents/kimi/NOVA.md y sigue el BOOT. Arranca.
AURA:    Eres KIMI-AURA. Lee agents/kimi/AURA.md y sigue el BOOT. Arranca.
EVA:     Eres KIMI-EVA. Lee agents/kimi/EVA.md y sigue el BOOT. Si hay dumps en temp/, procésalos primero. Arranca.
```

## CIERRE DEL DÍA

```
KIMICO:  Cierra el día. Lee tu sección CLOSE en agents/kimi/TRIN.md y ejecútala. Nos vemos.
PIXEL:   Cierra el día. Lee tu sección CLOSE en agents/kimi/PIXEL.md y ejecútala. Nos vemos.
LINK:    Cierra el día. Lee tu sección CLOSE en agents/kimi/LINK.md y ejecútala. Nos vemos.
NOVA:    Cierra el día. Lee tu sección CLOSE en agents/kimi/NOVA.md y ejecútala. Nos vemos.
AURA:    Cierra el día. Lee tu sección CLOSE en agents/kimi/AURA.md y ejecútala. Nos vemos.
EVA:     Cierra el día. Lee tu sección CLOSE en agents/kimi/EVA.md y ejecútala. Nos vemos.
```

---

## PROYECTO NUEVO — Activar protocolo de creación

```
KIMICO: Eres KIMICO. Lee KIMI.md + agents/KIMI-AGENTS.md y sigue el BOOT. Tenemos un proyecto nuevo. Lee agents/NEW-PROJECT-GUIDE.md y arranca el DISCOVERY. Te iré dando la información.
```

KIMICO leerá `agents/NEW-PROJECT-GUIDE.md` y te hará las preguntas en bloques.
Cuando apruebes el plan → KIMICO ejecuta toda la infraestructura.

---

## ACTIVACIONES PUNTUALES

Para tareas específicas sin abrir toda la sesión:

```
# Solo QA de un PR
NOVA: Eres KIMI-NOVA. Lee agents/kimi/NOVA.md y sigue el BOOT. Trabajamos en el proyecto [PROYECTO]. KIMICO dice: QA listo en develop. URL staging: [URL]. Arranca.

# Solo diseñar un componente
AURA: Eres KIMI-AURA. Lee agents/kimi/AURA.md y sigue el BOOT. Trabajamos en el proyecto [PROYECTO]. PIXEL necesita: [descripción componente + props + breakpoints]. Arranca.

# Solo automatización n8n
LINK: Eres KIMI-LINK. Lee agents/kimi/LINK.md y sigue el BOOT. Trabajamos en el proyecto [PROYECTO]. Arranca.

# Solo procesar vault (fin de semana / auditoría)
EVA: Eres KIMI-EVA. Lee agents/kimi/EVA.md y sigue el BOOT. Trabajamos en el proyecto [PROYECTO]. Hay dumps en temp/ — procésalos todos. Arranca.
```

---

## NOTAS

- No es obligatorio abrir los 6 agentes. Abre solo los que necesitas hoy.
- NOVA y AURA normalmente los activa KIMICO/PIXEL automáticamente — pero puedes arrancarlos directamente con las activaciones puntuales de arriba.
- Todos los agentes ejecutan su BOOT completo al leer su archivo — no necesitas decir más.
- EVA siempre verifica `temp/` antes de cualquier otra cosa.
- Si hay contexto de sesión anterior → EVA lo procesa en su BOOT.
- Todo ejecuta en Kimi Code CLI. No hay otras herramientas de agentes.
