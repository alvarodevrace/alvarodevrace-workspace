# 2026-07-13 — Fixes del entorno de desarrollo local

## Contexto

El entorno local de Las Chubys no mostraba productos en `http://localhost:4321/tienda`. Álvaro pidió estabilizar el ambiente dev antes de continuar con la auditoría Gentleman.

## Problemas encontrados

1. **Back local sin credenciales reales**: `LasChubys-Back/.env` contenía placeholders (`your-project.supabase.co`). El back arrancaba, pero las queries a Supabase fallaban con `ENOTFOUND` y el controller devolvía `[]` silenciosamente.
2. **SSR front pegaba a producción**: `src/app/core/config/environment.ts` usa `process.env['API_URL'] || 'https://api.laschubys.com'` en servidor. `ng serve` no cargaba `.env`, así que SSR usaba la API de prod.
3. **Throttling local**: `ThrottlerGuard` global estaba activo en dev. El SSR local emitía muchas peticiones concurrentes desde `127.0.0.1` y disparaba `ThrottlerException: Too Many Requests`.

## Decisiones

1. **Credenciales de develop desde Bitwarden**: usar los items `global/supabase-anon-key` y `global/supabase-service-role-key` para apuntar el back local a `https://db.alvarodevrace.tech` (Supabase self-hosted de develop).
2. **Cargar `.env` en SSR**: instalar `dotenv` en `LasChubys-Front` e importar `dotenv/config` en los entry points SSR (`server.ts` y `src/main.server.ts`). Esto hace que `process.env['API_URL']` esté disponible durante `ng serve`.
3. **Throttle solo en producción**: registrar `APP_GUARD` de `ThrottlerGuard` condicionalmente cuando `NODE_ENV === 'production'`. En dev se desactiva el guard global.

## Archivos modificados

- `LasChubys-Back/.env` — credenciales de develop (no versionado; ignorado por git).
- `LasChubys-Back/src/app.module.ts` — `APP_GUARD` de throttle condicional.
- `LasChubys-Front/package.json` — dependencia `dotenv`.
- `LasChubys-Front/bun.lock` — lockfile actualizado.
- `LasChubys-Front/server.ts` — `import 'dotenv/config'`.
- `LasChubys-Front/src/main.server.ts` — `import 'dotenv/config'`.

## Estado

- ✅ Tienda local renderiza 9 productos.
- ✅ SSR pega a `http://127.0.0.1:3000/api` en lugar de prod.
- ✅ Typecheck limpio en front y back.
- ⏳ Cambios locales pendientes de commit en `develop`.

## Próximos pasos

- Commitear cambios en `develop`.
- Crear PRs `develop → main` cuando se aprueben.
- Evaluar si agregar un `HealthController` o logging de errores de Supabase para evitar silenciamiento de `[]`.
