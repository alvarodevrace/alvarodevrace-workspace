## Task 11: Limpiar IDs globales restantes en wiki de Las Chubys

**Files:**
- Modify: `vault/laschubys/20-Tech/Supabase.md`
- Modify: `vault/laschubys/20-Tech/Angular-BFF.md`

**Interfaces:**
- Consumes: `vault/INFRA-GLOBAL-2026-06.md`.
- Produces: wiki del proyecto sin IDs/URLs globales duplicados.

- [ ] **Step 1: Read both files**

- [ ] **Step 2: Clean `vault/laschubys/20-Tech/Supabase.md`**

  In the "Referencias" section, replace:
  - URL `https://db.alvarodevrace.tech` with `Ver \`vault/INFRA-GLOBAL-2026-06.md\``.
  - Dokploy compose ID `KmZPDb3xeY_wZqNjpIAOT` with `Ver \`vault/INFRA-GLOBAL-2026-06.md\``.
  - Dokploy project `database` (`HTxz4FLFZ-FFasumznhf2`) with `Ver \`vault/INFRA-GLOBAL-2026-06.md\``.

  In the "Credenciales" section, replace:
  - URL `https://db.alvarodevrace.tech` with `Ver \`vault/INFRA-GLOBAL-2026-06.md\``.

- [ ] **Step 3: Clean `vault/laschubys/20-Tech/Angular-BFF.md`**

  In the "Dokploy — Deploy" table, replace the ID literals for `laschubys-app`, `laschubys-api`, and project `laschubys` with `Ver \`vault/INFRA-GLOBAL-2026-06.md\``.

- [ ] **Step 4: Validate**

  Run:
  ```bash
  rg -n -g '*.md' 'HTxz4FLFZ-FFasumznhf2|KmZPDb3xeY_wZqNjpIAOT|XX0AfFKhYHn9ayErXevJF|GzBwWmUjlYRCgfMK6tzBt|dcZfubBCdj1wno5hroswj|https://db\.alvarodevrace\.tech' vault/laschubys/20-Tech/
  ```
  Expected: empty output.

- [ ] **Step 5: Write report**

  Write report to `docs/superpowers/sdd/reports/task-11-report.md`.
