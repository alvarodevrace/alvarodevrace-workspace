# Separación de ambientes dev/prod — Las Chubys

> **Fecha:** 2026-07-12  
> **Ámbito:** `LasChubys-Back` (NestJS) + `LasChubys-Front` (Angular 21 SSR)  
> **Enfoque elegido:** A — dev local + prod deployado (Dokploy + GitHub Actions)

---

## 1. Resumen

Trabajar siempre en **dev local** y desplegar a **prod** solo desde `main`.  
Los secretos y URLs de cada ambiente nunca se mezclan: local usa archivos `.env`, prod usa env vars de Dokploy.

---

## 2. Variables por ambiente

| Variable | Local (`.env`) | Prod (Dokploy env vars) |
|---|---|---|
| `NODE_ENV` | `development` | `production` |
| `PORT` | `3000` (back), `4321` (front) | `3000` / `4321` |
| `SUPABASE_URL` | según entorno de desarrollo elegido | `https://db.alvarodevrace.tech` |
| `SUPABASE_ANON_KEY` | dev/prod | prod (ref Bitwarden) |
| `SUPABASE_SERVICE_ROLE_KEY` | dev/prod | prod (ref Bitwarden) |
| `ALLOWED_ORIGINS` | `http://localhost:4321` | `https://laschubys.com` |
| `SENTRY_DSN` | opcional / vacío | prod (ref Bitwarden) |
| `N8N_WEBHOOK_URL` | dev webhook o prod | `https://n8n.alvarodevrace.tech/webhook/lch-contact-notify` |
| Front `API_URL` | `http://127.0.0.1:3000` | `https://api.laschubys.com` |
| Front `PUBLIC_SUPABASE_URL` | dev/prod | `https://db.alvarodevrace.tech` |
| Front `GTM_CONTAINER_ID` | vacío / dev | prod (ref Bitwarden) |
| Front `underConstruction` | `false` (dev) | `true` (prod, hasta lanzamiento) |

**Regla de oro:**  
- `.env` y `.env.prod` nunca se commitean.  
- Solo `.env.example` y `.env.prod.example` van al repo, con valores dummy.  
- En Dokploy solo env vars, nunca archivos `.env` commiteados.

---

## 3. Backend (NestJS)

### Estado actual
- `src/shared/config/env.ts` ya centraliza lectura de `process.env`.  
- `main.ts` importa `dotenv/config`.  
- `ConfigModule.forRoot({ isGlobal: true })` carga `.env` en local.  
- Scripts `start:dev` y `start` ya existen.

### Cambios necesarios
1. **`.env.example`**: mantener como template de dev. Asegurar valores dummy claros.
2. **`.env.prod.example`**: nuevo archivo con mismas keys y valores de prod de ejemplo.
3. **Scripts npm**:
   - `start:dev` → `nest start --watch` (existente).
   - `start:prod` → `node dist/main` (existente; verificar entrypoint).
   - `build:dev` → `nest build` (configuración por defecto).
   - `build:prod` → `NODE_ENV=production nest build`.
4. **Dockerfile**: no recibir secrets como `ARG`; el runtime lee env vars de Dokploy.

### Comportamiento
- Local: `bun run start:dev` lee `.env`.
- Prod: Dokploy inyecta env vars; NestJS las lee vía `process.env`.

---

## 4. Frontend (Angular 21 SSR)

### Estado actual
- No existe `src/environments/`.
- `angular.json` tiene configuraciones `production` y `development`.
- `server.ts` lee `process.env` para `API_URL`, `SENTRY_DSN`, `PUBLIC_SUPABASE_URL`, etc.
- `.env.example` y `.env.prod.example` ya existen.

### Cambios necesarios
1. **Crear `src/environments/environment.ts`**: valores por defecto / dev para el bundle del browser.
2. **Crear `src/environments/environment.prod.ts`**: valores de prod para el bundle del browser.
3. **Actualizar `angular.json`**: añadir `fileReplacements` en configuración `production` para reemplazar `environment.ts` por `environment.prod.ts`.
4. **Scripts npm**:
   - `start:dev` → `ng serve --port 4321 --no-hmr` (con proxy a backend local).
   - `start:prod` → build prod + servidor local (opcional, para validar antes de deploy).
   - `build:dev` → `ng build --configuration development`.
   - `build:prod` → `ng build --configuration production`.
5. **Server-side (`server.ts`)**: seguir leyendo `process.env` en runtime; eso no cambia.

### Comportamiento
- Local: `bun run start:dev` carga `.env`; el bundle usa `environment.ts`.
- Prod: Dokploy inyecta env vars; el bundle usa `environment.prod.ts`; `server.ts` lee `process.env`.

---

## 5. CI/CD (GitHub Actions + Dokploy)

### Estado actual
- `ci.yml` en back y front corre typecheck, tests y build en PR/push a `main`.
- Deploy a Dokploy solo en `push` a `main`.
- `smoke.yml` corre E2E después de CI exitoso en `main`.

### Cambios necesarios
1. **No pasar secrets al build**: el build de Docker no necesita secretos. El runtime los obtiene de Dokploy.
2. **Verificar `DOKPLOY_APP_ID`**: asegurar que back y front apuntan a las apps prod correctas.
3. **Añadir validación de env vars**: script opcional que falle el build si faltan variables requeridas en `src/shared/config/env.ts`.

### Comportamiento
- PR a `main`: CI corre typecheck, tests, build. Sin deploy.
- Merge a `main`: CI + deploy a Dokploy prod. Dokploy inyecta env vars.

---

## 6. Flujo de trabajo diario

1. **Local**:
   - Copiar `.env.example` → `.env`.
   - Llenar valores de dev.
   - Crear rama `feature/xxx` desde `develop`.
   - Correr `bun run start:dev` en back y front.
2. **CI**:
   - PR a `main` corre typecheck, tests y build.
3. **Deploy**:
   - Merge a `main` dispara build + deploy a Dokploy prod.
   - Dokploy inyecta env vars de producción.

---

## 7. Decisiones

- **Un solo ambiente desplegado (prod)**: reduce costo y complejidad. `develop` se valida local y via CI.
- **Sin build args con secrets**: evita exponer secretos en capas de imagen Docker.
- **Environment files en Angular**: necesarios para valores que el bundle del browser necesita en build time.
- **Config centralizado en backend**: `src/shared/config/env.ts` sigue siendo la fuente única de env vars.

---

## 8. Pendientes de definir en implementación

- ¿Usar schema `laschubys` de Supabase también en dev local, o crear schema `laschubys_dev`?
- ¿Sentry en local está activo o desactivado por defecto?
- ¿GTM se carga solo en prod?
