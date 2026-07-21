# NEW-PROJECT-GUIDE.md — TRIN: Protocolo de Creación de Proyecto Nuevo

> **CUÁNDO LEER ESTE ARCHIVO:** Álvaro anuncia un proyecto nuevo. Cualquier frase como "nuevo proyecto", "vamos a hacer X", "necesito un sistema para Y" activa este protocolo.
> **IMPORTANTE:** No ejecutes nada hasta completar FASE 1 y recibir aprobación de Álvaro.

---

## FASE 1 — DISCOVERY (preguntar antes de ejecutar)

Ejecuta este checklist como conversación. Pregunta en bloques de 3-4 preguntas, no todo de golpe.

### Bloque A — Identidad del proyecto

```
□ Nombre del proyecto (display): e.g. "Cobros Express"
□ Slug interno (sin espacios, lowercase): e.g. "cobrosexp"
□ ¿Descripción en 1 línea? (para repo + Planka)
□ ¿Tipo de proyecto?
    [1] App web completa (frontend + backend)
    [2] App web solo frontend
    [3] Automatización pura (solo n8n, sin app)
    [4] Content/SEO (sin deploy, sin DB)
    [5] PWA / app mobile-first
```

### Bloque B — Stack técnico

```
□ ¿Frontend? Angular 21 / Astro SSR / React / Otro / Ninguno
□ ¿Backend/BFF? NestJS / Edge Functions Supabase / Otro / Ninguno
□ ¿Base de datos? Supabase / Otro / Ninguna
□ ¿Autenticación? Supabase Auth / Google OAuth / Magic Link / Sin auth / Otro
□ ¿Usuarios? Solo admin / Usuarios públicos con login / Solo APIs / Mixto
```

### Bloque C — Infraestructura e integraciones

```
□ ¿Necesita dominio propio? Sí → ¿cuál? / No → usar subdominio alvarodevrace.tech
□ ¿URL pública? e.g. "cobrosexp.com" o "cobros.alvarodevrace.tech"
□ ¿Deploy en Dokploy? Sí / No (content-only)
□ ¿Automatización n8n? Sí → ¿qué flows? / No
□ ¿WhatsApp? No disponible — Evolution API eliminado 2026-06-06
□ ¿Email transaccional (MailerSend)? Sí / No
□ ¿Pagos? PayPhone / Stripe / Otro / No
□ ¿Telegram notifications? Sí / No
□ ¿Printful (ecommerce físico)? Sí / No
□ ¿Monitoring / Sentry? Sí / No
```

### Bloque D — Producto

```
□ ¿MVP en 2-3 frases? ¿Qué hace exactamente el sistema?
□ ¿Usuarios finales? (dueño del negocio, clientes, admin, público general)
□ ¿Agentes activos en este proyecto? TRIN + PIXEL / TRIN + LINK / Todos / Solo TRIN
□ ¿Fecha objetivo para MVP? (para crear tickets con prioridad)
```

---

## FASE 2 — ARQUITECTURA (presentar plan antes de ejecutar)

Con las respuestas del Bloque A-D, presenta a Álvaro:

```
PROYECTO: <Nombre> (<slug>)
STACK: <Frontend> + <Backend> + <DB>
URL: <dominio>
DEPLOY: <Dokploy sí/no> | SUPABASE: <sí/no> | N8N: <prefijo WF-XXX-*>
AGENTES: <lista>

INFRAESTRUCTURA A CREAR:
□ Planka board + listas + labels
□ GitHub repo: alvarodevrace/<slug>
□ Supabase project (si aplica)
□ Dokploy app (si aplica)
□ DNS: <subdominio o dominio externo>
□ Vault: vault/<slug>/
□ KIMI.md en <Nombre>/
□ Actualizar KIMI-AGENTS.md

TICKETS INICIALES: <lista de tickets por agente>

¿Aprobamos y arrancamos?
```

**Álvaro aprueba → FASE 3.**

---

## FASE 3 — EJECUCIÓN (en este orden exacto)

### PASO 1 — Definir slugs y prefijos

Antes de cualquier acción, fijar:

```
SLUG:          <slug>                    # e.g. cobrosexp
NOMBRE:        <Nombre completo>         # e.g. Cobros Express
PREFIX_TKT:    <XXX>-                    # e.g. CEX- (3 letras del slug)
PREFIX_N8N:    WF-<XXX>-*               # e.g. WF-CEX-*
PREFIX_WH:     /webhook/<slug>-*         # e.g. /webhook/cobrosexp-*
```

---

### PASO 2 — Planka: crear board + listas + labels

```bash
# 1. Obtener token
TOKEN=$(curl -s -X POST "https://planka.alvarodevrace.tech/api/access-tokens" \
  -H "Content-Type: application/json" \
  -d '{"emailOrUsername":"alvaro@alvarodevrace.tech","password":"<BW>"}' \
  | python3 -c "import sys,json; print(json.load(sys.stdin).get('item',''))")

# 2. Listar workspaces (proyectos Planka) para obtener el ID principal
curl -s "https://planka.alvarodevrace.tech/api/projects" \
  -H "Authorization: Bearer $TOKEN" | python3 -c "import sys,json; [print(p['id'],p['name']) for p in json.load(sys.stdin)['items']]"

# 3. Crear board (usar el workspace ID del paso anterior)
BOARD=$(curl -s -X POST "https://planka.alvarodevrace.tech/api/projects/<WORKSPACE_ID>/boards" \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d "{\"name\":\"$NOMBRE\",\"position\":65535}")
BOARD_ID=$(echo $BOARD | python3 -c "import sys,json; print(json.load(sys.stdin)['item']['id'])")
echo "BOARD_ID: $BOARD_ID"

# 4. Crear listas (Backlog → Todo → In Progress → Done)
for LIST_NAME in "Backlog" "Todo" "In Progress" "Done"; do
  RESULT=$(curl -s -X POST "https://planka.alvarodevrace.tech/api/boards/$BOARD_ID/lists" \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d "{\"name\":\"$LIST_NAME\",\"position\":65535}")
  echo "$LIST_NAME: $(echo $RESULT | python3 -c "import sys,json; print(json.load(sys.stdin)['item']['id'])")"
done
# ⚠️ GUARDAR los 4 IDs de listas → van a vault/<slug>/40-Credentials/INFRA.md

# 5. Crear labels (TRIN, PIXEL, LINK, EVA, Álvaro)
for LABEL in "TRIN" "PIXEL" "LINK" "EVA" "Álvaro"; do
  RESULT=$(curl -s -X POST "https://planka.alvarodevrace.tech/api/boards/$BOARD_ID/labels" \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d "{\"name\":\"$LABEL\",\"color\":\"lagoon-blue\",\"position\":65535}")
  echo "$LABEL: $(echo $RESULT | python3 -c "import sys,json; print(json.load(sys.stdin)['item']['id'])")"
done
# ⚠️ GUARDAR los 5 IDs de labels → van a agents/KIMI-AGENTS.md y vault/<slug>/40-Credentials/INFRA.md
```

---

### PASO 3 — GitHub: crear repo

```bash
# Crear repo privado
gh repo create alvarodevrace/<slug> \
  --private \
  --description "<descripción 1 línea>"

# Clonar y configurar ramas permanentes
git clone git@github-alvarodevrace:alvarodevrace/<slug>.git <Nombre>/
cd <Nombre>/

# Crear rama develop (permanente)
git checkout -b develop
echo "# <Nombre>" > README.md
git add README.md
git commit -m "init: proyecto base"
git push origin develop

# Crear rama main (permanente)
git checkout -b main
git push origin main

# Proteger ramas en GitHub (sin push directo)
gh api repos/alvarodevrace/<slug>/branches/main/protection \
  -X PUT -H "Accept: application/vnd.github+json" \
  -f required_status_checks=null \
  -f enforce_admins=false \
  -f required_pull_request_reviews=null \
  -f restrictions=null

# Volver a develop (regla: siempre terminar en develop)
git checkout develop
```

---

### PASO 4 — Supabase: crear schema en self-hosted (si aplica)

**NO usar Supabase cloud.** Toda la infra corre en self-hosted: `https://db.alvarodevrace.tech`
Credenciales completas en `vault/INFRA-GLOBAL.md`.

**Crear schema vía SSH al VPS (key-based):**

> Usar clave SSH almacenada en Bitwarden. No escribir passwords en comandos.

```bash
ssh root@72.60.26.201 \
  "docker exec supabase-db-gkp3i7c53k0giqofgkpl7l0p psql -U postgres -c 'CREATE SCHEMA IF NOT EXISTS <slug>;'"
```

**Exponer schema en PostgREST** (editar docker-compose.yml en VPS):
```
PGRST_DB_SCHEMAS: 'public,storage,graphql_public,jauria,laschubys,brain,<slug>'
```
Luego: `docker compose up -d --force-recreate supabase-rest`

**Variables de entorno del proyecto:**
```
SUPABASE_URL=https://db.alvarodevrace.tech
SUPABASE_ANON_KEY=<ver INFRA-GLOBAL.md>
SUPABASE_SERVICE_ROLE_KEY=<ver INFRA-GLOBAL.md>
```

**Cliente JS:**
```ts
createClient(url, anonKey, { db: { schema: '<slug>' } })
```

---

### PASO 5 — Dokploy: crear app (si aplica)

**Prerequisito:** El repo GitHub debe existir (Paso 3 completo).

```bash
# Opción A: redeployar app existente vía API (la creación se hace por UI)
curl -s -X POST "https://dokploy.alvarodevrace.tech/api/application.deploy" \
  -H "x-api-key: $DOKPLOY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"applicationId":"<DOKPLOY_APP_ID>"}'
# ⚠️ Guardar Application ID en vault/<slug>/40-Credentials/INFRA.md

# Opción B (recomendada): via UI de Dokploy
# 1. New Project o usar proyecto existente
# 2. Add Application → Source: Git (GitHub App)
# 3. Seleccionar repo alvarodevrace/<slug>, branch: main
# 4. Configurar build según stack (ver Paso 5b)
# 5. Agregar dominio
# 6. Copiar Application ID de la URL: dokploy.../application/<ID>
```

**Comandos por stack:**

```yaml
# Angular
Build:  CI=1 ng build --configuration production --no-progress
Start:  nginx (static, usar Dockerfile custom)
Port:   80

# Astro SSR
Build:  npm run build
Start:  node ./dist/server/entry.mjs
Port:   4321

# NestJS
Build:  npm run build
Start:  node dist/main
Port:   3000
```

---

### PASO 6 — DNS: apuntar dominio

**Si es subdominio de alvarodevrace.tech (Cloudflare):**
```bash
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "A",
    "name": "<subdominio>",
    "content": "72.60.26.201",
    "proxied": true
  }'
```

**Si es dominio externo (e.g. nuevo dominio comprado):**
1. Agregar zona en Cloudflare (requiere permiso zone:create o via UI)
2. Actualizar nameservers en Hostinger/registrar
3. Crear registro A → 72.60.26.201
4. Registrar CLOUDFLARE_ZONE_ID_<SLUG> en `vault/<slug>/40-Credentials/INFRA.md`

---

### PASO 7 — n8n: configurar prefijo y variables de entorno

**Si el proyecto usa n8n:**

```bash
# Agregar variables al entorno global de n8n en Dokploy
# Ir a: Dokploy → Infra Global → n8n → Environment Variables

# Variables base para cualquier proyecto:
<SLUG>_SUPABASE_URL=https://<id>.supabase.co
<SLUG>_SUPABASE_SERVICE_KEY=<service_role_key>
<SLUG>_WEBHOOK_BASE=/webhook/<slug>-

# Variables opcionales según integraciones:
<SLUG>_MAILERSEND_TOKEN=<token>
<SLUG>_TELEGRAM_BOT_TOKEN=<token>
<SLUG>_TELEGRAM_CHAT_ID=<id>
```

**Crear primer workflow de health check:**
- Nombre: `WF-<XXX>-INFRA-HEALTH`
- Webhook: `/webhook/<slug>-health`
- Responde: `{status:"ok", project:"<slug>", ts: "{{$now}}"}`

---

### ~~PASO 8 — Evolution API~~ ✅ ELIMINADO 2026-06-06

> **Evolution API fue eliminado completamente del VPS por orden de Álvaro.**
> Si un cliente nuevo necesita WhatsApp → evaluar alternativas modernas (WPPConnect, WhatsApp Business API) desde cero.
>
> **Formato teléfono legacy (si aplica para otras integraciones):** Sin prefijo `+`. `593XXXXXXXXX` no `+593XXXXXXXXX`.

---

### PASO 9 — Vault: crear estructura completa

```bash
cd /Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro

# Crear estructura de directorios
mkdir -p vault/<slug>/{00-Index,10-Log/archive,20-Tech,30-Product,40-Credentials,temp}

# Crear INDEX.md
cat > vault/<slug>/00-Index/INDEX.md << 'EOF'
# INDEX — <Nombre>

**Slug:** <slug> | **Creado:** YYYY-MM-DD | **TRIN Boot:** ver KIMI.md

## Páginas Wiki

### 20-Tech/
| Página | Descripción |
|--------|-------------|
| Infra.md | Dokploy, DNS, VPS, deploy |
| Supabase.md | Schema, RLS, funciones |
| n8n.md | Workflows activos |
| Stack.md | Frontend/Backend setup |

### 30-Product/
| Página | Descripción |
|--------|-------------|
| Product.md | Visión, MVP, glosario |

## Convenciones
- Tickets: `<XXX>-N` (Planka board: <BOARD_ID>)
- n8n prefix: `WF-<XXX>-*`
- Webhooks: `/webhook/<slug>-*`
- Credenciales: `40-Credentials/INFRA.md`
EOF

# Crear LOG.md
cat > vault/<slug>/10-Log/LOG.md << 'EOF'
# LOG — <Nombre>

Formato append-only. EVA actualiza. No editar entradas previas.

---

## [YYYY-MM-DD] TRIN | Proyecto creado. Infraestructura base completa.
EOF

# Crear INFRA.md (credenciales — rellenar con IDs reales)
cat > vault/<slug>/40-Credentials/INFRA.md << 'EOF'
# INFRA — <Nombre>

## URLs
- App prod:       https://<dominio>
- App staging:    https://<slug>-staging.alvarodevrace.tech (si aplica)
- Supabase:       https://<id>.supabase.co (si aplica)
- n8n:            https://n8n.alvarodevrace.tech

## Supabase (si aplica)
- Project ID:     <supabase-project-id>
- Anon key:       (ver .env)
- Service key:    (ver .env — NUNCA commitear)

## Dokploy
- Project ID:   <dokploy-project-id>
- App ID:       <dokploy-app-id>
- Deploy trigger: curl -X POST -H "x-api-key: $DOKPLOY_API_KEY" -H "Content-Type: application/json" -d '{"applicationId":"<DOKPLOY_APP_ID>"}' "https://dokploy.alvarodevrace.tech/api/application.deploy"

## GitHub
- Repo:           https://github.com/alvarodevrace/<slug>
- SSH:            git@github-alvarodevrace:alvarodevrace/<slug>.git
- Ramas:          main (prod), develop (staging)

## Planka
- Board ID:       <board-id>
- Listas:
    Backlog:      <backlog-list-id>
    Todo:         <todo-list-id>
    In Progress:  <in-progress-list-id>
    Done:         <done-list-id>
- Labels:
    TRIN:         <trin-label-id>
    PIXEL:        <pixel-label-id>
    LINK:         <link-label-id>
    EVA:          <eva-label-id>
    Álvaro:       <alvaro-label-id>

## n8n
- Prefix:         WF-<XXX>-*
- Webhook base:   /webhook/<slug>-*
- Health check:   /webhook/<slug>-health (WF-<XXX>-INFRA-HEALTH)

## ~~Evolution API~~
> Eliminado 2026-06-06. No documentar para nuevos proyectos.

## Cloudflare
- Zone ID:        <zone-id> (si aplica)
- Dominio:        <dominio>

## Stack
- Frontend:       <Angular 21 / Astro SSR / otro>
- Backend:        <NestJS / Edge Functions / ninguno>
- Puerto local:   <4200 / 4321 / 3000>
EOF

# Crear páginas Tech y Product base
cat > vault/<slug>/20-Tech/Infra.md << 'EOF'
# Infra — <Nombre>

## Deploy
- Dokploy app ID: <app-id>
- Branch prod: main → auto-deploy via GitHub Actions
- Build: <comando>
- Start: <comando>

## DNS
- Dominio: <dominio> → 72.60.26.201 (Hostinger VPS)
- CDN: Cloudflare (si aplica)

## Decisiones
- YYYY-MM-DD: <decisión arquitectural>
EOF

cat > vault/<slug>/30-Product/Product.md << 'EOF'
# Product — <Nombre>

## Visión
<descripción del sistema en 2-3 líneas>

## MVP (Sprint 1)
- [ ] <Feature 1>
- [ ] <Feature 2>
- [ ] <Feature 3>

## Usuarios
- <Tipo de usuario>: <qué puede hacer>

## Glosario
| Término | Definición |
|---------|-----------|
| <término> | <definición> |
EOF
```

---

### PASO 10 — KIMI.md del proyecto

```bash
cat > /Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/<Nombre>/KIMI.md << 'EOF'
# KIMI.md — <Nombre>

**Proyecto:** <slug> | **Agente activo:** TRIN

## Instrucciones

Leer en orden:
1. `../agents/KIMI-AGENTS.md` → schema maestro, tabla de proyectos, Planka API
2. `../agents/kimi/TRIN.md` → rol TRIN completo
3. `../vault/<slug>/10-Log/LOG.md` → historial reciente y contexto de sesión activa
4. `../vault/<slug>/00-Index/INDEX.md` → mapa del proyecto

## Stack PIXEL

- `<ruta app>/` → <stack> (<URL>)
- <agregar según proyecto>

## Delta específico

- n8n webhooks: `/webhook/<slug>-*`
- Supabase: `<project-id>` (si aplica)
- Dokploy app ID: `<app-id>` (si aplica)
- Planka board: `<board-id>`

## Credenciales completas

`../vault/<slug>/40-Credentials/INFRA.md`

## Prompt de inicio

`../prompts/TRIN-BOOT.md`
EOF
```

---

### PASO 11 — Actualizar KIMI-AGENTS.md (tabla maestra)

Agregar fila a la tabla de proyectos en `agents/KIMI-AGENTS.md`:

```markdown
| <slug> | vault/<slug>/ | <supabase-id o —> | <dokploy-app-id o —> | <planka-board-id> | WF-<XXX>-* | <stack> |
```

Agregar fila a las tablas de **Labels** y **Listas** con los IDs obtenidos en el Paso 2.

Agregar prefijo a la tabla de **Prefijos por proyecto**:
```markdown
| <slug> | <XXX>-N |
```

---

### PASO 12 — Crear tickets iniciales en Planka

Crear los tickets de arranque para cada agente activo. Usar la API del Paso 2.

**Tickets TRIN obligatorios:**
```
[<XXX>-1] Setup infraestructura base (Supabase schema + RLS inicial)
[<XXX>-2] Configurar Dokploy deploy pipeline
[<XXX>-3] Configurar DNS y SSL
```

**Tickets PIXEL (si hay app):**
```
[<XXX>-4] Scaffold <stack> base + routing + estructura de carpetas
[<XXX>-5] Implementar autenticación (<tipo auth>)
[<XXX>-6] <Feature MVP 1>
[<XXX>-7] <Feature MVP 2>
```

**Tickets LINK (si hay n8n):**
```
[<XXX>-8] Crear WF-<XXX>-INFRA-HEALTH (health check base)
[<XXX>-9] <Primer workflow de negocio>
```

**Tickets EVA:**
```
[<XXX>-10] Completar vault inicial (20-Tech/ + 30-Product/)
[<XXX>-11] Documentar decisiones arquitecturales del setup
```

```bash
# Ejemplo curl para crear ticket
CARD=$(curl -s -X POST "https://planka.alvarodevrace.tech/api/lists/<TODO_LIST_ID>/cards" \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d "{\"name\":\"[<XXX>-1] Setup infraestructura base\",\"position\":65535,\"type\":\"project\"}")
CARD_ID=$(echo $CARD | python3 -c "import sys,json; print(json.load(sys.stdin)['item']['id'])")

# Agregar label TRIN
curl -s -X POST "https://planka.alvarodevrace.tech/api/cards/$CARD_ID/card-labels" \
  -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d "{\"labelId\":\"<TRIN_LABEL_ID>\"}"
```

---

## CHECKLIST FINAL DE VERIFICACIÓN

Antes de reportar a Álvaro que el proyecto está listo:

```
INFRAESTRUCTURA
□ Planka board creado con 4 listas + 5 labels
□ GitHub repo creado (branches: main + develop)
□ Supabase proyecto creado (si aplica)
□ Dokploy app configurada y desplegable (si aplica)
□ DNS apuntando correctamente (si aplica)
□ n8n variables de entorno agregadas (si aplica)
□ ~~Evolution API~~ → No aplica (eliminado 2026-06-06)

ARCHIVOS
□ vault/<slug>/00-Index/INDEX.md ✅
□ vault/<slug>/10-Log/LOG.md ✅
□ vault/<slug>/20-Tech/Infra.md ✅
□ vault/<slug>/30-Product/Product.md ✅
□ vault/<slug>/40-Credentials/INFRA.md ✅ (con todos los IDs reales)
□ <Nombre>/KIMI.md ✅

KIMI-AGENTS.md ACTUALIZADO
□ Fila en tabla maestra de proyectos ✅
□ Fila en tabla de Labels ✅
□ Fila en tabla de Listas ✅
□ Fila en tabla de Prefijos de tickets ✅

TICKETS
□ Tickets TRIN creados en Todo (infra)
□ Tickets PIXEL creados en Backlog (si aplica)
□ Tickets LINK creados en Backlog (si aplica)
□ Ticket EVA creado en Todo (vault completo)

REPORTE A ÁLVARO
□ Board Planka: https://planka.alvarodevrace.tech (ir a <Nombre>)
□ Repo GitHub: https://github.com/alvarodevrace/<slug>
□ URL prod: https://<dominio> (pendiente primer deploy)
□ Próximo paso: PIXEL arranca <XXX>-4 / LINK arranca <XXX>-8
```

---

## TEMPLATES DE SCAFFOLD POR STACK

### Angular 21 (standalone, SSR opcional)

```bash
cd /Users/alvarocarreramontalvo/Documents/Proyectos/Alvaro/<Nombre>
ng new <slug> --standalone --style=scss --ssr=false --routing=true
cd <slug>
npm install @supabase/supabase-js  # si usa Supabase

# Estructura recomendada
src/
  app/
    core/           # services, guards, interceptors
    features/       # módulos de feature
    shared/         # componentes compartidos
    layout/         # shell, navbar, sidebar
  environments/
```

### Astro SSR (node adapter)

```bash
npm create astro@latest <slug> -- --template minimal --yes
cd <slug>
npx astro add node
npm install @supabase/supabase-js  # si usa Supabase

# astro.config.mjs
output: 'server'
adapter: node({ mode: 'standalone' })
```

### NestJS (BFF / API)

```bash
npm i -g @nestjs/cli
nest new <slug>-api --package-manager npm
cd <slug>-api
npm install @supabase/supabase-js @nestjs/config

# Estructura recomendada
src/
  modules/          # un módulo por entidad
  common/           # guards, interceptors, decorators
  config/           # configuración tipada
```

### Monorepo Angular + NestJS (como Jauría)

```bash
mkdir <Nombre> && cd <Nombre>
mkdir apps
# admin panel
ng new admin-panel --standalone --style=scss --routing=true --directory apps/admin-panel
# api
nest new admin-api --package-manager npm --directory apps/admin-api
# landing (si aplica)
ng new landing-page --standalone --style=scss --routing=true --directory apps/landing-page
```

---

## NOTAS FINALES PARA TRIN

1. **Nunca crear infraestructura sin aprobación de Álvaro** en FASE 2.
2. **Todo ID generado** (Planka, Dokploy, Supabase) va inmediatamente a `vault/<slug>/40-Credentials/INFRA.md`.
3. **Todo ID nuevo en KIMI-AGENTS.md** → actualizar la sesión antes de /clear.
4. **Primer commit del repo** siempre en `develop`, nunca en `main`.
5. **Dokploy deploy** solo se activa cuando hay código real en `main` (primer PR de PIXEL).
6. **EVA** debe procesar el temp/ del proyecto después del setup → crear las páginas 20-Tech/ definitivas.
7. **Protocol RX obligatorio** para cualquier schema Supabase, incluso el inicial.
