# SOPS — Guía de uso

**Instalado:** `sops 3.13.1` + `age 1.3.1` (via homebrew Mac)
**Clave Age pública:** ver `INFRA-GLOBAL-2026-06.md#secretos-maestros--referencias-bitwarden`
**Clave Age privada:** `bitwarden:global/sops-age-key` | GitHub Secret: `SOPS_AGE_KEY`

> **Nota:** La clave pública se repite en los ejemplos de comandos a continuación por legibilidad; el valor vigente está en `INFRA-GLOBAL-2026-06.md`.

## Encriptar un .env

```bash
export SOPS_AGE_RECIPIENTS=age19kgpxyhgn8c0tv28lvqe0zws5k0pwhwnp79vsyy0tl2f0hjp0fps734wv6
/opt/homebrew/bin/sops --encrypt .env.prod > .env.prod.enc
# .env.prod → en .gitignore
# .env.prod.enc → commitear al repo
```

## Desencriptar

```bash
export SOPS_AGE_KEY_FILE=~/.age/alvarodevrace.txt
/opt/homebrew/bin/sops --decrypt .env.prod.enc > .env.prod
```

## En GitHub Actions (CI/CD)

```yaml
- name: Decrypt env
  run: |
    echo "${{ secrets.SOPS_AGE_KEY }}" > /tmp/age.key
    SOPS_AGE_KEY_FILE=/tmp/age.key sops --decrypt .env.prod.enc > .env.prod
```

## Repos configurados

| Repo | .sops.yaml | Estado |
|---|---|---|
| alvarodevrace/laschubys-app | ✅ | age key configurada |
| alvarodevrace/laschubys-api | ✅ | age key configurada (copiado 2026-06-05) |
