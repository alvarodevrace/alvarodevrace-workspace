# Task 5 — Reporte: Limpiar `vault/portfolio/40-Credentials/INFRA.md`

## Archivo modificado
- `vault/portfolio/40-Credentials/INFRA.md`

## Cambios aplicados

1. **Tabla de servicios:**
   - Se eliminó el ID del proyecto Dokploy (`oSVdXwFYGekg16v18XNW1`) y el ID de la aplicación Dokploy (`r9HA2pNx6Uiip1sYJ8ubg`), reemplazándolos por una referencia a `vault/INFRA-GLOBAL-2026-06.md` → proyecto `portfolio`.
   - Se eliminó la zona `alvarodevrace.tech` de Cloudflare, reemplazándola por referencia a `vault/INFRA-GLOBAL-2026-06.md`.
   - Se eliminó la URL de la app duplicada, reemplazándola por referencia a `vault/INFRA-GLOBAL-2026-06.md` → app `alvaro-portfolio`.
   - Se conservaron datos propios del proyecto: GitHub repo, SSH remote, Dokploy environment ID, Formspree, Sentry y todas las credenciales de Planka.

2. **Snippet de deploy manual:**
   - Se reemplazó el ID de aplicación hardcodeado por una variable `APP_ID` con indicación de consultar `INFRA-GLOBAL-2026-06.md`.
   - Se cambió la URL del endpoint de `http://100.105.133.25:3000` a `https://dokploy.alvarodevrace.tech`.

## Validación

Comando ejecutado:

```bash
rg -n -g 'vault/portfolio/40-Credentials/INFRA.md' 'oSVdXwFYGekg16v18XNW1|r9HA2pNx6Uiip1sYJ8ubg|2a17143e03abfec70bd29db73b74fecf'
```

Resultado: **sin coincidencias** (salida vacía), como se esperaba.

## Estado
**DONE**
