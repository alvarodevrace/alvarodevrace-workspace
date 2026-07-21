#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="/tmp/vps-health-status.json"

PING_HOST="72.60.26.201"
URLS=(
  "https://laschubys.com"
  "https://api.laschubys.com/api/health"
  "https://n8n.alvarodevrace.tech"
)

failures=()

# Ping check
if ! ping -c 1 -W 3 "${PING_HOST}" >/dev/null 2>&1; then
  failures+=("ping ${PING_HOST}")
fi

# HTTP checks
for url in "${URLS[@]}"; do
  code=$(curl -s -o /dev/null --max-time 5 -w "%{http_code}" "${url}" 2>/dev/null || echo "000")
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

if [[ "${should_notify}" == "true" ]]; then
  body=$(printf '%s\n' "${failures[@]}")
  osascript -e "display notification \"${body//\"/\\\"}\" with title \"VPS / servicio caído\" sound name \"Ping\""
  last_alert_ts=${now_ts}
fi

# Write state
python3 - <<PY
import json
with open("${STATE_FILE}", "w") as f:
    json.dump({"healthy": ${healthy^}, "last_alert_ts": ${last_alert_ts}, "checked_at": ${now_ts}}, f)
PY
