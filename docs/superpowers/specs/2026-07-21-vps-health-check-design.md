# VPS Health Check — macOS Notification Design

**Date:** 2026-07-21  
**Status:** Approved  
**Approach:** A — shell script + macOS LaunchAgent

---

## Goal

Detect automatically, on the user's Mac, when the Hostinger VPS or its critical public services are unreachable, and surface a native macOS notification so the outage is noticed quickly during the workday.

## Background

On 2026-07-20 the Hostinger VPS (`72.60.26.201`) was found powered off after being down since 2026-07-12T21:35-05:00. The root cause was a hypervisor-initiated shutdown (`systemd-logind: System is powering down (hypervisor initiated shutdown)`). No alert reached the user because existing uptime monitoring runs from the VPS itself, which is useless when the whole machine is down.

This local Mac-based watchdog is a lightweight, zero-cost Plan B that runs only when the Mac is on (which matches the user's working schedule).

## Scope

- Run on macOS only.
- Trigger on user login and repeat every 30 minutes.
- Check the VPS IP plus three critical public URLs.
- Show a native notification only when something fails, with anti-spam logic.
- No external services, no cloud dependencies, no credentials required.

## Architecture

```
macOS launchd
  └─ com.alvarodevrace.vps-health-check.plist
       └─ runs scripts/vps-health-check.sh every 30 min + at login
              ├─ TCP 72.60.26.201:443
              ├─ curl https://laschubys.com
              ├─ curl https://api.laschubys.com/api/health
              ├─ curl https://n8n.alvarodevrace.tech
              └─ if any fail → osascript display notification
```

## Files

| Path | Purpose |
|------|---------|
| `scripts/vps-health-check.sh` | Health check logic and notification. |
| `scripts/com.alvarodevrace.vps-health-check.plist` | launchd job definition. |
| `scripts/install-vps-health-check.sh` | One-command installer. |
| `/tmp/vps-health-status.json` | Runtime state to avoid notification spam. |

## Behavior

1. The script performs checks with short timeouts:
   - TCP connection to `72.60.26.201:443`
   - `curl -sL -o /dev/null --max-time 5 -w "%{http_code}" <url>`
2. A check is considered OK if the TCP connection succeeds or HTTP returns `2xx`/`3xx`.
3. If all checks pass, the script exits silently.
4. If any check fails, the script:
   - Reads `/tmp/vps-health-status.json`.
   - Notifies only if the previous run was healthy or the last notification was more than 60 minutes ago.
   - Writes the new unhealthy state to `/tmp/vps-health-status.json`.

## Anti-spam Rule

- Notify on the transition `healthy → unhealthy`.
- If already unhealthy, re-notify at most once per 60 minutes.
- When the system recovers (`unhealthy → healthy`), update the state file but do not notify (keep it silent).

## Error Handling

- Timeout on the TCP probe and curl prevents the script from hanging.
- If the Mac itself has no internet, checks will fail; the notification text will indicate which endpoint failed so the user can distinguish "no Wi-Fi" from "VPS down".
- The script exits with code `0` even on failures so launchd does not mark the job as failed/retrying.

## Installation

Run from the project root:

```bash
./scripts/install-vps-health-check.sh
```

The installer:
1. Copies the plist to `~/Library/LaunchAgents/`.
2. Replaces placeholders with the absolute path to `scripts/vps-health-check.sh`.
3. Loads the agent with `launchctl load`.

## Testing

1. Run `./scripts/vps-health-check.sh` manually while the VPS is healthy → no notification.
2. Temporarily block the VPS IP with a local firewall rule or disconnect Wi-Fi → notification appears.
3. Verify the agent is loaded: `launchctl list | grep com.alvarodevrace.vps-health-check`.
4. Verify it runs on schedule: check Console.app logs or add a temporary log line.

## Future Enhancements (out of scope)

- Telegram fallback for alerts when away from the Mac.
- Dell-based external watchdog for 24/7 coverage.
- Track historical uptime in a local log file.
