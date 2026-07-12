# Angular + NestJS BFF — Las Chubys (stack activo)

Migración desde Astro SSR a Angular 21 SSR + NestJS BFF. Decisión tomada 2026-05-20.
**Deploy completo en producción: 2026-05-21.** running:healthy ✅

## Stack

| Capa | Tecnología | Repo GitHub | Puerto |
|---|---|---|---|
| Frontend | Angular 21 SSR (`@angular/ssr`) | `alvarodevrace/laschubys-app` | 4000 |
| Backend BFF | NestJS (`laschubys-api`) | `alvarodevrace/laschubys-api` | 3000 |

> Monorepo `alvarodevrace/laschubys` eliminado 2026-05-21. Repos independientes por app.

## Dokploy — Deploy (estado 2026-06-25)

| App | ID | Estado | Dominio |
|---|---|---|---|
| laschubys-app (Angular SSR) | Ver `vault/INFRA-GLOBAL-2026-06.md` | running:healthy ✅ | `laschubys.com` |
| laschubys-api (NestJS BFF) | Ver `vault/INFRA-GLOBAL-2026-06.md` | running:healthy ✅ | `api.laschubys.com` / interno |
| Proyecto Dokploy Las Chubys | Ver `vault/INFRA-GLOBAL-2026-06.md` | — | — |

> `laschubys-web` (Astro legacy) eliminado. Cut-over a Angular SSR completado.

**GitHub Actions — deploy automático:**
- Push a `main` en cada repo → GitHub Action → curl Dokploy API → deploy
- Secrets en cada repo: `DOKPLOY_API_KEY`, `DOKPLOY_APP_ID`, `DOKPLOY_URL`
- `.github/workflows/deploy.yml` presente en `laschubys-app` y `laschubys-api`

**Lecciones aprendidas (fixes 2026-06-09/10):**
- **Backend build fail**: El build de Docker inyecta `NODE_ENV=production` como build-time var. `npm ci` instala solo `dependencies`, omitiendo `@nestjs/cli` y `typescript` (devDeps). Fix: `ENV NODE_ENV=development` en etapa `deps` del Dockerfile.
- **Frontend ID incorrecto**: El ID `i084o8goossksg88k4gswco8` usado en monitoreo era de app eliminada. ID real: Ver `vault/INFRA-GLOBAL-2026-06.md`.
- **robots.txt cacheado como HTML**: Cloudflare cacheó HTML (fallback Angular SSR) durante deploys previos. Fix: servir `/robots.txt` inline en `server.ts` con `Content-Type: text/plain`. Los tokens de Cloudflare para purge están expirados — requiere renovación.
- **Bun lockfile**: Bun 1.2+ usa `bun.lock` (texto), no `bun.lockb` (binario). Dockerfiles deben usar `COPY package.json bun.lock ./`. Patrón `bun.lockb*` no matchea nada → builds sin lockfile.
- **Package manager consistente**: CI usaba `npm ci` mientras Dockerfile usaba `bun install`. Migrado todo a Bun (`oven-sh/setup-bun@v2` + `bun install --frozen-lockfile`).
- **Proxy HTTPS**: gestionado automáticamente por Dokploy (Traefik) — sin workarrows manuales.

## NestJS BFF — Endpoints

| Método | Ruta | Descripción |
|---|---|---|
| `GET` | `/api/auth/google` | Inicia OAuth Google desde backend |
| `GET` | `/api/auth/me` | Devuelve sesión actual basada en cookie |
| `GET` | `/api/auth/logout` | Cierra sesión, limpia cookie |
| `GET` | `/api/content/posts` | Lista posts de blog |
| `GET` | `/api/content/posts/:slug` | Devuelve detalle de post |
| `GET` | `/api/content/products` | Lista catálogo de tienda |
| `POST` | `/api/comments` | Crea comentario (Supabase service role) |

- Supabase service role key en env var (schema `laschubys`).
- Throttling habilitado (NestJS Throttler).
- Dockerfile propio en `apps/laschubys-api/`.

## Proxy Angular → BFF

`server.ts` Angular proxía `/api/*` → `http://laschubys-api:3000` via env var `API_URL`.

## Auth

- Cookie SSR: `lch_access_token`.
- Supabase Auth Google OAuth orquestado desde backend.
- Angular ya no usa Supabase directo para login, logout ni sesión.
- Admin: `profiles.role = 'admin'` en schema `laschubys`.

## Contenido

- `laschubys-ng` consume `posts`, `post detail`, `products` y `comments` vía API.
- `ContentModule` en `laschubys-api` centraliza lectura del schema real.
- Queda descartada la dependencia de columnas no existentes como `products.audience`.

## Cut-over ✅ Completado (2026-05-21)

- Dominio principal `laschubys.com` apunta a Angular SSR.
- `laschubys-web` (Astro legacy) eliminado.
- `api.laschubys.com` apunta al BFF NestJS.

## Estado de pendientes históricos (dump TRIN 2026-05-21)

- [x] Validar que `laschubys.com` carga correctamente en browser — ✅ funcional
- [x] Cleanup Jauria: eliminar jauria-admin/api/landing de infra + backup schema `jauria` — ✅ completado 2026-06-05
- [x] ~~cobroslatam-web: hacer deploy~~ — Proyecto CobrosLatam eliminado 2026-06-24
- [x] Evaluar supabase-analytics: container no existe — ✅ excluido permanente del health check

## Notas para PIXEL (repos separados)

- `alvarodevrace/laschubys-app` → frontend Angular
- `alvarodevrace/laschubys-api` → backend NestJS
- Feature branches: `pixel/lch-XXX` en cada repo por separado
- `styles.css` ya no importa nada del Astro — todos los estilos globales directamente en `styles.css`
- Push a `develop` → no deploya. Push a `main` → auto-deploy Dokploy

## Ambientes

Separación **dev local / prod deployado**. No hay staging.

### Local (dev)

**Backend:**

```bash
cd LasChubys-Back
cp .env.example .env
# editar .env con valores de dev
bun install --frozen-lockfile
bun run start:dev
```

**Frontend:**

```bash
cd LasChubys-Front
cp .env.example .env
# editar .env con valores de dev
bun install --frozen-lockfile
bun run start:dev
```

### Producción (prod)

- Deploy automático desde `main` vía GitHub Actions.
- Env vars se configuran en Dokploy, no en el repo.
- Frontend: valores build-time inyectados vía `src/environments/environment.prod.ts`.
- Backend: env vars leídas en runtime vía `src/shared/config/env.ts`.
- Hasta el lanzamiento oficial, `underConstruction: true` en prod muestra pantalla "En construcción" en todo excepto `/linktree`.

### Convenciones

- `.env` y `.env.prod` nunca se commitean.
- Dockerfiles no reciben secrets como `ARG`.
- Local usa URLs locales; prod usa URLs de `vault/INFRA-GLOBAL-2026-06.md`.

## Referencia detallada

- Ver [[Content-Auth-BFF]] para el refactor operativo de contenido y auth.
