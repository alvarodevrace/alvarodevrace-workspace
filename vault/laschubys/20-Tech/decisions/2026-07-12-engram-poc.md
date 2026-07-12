# PoC Engram como memoria persistente

## Contexto
Se evaluó Engram (https://github.com/Gentleman-Programming/engram) como sistema de memoria persistente para Kimi Code en Las Chubys.

## Decisión
**Funciona** — Engram se instaló correctamente, Kimi Code cargó el servidor MCP y fue capaz de guardar y recuperar memorias entre sesiones.

## Cómo se configuró
1. `brew install gentleman-programming/tap/engram` → instaló `engram 1.19.0`.
2. `engram doctor` → 4 checks OK, 0 warnings/errores.
3. `engram setup` no lista Kimi Code entre sus agentes soportados (lista OpenCode, Pi, Claude Code, Gemini CLI, Codex, Antigravity CLI, Windsurf, Qwen Code, Kiro IDE, Cursor, VS Code Copilot, Kilo Code).
4. Se creó manualmente la configuración MCP de Kimi Code en:
   - Ruta: `~/.kimi-code/mcp.json`
   - Contenido exacto:
     ```json
     {
       "mcpServers": {
         "engram": {
           "command": "engram",
           "args": ["mcp"]
         }
       }
     }
     ```
   > Documentación de referencia: Kimi Code CLI almacena declaraciones de servidores MCP en `~/.kimi-code/mcp.json` o en `.kimi-code/mcp.json` a nivel de proyecto, no en `config.toml`. ([Configuration files – Kimi Code Docs](https://www.kimi.com/code/docs/en/kimi-code-cli/configuration/config-files.html))
5. Se verificó que el servidor MCP responde:
   - `engram mcp` expone herramientas como `mem_save`, `mem_search`, `mem_context`, `mem_session_summary`, etc.

## Pruebas realizadas
- `engram --version` → `engram 1.19.0`
- `engram doctor` → OK
- `engram projects list` → inicialmente vacío; tras guardar la primera memoria aparece `laschubys-app`.
- Guardado desde `LasChubys-Front` con Kimi Code:
  - Prompt: *“Guarda en memoria que estamos usando Angular 21 SSR con Spartan NG.”*
  - Resultado: Engram guardó la observación ID `1` y sugirió topic key `config/stack-angular-21-ssr-con-spartan-ng`.
- Recuperación en una nueva sesión de Kimi Code en el mismo proyecto:
  - Prompt directo *“¿qué framework de UI usamos en Las Chubys?”* fue respondido desde `AGENTS.md` sin consultar Engram.
  - Prompt explícito *“Según la memoria persistente de Engram, ¿qué framework de UI usamos en Las Chubys?”* invocó `mcp__engram__mem_search` y recuperó correctamente: **Spartan NG sobre Angular 21 con SSR**.

## Problemas encontrados
- `engram setup` no incluye Kimi Code; la configuración MCP debe hacerse a mano.
- El nombre de proyecto que usa Engram se detecta desde el remote de git (`laschubys-app`), no desde el nombre de carpeta local (`LasChubys-Front`). Esto puede confundir si se espera que las memorias se agrupen por el nombre del directorio.
- Kimi Code no consulta Engram de forma proactiva para preguntas que ya puede responder desde el contexto actual (`AGENTS.md`). Para forzar el uso de la memoria persistente hay que pedírselo explícitamente.

## Próximos pasos
- Activar la misma configuración MCP en todos los proyectos de Las Chubys (la config global `~/.kimi-code/mcp.json` ya aplica, pero conviene documentarlo en el onboarding del equipo).
- Evaluar si merece la pena añadir `.kimi-code/mcp.json` a nivel de repositorio para que cualquier nuevo entorno de Kimi Code herede Engram automáticamente.
- Definir convenciones de qué decisiones/bugs/contextos deben guardarse en Engram para que la memoria persista entre sesiones y compresiones de contexto.
