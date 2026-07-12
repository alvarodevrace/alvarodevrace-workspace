# Las Chubys — Design System & Estructura Penpot

> **Fecha:** 2026-06-06
> **Referencia visual:** https://www.petstation.ec/ (estructura + flujo de compra)
> **Stack:** Angular 21 SSR + SCSS (sin Tailwind en componentes)
> **Diseñadora:** AURA (Brenda) — edita Penpot
> **Desarrollador:** PIXEL (Kimi) — replica a Angular

---

## 1. Estructura de Penpot

### Proyecto: Las Chubys
**URL:** https://penpot.alvarodevrace.tech
**ID:** `55b46c3d-8d9c-8016-8008-21f7c430e479`

| # | Archivo | ID | Responsable | Contenido |
|---|---|---|---|---|
| 01 | **Design Tokens** | `55b46c3d-8d9c-8016-8008-21f7d8b94cd8` | AURA | Colores, tipografía, espaciado, sombras, radios |
| 02 | **Components** | `55b46c3d-8d9c-8016-8008-21f7d94c5af0` | AURA | Componentes reutilizables, variants |
| 03 | **Screens** | `55b46c3d-8d9c-8016-8008-21f7d9bacc18` | AURA | Pantallas completas Desktop + Mobile |
| 04 | **Archive** | `55b46c3d-8d9c-8016-8008-21f7da33cef5` | — | Backup, exploraciones descartadas |

### Proyecto Legacy (archivado)
**Nombre:** Las Chubys — Legacy (archivado)
**ID:** `eb1247f1-ed2f-8053-8008-2028442de8f4`
→ No editar. Solo referencia histórica.

---

## 2. Design Tokens (Archivo 01)

### Páginas a crear en Penpot:

#### 🎨 Color Palette
Paleta de Las Chubys (NO copiar de PetStation):

| Token | Valor | Uso |
|---|---|---|
| `--orange` | `#FF7A1A` | Primario, CTAs, acentos |
| `--orange-dark` | `#E06300` | Hover primario |
| `--orange-light` | `#FFF1E5` | Fondos suaves |
| `--surface` | `#FFF4E8` | Fondos de sección |
| `--white` | `#FFFFFF` | Fondo base |
| `--text` | `#333333` | Texto principal |
| `--text-muted` | `#6B7280` | Texto secundario |
| `--border` | `#E0E0E0` | Bordes, divisores |
| `--gray-50` | `#F9FAFB` | Fondos alternos |
| `--gray-100` | `#F3F4F6` | Placeholders, skeletons |
| `--dark` | `#141313` | Texto sobre fondos oscuros |
| `--whatsapp` | `#25D366` | Botón flotante WA |

#### 🔤 Typography
| Token | Valor | Uso |
|---|---|---|
| Font family | `'Open Sans', sans-serif` | Todo el texto |
| H1 | `clamp(1.8rem, 4vw, 2.6rem)` | Hero titles |
| H2 | `clamp(1.4rem, 2.5vw, 1.8rem)` | Section titles |
| H3 | `1.3rem` | Card titles |
| Body | `15px / 1.6` | Párrafos |
| Small | `0.85rem` | Labels, captions |
| Eyebrow | `0.7rem / 800 / uppercase / 0.12em` | Section labels |
| Button | `0.85rem / 800` | Botones |

#### 📐 Spacing
| Token | Valor |
|---|---|
| Section padding | `2.5rem 0 3rem` |
| Page wrap | `min(1180px, calc(100vw - 2rem))` |
| Grid gap (shop) | `1.25rem` |
| Grid gap (cards) | `1.5rem` |
| Card radius | `16px` |
| Button radius | `999px` (pill) |
| Banner radius | `20px` |

#### 🌑 Shadows
| Token | Valor |
|---|---|
| Card hover | `0 16px 40px rgba(0,0,0,0.08)` |
| Button hover | `0 8px 20px rgba(255,122,26,0.3)` |
| WA button | `0 20px 45px rgba(37,211,102,0.32)` |

---

## 3. Components (Archivo 02)

### Páginas a crear en Penpot:

#### 🧩 Componentes Atómicos
- **Button Primary** — pill, naranja, texto blanco
- **Button Secondary** — pill, outline naranja, texto naranja
- **Button Icon** — circular, con icono (carrito, búsqueda, menú)
- **Input Text** — borde suave, focus naranja
- **Input Search** — con icono lupa
- **Badge** — "Nuevo", "Oferta", "Agotado"
- **Tag/Pill** — categoría, filtro

#### 🧩 Componentes Moleculares
- **Product Card** — imagen 1:1, badge, nombre, precio, botón add
- **Blog Card** — imagen 16:10, tag, título, excerpt
- **Category Card** — icono + nombre (circular o cuadrado)
- **Review Card** — avatar, nombre, estrellas, comentario
- **Cart Item Row** — imagen mini, nombre, cantidad, precio, eliminar

#### 🧩 Componentes Organismos
- **Header** — logo, nav desktop, search, cart icon, account, mobile hamburger
- **Footer** — logo, links, newsletter, redes sociales, copyright
- **Cart Drawer** — panel lateral derecho, items, subtotal, checkout CTA
- **WhatsApp Float** — botón fijo bottom-right
- **Hero Section** — banner grande, texto overlay, CTA
- **Section Header** — eyebrow + título + "Ver todo" link
- **Product Shelf** — grid de Product Cards con header
- **Category Grid** — grid de Category Cards
- **Promo Strip** — marquee animado con textos promocionales
- **Newsletter Band** — email input + CTA suscripción
- **Breadcrumb** — Inicio > Categoría > Producto

---

## 4. Screens (Archivo 03)

### Páginas a crear en Penpot (cada una en Desktop 1440px y Mobile 375px):

#### 🏠 Home
**Ruta:** `/`
**Secciones (orden):
1. **Header** (fijo, transparente → blanco al scroll)
2. **Hero** — banner principal con imagen de gatas, texto CTA
3. **Promo Strip** — marquee con promos (envío gratis, etc.)
4. **Categories** — grid de categorías (Alimentar, Dormir, Juguetes, etc.)
5. **Featured Products** — vitrina "Recomendado para ti" (4-6 cards)
6. **New Products** — vitrina "Nuevos Productos" (4 cards)
7. **Instagram Feed** — @laschubys_ec, grid de fotos
8. **Newsletter** — banda con input email
9. **Footer**

**Ref PetStation:** Hero grande, categorías visuales, vitrinas con carrusel.

#### 🛍️ Tienda (Shop)
**Ruta:** `/tienda`
**Secciones:
1. **Page Hero** — título "Tienda", breadcrumb
2. **Filter Bar** — categorías, ordenar, filtros
3. **Product Grid** — 4 cols desktop, 2 cols tablet, 1 col mobile
4. **Pagination** — o lazy load
5. **Footer**

**Ref PetStation:** Grid de productos con cards limpias, filtros laterales.

#### 📦 Producto Detalle
**Ruta:** `/tienda/:slug`
**Secciones:
1. **Breadcrumb**
2. **Product Gallery** — imagen principal + thumbnails
3. **Product Info** — nombre, precio, descripción, selector cantidad, botón "Agregar al carrito"
4. **Related Products** — vitrina "También te puede gustar"
5. **Footer**

**Ref PetStation:** Layout split (imagen izq, info der), gallery con zoom.

#### 🛒 Carrito
**Ruta:** `/carrito`
**Secciones:
1. **Page Hero** — "Tu Carrito"
2. **Cart Items** — lista de Cart Item Rows
3. **Cart Summary** — subtotal, envío, total, botón "Ir a pagar"
4. **Empty State** — cuando no hay items
5. **Footer**

**Ref PetStation:** Drawer lateral (ya existe) + página dedicada.

#### 💳 Checkout
**Ruta:** `/checkout`
**Secciones:
1. **Progress Steps** — Carrito → Información → Pago → Confirmación
2. **Contact Form** — nombre, email, teléfono, dirección
3. **Shipping** — método de envío
4. **Payment** — integración PayPhone (resumen)
5. **Order Summary** — items, total
6. **Footer**

**Ref PetStation:** Formulario limpio, pasos claros, resumen lateral.

#### 📝 Blog (Listado)
**Ruta:** `/blog`
**Secciones:
1. **Page Hero** — "Blog", subtítulo
2. **Blog Grid** — 3 cols desktop, 1 col mobile
3. **Footer**

#### 📝 Blog Detalle
**Ruta:** `/blog/:slug`
**Secciones:
1. **Article Header** — título, fecha, autor, imagen cover
2. **Article Content** — cuerpo del post
3. **Share Buttons** — compartir en redes
4. **Comments Section** — lista de comentarios + formulario
5. **Related Posts** — cards de posts relacionados
6. **Footer**

#### 👩‍👩‍👧 Nosotras (About)
**Ruta:** `/nosotras`
**Secciones:
1. **Page Hero** — "Nosotras", historia
2. **Team/Cats** — cards de las gatas (Mila, Luna, etc.)
3. **Misión/Visión** — split section con imagen
4. **CTA Band** — "Visita nuestra tienda"
5. **Footer**

#### 📞 Contacto
**Ruta:** `/contacto`
**Secciones:
1. **Page Hero** — "Contáctanos"
2. **Contact Info** — dirección, teléfono, email, horarios
3. **Contact Form** — nombre, email, mensaje
4. **Map** — (opcional)
5. **Footer**

#### 🔐 Auth Login
**Ruta:** `/auth/login`
**Secciones:
1. **Auth Hero** — "Bienvenida", botón Google OAuth
2. **Auth Perks** — beneficios de cuenta
3. **Footer** (minimal)

#### ⚙️ Admin Dashboard
**Ruta:** `/admin`
**Secciones:
1. **Sidebar Nav** — pedidos, productos, blog, usuarios
2. **Stats Cards** — ventas, pedidos, usuarios
3. **Recent Orders Table**
4. **Quick Actions**

---

## 5. Responsive Breakpoints

| Breakpoint | Ancho | Layout |
|---|---|---|
| Mobile | < 480px | 1 columna, nav hamburger, drawer |
| Tablet | 481-768px | 2 columnas, nav simplificado |
| Desktop | 769-1024px | 3-4 columnas, nav completa |
| Wide | > 1024px | 4 columnas, max-width 1180px |

### Mobile-first approach:
- Base: mobile
- `@media (min-width: 768px)` → tablet
- `@media (min-width: 1024px)` → desktop

---

## 6. Animaciones & Micro-interacciones

| Elemento | Animación | Implementación |
|---|---|---|
| Product Card hover | translateY(-3px) + shadow | CSS transition 200ms |
| Product image hover | scale(1.04) | CSS transition 300ms |
| Button hover | translateY(-1px) + shadow | CSS transition 180ms |
| Cart Drawer | slide from right | CSS transform + transition |
| Page reveal | fadeIn + translateY | IntersectionObserver + CSS |
| Promo Strip | marquee scroll | CSS @keyframes |
| Header scroll | background blur + shadow | Scroll event + CSS |

---

## 7. Flujo de Usuario (UX)

```
Home → Tienda → Producto → Carrito (drawer) → Checkout → Confirmación
  ↓       ↓        ↓           ↓
Blog   Filtros   Gallery    Seguir comprando
  ↓
Contacto
```

---

## 8. Assets Necesarios

### Imágenes (solicitar a Álvaro/Brenda):
- [ ] Logo Las Chubys (SVG, blanco + naranja)
- [ ] Hero banner desktop (1440×600)
- [ ] Hero banner mobile (375×500)
- [ ] Fotos de las gatas (Mila, Luna, etc.)
- [ ] Fotos de productos (alimentos, juguetes, camas)
- [ ] Iconos de categorías (lucide o custom)
- [ ] Instagram feed placeholder (6 fotos)

### Iconos (Lucide Angular ya instalado):
- Search, ShoppingCart, Menu, X, Heart, Star, ChevronRight, Phone, Mail, MapPin, User

---

## 9. Checklist AURA → Penpot

### Archivo 01 — Design Tokens
- [ ] Color Palette (todos los tokens con muestras)
- [ ] Typography (todos los estilos de texto)
- [ ] Spacing Scale (8px base: 4, 8, 12, 16, 24, 32, 48, 64)
- [ ] Shadows (3 niveles)
- [ ] Border Radius (4px, 8px, 12px, 16px, 20px, 999px)

### Archivo 02 — Components
- [ ] Button Primary (default, hover, disabled)
- [ ] Button Secondary (default, hover, disabled)
- [ ] Button Icon (3 tamaños)
- [ ] Input Text (default, focus, error)
- [ ] Input Search
- [ ] Badge (3 variantes)
- [ ] Product Card (desktop + mobile)
- [ ] Blog Card (desktop + mobile)
- [ ] Category Card
- [ ] Cart Item Row
- [ ] Header (desktop + mobile)
- [ ] Footer (desktop + mobile)
- [ ] Cart Drawer

### Archivo 03 — Screens
- [ ] Home Desktop
- [ ] Home Mobile
- [ ] Tienda Desktop
- [ ] Tienda Mobile
- [ ] Producto Detalle Desktop
- [ ] Producto Detalle Mobile
- [ ] Carrito Desktop
- [ ] Carrito Mobile
- [ ] Checkout Desktop
- [ ] Checkout Mobile
- [ ] Blog List Desktop
- [ ] Blog List Mobile
- [ ] Blog Detail Desktop
- [ ] Blog Detail Mobile
- [ ] Nosotras Desktop
- [ ] Nosotras Mobile
- [ ] Contacto Desktop
- [ ] Contacto Mobile
- [ ] Auth Login Desktop
- [ ] Auth Login Mobile
- [ ] Admin Dashboard Desktop

---

## 10. Notas de Implementación para PIXEL

- **NO usar Tailwind** en componentes nuevos → SCSS puro con variables CSS
- **Standalone components** obligatorio (`standalone: true`)
- **Zoneless Angular** — signals + `OnPush` donde aplique
- **SSR-safe** — todo el DOM manipulation en `afterNextRender` o con `isPlatformBrowser`
- **Imágenes** — usar `<img>` con `loading="lazy"` para vitrinas
- **Motion** — librería `motion` ya instalada, usar para scroll reveals
- **A11y** — contraste WCAG AA mínimo, focus visible, aria-labels
