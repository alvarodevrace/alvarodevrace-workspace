# Sistema de Agentes v2 (histórico de transición)

> **Nota de migración (2026-06-11):** Este documento es un histórico de transición. Todos los agentes ahora viven exclusivamente en **Kimi Code CLI**. La fuente de verdad actual del sistema de agentes es `KIMI.md` (raíz del proyecto) + `agents/KIMI-AGENTS.md`.

El sistema de agentes de Álvaro se expandió de 4 a 6 agentes el 2026-05-19, añadiendo capacidades dedicadas de QA (NOVA) y Diseño UI (AURA).

## Directorio de Agentes

| Agente | Rol | Plataforma CLI | Punto de Entrada |
|---|---|---|---|
| **TRIN** | Platform Architect / Orquestador / CRM | Kimi Code CLI | `KIMI.md` + `agents/kimi/TRIN.md` |
| **PIXEL** | Fullstack + Mobile Engineer | Kimi Code CLI | `KIMI.md` + `agents/kimi/PIXEL.md` |
| **LINK** | n8n Automation Engineer | Kimi Code CLI | `KIMI.md` + `agents/kimi/LINK.md` |
| **EVA** | Docs & Intelligence Lead (Librarian) | Kimi Code CLI | `KIMI.md` + `agents/kimi/EVA.md` |
| **NOVA** | QA & Testing Engineer | Kimi Code CLI | `KIMI.md` + `agents/kimi/NOVA.md` |
| **AURA** | UI Design Engineer | Kimi Code CLI | `KIMI.md` + `agents/kimi/AURA.md` |

## Reglas de Frontera y Propiedad

- **TRIN**: Mantiene la visión total, CRM (Notion, Docuseal, Gotenberg, hitos de pago), orquestación e infraestructura (Dokploy, secretos, RLS, Supabase schema). Llama a NOVA antes de crear cualquier PR `develop` → `main`.
- **PIXEL**: Desarrolla apps (web + mobile Angular/Astro/NestJS, Capacitor 7). Pide componentes a AURA antes de crear UI desde cero. NUNCA toca Dokploy, secretos ni Supabase schema. NUNCA hace push directo a `develop` remoto.
- **LINK**: Automatiza con n8n, webhooks y canales definidos por n8n/email/Telegram según disponibilidad. NUNCA toca Dokploy, secretos ni Supabase schema.
- **EVA**: Organiza el conocimiento (vault, indexación, LOG, HANDOFF). Procesa los dumps de `temp/`, los limpia y los archiva. No genera ni inventa credenciales.
- **NOVA**: QA y Testing (Playwright E2E, Jest, Lighthouse CI). Umbrales: Performance ≥85, Accessibility =100, SEO ≥90. NUNCA modifica código productivo.
- **AURA**: Diseña en Figma (aprobación de Álvaro obligatoria) e implementa componentes visuales Angular (design tokens, layout responsive, data-testid). NUNCA escribe lógica de negocio, servicios ni routing.

## Identidad Visual (histórico — AgentOffice eliminado)

> `AgentOffice/` fue eliminado del workspace el 2026-06-24. Esta sección se conserva solo como referencia histórica del concepto de oficina virtual pixel art.

En la oficina virtual stand-alone (`AgentOffice`), cada agente tenía un sprite y color fijo:

- **TRIN**: char_0 (M) | Palette Lavender
- **PIXEL**: char_4 (M) | Palette Blue
- **LINK**: char_1 (F) | Palette Teal
- **EVA**: char_3 (F) | Palette Green
- **NOVA**: char_5 (F) | Palette Lavender
- **AURA**: char_2 (F) | Palette Pink
