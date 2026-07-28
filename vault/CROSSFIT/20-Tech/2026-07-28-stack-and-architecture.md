# CROSSFIT — Stack y Arquitectura

**Fecha:** 2026-07-28  
**Estado:** Aprobado para el MVP  

## Decisión

Usar **Supabase Cloud** como backend para no tocar infra propia del VPS en la fase de validación.

## Stack

### App móvil
- React Native con Expo SDK.
- Expo Router.
- NativeWind v4.
- TypeScript estricto.
- React Query.
- Zustand.
- React Hook Form + Zod.

### Backend
- Supabase Cloud (Auth, Postgres, Storage, Edge Functions).
- RLS por `organization_id` en todas las tablas.
- Expo Push para notificaciones.

### Distribución
- Expo EAS Build.
- TestFlight / Google Play Internal.

## Arquitectura de datos

Ver modelo completo en `CROSSFIT/2026-07-28-crossfit-platform-scope.md`.

Tablas principales:
- `users`
- `organizations`
- `organization_memberships`
- `wods`
- `classes`
- `reservations`
- `scores`
- `user_push_tokens`

## Seguridad

- RLS en todas las tablas.
- Roles: admin, owner, coach, athlete.
- Un usuario puede tener roles distintos en Boxes distintos.
- Sin datos médicos ni documentos en MVP.

## Notas

- No se usa Dokploy ni VPS para el MVP.
- El schema incluye campos de billing para conectar pagos en el futuro sin migraciones grandes.
