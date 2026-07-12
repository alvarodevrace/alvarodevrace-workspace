# Sistema de animaciones con Motion (Angular 21 SSR)

> **Fecha:** 2026-06-18  
> **Agente:** PIXEL  
> **Rama:** `feature/visual-refresh` (worktree local, aún no mergeada a `develop`)

## Propósito
Reemplazar/adicionar animaciones manuales por un sistema consistente, declarativo y SSR-safe basado en la librería [`motion`](https://motion.dev/) (v^12.38.0).

## Arquitectura

### Core: `MotionService`
- **Ubicación:** `src/app/shared/animations/motion.service.ts`
- **Pattern:** wrapper lazy alrededor de `motion`. La librería se importa dinámicamente con `import('motion')` para evitar que el bundle del servidor la cargue.
- **Inicialización:** `init()` debe llamarse dentro de `afterNextRender()` en componentes/ directivas que la usen.
- **Métodos expuestos:** `animate()`, `scroll()`, `inView()`, `hover()`, `prefersReducedMotion()`.
- **Accesibilidad:** respeta `prefers-reduced-motion` en todos los helpers.

### Modelos tipados
- **Ubicación:** `src/app/shared/animations/animations.model.ts`
- Define interfaces para configuración de reveals, parallax, stagger, tilt, marquee.

### Directivas declarativas
| Directiva | Uso |
|-----------|-----|
| `ScrollRevealDirective` | Animar entrada de elementos al hacer scroll (`scrollReveal`). |
| `ParallaxDirective` | Efecto parallax ligero vinculado al scroll (`parallaxIntensity`). |
| `StaggerChildrenDirective` | Animar hijos secuencialmente (`staggerChildren`, `staggerDelay`). |
| `TiltCardDirective` | Tilt 3D sutil al hover (solo desktop, detecta touch). |
| `TextRevealDirective` | Revelado de texto letra por letra o palabra por palabra. |

### Componentes animados reutilizables
- `AnimatedHeroComponent` — hero con textos/CTAs animados.
- `AnimatedCardComponent` — card con hover lift + tilt opcional.
- `AnimatedSectionComponent` — wrapper de sección con reveal y stagger.

### Utilidades
- `is-touch-device.ts` — detecta si el dispositivo es táctil para deshabilitar efectos que no apliquen.
- `MarqueeComponent` — carrusel infinito horizontal/vertical.

## Convenciones
- Las directivas usan inputs con nombres descriptivos (`scrollReveal`, `staggerChildren`) para evitar colisiones con otros sistemas de animación.
- Todo efecto se limpia en `ngOnDestroy` usando el cleanup devuelto por `motion`.
- No se ejecutan animaciones durante el SSR; el DOM hidratado se anima solo en el cliente.

## Integración en páginas
- `HomeComponent`
- `AboutComponent`
- `BlogListComponent` / `BlogDetailComponent`
- `ContactComponent`
- `ShopComponent` / `CheckoutComponent`

## Límites y decisiones
- **Bundle:** initial bundle ~703 kB / límite 750 kB. `motion` se carga lazy vía `MotionService`.
- **SSR:** `MotionService` no inicializa en servidor; los elementos se renderizan estáticamente y animan tras hidratación.
- **Accesibilidad:** `prefers-reduced-motion` desactiva transiciones.

## Pendientes
- Validar performance real en mobile con Lighthouse.
- Decidir si se mantiene `motion` o se migra parcialmente a CSS nativo para animaciones simples.
- Documentar ejemplos de uso una vez aprobado visualmente por Álvaro.
