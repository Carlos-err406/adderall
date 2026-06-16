#!/bin/bash
#
# Raycast Script Command — turn adderall off.
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Adderall Off
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 😴
# @raycast.packageName Adderall
# @raycast.description Restore normal sleep.

ADDERALL="$HOME/.local/bin/adderall"
[ -x "$ADDERALL" ] || ADDERALL="$(command -v adderall 2>/dev/null)"
[ -x "$ADDERALL" ] || { echo "adderall not found — run ./install.sh"; exit 1; }

"$ADDERALL" off | head -1
