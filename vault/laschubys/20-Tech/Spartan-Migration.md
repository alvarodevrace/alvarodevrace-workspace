# Las Chubys — Migración a spartan.ng

> **SSOT** para la migración de la UI del frontend (`LasChubys-Front`) a spartan.ng.
> **Rama/worktree:** `feature-visual-refresh` en `.worktrees/feature-visual-refresh`.
> **Última actualización:** 2026-06-19 (PIXEL).
> **Estado global:** typecheck ✅ 0 errores | build ✅ 0 errores, 0 warnings (`CI=1 bun run build`).

---

## Áreas migradas

| Área | Archivos |
|---|---|
| **Static pages** | `src/app/features/static/about.component.ts`<br>`src/app/features/static/contact.component.ts`<br>`src/app/features/static/servicios.component.ts`<br>`src/app/features/media-kit/media-kit.component.ts` |
| **Blog** | `src/app/features/blog/blog-list.component.ts`<br>`src/app/features/blog/blog-detail.component.ts`<br>`src/app/features/blog/components/blog-post-card.component.ts`<br>`src/app/features/blog/components/comments.component.ts` |
| **Tienda** | `src/app/features/shop/shop.component.ts`<br>`src/app/features/shop/product-card.component.ts`<br>`src/app/features/shop/product-detail.component.ts`<br>`src/app/features/shop/product-gallery.component.ts`<br>`src/app/features/shop/category-sidebar.component.ts` |
| **Carrito / Checkout / Auth** | `src/app/features/cart/cart.component.ts`<br>`src/app/features/cart/cart-item-row.component.ts`<br>`src/app/features/checkout/checkout.component.ts`<br>`src/app/features/auth/auth-login.component.ts`<br>`src/app/features/auth/auth-callback.component.ts` |
| **Admin** | `src/app/features/admin/admin-layout.component.ts`<br>`src/app/features/admin/admin-dashboard.component.ts`<br>`src/app/features/admin/products/admin-products.component.ts`<br>`src/app/features/admin/products/admin-product-form.component.ts`<br>`src/app/features/admin/posts/admin-posts.component.ts`<br>`src/app/features/admin/posts/admin-post-form.component.ts`<br>`src/app/features/admin/shared/image-uploader.component.ts`<br>`src/app/features/admin/ui-playground.component.ts` |
| **Shared** | `src/app/shared/components/cart-drawer/cart-drawer.component.ts` + `.html`<br>`src/app/shared/components/footer/footer.component.ts` + `.html`<br>`src/app/shared/components/header/header.component.ts`<br>`src/app/shared/components/whatsapp-float/whatsapp-float.component.ts`<br>`src/app/shared/ui/carousel/carousel.component.ts` |

---

## Mapeo de componentes (wrapper antiguo → spartan)

| Wrapper anterior | spartan.ng | Notas |
|---|---|---|
| `app-button` | `hlmBtn` (`<button hlmBtn>` / `<a hlmBtn>`) | primary → `default`; secondary → `outline`. |
| `app-card` | `hlm-card` (`<div hlmCard>`, `<div hlmCardContent>`, `<div hlmCardFooter>`) | Se usan los selectores de atributo porque spartan no expone tags para subelementos. |
| `app-badge` | `hlmBadge` | default → `default`; usar `variant` en lugar de clases de color dinámicas. |
| `app-input` | `hlmInput` + `hlmLabel` | Inputs, textareas y selects nativos reemplazados. |
| Inputs/selects nativos | `hlmInput` / `hlmTextarea` / `hlm-select` / `hlmInputGroup` | Buscador de tienda usa `hlmInputGroup`. |
| Modales de confirmación | `hlm-dialog` + `hlmDialogPortal` | Requiere importar `HlmDialogImports` completo. |
| Toggle de activo | `hlm-switch` | Usado en `admin-product-form`. |
| Skeletons manuales | `hlmSkeleton` | Blog, media-kit. |
| Tabs admin | `hlm-tabs` | `admin-layout` con variant `line`. |

---

## Decisiones clave

1. **Íconos:** se mantiene `lucide-angular`; no se migra a `ng-icons`. SVGs inline se conservan en admin para no ampliar el `LucideAngularModule.pick` global.
2. **Colores:** migración de naranja custom (`text-orange`, `bg-orange`, `#fff4e8`, `#ff7a1a`, `#e06300`, etc.) a tokens spartan:
   - `text-orange` / `#ff7a1a` → `text-primary`
   - `bg-orange*` / `#fff1e5` / `#fff7ed` → `bg-amber-50` / `bg-primary`
   - `border-orange` → `border-primary`
   - `text-orange-dark` / `#e06300` → `text-amber-700`
   - Sombras naranjas custom → `shadow-sm/md/lg/xl`
3. **Botones:** limpieza de overrides (`rounded-full`, `px-7/8/6`, `h-12`, `min-h-12`, colores manual, sombras, transiciones, etc.). Text-links tipo "Ver todo →" se convierten a `hlmBtn variant="link"`.
4. **Cards:** eliminados bordes/fondos/gradientes custom (`border-primary/[0.14]`, `bg-gradient-to-br`, `hover:shadow-[...]` con tintes). Contenedores vacíos/error convertidos a `hlmCard`.
5. **Badges:** eliminados overrides de tamaño/color dinámico en filtros de tienda; product detail usa `variant`.
6. **WhatsApp float:** convertido a `<a>` plano con estilo de marca propio, sin mezclar `hlmBtn` con colores WhatsApp custom.
7. **Header:** ya usaba `hlmNavigationMenu`; se verificó limpieza sin overrides de color en botones.
8. **Animaciones:** se preservaron todas las directivas Motion (`appScrollReveal`, `appParallax`, `appStaggerChildren`, `appTiltCard`, `appTextReveal`) y micro-interacciones.
9. **Idempotencia:** añadido guard en `ContactComponent.submit()` (`if (this.pending() || this.contactForm.invalid) return;`).
10. **Semántica:** en media-kit los `<a>` que envolvían `<app-button>` ahora usan directamente `<a hlmBtn>`, corrigiendo `<button>` dentro de `<a>`.
11. `standalone: true` se mantiene en todos los componentes.

---

## Estado de verificación

| Fecha | Comando | Resultado |
|---|---|---|
| 2026-06-18 | `bun run typecheck` | ✅ 0 errores |
| 2026-06-18 | `bun run build` | ⚠️ Fallaba por errores en Admin/Blog (preexistentes a la revisión final) |
| 2026-06-19 | `bun run typecheck` | ✅ 0 errores |
| 2026-06-19 | `CI=1 bun run build` | ✅ 0 errores, 0 warnings |

---

## Pendientes / notas

- Algunos icon-containers raw (contacto, media-kit) conservan `bg-primary/10 text-primary` porque no son componentes spartan; se considera aceptable para la identidad visual.
- WhatsApp float mantiene estilo de marca propio.
- No se hizo push desde PIXEL; integración a `develop` → `main` es responsabilidad de TRIN con PR y aprobación de Álvaro.
- Verificar en producción tras purgar Cloudflare cache (producción puede estar en modo construcción según `environment.underConstruction`).

---

## Relacionado

- [Angular-BFF.md](./Angular-BFF.md) — stack actual y cut-over.
- [Motion-Animations.md](./Motion-Animations.md) — sistema de animaciones SSR-safe.
