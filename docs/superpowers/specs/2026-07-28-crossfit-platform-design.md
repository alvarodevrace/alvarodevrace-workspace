# CrossFit Platform — Design Spec

**Fecha:** 2026-07-28  
**Estado:** Aprobado para plan de implementación  
**Autor:** TRIN + AlvaroDevRace  

## 1. Propósito

Plataforma móvil multi-Box para la gestión de Boxes de CrossFit. El objetivo inmediato es reemplazar a CrossHero en Ecuador con una experiencia minimalista, rápida y centrada en comunidad. Se validará primero con el Box del usuario (~40 atletas) antes de escalar a otros Boxes.

## 2. Principios de diseño

- **Minimalismo extremo:** menos pantallas, menos clicks, menos configuración.
- **Costo cero inicial:** todo en free tier hasta tener tracción.
- **No tocar infra propia del VPS:** el backend vive en Supabase Cloud para no afectar Las Chubys ni saturar el VPS.
- **MVP enfocado:** solo lo necesario para que un Box funcione perfectamente.
- **Post-MVP medido:** chat, IA, pagos, web y otras funciones se agregan después de la validación.
- **Seguridad desde el inicio:** RLS por `organization_id`, roles claros, sin datos médicos ni documentos en MVP.

## 3. Stack

### App móvil
- React Native con Expo SDK (último estable).
- Expo Router para navegación tipo file-system.
- NativeWind v4 para estilos con Tailwind CSS.
- TypeScript estricto.
- React Query para cacheo, sincronización y offline básico.
- Zustand para estado global ligero (auth, UI).
- React Hook Form + Zod para formularios.

### Backend
- Supabase Cloud (free tier inicial).
- Supabase Auth: email/password, Google Sign-In, Apple Sign-In.
- Postgres: datos de Box, usuarios, WODs, clases, reservas, scores.
- Supabase Storage: fotos de perfil.
- Supabase Edge Functions: envío de notificaciones push vía Expo Push.
- RLS en todas las tablas por `organization_id`.

### Push
- Expo Push Notifications.
- Tokens guardados en `user_push_tokens`.

### Distribución
- Expo EAS Build.
- TestFlight (iOS) y Google Play Internal (Android) para pruebas.
- App Store y Google Play para lanzamiento público.

### Diseño
- OpenPencil para wireframes y flujo antes de tocar código.
- NativeWind v4 con paleta reducida (2-3 colores), tipografía clara y mucho aire.

### Gestión de secretos y tareas
- Bitwarden para contraseñas, API keys y tokens.
- Planka para tareas técnicas y seguimiento del MVP.

## 4. Arquitectura general

```
┌─────────────────────────────────────────┐
│           App móvil (Expo)              │
│  React Native + Expo Router + NativeWind │
│  React Query + Zustand + Zod            │
└─────────────────┬───────────────────────┘
                  │ HTTPS / Supabase SDK
                  ▼
┌─────────────────────────────────────────┐
│           Supabase Cloud                │
│  Auth │ Postgres │ Storage │ Edge Funcs │
│  RLS por organization_id                │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│        Expo Push Notifications          │
└─────────────────────────────────────────┘
```

## 5. Modelo de datos MVP

### `users`
Perfil público de cada usuario. La autenticación real la maneja Supabase Auth.

| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK, igual al auth.user_id |
| email | text | |
| phone | text | |
| full_name | text | |
| avatar_url | text | URL de Supabase Storage |
| birth_date | date | |
| gender | text | |
| weight_kg | numeric | |
| height_cm | numeric | |
| emergency_contact | text | |
| is_admin | boolean | Superusuario de AlvaroDevRace |
| created_at | timestamptz | |

### `organizations` (el Box)
| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| name | text | |
| slug | text | único |
| logo_url | text | |
| timezone | text | ej. America/Guayaquil |
| owner_id | uuid | FK a users |
| tier | text | `free` por ahora |
| max_free_athletes | int | 10 en free tier |
| price_per_extra_athlete | numeric | 1 USD por ahora |
| billing_status | text | `trial`, `active`, `suspended` |
| billing_provider_customer_id | text | Vacío hasta conectar pagos |
| created_at | timestamptz | |

### `organization_memberships`
Un usuario puede tener roles distintos en Boxes distintos.

| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| user_id | uuid | FK a users |
| organization_id | uuid | FK a organizations |
| role | text | `owner`, `coach`, `athlete` |
| status | text | `invited`, `active`, `inactive` |
| joined_at | timestamptz | |

**Regla de conteo de atletas:** se cuenta cuando `role = 'athlete'` y `status = 'active'`.

### `wods`
| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| organization_id | uuid | FK |
| date | date | Día del WOD |
| title | text | |
| type | text | `for_time`, `amrap`, `emom`, ... |
| description | text | |
| exercises | jsonb | Lista de ejercicios |
| scaled_options | jsonb | Opciones scaled |
| created_by | uuid | FK a users |
| published_at | timestamptz | Cuándo se publicó y notificó |
| created_at | timestamptz | |

### `classes`
| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| organization_id | uuid | FK |
| wod_id | uuid | FK |
| scheduled_at | timestamptz | Hora de inicio |
| duration_minutes | int | |
| max_capacity | int | |
| coach_id | uuid | FK a users |
| created_at | timestamptz | |

### `reservations`
| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| class_id | uuid | FK |
| user_id | uuid | FK |
| status | text | `confirmed`, `cancelled`, `attended` |
| created_at | timestamptz | |
| cancelled_at | timestamptz | |

### `scores`
| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| wod_id | uuid | FK |
| user_id | uuid | FK |
| organization_id | uuid | FK |
| result_type | text | `time`, `reps`, `weight` |
| value | numeric | |
| unit | text | `seconds`, `reps`, `kg`, `lbs` |
| rx | boolean | |
| notes | text | |
| created_at | timestamptz | |

### `user_push_tokens`
| Campo | Tipo | Notas |
|-------|------|-------|
| id | uuid | PK |
| user_id | uuid | FK |
| token | text | |
| platform | text | `ios`, `android` |
| created_at | timestamptz | |

## 6. Roles y permisos

| Rol | Descripción | Permisos MVP |
|-----|-------------|--------------|
| admin | Superusuario de AlvaroDevRace | Ver/controlar todo |
| owner | Dueño del Box, paga la app | Todo en su Box, crear coaches y atletas |
| coach | Entrenador | CRUD WODs, clases, scores de atletas, asistencia |
| athlete | Atleta del Box | Ver WODs/clases, reservar, registrar sus scores, ver leaderboard |

**Notas:**
- Un usuario puede ser owner/coach en un Box y athlete en otro.
- Coach no puede eliminar owner ni ver/ajustar billing.
- Owner puede ser coach al mismo tiempo.

## 7. Flujo de pantallas MVP

### Auth
- Login / Registro / Recuperar contraseña.
- Onboarding: elegir si eres coach/owner o atleta, unirse a Box con código de invitación.

### Atleta
- **Home:** WOD del día + clases disponibles.
- **WOD detail:** descripción, ejercicios, scaled options.
- **Reservar:** elegir clase, confirmar, ver cupo.
- **Mis reservas:** próximas + historial.
- **Registrar score:** tiempo/reps/peso + notas.
- **Leaderboard:** ranking del Box por WOD.
- **Perfil:** datos, membresías, notificaciones.

### Coach / Owner
- **Dashboard:** resumen de hoy (clases, asistencias, atletas activos).
- **Crear WOD:** formulario simple, publicar.
- **Crear clases:** elegir WOD, hora, cupo, coach.
- **Lista de asistencia:** por clase, marcar quién vino.
- **Gestión de atletas:** invitar, activar, inactivar.
- **Scores del box:** ver/editar resultados.

### Navegación
- Atleta: Home, Reservas, Scores, Perfil.
- Coach/Owner: Dashboard, WODs, Clases, Box, Perfil.

## 8. Seguridad

- Todas las tablas tienen `organization_id`.
- RLS: usuario solo ve filas donde tiene membresía activa en esa organización.
- Admins globales ven todo.
- Fotos de perfil en Storage con RLS por `user_id`.
- Sin documentos ni historial médico en MVP.
- Confirmación de email opcional en MVP para reducir fricción en pruebas.

## 9. Modelo de negocio futuro

- **Free tier:** crear Box + hasta 10 atletas activos gratis.
- **Pay-per-athlete:** después de 10 atletas, cobrar aproximadamente $1 por atleta extra.
- **El dueño/coach es quien paga.** Los atletas usan la app gratis.
- **Features pagas futuras:** IA generadora de WODs, analytics avanzados, etc.
- **En el MVP no se implementa pasarela de pagos**, pero el schema ya incluye campos de billing para conectar después.

## 10. Roadmap

### MVP (validación con el Box del usuario)
1. Auth con email/password, Google y Apple.
2. Crear/unirse a Box por invitación.
3. Roles: admin, owner, coach, athlete.
4. Crear y publicar WODs del día.
5. Crear clases con cupo máximo.
6. Atletas reservan y cancelan clases.
7. Coach ve lista de asistencia.
8. Atletas registran scores.
9. Leaderboard básico por WOD.
10. Perfiles de atletas.
11. Notificaciones push básicas (WOD publicado, recordatorio de clase).
12. Diseño minimalista con OpenPencil.

### Post-MVP
- Chat del Box y feed de noticias.
- IA generadora de WODs (feature paga).
- Benchmarks históricos (FRAN, Grace, 1RM, etc.).
- Pagos y billing real (Stripe/LemonSqueezy).
- Web para administración.
- Integración con wearables.
- Multi-idioma.
- Analytics para coaches.

### Fuera de MVP
- Pagos reales, n8n, web, chat, IA.

## 11. Infra y deployment

### Repositorio
- Nuevo repo en GitHub: `crossfit-platform-mobile` (nombre tentativo).
- Rama `main` protegida, PRs con revisión.
- Estructura inicial: `apps/mobile/`, `supabase/`, `docs/`.

### Secretos
- Bitwarden para API keys, Supabase anon/service role, Apple/Google OAuth, Expo tokens.
- `.env` local nunca commiteado.

### Tareas
- Planka para seguimiento del MVP.

### CI/CD
- GitHub Actions para lint, type-check y tests unitarios.
- EAS Build en cada push a `main` o `develop`.
- EAS Submit para TestFlight / Google Play Internal.

### Ambientes
- `development`: Expo Go / local.
- `staging`: EAS Build interno, Supabase project de staging.
- `production`: EAS Build, Supabase project de producción, stores.

### Backups
- Supabase Cloud maneja backups automáticos.
- Para free tier, export periódico con `supabase db dump`.

### Observabilidad
- Sentry para errores en la app (free tier).
- Supabase logs para backend.

## 12. Notas sobre Dokploy y dominios

- **La app móvil no se despliega en Dokploy.** Se compila con EAS Build y se sube a las stores.
- Dokploy se usará en el futuro solo si se agrega una landing web o dashboard admin.
- Para la app móvil en MVP no se necesita dominio propio ni Cloudflare.
- Deep links y universal links requieren dominio; se dejan para post-MVP si aplica.

## 13. Riesgos y mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| Supabase Cloud free tier se queda corto | Empezar gratis, migrar a plan pago solo con tracción |
| Apple/Google rechazan la app | Cumplir guidelines, no usar pagos reales en MVP |
| Atletas no adoptan la app | Onboarding simple, notificaciones push, UX minimalista |
| Crecimiento rápido sin billing listo | Schema preparado para conectar pagos rápidamente |
| Datos sensibles | No guardar documentos ni médicos en MVP |

## 14. Decisiones pendientes para el plan de implementación

- Nombre final del producto y del repo.
- Paleta de colores y tipografía (definir en OpenPencil).
- Flujo exacto de invitación a atletas (código corto vs link).
- Si las notificaciones push se envían inmediatamente al publicar WOD o en horario programado.
- Política de cancelación de reservas (hasta cuánto antes).
