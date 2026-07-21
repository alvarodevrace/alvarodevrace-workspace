# Portfolio — Credenciales e Infraestructura

## Servicios

| Servicio | URL / ID |
|---|---|
| App | https://alvarodevrace.tech |
| GitHub repo | `alvarodevrace/alvaro-portfolio` |
| SSH remote | `git@github-alvarodevrace:alvarodevrace/alvaro-portfolio.git` |
| Dokploy project ID | `oSVdXwFYGekg16v18XNW1` |
| Dokploy environment ID | `6aSWtCz4LWWvtHfYJXXMG` |
| Dokploy application ID | `r9HA2pNx6Uiip1sYJ8ubg` |
| Cloudflare zone | `alvarodevrace.tech` |
| Formspree | endpoint del formulario de contacto (configurar en env vars) |
| Sentry | https://sentry.io (configurar DSN en env vars) |

## Planka

| Campo | Valor |
|---|---|
| Board ID | `1739527870750917748` |
| Lista Backlog | `1739527873686930552` |
| Lista Todo | `1739527877008819321` |
| Lista In Progress | `1739527880548811898` |
| Lista Done | `1739527883946198139` |
| Label TRIN | `1739531351712859282` |
| Label PIXEL | `1739531355621950611` |
| Label LINK | `1739531558399771800` |
| Label EVA | `1739531362659992724` |
| Label Álvaro | `1739531365579228309` |

## Dokploy — Deploy manual

```bash
curl -X POST -H "Content-Type: application/json" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -d '{"applicationId":"r9HA2pNx6Uiip1sYJ8ubg"}' \
  "http://100.105.133.25:3000/api/application.deploy"
```

## Stack PIXEL

- `alvaro-portfolio/` — Angular 18 standalone (→ Angular 21 pendiente)
- GSAP + IntersectionObserver, SCSS puro, sin frameworks CSS
- Build: `CI=1 ng build --configuration production --no-progress`
- Deploy: Dokploy → nginx:alpine → Hostinger VPS
- DNS: Cloudflare A record `alvarodevrace.tech` → IP Hostinger VPS

## Diseño

- Paleta: `$bg: #111111`, `$accent: #4F8EF7`, `$accent-2: #7C3AED`, `$accent-3: #06D6A0`
- Fonts: Roboto Mono + Inter + Space Grotesk
- Referencia visual: https://tamalsen.dev/
