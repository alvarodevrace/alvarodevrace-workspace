## Task 8: Sincronizar catálogo de skills

**Files:**
- Modify: `~/.kimi-code/skills/KIMI-MASTER-SKILLS.md`
- Delete: `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md`

**Interfaces:**
- Consumes: `vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md`.
- Produces: skill global actualizada y duplicado vault eliminado.

- [ ] **Step 1: Read both files**

  Run:
  ```bash
  Read ~/.kimi-code/skills/KIMI-MASTER-SKILLS.md
  Read vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md
  ```

- [ ] **Step 2: Write updated global skill**

  Create a Python script to transform the vault file into the new global file:

  ```python
  #!/usr/bin/env python3
  import re, pathlib
  src = pathlib.Path('vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md').read_text()
  # Replace obsolete references
  src = src.replace('Coolify', 'Dokploy')
  src = src.replace('coolify', 'dokploy')
  src = src.replace('coolify-api-token', 'dokploy-api-token')
  src = src.replace('coolify-manager', 'dokploy-manager')
  # Remove eliminated projects and their rows
  eliminated = ['agrovivas', 'jauria', 'cobroslatam', 'utilboxes', 'agentoffice', 'brain']
  for p in eliminated:
      src = re.sub(r'\|\s*~~?' + p + r'~~?\s*\|.*?\n', '', src, flags=re.IGNORECASE)
      src = re.sub(r'\|\s*' + p + r'\s*\|.*?\n', '', src, flags=re.IGNORECASE)
  # Remove obsolete paths
  src = src.replace('.codex/', '.kimi/')
  src = src.replace('.claude/', '.kimi/')
  # Update outdated deployment note
  src = src.replace('Coolify deploy automático', 'Dokploy deploy automático')
  src = src.replace('Coolify API Token', 'Dokploy API Key')
  src = src.replace('Deploy manual de emergencia (Coolify)', 'Deploy manual de emergencia (Dokploy)')
  src = re.sub(r'https://coolify\.alvarodevrace\.tech/api/v1/deploy\?uuid=<COOLIFY_UUID>', 'https://dokploy.alvarodevrace.tech/api/application.deploy', src)
  # Write output
  pathlib.Path('~/.kimi-code/skills/KIMI-MASTER-SKILLS.md').expanduser().write_text(src)
  print('done')
  ```

  Run:
  ```bash
  python3 /tmp/sync_skills.py
  ```

- [ ] **Step 3: Delete vault duplicate**

  Run:
  ```bash
  rm vault/alvarodevrace/20-Tech/KIMI-SKILLS-MASTER.md
  ```

- [ ] **Step 4: Validate global skill**

  Run:
  ```bash
  rg -n -i -g '*.md' 'coolify|codex|claude|agrovivas|jauria|cobroslatam|utilboxes|agentoffice|brain' ~/.kimi-code/skills/KIMI-MASTER-SKILLS.md | head -20
  ```
  Expected: no hits for eliminated projects; possibly "coolify" only inside historical notes if any remain.

---
