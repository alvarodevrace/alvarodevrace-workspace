# Content + Auth BFF — Las Chubys

Refactor aplicado el 2026-05-20 para consolidar contenido y auth detrás de `laschubys-api`.

## Objetivo

- Mover el frontend a patrón `Angular -> Nest API -> Supabase`.
- Evitar acceso directo del cliente Angular a `supabase-js` para contenido y sesión.
- Centralizar OAuth y comentarios autenticados en backend.

## Endpoints nuevos o consolidados

| Método | Ruta | Uso |
|---|---|---|
| `GET` | `/api/content/posts` | Listado de posts para blog |
| `GET` | `/api/content/posts/:slug` | Detalle de post |
| `GET` | `/api/content/products` | Catálogo tienda |
| `GET` | `/api/auth/google` | Inicio de OAuth Google |
| `GET` | `/api/auth/me` | Estado de sesión actual |
| `GET` | `/api/auth/logout` | Cierre de sesión |
| `POST` | `/api/comments` | Comentario autenticado vía cookie backend |

## Decisiones

- La sesión queda en cookies `httpOnly`; no exponer tokens al JS del navegador.
- SSR usa `apiServerUrl` para resolver `/api` durante render del servidor.
- El frontend consume `AuthService` y `ContentService` contra el BFF, no contra SQL ni Supabase directo.
- Se elimina dependencia de columnas inexistentes del schema real, como `products.audience`.

## Impacto técnico

- `ContentModule` concentra lectura de `posts`, `post detail` y `products`.
- `AuthService` Angular consulta `/api/auth/me` y `/api/auth/logout`.
- El callback OAuth se cierra en backend.
- Los comentarios autenticados reutilizan la misma sesión backend.

## Validación reportada en dump

- `apps/laschubys-api`: `npm run typecheck` OK, `npm run build` OK
- `apps/laschubys-ng`: `npm run typecheck` OK, `npm run build` OK

## Pendientes

- Probar login Google completo en navegador.
- Verificar `/api/auth/me`, comentario autenticado y logout.
- Evaluar limpieza de dependencias frontend ya no usadas.
