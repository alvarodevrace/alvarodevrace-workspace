# Angular 21 — Estándar de Desarrollo (PIXEL)

Establecido el 2026-05-20 tras auditoría de código en Agrovivas, Brain PWA y Portfolio. Define la "Ley de Calidad" que PIXEL debe cumplir obligatoriamente para cualquier código nuevo.

## Patrones Obligatorios (A–H)

### A. ZONELESS
- **Apps nuevas** (sin código legacy): Zero Zone.js. Requiere todo en signals y componentes OnPush.
  ```typescript
  // app.config.ts
  import { provideExperimentalZonelessChangeDetection } from '@angular/core';
  export const appConfig: ApplicationConfig = {
    providers: [
      provideExperimentalZonelessChangeDetection(),
    ],
  };
  ```
- **Apps existentes con código mixto** (migración progresiva):
  ```typescript
  // app.config.ts
  import { provideZoneChangeDetection } from '@angular/core';
  export const appConfig: ApplicationConfig = {
    providers: [
      provideZoneChangeDetection({ eventCoalescing: true }),
    ],
  };
  ```
- **Regla**: Toda app nueva arranca sin Zone.js.

### B. SSR + HYDRATION
- **SPA privada / panel admin**: Sin SSR.
- **Sitios públicos / landings / portfolio**: SSR obligatorio con hidratación estable.
  ```typescript
  // app.config.ts (cliente)
  import { provideClientHydration, withEventReplay } from '@angular/platform-browser';
  export const appConfig: ApplicationConfig = {
    providers: [
      provideClientHydration(withEventReplay()),
    ],
  };
  ```
  ```typescript
  // app.config.server.ts (servidor)
  import { provideServerRendering } from '@angular/platform-server';
  const serverConfig: ApplicationConfig = {
    providers: [provideServerRendering()],
  };
  export const config = mergeApplicationConfig(appConfig, serverConfig);
  ```

### C. TIPADO ESTRICTO
- **Regla**: Prohibido usar `any` en la capa de servicios/API.
- Crear interfaces en `src/app/core/models/<entidad>.model.ts` antes de implementar el endpoint.

### D. DESTROYREF
- **Regla**: Prohibido usar `ngOnDestroy` con suscripciones manuales (`Subscription.unsubscribe()`) en componentes nuevos.
- Usar `takeUntilDestroyed` pasándole la referencia del `DestroyRef`:
  ```typescript
  private readonly destroyRef = inject(DestroyRef);
  ngOnInit() {
    this.service.obs$.pipe(takeUntilDestroyed(this.destroyRef)).subscribe(...);
  }
  ```
- Para event listeners en servicios:
  ```typescript
  constructor() {
    const destroyRef = inject(DestroyRef);
    const handler = () => {};
    document.addEventListener('visibilitychange', handler);
    destroyRef.onDestroy(() => document.removeEventListener('visibilitychange', handler));
  }
  ```

### E. `resource()`
- **Regla**: Usar `resource()` de Angular 21 para el manejo de estado asíncrono (loaders) en componentes nuevos en lugar de signals manuales con `loading` flag.
  ```typescript
  import { resource } from '@angular/core';
  clients = resource({
    loader: () => this.api.getClients(),
  });
  // expone: clients.value(), clients.isLoading(), clients.error()
  ```
- Con filtros reactivos:
  ```typescript
  filter = signal('active');
  clients = resource({
    request: () => ({ status: this.filter() }),
    loader: ({ request }) => this.api.getClientsPage({ status: request.status }),
  });
  ```

### F. `@defer`
- **Regla**: Obligatorio para componentes pesados (gráficos, tablas >20 filas) o secciones below-the-fold.
  ```html
  @defer (on viewport) {
    <ng-apexcharts [series]="chartData()"></ng-apexcharts>
  } @placeholder {
    <div class="h-64 animate-pulse rounded-xl bg-white/5"></div>
  }
  ```

### G. INYECCIÓN DE DEPENDENCIAS CONSISTENTE
- **Regla**: Usar únicamente la función `inject()`, prohibido el constructor DI en código nuevo.
- `NgZone` no se inyecta (removido por el esquema Zoneless).

### H. TAILWIND POR TIPO DE APP
- **Admin / SPA**: Tailwind v4.x (sintaxis `@import "tailwindcss"`).
- **Landings existentes con v3**: Tailwind v3.x (sintaxis `@tailwind base/components/utilities`).
- **Regla**: No mezclar versiones en el mismo repositorio.
