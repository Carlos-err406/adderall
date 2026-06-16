#!/bin/bash
#
# Raycast Script Command — toggle adderall.
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Adderall Toggle
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon 💊
# @raycast.packageName Adderall
# @raycast.description Toggle keeping the Mac awake, even with the lid closed.

# GUI apps have a minimal PATH, so resolve the binary by absolute path.
ADDERALL="$HOME/.local/bin/adderall"
[ -x "$ADDERALL" ] || ADDERALL="$(command -v adderall 2>/dev/null)"
[ -x "$ADDERALL" ] || { echo "adderall not found — run ./install.sh"; exit 1; }

"$ADDERALL" toggle | head -1
