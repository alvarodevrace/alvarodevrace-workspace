# VPS Health Check — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Create a local macOS watchdog that probes the Hostinger VPS via TCP 443 and curls critical public URLs, showing a native notification if anything is unreachable.

**Architecture:** A shell script performs the checks and emits macOS notifications via `osascript`. A `launchd` LaunchAgent runs the script at user login and every 30 minutes. A small installer registers the agent. State is tracked in `/tmp/vps-health-status.json` to avoid notification spam.

**Tech Stack:** bash, `osascript`, `launchd`, TCP connection, `curl`.

## Global Constraints

- macOS only.
- No external services or credentials.
- Short timeouts: 3s TCP probe, 5s curl.
- Notify only on `healthy → unhealthy` transition or once per 60 minutes while unhealthy.
- Silent on success.
- Keep files small and focused.

---

## File Map

| File | Responsibility |
|------|----------------|
| `scripts/vps-health-check.sh` | Performs TCP/HTTP checks and shows macOS notification when needed. |
| `scripts/com.alvarodevrace.vps-health-check.plist` | launchd definition: run at login and every 30 minutes. |
| `scripts/install-vps-health-check.sh` | Copies script to `~/.local/bin/`, copies plist to `~/Library/LaunchAgents/`, patches absolute path, bootstraps agent. |

---

### Task 1: Health check script

**Files:**
- Create: `scripts/vps-health-check.sh`

**Interfaces:**
- Consumes: none.
- Produces: stdout log line on failure; macOS notification via `osascript`; state file `/tmp/vps-health-status.json`.

- [x] **Step 1: Create the script with checks and notification logic**

Create `scripts/vps-health-check.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="/tmp/vps-health-status.json"

TCP_HOST="72.60.26.201"
TCP_PORT="443"
URLS=(
  "https://laschubys.com"
  "https://api.laschubys.com/api/health"
  "https://n8n.alvarodevrace.tech"
)

failures=()

# macOS does not ship GNU `timeout`; emulate it in pure Bash.
run_with_timeout() {
  local secs=$1
  shift
  local pid rc=0
  "$@" &
  pid=$!
  (sleep "$secs"; kill "$pid" 2>/dev/null) &
  local killer=$!
  wait "$pid" || rc=$?
  kill "$killer" 2>/dev/null || true
  wait "$killer" 2>/dev/null || true
  return "$rc"
}

# TCP connectivity check (VPS blocks ICMP, so use port 443)
if ! run_with_timeout 3 bash -c "cat < /dev/null > /dev/tcp/${TCP_HOST}/${TCP_PORT}" >/dev/null 2>&1; then
  failures+=("tcp ${TCP_HOST}:${TCP_PORT}")
fi

# HTTP checks
for url in "${URLS[@]}"; do
  code=$(curl -sL -o /dev/null --max-time 5 -w "%{http_code}" "${url}" 2>/dev/null || echo "000")
  if [[ ! "${code}" =~ ^[23] ]]; then
    failures+=("${url} -> ${code}")
  fi
done

# Read previous state
prev_healthy=true
last_alert_ts=0
now_ts=$(date +%s)
if [[ -f "${STATE_FILE}" ]]; then
  prev_healthy=$(python3 -c "import json,sys; d=json.load(open('${STATE_FILE}')); print('true' if d.get('healthy',True) else 'false')" 2>/dev/null || echo true)
  last_alert_ts=$(python3 -c "import json,sys; d=json.load(open('${STATE_FILE}')); print(d.get('last_alert_ts',0))" 2>/dev/null || echo 0)
fi

healthy=true
if [[ ${#failures[@]} -gt 0 ]]; then
  healthy=false
fi

should_notify=false
if [[ "${healthy}" == "false" ]]; then
  if [[ "${prev_healthy}" == "true" ]]; then
    should_notify=true
  elif (( now_ts - last_alert_ts > 3600 )); then
    should_notify=true
  fi
fi

healthy_bool=$([[ "$healthy" == "true" ]] && echo "True" || echo "False")

if [[ "${should_notify}" == "true" ]]; then
  timestamp=$(date +%Y-%m-%dT%H:%M:%S%z)
  echo "[${timestamp}] VPS health check FAILED: ${#failures[@]} failure(s)"
  printf '  - %s\n' "${failures[@]}"
  body=$(printf '%s\n' "${failures[@]}")
  escaped_body=${body//\\/\\\\}
  escaped_body=${escaped_body//\"/\\\"}
  if osascript -e "display notification \"${escaped_body}\" with title \"VPS / servicio caído\" sound name \"Ping\""; then
    echo "[$(date +%Y-%m-%dT%H:%M:%S%z)] Notification dispatched"
    last_alert_ts=${now_ts}
  fi
fi

# Write state
python3 - <<PY || true
import json
with open("${STATE_FILE}", "w") as f:
    json.dump({"healthy": ${healthy_bool}, "last_alert_ts": ${last_alert_ts}, "checked_at": ${now_ts}}, f)
PY
```

- [x] **Step 2: Make it executable**

Run:

```bash
chmod +x scripts/vps-health-check.sh
```

- [x] **Step 3: Manual test while healthy**

Run:

```bash
./scripts/vps-health-check.sh
```

Expected: no output, no notification, and `/tmp/vps-health-status.json` shows `"healthy": true`.

- [x] **Step 4: Commit**

```bash
git add scripts/vps-health-check.sh
git commit -m "feat(monitoring): add local macOS VPS health check script"
```

---

### Task 2: LaunchAgent plist

**Files:**
- Create: `scripts/com.alvarodevrace.vps-health-check.plist`

**Interfaces:**
- Consumes: `scripts/vps-health-check.sh` (absolute path patched by installer).
- Produces: scheduled execution by `launchd`.

- [x] **Step 1: Create the plist template**

Create `scripts/com.alvarodevrace.vps-health-check.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.alvarodevrace.vps-health-check</string>
    <key>ProgramArguments</key>
    <array>
        <string>__SCRIPT_PATH__</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartInterval</key>
    <integer>1800</integer>
    <key>StandardOutPath</key>
    <string>/tmp/vps-health-check.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/vps-health-check.error.log</string>
</dict>
</plist>
```

- [x] **Step 2: Commit**

```bash
git add scripts/com.alvarodevrace.vps-health-check.plist
git commit -m "feat(monitoring): add launchd agent for VPS health check"
```

---

### Task 3: Installer script

**Files:**
- Create: `scripts/install-vps-health-check.sh`

**Interfaces:**
- Consumes: `scripts/vps-health-check.sh`, `scripts/com.alvarodevrace.vps-health-check.plist`.
- Produces: installed script in `~/.local/bin/vps-health-check.sh` and loaded LaunchAgent in `~/Library/LaunchAgents/`.

- [x] **Step 1: Create installer**

Create `scripts/install-vps-health-check.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_SOURCE="${REPO_ROOT}/scripts/vps-health-check.sh"
SCRIPT_TARGET="${HOME}/.local/bin/vps-health-check.sh"
PLIST_SOURCE="${REPO_ROOT}/scripts/com.alvarodevrace.vps-health-check.plist"
PLIST_TARGET="${HOME}/Library/LaunchAgents/com.alvarodevrace.vps-health-check.plist"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: this installer is for macOS only." >&2
  exit 1
fi

if [[ ! -f "${SCRIPT_SOURCE}" ]]; then
  echo "Error: ${SCRIPT_SOURCE} not found." >&2
  exit 1
fi

if [[ ! -f "${PLIST_SOURCE}" ]]; then
  echo "Error: ${PLIST_SOURCE} not found." >&2
  exit 1
fi

# Install script to a non-TCC-protected location so launchd can execute it.
mkdir -p "$(dirname "${SCRIPT_TARGET}")"
cp "${SCRIPT_SOURCE}" "${SCRIPT_TARGET}"
chmod +x "${SCRIPT_TARGET}"

# Copy plist and patch absolute script path
sed "s|__SCRIPT_PATH__|${SCRIPT_TARGET}|g" "${PLIST_SOURCE}" > "${PLIST_TARGET}"

# Boot out existing agent if loaded, then bootstrap.
launchctl bootout gui/"$(id -u)" "${PLIST_TARGET}" 2>/dev/null || true
launchctl bootstrap gui/"$(id -u)" "${PLIST_TARGET}"

echo "Installed and loaded: ${PLIST_TARGET}"
echo "Next run: at login and every 30 minutes."
echo "Manual run: ${SCRIPT_TARGET}"
```

- [x] **Step 2: Make it executable**

Run:

```bash
chmod +x scripts/install-vps-health-check.sh
```

- [x] **Step 3: Run installer**

Run:

```bash
./scripts/install-vps-health-check.sh
```

Expected output:

```
Installed and loaded: /Users/alvarocarreramontalvo/Library/LaunchAgents/com.alvarodevrace.vps-health-check.plist
Next run: at login and every 30 minutes.
Manual run: /Users/alvarocarreramontalvo/.local/bin/vps-health-check.sh
```

- [x] **Step 4: Verify agent is loaded**

Run:

```bash
launchctl list | grep com.alvarodevrace.vps-health-check
```

Expected: a line showing the job with a PID or `-`.

- [x] **Step 5: Commit**

```bash
git add scripts/install-vps-health-check.sh
git commit -m "feat(monitoring): add installer for VPS health check LaunchAgent"
```

---

### Task 4: Validate failure notification

**Files:**
- None (manual test).

**Interfaces:**
- Consumes: `scripts/vps-health-check.sh`, loaded LaunchAgent.
- Produces: verified notification behavior.

- [x] **Step 1: Simulate failure by pointing to an unreachable IP**

Temporarily edit `scripts/vps-health-check.sh` and change `TCP_HOST` to `192.0.2.1` (TEST-NET-1, unreachable). Also change one URL to `https://httpbin.org/status/503` or a known dead endpoint.

Run:

```bash
./scripts/vps-health-check.sh
```

Expected: native macOS notification appears with the failure details.

- [x] **Step 2: Verify anti-spam**

Run the script again immediately.

Expected: no second notification (state file shows last_alert_ts recent).

- [x] **Step 3: Restore script**

Revert `TCP_HOST` to `72.60.26.201` and restore URLs.

Run:

```bash
./scripts/vps-health-check.sh
```

Expected: silent, state file shows `"healthy": true`.

- [x] **Step 4: Commit final state**

If any changes remain from testing, commit them:

```bash
git diff
# ensure only intended changes are present
git commit -m "feat(monitoring): validate VPS health check notifications" || echo "no changes to commit"
```

---

## Self-Review

**Spec coverage:**
- TCP + HTTP checks → Task 1.
- Native macOS notification → Task 1.
- Anti-spam state file → Task 1.
- launchd at login + 30 min interval → Task 2.
- Installer → Task 3.
- Testing → Task 4.

**Placeholder scan:** No TBDs, TODOs, or vague steps. All code is complete.

**Type consistency:** Shell-only; variable names consistent across files.

---

*Plan completed.*
