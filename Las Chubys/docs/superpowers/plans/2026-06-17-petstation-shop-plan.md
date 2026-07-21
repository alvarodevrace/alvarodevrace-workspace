# PetStation-style shop — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` or dispatch focused `coder` subagents per subsystem. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the LasChubys shop into a PetStation-style experience: category sidebar + product grid, product detail page with gallery and related products, backed by a real `categories` table, product `slug` and `productType`.

**Architecture:** Add a `categories` table and extend `products` in Supabase; expose public endpoints for categories, filtered products and product detail with related items; update the Angular shop list, product card, detail page and admin form; reuse existing UI components (`CarouselComponent`, `ButtonComponent`, `BadgeComponent`, `SectionShellComponent`).

**Tech Stack:** NestJS 11 / Supabase (backend), Angular 21 standalone signals / Tailwind CSS (frontend).

---

## File map

| File | Responsibility |
|------|----------------|
| `LasChubys-Back/supabase/migrations/20260617_add_product_categories_and_type.sql` | Schema changes + seed categories + backfill existing products |
| `LasChubys-Back/src/shared/types/supabase.ts` | Regenerated Supabase types |
| `LasChubys-Back/src/modules/admin/dto/product.dto.ts` | `categoryId`, `productType`, `slug` DTO fields + validation |
| `LasChubys-Back/src/modules/admin/admin-products.controller.ts` | Propagate new fields; auto-generate slug |
| `LasChubys-Back/src/modules/content/content.controller.ts` | Public `GET /content/categories`, filtered `GET /content/products`, `GET /content/products/:slug` with related |
| `LasChubys-Front/src/app/core/models/content.model.ts` | Extend `ProductPick`/`DbProduct` types |
| `LasChubys-Front/src/app/core/services/content.service.ts` | New service methods |
| `LasChubys-Front/src/app/app.routes.ts` | Add `/tienda/:slug` route |
| `LasChubys-Front/src/app/features/shop/category-sidebar.component.ts` | Sidebar of categories (mobile accordion) |
| `LasChubys-Front/src/app/features/shop/product-card.component.ts` | Reusable product card |
| `LasChubys-Front/src/app/features/shop/product-gallery.component.ts` | Main image + thumbnails |
| `LasChubys-Front/src/app/features/shop/product-detail.component.ts` | Detail page with gallery, info, CTA, related products |
| `LasChubys-Front/src/app/features/shop/shop.component.ts` | Sidebar + grid + audience chips + search |
| `LasChubys-Front/src/app/features/admin/products/admin-product-form.component.ts` | Add category/type selects |
| `LasChubys-Front/src/app/features/admin/products/admin-products.component.ts` | Show category/type columns |

---

## Task 1 — Backend schema + seed

**Files:**
- Create: `LasChubys-Back/supabase/migrations/20260617_add_product_categories_and_type.sql`

**Steps:**
- [ ] Write migration that:
  - Creates `laschubys.categories` table (`id`, `slug`, `name`, `sort_order`, `active`).
  - Adds `category_id`, `product_type`, `slug` columns to `laschubys.products`.
  - Inserts seed categories: `alimentacion`, `cuidado`, `juguetes`, `descanso`, `higiene`, `accesorios`, `para-humanos`, `otros`.
  - Backfills existing products: assign to `otros`, set `product_type` from `source` (`owned` → `physical`, `affiliate` → `link`), generate slugs from name.
  - Adds FK and indexes.
- [ ] Verify migration SQL syntax with `psql` dry-run if possible, otherwise visually.
- [ ] **Commit**.

**Verification:** migration file exists and applies cleanly (will be validated when backend builds).

---

## Task 2 — Backend DTOs + admin controller

**Files:**
- Modify: `LasChubys-Back/src/modules/admin/dto/product.dto.ts`
- Modify: `LasChubys-Back/src/modules/admin/admin-products.controller.ts`

**Steps:**
- [ ] Add to `CreateProductDto` / `UpdateProductDto`:
  - `categoryId?: string` (optional UUID string).
  - `productType?: 'physical' | 'link'` with `@IsIn`.
  - `slug?: string` (optional, validated as slug-like string).
- [ ] In `AdminProductsController.create`:
  - If `slug` not provided, generate from `name`: lowercase, replace non-alphanumeric with `-`, collapse dashes, trim; if collision, append `-2`, `-3`, etc.
  - Pass `categoryId`, `productType`, `slug` to the Supabase insert.
- [ ] In `update` propagate the same fields.
- [ ] Build backend: `cd LasChubys-Back && npm run build`.
- [ ] **Commit**.

**Verification:** `npm run build` in backend passes with 0 errors.

---

## Task 3 — Backend public content API

**Files:**
- Modify: `LasChubys-Back/src/modules/content/content.controller.ts`

**Steps:**
- [ ] Add type `DbCategory` and update `DbProduct` to include `category_id`, `product_type`, `slug`.
- [ ] Add `GET /content/categories` returning active categories ordered by `sort_order`.
- [ ] Update `GET /content/products`:
  - Accept optional query params: `category` (slug), `type` (`physical` | `link`), `audience` (`michis` | `michi-lovers`), `search`.
  - If `category` provided, join/filter by category slug.
  - If `type` provided, filter by `product_type`.
  - Keep existing audience keyword classification if no DB audience column exists.
  - If `search` provided, filter by name/copy/description/tag.
- [ ] Add `GET /content/products/:slug`:
  - Return single product by slug including `relatedProducts` (same category, active, excluding self, limit 8).
- [ ] Update `toProductView` to include `categoryId`, `categoryName`, `productType`, `slug`.
- [ ] Build backend.
- [ ] **Commit**.

**Verification:** `npm run build` passes; endpoints can be smoke-tested via curl (`/api/content/categories`, `/api/content/products`, `/api/content/products/:slug`).

---

## Task 4 — Frontend models + content service

**Files:**
- Modify: `LasChubys-Front/src/app/core/models/content.model.ts`
- Modify: `LasChubys-Front/src/app/core/services/content.service.ts`

**Steps:**
- [ ] Extend `ProductPick`:
  ```ts
  slug: string;
  categoryId?: string | null;
  categoryName?: string;
  productType: 'physical' | 'link';
  relatedProducts?: ProductPick[];
  ```
- [ ] Extend `DbProduct` with matching fields.
- [ ] Add `Category` interface:
  ```ts
  export interface Category { id: string; slug: string; name: string; sortOrder: number; active: boolean; }
  ```
- [ ] Add to `ContentService`:
  - `getCategories()` → `GET /content/categories`.
  - `getProducts(filters?: { category?: string; type?: 'physical'|'link'; audience?: 'michis'|'michi-lovers'; search?: string })`.
  - `getProduct(slug: string)` → `GET /content/products/:slug`.
- [ ] Typecheck frontend: `cd LasChubys-Front && npm run typecheck`.
- [ ] **Commit**.

**Verification:** `npm run typecheck` passes.

---

## Task 5 — Angular routes + category sidebar

**Files:**
- Modify: `LasChubys-Front/src/app/app.routes.ts`
- Create: `LasChubys-Front/src/app/features/shop/category-sidebar.component.ts`

**Steps:**
- [ ] Add route:
  ```ts
  { path: 'tienda/:slug', loadComponent: () => import('./features/shop/product-detail.component').then(m => m.ProductDetailComponent) }
  ```
- [ ] Create `CategorySidebarComponent`:
  - Input `categories: Category[]` and `activeSlug: string`.
  - Render list of category buttons/links.
  - On mobile, render as collapsible accordion with a "Categorías" trigger.
  - Use Tailwind; active category styled with `bg-orange text-white`.
- [ ] Typecheck.
- [ ] **Commit**.

**Verification:** `npm run typecheck` passes.

---

## Task 6 — Reusable product card

**Files:**
- Modify: `LasChubys-Front/src/app/features/shop/product-card.component.ts`

**Steps:**
- [ ] Refactor `ProductCardComponent` to accept `ProductPick` and emit `preview`/`add`.
- [ ] Display: image (aspect-square, object-cover), badge source/type, name, price, CTA row.
- [ ] CTA logic:
  - `productType === 'physical'` → "Agregar" button.
  - `productType === 'link'` → "Ver tienda" link button opening `affiliateUrl`.
- [ ] Add click on card body (excluding buttons) navigates to `/tienda/:slug`.
- [ ] Typecheck.
- [ ] **Commit**.

**Verification:** `npm run typecheck` passes.

---

## Task 7 — Shop list page (sidebar + grid + audience chips)

**Files:**
- Modify: `LasChubys-Front/src/app/features/shop/shop.component.ts`

**Steps:**
- [ ] Load categories via `resource()` and products via `resource()` with query params.
- [ ] Layout: two columns on desktop (`aside` sidebar + `main` grid); stacked on mobile.
- [ ] Main area:
  - Keep audience chips (Todo / Para Michis / Michi Lovers).
  - Keep search input.
  - Render `ProductCardComponent` grid (`grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4`).
- [ ] Empty state reuses existing orange block with clear "no products" message.
- [ ] Update breadcrumb/title to reflect active category if any.
- [ ] Typecheck.
- [ ] **Commit**.

**Verification:** `npm run typecheck` passes.

---

## Task 8 — Product detail page

**Files:**
- Create: `LasChubys-Front/src/app/features/shop/product-detail.component.ts`
- Create: `LasChubys-Front/src/app/features/shop/product-gallery.component.ts`

**Steps:**
- [ ] Create `ProductGalleryComponent`:
  - Inputs: `images: string[]`.
  - State: selected index signal.
  - Main image large; thumbnails below; click thumbnail updates main.
- [ ] Create `ProductDetailComponent`:
  - Read `:slug` param, load product via `resource()`.
  - Show breadcrumb (Inicio › Tienda › Categoría › Producto).
  - Two-column layout: gallery left, info right.
  - Info: name, price, category badge, type badge, description.
  - CTA: physical → "Agregar al carrito"; link → "Ver en tienda" external.
  - Section "Productos relacionados" using `CarouselComponent` with `ProductCardComponent` template.
  - SEO via `SeoService`.
- [ ] Typecheck.
- [ ] **Commit**.

**Verification:** `npm run typecheck` passes.

---

## Task 9 — Admin product form + list

**Files:**
- Modify: `LasChubys-Front/src/app/features/admin/products/admin-product-form.component.ts`
- Modify: `LasChubys-Front/src/app/features/admin/products/admin-products.component.ts`

**Steps:**
- [ ] Load categories in admin form and show `<select>` for category.
- [ ] Add `<select>` for `productType` (`physical` / `link`).
- [ ] Show/auto-generate `slug` input (editable).
- [ ] In admin products list, add columns for category and type.
- [ ] Typecheck.
- [ ] **Commit**.

**Verification:** `npm run typecheck` passes.

---

## Task 10 — Full build + smoke test

**Files:** all above

**Steps:**
- [ ] Run `npm run typecheck` in `LasChubys-Front`.
- [ ] Run `npm run build` in `LasChubys-Front` (production SSR).
- [ ] Run `npm run build` in `LasChubys-Back`.
- [ ] Apply migration if possible / verify migration syntax.
- [ ] Smoke-test endpoints:
  - `curl /api/content/categories`
  - `curl /api/content/products?category=accesorios`
  - `curl /api/content/products/<slug>`
- [ ] Run dev server and manually verify: sidebar filters, click product → detail, related products carousel, "Agregar al carrito" / "Ver en tienda" CTAs.
- [ ] **Commit**.

**Verification:** all builds pass, endpoints respond, manual flow works.

---

## Implementation notes for agents

- Keep using Tailwind CSS and the existing color tokens (`text-orange`, `bg-[#fff4e8]`, etc.).
- Preserve Angular 21 patterns: standalone components, `inject()`, signals, `resource()`, `@if/@for`, `track`.
- Do not remove existing audience chips; they must coexist with the category sidebar.
- For the slug generator, reuse or add a small shared helper in backend.
- If Supabase CLI is unavailable to apply the migration, still write the migration file; the backend should tolerate existing data via the backfill.
