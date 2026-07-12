# Vault Global — Índice de Proyectos

Fuente de verdad central. Para buscar en todo el vault: `grep -r "Keyword" vault/`

## Proyectos Activos

| Proyecto | Vault | Estado | Stack | Última actividad |
|---|---|---|---|---|
| **laschubys** | [vault/laschubys/](laschubys/00-Index/INDEX.md) | activo | Angular 21 SSR + NestJS BFF | 2026-06 |
| **portfolio** | [vault/portfolio/](portfolio/00-Index/INDEX.md) | activo | Angular 18 | 2026-06 |
| **alvarodevrace** | [vault/alvarodevrace/](alvarodevrace/00-Index/INDEX.md) | activo | Freelance System | 2026-06 |
| **infra** | [vault/infra/](infra/00-Index/INDEX.md) | activo | VPS Hostinger + Dell local | 2026-06 |

## Backlog (código local, sin vault)

_Sin proyectos en backlog._

## Eliminados

| Proyecto | Vault | Notas |
|---|---|---|
| ~~agentoffice~~ | ~~eliminado~~ | React 19 + Vite — proyecto descartado 2026-06-24 |
| ~~cobroslatam~~ | ~~eliminado~~ | Content/SEO — proyecto descartado 2026-06-24 |
| ~~utilboxes~~ | ~~eliminado~~ | Content/SEO — proyecto descartado 2026-06-24 |
| ~~brain~~ | ~~eliminado~~ | Angular PWA — descartado |
| ~~agrovivas~~ | ~~eliminado~~ | Angular 21 + NestJS — proyecto descartado 2026-06-24 |
| ~~jauria~~ | ~~eliminado~~ | Angular + NestJS — código eliminado 2026-06-25 |

## Estructura estándar de cada vault

```
<proyecto>/
├── 00-Index/INDEX.md      ← Catálogo de páginas wiki del proyecto
├── 10-Log/
│   └── LOG.md             ← Registro append-only (formato Karpathy)
├── 20-Tech/               ← Wiki: arquitectura, stack, decisiones técnicas
├── 30-Product/            ← Wiki: features, roadmap, decisiones de producto
├── 40-Credentials/
│   └── INFRA.md           ← Credenciales e IDs del proyecto
└── temp/                  ← Dumps de agentes (EVA procesa y limpia)
```

## Agentes globales

Instrucciones en `../agents/kimi/`. Tabla maestra de proyectos y credenciales en `../agents/KIMI-AGENTS.md`.

## Infraestructura compartida

| Servicio | URL |
|---|---|
| Dokploy | https://dokploy.alvarodevrace.tech |
| n8n | https://n8n.alvarodevrace.tech |
| Planka | https://planka.alvarodevrace.tech |
| Hostinger VPS | VPS principal — corre todo |
| Dell zion-node | Tailscale 100.88.228.17 — build server |

## Documentación Técnica Global

- [**Infraestructura Global (Credenciales)**](INFRA-GLOBAL-2026-06.md)
- [**Supabase Self-Hosted (Guía Técnica)**](20-Tech/Supabase-Self-Hosted.md)
- [**Sistema de Agentes v2 (Guía)**](20-Tech/Agentes-v2.md)
- [**Angular 21 — Estándar de Desarrollo (PIXEL)**](20-Tech/Angular-21-Pixel-Standard.md)

**Credenciales SSH y servicios globales completos → [`vault/INFRA-GLOBAL-2026-06.md`](INFRA-GLOBAL-2026-06.md)**
