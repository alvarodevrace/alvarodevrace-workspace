# Supabase Self-Hosted — #infra #database

Guía técnica centralizada del despliegue self-hosted en Dokploy.

## 🔗 Referencias Globales
- **URL Pública:** https://db.alvarodevrace.tech
- **Dokploy service:** `Supabase Self-Hosted` (ID en `vault/alvarodevrace/40-Credentials/INFRA.md`)
- **Instancia:** 14 containers (Kong, GoTrue, PostgREST, Realtime, Storage, Postgres, etc.)

## 🛠️ Arquitectura Multi-Tenant (Schemas)
En lugar de múltiples instancias, usamos una sola base de datos Postgres con esquemas separados para cada proyecto:

| Proyecto | Schema | Notas |
|---|---|---|
| Jauría CrossFit | `jauria` | Migrado 2026-05-09. RLS Activo. |
| Las Chubys | `laschubys` | Migrado 2026-05-09. RLS Activo. |
| ~~Brain~~ | ~~`brain`~~ | ~~Esquema eliminado.~~ |

## 🔑 Configuración de Clientes
Para conectar a un esquema específico, es obligatorio pasar el header `Accept-Profile` (PostgREST) o configurar el cliente de Supabase:

### JavaScript / TypeScript
```typescript
const supabase = createClient(URL, ANON_KEY, {
  db: { schema: 'jauria' }
});
```

### n8n (HTTP Request)
- **Headers:** `Accept-Profile: jauria`
- **typeVersion:** Mantener en `4.2` (la `4.4` puede ser inestable en self-hosted).

## 🚀 Mantenimiento y Backups
- **Backups SQL:** Se ejecutan vía n8n (`WF-BACKUP`) exportando el schema específico a GitHub.
- **Storage:** Almacenado localmente en el VPS dentro del volumen de datos de Dokploy (`/opt/dokploy-data/`).
- **Logs:** Visibles en el panel de Dokploy o vía Docker logs en el VPS.

## 🔐 Seguridad y Hardening

### Search Path Hijacking (Mutable Path)
Las funciones deben tener un `search_path` fijo para evitar que usuarios malintencionados suplanten operadores o funciones en otros esquemas.

**Fix para funciones reportadas:**
```sql
ALTER FUNCTION jauria.update_updated_at_column() SET search_path = '';
ALTER FUNCTION jauria.get_user_rol() SET search_path = '';
ALTER FUNCTION laschubys.update_updated_at_column() SET search_path = '';
ALTER FUNCTION laschubys.is_admin() SET search_path = '';
```

**Estándar para nuevas funciones:**
Siempre definir `SET search_path = ''` (o esquemas específicos) en la creación de la función.
