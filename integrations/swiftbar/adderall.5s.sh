#!/bin/bash
#
# SwiftBar plugin — 💊 menu-bar indicator + toggle for adderall.
# Install: copy into your SwiftBar plugin folder (the installer does this for you,
# baking in the absolute path to the `adderall` binary).
# Filename "adderall.5s.sh" => SwiftBar re-runs it every 5s.
# Shows 💊 only while active; nothing when off (SwiftBar hides the item).
#
# Strip all of SwiftBar's default footer items for a minimal dropdown.
# (Delete the hideSwiftBar line to restore the "SwiftBar" submenu — it's the
#  only in-menu way to reach SwiftBar's own preferences.)
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

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

# Render only when active. Menu bar uses monochrome SF Symbols (outline; they
# auto-match the system light/dark menu bar): an outline pill, plus a timer
# glyph on a timed run. The exact time lives in the dropdown to keep the bar clean.
if "$ADDERALL" active 2>/dev/null; then
  rem="$("$ADDERALL" remaining 2>/dev/null)"
  if [ -n "$rem" ]; then echo ":pills: :timer:"; else echo ":pills:"; fi
  echo "---"
  [ -n "$rem" ] && { echo "Auto-off in $rem | sfimage=timer"; echo "---"; }
  echo "Turn off | sfimage=moon.zzz.fill bash=\"$0\" param1=off terminal=false refresh=true"
fi
