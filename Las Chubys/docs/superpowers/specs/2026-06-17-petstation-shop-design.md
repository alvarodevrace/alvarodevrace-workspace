# Diseño — Tienda LasChubys al estilo PetStation

## Objetivo
Replicar la experiencia de compra de `https://www.petstation.ec/Perros` y su página de producto en la tienda de LasChubys:
- Listado con **sidebar de categorías** a la izquierda y **grid de productos** a la derecha.
- **Página de detalle** propia (`/tienda/:slug`) con galería, información de compra, descripción y productos relacionados.
- Base de datos extendida para soportar **categorías**, **slug** y **tipo físico/link**.

## Decisiones de producto
- Se mantienen los filtros de audiencia **Michis / Michi Lovers** como chips encima del grid.
- El sidebar usará **categorías planas** de primer nivel (sin subcategorías) para el MVP.
- Se conserva `source` (`owned` | `affiliate`) y se añade `productType` (`physical` | `link`).
- Las URLs de producto usan **slug amigable**: `/tienda/limpiador-dental-50-unidades`.
- Enfoque **MVP end-to-end**: schema, backend, frontend y admin en una sola pasada.

## Schema de base de datos
### Tabla nueva: `laschubys.categories`
```sql
id          uuid PK DEFAULT gen_random_uuid()
slug        text UNIQUE NOT NULL
name        text NOT NULL
sort_order  int DEFAULT 0
active      boolean DEFAULT true
```

### Cambios en `laschubys.products`
```sql
category_id   uuid REFERENCES laschubys.categories(id)
product_type  text CHECK (product_type IN ('physical', 'link'))
slug          text UNIQUE
```

### Backfill
- Productos existentes se asignan a una categoría por defecto `general`.
- `owned` → `product_type = 'physical'`.
- `affiliate` → `product_type = 'link'`.
- El `slug` se genera a partir del nombre en minúsculas, reemplazando espacios y caracteres especiales por guiones. Si colisiona, se añade un sufijo numérico.

## Backend API
### Público (`ContentController`)
- `GET /content/categories`  
  Lista categorías activas ordenadas por `sort_order`.
- `GET /content/products?category=slug&type=physical|link&audience=michis|michi-lovers&search=texto`  
  Listado filtrado y ordenado por `created_at DESC`.
- `GET /content/products/:slug`  
  Detalle de producto incluyendo `relatedProducts` (misma categoría, excluido el actual, límite 8).

### Admin
- DTOs `CreateProductDto` / `UpdateProductDto` aceptan `categoryId`, `productType` y `slug`.
- `AdminProductsController` propaga los nuevos campos y autogenera `slug` si no se envía.

## Frontend
### Rutas
```ts
{ path: 'tienda', loadComponent: () => import('./features/shop/shop.component').then(m => m.ShopComponent) }
{ path: 'tienda/:slug', loadComponent: () => import('./features/shop/product-detail.component').then(m => m.ProductDetailComponent) }
```

### Modelos
Extender `ProductPick` y `DbProduct` con:
```ts
slug: string;
categoryId?: string | null;
categoryName?: string;
productType: 'physical' | 'link';
relatedProducts?: ProductPick[];
```

### Componentes
- `CategorySidebarComponent` — lista de categorías; en móvil acordeón/drawer.
- `ProductCardComponent` — tarjeta reusable para listado, home y relacionados.
- `ProductGalleryComponent` — imagen principal + thumbnails.
- `ProductDetailComponent` — galería, info, CTA, descripción, productos relacionados.
- `ShopComponent` — layout sidebar + grid, chips de audiencia, búsqueda.

### Reutilización
- `ButtonComponent`, `BadgeComponent`, `CarouselComponent`, `SectionShellComponent`.
- `CarouselComponent` para productos relacionados.

### CTA según tipo
- `physical` + `owned` → **Agregar al carrito**.
- `link` / `affiliate` → **Ver en tienda** (abre `affiliateUrl`).

## Admin
- Formulario de producto añade selects de **Categoría** y **Tipo**.
- Tabla de productos muestra categoría y tipo.

## Datos de ejemplo
- Seed de 6-8 categorías:  
  `Alimentación`, `Cuidado`, `Juguetes`, `Descanso`, `Higiene`, `Accesorios`, `Para humanos`, `Otros`.
- Backfill de productos existentes para que no queden huérfanos.

## Verificación
- Backend: compilar sin errores (`npm run build`).
- Frontend: `npm run typecheck` y `npm run build` limpios.
- Flujo manual: navegar `/tienda`, cambiar categorías, abrir producto, ver relacionados, agregar físico al carrito, abrir link externo.

## Archivos clave
### Backend
- `LasChubys-Back/supabase/migrations/20260617_add_product_categories_and_type.sql`
- `LasChubys-Back/src/modules/admin/dto/product.dto.ts`
- `LasChubys-Back/src/modules/admin/admin-products.controller.ts`
- `LasChubys-Back/src/modules/content/content.controller.ts`
- `LasChubys-Back/src/shared/types/supabase.ts`

### Frontend
- `LasChubys-Front/src/app/app.routes.ts`
- `LasChubys-Front/src/app/core/models/content.model.ts`
- `LasChubys-Front/src/app/core/services/content.service.ts`
- `LasChubys-Front/src/app/features/shop/shop.component.ts`
- `LasChubys-Front/src/app/features/shop/product-card.component.ts`
- `LasChubys-Front/src/app/features/shop/product-detail.component.ts`
- `LasChubys-Front/src/app/features/shop/category-sidebar.component.ts`
- `LasChubys-Front/src/app/features/shop/product-gallery.component.ts`
- `LasChubys-Front/src/app/features/admin/products/admin-product-form.component.ts`
