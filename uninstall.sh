#!/usr/bin/env bash
#
# adderall uninstaller — reverses install.sh.
set -euo pipefail

BIN_DIR="${ADDERALL_BIN_DIR:-$HOME/.local/bin}"
info() { printf '\033[92m✓\033[0m %s\n' "$1"; }

# Make sure sleep is back to normal before we remove anything.
command -v adderall >/dev/null 2>&1 && adderall off >/dev/null 2>&1 || true

# 1. binary
rm -f "$BIN_DIR/adderall" && info "removed $BIN_DIR/adderall"

# 2. SwiftBar plugin
PLUGDIR="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || echo "$HOME/.config/swiftbar")"
rm -f "$PLUGDIR/adderall.5s.sh" && info "removed SwiftBar plugin (if present)"
open "swiftbar://refreshallplugins" 2>/dev/null || true

# 3. sudoers rule
if [ -f /etc/sudoers.d/adderall ]; then
  echo "Removing sudoers rule (needs your password)…"
  sudo rm -f /etc/sudoers.d/adderall && info "removed /etc/sudoers.d/adderall"
fi

echo "Done. Remove any starship/status-line snippets you added manually."
