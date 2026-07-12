# Supabase — #data #infra

Configuración y estado de Supabase para Las Chubys.

## 🔗 Referencias (self-hosted — migrado 2026-06-25 a Dokploy)
- URL: Ver `vault/INFRA-GLOBAL-2026-06.md`
- Schema: `laschubys`
- Dokploy compose ID: Ver `vault/INFRA-GLOBAL-2026-06.md`
- Dokploy project: Ver `vault/INFRA-GLOBAL-2026-06.md`

## 🛠️ Esquema (Tablas — schema laschubys)
- `profiles`: Datos de usuario, roles.
- `blog_posts`: Contenido editorial.
- `comments`: Comentarios de comunidad.
- `products`: Catálogo (Owned + Affiliate).
- `orders`: Registro de ventas Ecuador.
- `leads`: Captación de email.
- `social_metrics`: Métricas sociales (Meta + TikTok) para Media Kit y admin dashboard.

## 📁 Storage
- `cat-photos` (public)
- `blog-covers` (public)
- `product-images` (public)

## social_metrics

Tabla para almacenar métricas sociales oficiales (Instagram, Facebook, TikTok) vía workflows n8n.

| Columna | Tipo | Uso |
|---|---|---|
| `id` | uuid | PK |
| `platform` | text | instagram \| facebook \| tiktok \| engagement/global |
| `account_id` | text | handle o id de cuenta |
| `metric_type` | text | followers, reach, impressions, engagement, likes, etc. |
| `value_numeric` | numeric | valor numérico |
| `value_text` | text | valor formateado (ej. "17K") |
| `period` | text | lifetime, daily, 7d, 30d |
| `recorded_at` | timestamptz | fecha de la medición |
| `external_id` | text | id del post/video en la red social |
| `metadata` | jsonb | datos extra (engagement %, href, etc.) |
| `created_at` | timestamptz | fecha de inserción |

### RLS

- `INSERT/UPDATE/DELETE`: `service_role`.
- `SELECT`: público (`true`).

### Índices

- `(platform, metric_type, recorded_at DESC)`
- `(platform, account_id, recorded_at DESC)`

### Seed / Datos actuales

Valores manuales iniciales (2026-06-20) para que el Media Kit funcione mientras se aprueban apps oficiales:
- Instagram 17K, TikTok 14.4K, Facebook 2.6K (seed manual).
- Engagement rate 4-7% (manual).

**Datos sincronizados automáticamente vía `WF-LCH-META-SYNC` (2026-06-20):**
- Instagram: 18,965 followers (`account_id: 17841438018214431`).
- Facebook: 2,704 followers (`account_id: 1131865923345617`).

**Pendiente:** TikTok requiere app de desarrollador/credenciales. Workflow `WF-LCH-TIKTOK-SYNC` no creado.

---

## 🛡️ RLS Matrix (schema `laschubys`)

Auditoría realizada el 2026-07-12. Todas las tablas tienen RLS habilitado.

| Tabla | SELECT | INSERT | UPDATE | DELETE | Notas |
|---|---|---|---|---|---|
| `profiles` | propio / admin | propio (`uid() = id`) | propio (`uid() = id`) | admin | `lch_profiles_admin` (ALL) permite admin |
| `blog_posts` | público / admin | admin | admin | admin | solo posts `published_at IS NOT NULL` para público |
| `categories` | público | denegado | denegado | denegado | Escrituras vía `service_role` (bypassrls) |
| `comments` | público (no reportados) / admin | propio (`uid() = user_id`) | propio | admin | |
| `contacts` | admin | `service_role` | — | admin | Insert vía BFF con service_role |
| `products` | público (`active=true`) / admin | admin | admin | admin | |
| `orders` | admin | `service_role` | admin | — | Insert vía BFF con service_role. Sin política DELETE (intencional). |
| `social_metrics` | público | `service_role` | `service_role` | `service_role` | Gestión vía workflows n8n |

> Las operaciones marcadas como `service_role` se ejecutan desde el BFF con la clave de servicio, que tiene `bypassrls`, por lo que las políticas `false` para `anon`/`authenticated` no afectan al flujo de administración.

## 🔑 Credenciales
- URL: Ver `vault/INFRA-GLOBAL-2026-06.md`
- Anon Key: ver `vault/INFRA-GLOBAL-2026-06.md`
- Service Role Key: ver `vault/INFRA-GLOBAL-2026-06.md`
- Cliente JS: `createClient(url, anonKey, { db: { schema: 'laschubys' } })`

## 🚀 Decisiones [[Auth]]
- Usar Supabase SSR + PKCE + exchangeCodeForSession.
- Cookies seguras con `httponly`.
- **Admin Role (2026-04-29):** Se usa la columna `role` en la tabla `profiles`. Se descartó añadir `admin_level` para mantener el esquema simple y alineado al contrato actual.
- **Migración self-hosted (2026-05-09):** Cloud `saucjvadxcjplxjigqda` eliminado. Todo en self-hosted bajo schema `laschubys`.
- **Refactor BFF (2026-05-20):** Angular deja de depender de `supabase-js` para auth y contenido; sesión y comentarios pasan por `laschubys-api` con cookies `httpOnly`.

## 🛠️ Implementación Detallada (LCH-4)
- **Tables:** `profiles`, `blog_posts`, `comments`, `products`, `orders`, `order_items`.
- **Triggers:** `handle_new_user` automatiza la creación de perfiles.
- **RLS:** Función `is_admin()` implementada para protección de tablas críticas.
- **Buckets:** `blog-images` y `product-images` configurados con políticas RLS.

## n8n — Accept-Profile header
Todas las llamadas HTTP de n8n a PostgREST deben incluir:
```
Accept-Profile: laschubys
```
