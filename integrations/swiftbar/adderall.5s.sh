#!/bin/bash
#
# SwiftBar plugin — 💊 menu-bar indicator + toggle for adderall.
# Install: copy into your SwiftBar plugin folder (the installer does this for you,
# baking in the absolute path to the `adderall` binary).
# Filename "adderall.5s.sh" => SwiftBar re-runs it every 5s.
# Shows 💊 only while active; nothing when off (SwiftBar hides the item).
#
# Strip SwiftBar's default footer noise (keep only the SwiftBar submenu):
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>

# Resolve the adderall binary by absolute path (GUI apps have a minimal PATH).
# install.sh replaces __ADDERALL_BIN__ with the real install path.
ADDERALL="__ADDERALL_BIN__"
[ -x "$ADDERALL" ] || ADDERALL="$(command -v adderall 2>/dev/null)"
[ -x "$ADDERALL" ] || ADDERALL="$HOME/.local/bin/adderall"

# Menu action: turn off, then refresh the icon away.
if [ "$1" = "off" ]; then
  "$ADDERALL" off >/dev/null 2>&1
  exit 0
fi

# Render: 💊 + a "Turn off" item, only when active.
if "$ADDERALL" active 2>/dev/null; then
  echo "💊"
  echo "---"
  echo "Turn off 💊 | bash=\"$0\" param1=off terminal=false refresh=true"
fi
