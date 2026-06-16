#!/bin/bash
#
# Raycast Script Command — turn adderall on, or set/change its auto-off timer.
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Adderall On
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 💊
# @raycast.packageName Adderall
# @raycast.argument1 { "type": "text", "placeholder": "2h, 30m, 90s — blank = no timer", "optional": true }
# @raycast.description Keep the Mac awake; optionally set or change the auto-off timer.

ADDERALL="$HOME/.local/bin/adderall"
[ -x "$ADDERALL" ] || ADDERALL="$(command -v adderall 2>/dev/null)"
[ -x "$ADDERALL" ] || { echo "adderall not found — run ./install.sh"; exit 1; }

# adderall already shows a 💊; Raycast renders @raycast.icon, so emit plain text.
if "$ADDERALL" on "$1" >/dev/null 2>&1; then
  rem="$("$ADDERALL" remaining 2>/dev/null)"
  if [ -n "$rem" ]; then echo "Adderall ON — auto-off in $rem"; else echo "Adderall ON — no timer"; fi
else
  echo "Invalid duration: '$1' (try 2h, 30m, 90s)"
  exit 1
fi
