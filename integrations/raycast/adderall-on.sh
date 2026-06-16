#!/bin/bash
#
# Raycast Script Command — turn adderall on.
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Adderall On
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 💊
# @raycast.packageName Adderall
# @raycast.description Keep the Mac awake, even with the lid closed.

ADDERALL="$HOME/.local/bin/adderall"
[ -x "$ADDERALL" ] || ADDERALL="$(command -v adderall 2>/dev/null)"
[ -x "$ADDERALL" ] || { echo "adderall not found — run ./install.sh"; exit 1; }

"$ADDERALL" on | head -1
