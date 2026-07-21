# Separación de ambientes dev/prod — Las Chubys

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Separar ambientes dev local y prod deployado para `LasChubys-Back` (NestJS) y `LasChubys-Front` (Angular 21 SSR), sin mezclar secretos ni URLs entre ambientes.

**Architecture:** Local usa archivos `.env` commiteados como templates (`.env.example`, `.env.prod.example`). Prod usa env vars inyectadas por Dokploy en runtime. Angular usa `src/environments/` con `fileReplacements` de `angular.json` para valores de build-time. NestJS mantiene `src/shared/config/env.ts` como única fuente de lectura de env vars.

**Tech Stack:** Angular 21 SSR, NestJS 11, Bun 1.3/1.2, Dokploy, GitHub Actions.

## Global Constraints

- Nunca commitear `.env`, `.env.prod` ni secretos completos.
- Los Dockerfiles no reciben secrets como `ARG`.
- Deploy a Dokploy solo desde `main`.
- Todo en español; scripts y nombres de archivos en inglés.
- Cada task termina con build exitoso y commit.

---

## File Structure

| File | Responsibility |
|---|---|
| `LasChubys-Back/.env.example` | Template de dev para backend. |
| `LasChubys-Back/.env.prod.example` | Template de prod para backend. |
| `LasChubys-Back/package.json` | Scripts `start:dev`, `start:prod`, `build:dev`, `build:prod`. |
| `LasChubys-Back/src/shared/config/env.ts` | Lectura centralizada de env vars (ya existe). |
| `LasChubys-Front/.env.example` | Template de dev para frontend server-side. |
| `LasChubys-Front/.env.prod.example` | Template de prod para frontend server-side. |
| `LasChubys-Front/package.json` | Scripts `start:dev`, `start:prod`, `build:dev`, `build:prod`. |
| `LasChubys-Front/src/environments/environment.ts` | Valores build-time dev. |
| `LasChubys-Front/src/environments/environment.prod.ts` | Valores build-time prod. |
| `LasChubys-Front/src/app/core/config/environment.ts` | Re-exporta build-time + añade `apiServerUrl` runtime server-side. |
| `LasChubys-Front/angular.json` | Configura `fileReplacements` para producción. |
| `vault/laschubys/20-Tech/Angular-BFF.md` | Documenta setup de ambientes. |

---

## Task 1: Backend — templates de env y scripts npm

**Files:**
- Create: `LasChubys-Back/.env.prod.example`
- Modify: `LasChubys-Back/package.json`

**Interfaces:**
- Produces: scripts npm consistentes y template de prod.

- [ ] **Step 1: Crear `.env.prod.example`**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
```

Crear el archivo con este contenido exacto:

```env
# Production environment template.
# Copy this file to .env.prod and fill with real values from Bitwarden.
# .env.prod is gitignored and must never be committed.

NODE_ENV=production
PORT=3000
SUPABASE_URL=https://db.alvarodevrace.tech
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
ALLOWED_ORIGINS=https://laschubys.com
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id
N8N_WEBHOOK_URL=https://n8n.alvarodevrace.tech/webhook/lch-contact-notify
```

- [ ] **Step 2: Actualizar scripts en `package.json`**

Reemplazar la sección `scripts` existente por:

```json
"scripts": {
  "build": "nest build",
  "build:dev": "nest build",
  "build:prod": "NODE_ENV=production nest build",
  "start": "node dist/main",
  "start:dev": "nest start --watch",
  "start:prod": "NODE_ENV=production node dist/main",
  "typecheck": "npx tsc --noEmit",
  "test": "jest",
  "test:watch": "jest --watch",
  "test:cov": "jest --coverage",
  "seed:shop": "bun run scripts/seed-shop-examples.ts",
  "prepare": "[ \"$NODE_ENV\" = \"production\" ] || [ \"$CI\" = \"true\" ] || husky"
}
```

- [ ] **Step 3: Verificar build backend**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
bun install --frozen-lockfile
bun run build:prod
```

Expected: build sin errores, `dist/` generado.

- [ ] **Step 4: Commit**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
git checkout -b feature/backend-env-scripts
git add .env.prod.example package.json
git commit -m "chore(back): add prod env template and dev/prod npm scripts"
git checkout develop
git merge feature/backend-env-scripts
git push origin develop
git branch -D feature/backend-env-scripts
```

---

## Task 2: Frontend — environment files y fileReplacements

**Files:**
- Create: `LasChubys-Front/src/environments/environment.ts`
- Create: `LasChubys-Front/src/environments/environment.prod.ts`
- Modify: `LasChubys-Front/src/app/core/config/environment.ts`
- Modify: `LasChubys-Front/angular.json`

**Interfaces:**
- Consumes: `src/environments/environment.ts` dev values.
- Produces: `fileReplacements` config que inyecta prod en build de producción.

- [ ] **Step 1: Crear `src/environments/environment.ts`**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
```

Crear `src/environments/environment.ts`:

```typescript
export const environment = {
  production: false,
  apiUrl: '/api',
  siteUrl: 'http://localhost:4321',
  underConstruction: false,
};
```

- [ ] **Step 2: Crear `src/environments/environment.prod.ts`**

Crear `src/environments/environment.prod.ts`:

```typescript
export const environment = {
  production: true,
  apiUrl: '/api',
  siteUrl: 'https://laschubys.com',
  underConstruction: true,
};
```

- [ ] **Step 3: Refactorizar `src/app/core/config/environment.ts`**

Reemplazar todo el contenido por:

```typescript
import { environment as buildTimeEnvironment } from '../../../environments/environment';

const isServer = typeof process !== 'undefined' && typeof window === 'undefined';

export const environment = {
  ...buildTimeEnvironment,
  apiServerUrl: isServer
    ? `${process.env['API_URL'] || 'https://api.laschubys.com'}/api`
    : '/api',
};
```

- [ ] **Step 4: Configurar `fileReplacements` en `angular.json`**

Dentro de `projects.laschubys-ng.architect.build.configurations.production`, añadir:

```json
"fileReplacements": [
  {
    "replace": "src/environments/environment.ts",
    "with": "src/environments/environment.prod.ts"
  }
]
```

La sección `production` debe quedar así:

```json
"production": {
  "budgets": [
    {
      "type": "initial",
      "maximumWarning": "800kB",
      "maximumError": "1.2MB"
    },
    {
      "type": "anyComponentStyle",
      "maximumWarning": "38kB",
      "maximumError": "42kB"
    }
  ],
  "outputHashing": "all",
  "fileReplacements": [
    {
      "replace": "src/environments/environment.ts",
      "with": "src/environments/environment.prod.ts"
    }
  ]
}
```

- [ ] **Step 5: Verificar imports no rotos**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
bun run typecheck
```

Expected: sin errores de TypeScript.

- [ ] **Step 6: Commit**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git checkout -b feature/frontend-environments
git add src/environments src/app/core/config/environment.ts angular.json
git commit -m "feat(front): add src/environments and fileReplacements for dev/prod"
git checkout develop
git merge feature/frontend-environments
git push origin develop
git branch -D feature/frontend-environments
```

---

## Task 3: Frontend — scripts npm y templates de env

**Files:**
- Modify: `LasChubys-Front/package.json`
- Modify: `LasChubys-Front/.env.example`
- Modify: `LasChubys-Front/.env.prod.example`

**Interfaces:**
- Consumes: `src/environments/environment.ts` / `environment.prod.ts`.
- Produces: scripts npm claros y env templates actualizados.

- [ ] **Step 1: Actualizar scripts en `package.json`**

Reemplazar la sección `scripts` existente por:

```json
"scripts": {
  "ng": "ng",
  "start": "ng serve --port 4321 --no-hmr",
  "start:dev": "ng serve --port 4321 --no-hmr",
  "start:prod": "bun run build:prod && bun run serve:prod",
  "serve:prod": "NODE_ENV=production bun dist/laschubys-ng/server/server.mjs",
  "build": "NG_BUILD_PARTIAL_SSR=1 CI=1 ng build --configuration production --no-progress",
  "build:dev": "ng build --configuration development",
  "build:prod": "NG_BUILD_PARTIAL_SSR=1 CI=1 ng build --configuration production --no-progress",
  "typecheck": "npx tsc --noEmit",
  "watch": "ng build --watch --configuration development",
  "test": "ng test",
  "test:ci": "ng test --watch=false",
  "e2e": "playwright test",
  "prepare": "husky",
  "lint": "ng lint"
}
```

- [ ] **Step 2: Actualizar `.env.example`**

Contenido exacto:

```env
# Desarrollo local
API_URL=http://127.0.0.1:3000

# Sentry (opcional en dev, obligatorio en producción)
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id

# Supabase pública (usada por server.ts para CSP y SSR)
PUBLIC_SUPABASE_URL=https://your-project.supabase.co

# Google Tag Manager (opcional en dev)
GTM_CONTAINER_ID=
```

- [ ] **Step 3: Actualizar `.env.prod.example`**

Contenido exacto:

```env
# Production environment template.
# Copy this file to .env.prod and fill with real values from Bitwarden.
# .env.prod is gitignored and must never be committed.

API_URL=https://api.laschubys.com
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project-id
PUBLIC_SUPABASE_URL=https://db.alvarodevrace.tech
GTM_CONTAINER_ID=
```

- [ ] **Step 4: Verificar build dev y prod**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
bun install --frozen-lockfile
bun run build:dev
bun run build:prod
```

Expected: ambos builds sin errores, `dist/` generado.

- [ ] **Step 5: Commit**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
git checkout -b feature/frontend-env-scripts
git add package.json .env.example .env.prod.example
git commit -m "chore(front): add dev/prod npm scripts and env templates"
git checkout develop
git merge feature/frontend-env-scripts
git push origin develop
git branch -D feature/frontend-env-scripts
```

---

## Task 4: Verificación cruzada y seguridad

**Files:**
- Verify: `LasChubys-Back/`
- Verify: `LasChubys-Front/`

**Interfaces:**
- Consumes: cambios de Task 1, 2 y 3.

- [ ] **Step 1: Build backend prod**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Back"
bun run build:prod
```

Expected: exit 0.

- [ ] **Step 2: Build frontend prod**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys/LasChubys-Front"
bun run build:prod
```

Expected: exit 0.

- [ ] **Step 3: Buscar secretos expuestos accidentalmente**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/Las Chubys"
rg -n '[a-zA-Z0-9_-]{20,}\.[a-zA-Z0-9_-]{20,}|ntn_[a-zA-Z0-9]{20,}|p9zi[a-zA-Z0-9]{20,}|sk-[a-zA-Z0-9]{20,}|sk_live_[a-zA-Z0-9]{20,}' LasChubys-Back LasChubys-Front \
  --glob '!node_modules' --glob '!dist' --glob '!*.lock'
```

Expected: salida vacía.

- [ ] **Step 4: Verificar .gitignore**

Asegurar que en ambos repos existen:

```gitignore
.env
.env.prod
```

- [ ] **Step 5: Commit de verificación (opcional)**

Si se encontraron y corrigieron problemas, commit. Si no, este task no genera commit nuevo.

---

## Task 5: Documentación en vault

**Files:**
- Modify: `vault/laschubys/20-Tech/Angular-BFF.md`

**Interfaces:**
- Produces: instrucciones de setup de ambientes.

- [ ] **Step 1: Añadir sección "Ambientes" a `vault/laschubys/20-Tech/Angular-BFF.md`**

Añadir al final del archivo:

```markdown
## Ambientes

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
- Las env vars se configuran en Dokploy, no en el repo.
- Los valores build-time del frontend se inyectan vía `src/environments/environment.prod.ts`.
- El backend lee env vars en runtime vía `src/shared/config/env.ts`.

### Convenciones

- `.env` y `.env.prod` nunca se commitean.
- Los Dockerfiles no reciben secrets como `ARG`.
- Local usa URLs locales; prod usa URLs de `vault/INFRA-GLOBAL-2026-06.md`.
```

- [ ] **Step 2: Commit**

```bash
cd "/Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro"
git checkout -b feature/docs-environments
git add vault/laschubys/20-Tech/Angular-BFF.md
git commit -m "docs(laschubys): add environments setup guide"
git checkout develop
git merge feature/docs-environments
git push origin develop
git branch -D feature/docs-environments
```

---

## Self-Review Checklist

- [ ] Spec coverage: cada sección del spec tiene al menos un task.
- [ ] Placeholder scan: no hay TBD, TODO ni referencias vagas.
- [ ] Type consistency: `environment` se exporta desde `src/environments/environment.ts` y `environment.prod.ts` con la misma forma.
- [ ] Security: no se commitean `.env` ni secrets.
- [ ] CI/CD: deploy sigue siendo solo desde `main`; no se pasan secrets al build.
