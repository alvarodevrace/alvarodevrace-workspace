# Filosofía Chubys — Documento de Inteligencia del Proyecto

> Propósito: alinear a todo el equipo (Álvaro, Brenda, TRIN, PIXEL, AURA, LINK, NOVA) sobre qué es Las Chubys, a quién apuntamos, qué estamos construyendo y hacia dónde vamos. Fuente viva: se actualiza cada vez que la marca, el producto o la tecnología evolucionen.

---

## 1. Origen y esencia

**Las Chubys** es una marca de entretenimiento felino creada en torno a **Iris** y **Rubi**, las gatas de Álvaro y Brenda. Brenda le dio vida a sus redes sociales y convirtió a las gatitas en personajes de una **reality-telenovela felina**: dramas, juicios, parodías de libros de autoayuda ("Potencial humano"), encuestas a la comunidad y episodios seriados en reels/TikTok.

**Pilares de la marca:**
- **Personajes fuertes:** Iris (la princesa), Rubi (la energía), Karen (la admin/villana recurrente).
- **Humor + drama absurdo:** contenido corto, narrativa serializada, CTAs de opinión.
- **Anclaje local:** Ecuador 🇪🇨 como origen, pero con aspiración latinoamericana y global.
- **Comunidad primero:** la audiencia decide, vota y comenta. "Se queda oficial" es un mantra de interacción directa.

---

## 2. El universo social

| Red | Handle | Seguidores | Observaciones |
|-----|--------|------------|---------------|
| Instagram | [@laschubys](https://www.instagram.com/laschubys/) | ~17K | Bio con contacto comercial. Feed bloqueado sin login; metadata pública disponible. |
| TikTok | [@laschubys.oficial](https://www.tiktok.com/@laschubys.oficial) | ~14.4K | ~609.8K likes totales. Mejor ratio likes/seguidor. Feed bloqueado sin login. |
| Facebook | [Las Chubys](https://www.facebook.com/people/Las-Chubys/61589964727281/) | ~2.6K | Contenido reciente visible: series de 5 reels, encuestas, comentarios activos. |

**Tono de voz detectado:**
- Directo, cercano, con humor y dramatización.
- Uso recurrente de emojis: 👑 ⚡ 🐾 🐈‍⬛.
- CTAs a la comunidad: "¿se queda o se va?", "Parte 1 a 5 en reels".

**Oportunidades de marca:**
- Colaboraciones con marcas de mascotas, productos ecuatorianos, lifestyle.
- Merchandising oficial de personajes.
- Spin-offs del reality (libros, calendarios, accesorios).
- Integración ecommerce web: productos propios + afiliados.

---

## 3. Propuesta de valor para marcas

Las Chubys no es solo una cuenta de gatos. Es un **IP de entretenimiento con audiencia comprometida** que puede:

1. **Generar awareness** con contenido orgánico de alto engagement (TikTok ~42 likes/seguidor).
2. **Validar productos** mediante encuestas y reacciones reales de la comunidad.
3. **Vender** a través de la tienda propia y links de afiliados.
4. **Escalar SEO** con el blog de contenido felino + reseñas + guías.

**Buyer persona objetivo de la marca:**
- Amantes de gatos, mayormente jóvenes/adultos 18-45.
- Audiencia latinoamericana (Ecuador, México, Colombia, Argentina, España).
- Consumidores de contenido corto, memes y cultura pop.
- Compradores de productos para mascotas, accesorios kawaii, merch de creadores.

---

## 4. Plataforma web: LasChubys.com

La web es el **hub comercial y de contenido** de la marca. Debe convertir tráfico social en:
- Ventas de productos propios (Ecuador).
- Comisiones por links de afiliados (Amazon, Temu, etc.).
- Leads de contacto y colaboraciones.
- Tráfico SEO orgánico mediante el blog.

### Secciones actuales
- **Home:** hero editorial, contenido destacado, links a tienda/blog.
- **Tienda (`/tienda`):** catálogo de productos propios + afiliados, filtros, preview modal.
- **Carrito (`/carrito`):** signal-based, `localStorage`, drawer + página.
- **Checkout (`/checkout`):** formulario de datos de envío. Guarda orden en BD con estado `pending`.
- **Blog (`/blog`, `/blog/:slug`):** listado y detalle de posts, comentarios con login.
- **Admin (`/admin`):** CRUD de posts y productos, subida de imágenes a Supabase Storage.
- **Auth:** login con Google OAuth, cookies httpOnly.
- **Estáticas:** about, servicios, contacto.

### Secciones futuras clave
- **Media Kit (`/media-kit`):** métricas en vivo, propuesta de colaboración, contacto comercial.
- **Perfil de usuario:** historial de órdenes, wishlist.
- **Pago real:** PayPhone / PlaceToPay / Stripe.
- **Fulfillment:** integración Printful o logística local.
- **SEO avanzado:** schema.org, sitemap dinámico, indexación automática.

---

## 5. Arquitectura técnica

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  LasChubys-Front │──────▶  LasChubys-Back  │──────▶  Supabase      │
│  Angular 21 SSR  │      │  NestJS 11 BFF   │      │  Postgres 15    │
│  Tailwind 4      │      │  Auth / Content  │      │  Auth / Storage │
│  Bun             │      │  Checkout / Admin│      │  RLS            │
└─────────────────┘      └─────────────────┘      └─────────────────┘
        │                         │
        ▼                         ▼
   Dokploy (app)            Dokploy (api)
   Cloudflare               n8n (automatizaciones)
   Sentry                   Uptime Kuma
```

### Frontend
- Angular 21 standalone, SSR, signals, zoneless.
- Tailwind 4 + SCSS + tokens en `:root`.
- Componentes UI: button, input, card, badge (cva + tailwind-merge).
- Playwright e2e (algunos desactualizados).

### Backend
- NestJS 11, validation pipe global, Helmet, Throttler, CORS.
- Auth Google OAuth con PKCE + CSRF double-submit cookie.
- Módulos: auth, admin, content, checkout, contact, comments, health.

### Base de datos
- Schema `laschubys` con tablas: `profiles`, `blog_posts`, `products`, `orders`, `comments`, `contacts`.
- Storage bucket `las-chubys-media` para imágenes de admin.
- RLS activo; backend usa service role para escrituras sensibles.

---

## 6. Estado actual (~60%)

### Lo que funciona ✅
- SSR en producción, deploy en Dokploy healthy.
- Home, tienda, carrito, blog, auth, admin básico operativos.
- Subida de imágenes desde admin a Supabase Storage.
- Sitemap dinámico y robots.txt.
- Sentry en front y back.

### Gaps críticos ⚠️
- **Checkout sin pago:** solo captura lead. No hay pasarela real.
- **Admin sin protección de ruta:** `admin` route no aplica `canActivate` en Angular; backend admin tampoco aplica `@UseGuards(AdminGuard)` en controllers.
- **E2E rotos:** data-testid inexistentes.
- **Auth callback estático:** no procesa sesión después del login.
- **Blog básico:** `content` es jsonb/array de strings; falta editor rico.
- **Stock/envíos:** no existe.
- **Media kit:** no existe. Es prioridad para colaboraciones con marcas.

---

## 7. Hoja de ruta prioritaria

1. **Media Kit en vivo**
   - Endpoint `/api/media-kit` que exponga métricas sociales (seguidores, likes, posts, engagement).
   - Página `/media-kit` con diseño premium, descargable PDF, CTA de contacto.
   - Conectar con APIs sociales o scrapeo programado vía n8n.

2. **Seguridad admin**
   - Aplicar guards en rutas Angular y `@UseGuards(AdminGuard)` en backend.
   - Auditar RLS de `comments` (cualquier usuario autenticado puede editar).

3. **Checkout real**
   - Integrar pasarela (PayPhone Ecuador / PlaceToPay / Stripe).
   - Validar stock, calcular envío, historial de órdenes.

4. **SEO + contenido**
   - Mejorar editor de blog, schema.org, indexación automática (WF-LCH-SEO-01).
   - Lote de 5+ artículos listos para publicar.

5. **Perfil de usuario**
   - Wishlist, historial de compras, recuperación de carrito cross-device.

---

## 8. Notas para el Media Kit

El Media Kit es la puerta de entrada a colaboraciones pagadas. Debe comunicar:

- **Audiencia total cross-red:** ~34K seguidores combinados (IG + TikTok + FB).
- **Engagement:** TikTok lidera en likes/seguidor; Facebook en interacción inmediata.
- **Formatos ofrecidos:** reels integrados, posts estáticos, stories, unboxing, parodias de marca, encuestas.
- **CTA comercial:** `laschubys.oficial@gmail.com`.
- **Propuesta de valor:** contenido orgánico, personajes con carisma, comunidad activa, ecommerce propio para co-creaciones.

> **Próximo paso inmediato:** diseñar y construir la página `/media-kit` + endpoint de métricas. AURA lidera diseño, PIXEL integra, TRIN valida infra y datos.

---

*Documento creado por KIMICO (TRIN) con inteligencia de swarm: AURA, PIXEL, TRIN. Fecha: 2026-06-16.*
