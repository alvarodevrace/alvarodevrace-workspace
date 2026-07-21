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

# Unload if already loaded, then load
if launchctl list | grep -q "com.alvarodevrace.vps-health-check"; then
  launchctl unload "${PLIST_TARGET}" 2>/dev/null || true
fi

launchctl load "${PLIST_TARGET}"

echo "Installed and loaded: ${PLIST_TARGET}"
echo "Next run: at login and every 30 minutes."
echo "Manual run: ${SCRIPT_TARGET}"
