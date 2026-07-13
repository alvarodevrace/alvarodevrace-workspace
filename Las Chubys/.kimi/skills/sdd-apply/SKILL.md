# SDD Apply

> Implementa las tareas de la checklist.

## Cuándo usar

Después de `/sdd:tasks`, con aprobación de Álvaro.

## Pasos

1. Leer `tasks.md`, `specs.md` y `design.md`.
2. Ejecutar tareas en orden, marcando con `TodoList`.
3. Para cada tarea, preferir TDD cuando aplique.
4. Ejecutar scripts obligatorios del repo:
   - Front: `bun run typecheck`, `bun run test:ci`, `bun run build`
   - Back: `bun run typecheck`, `bun run test`, `bun run build`
5. No mergear; avisar a TRIN cuando esté listo para PR.

## Reglas

- Seguir specs y design.
- No añadir scope no pedido.
- Si surge un riesgo no contemplado, pausar y consultar a Álvaro/TRIN.
- Guardar progreso en Engram si la sesión es larga.
