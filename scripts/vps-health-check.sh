#!/usr/bin/env bash
set -euo pipefail

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
