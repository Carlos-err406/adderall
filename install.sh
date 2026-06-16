#!/usr/bin/env bash
#
# adderall installer.
#   - links `adderall` into your PATH
#   - installs a scoped passwordless sudoers rule for `pmset disablesleep`
#   - optionally installs the SwiftBar menu-bar plugin
#
# Re-runnable (idempotent). Override the binary location with:
#   ADDERALL_BIN_DIR=/usr/local/bin ./install.sh
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${ADDERALL_BIN_DIR:-$HOME/.local/bin}"
BIN="$BIN_DIR/adderall"
USER_NAME="$(whoami)"

info() { printf '\033[92m✓\033[0m %s\n' "$1"; }
warn() { printf '\033[93m!\033[0m %s\n' "$1"; }

echo "Installing adderall from $REPO"

# 1. Link the binary onto PATH ------------------------------------------------
chmod +x "$REPO/bin/adderall"
mkdir -p "$BIN_DIR"
ln -sf "$REPO/bin/adderall" "$BIN"
info "linked adderall -> $BIN"
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) warn "$BIN_DIR is not on your PATH — add it to your shell rc (e.g. export PATH=\"$BIN_DIR:\$PATH\")" ;;
esac

# 2. Passwordless sudoers rule for pmset disablesleep -------------------------
SUDO_TMP="$(mktemp)"
sed "s/__USER__/$USER_NAME/" "$REPO/sudoers/adderall" > "$SUDO_TMP"
if visudo -cf "$SUDO_TMP" >/dev/null 2>&1; then
  echo "Installing sudoers rule to /etc/sudoers.d/adderall (needs your password once)…"
  sudo install -m 0440 -o root -g wheel "$SUDO_TMP" /etc/sudoers.d/adderall
  info "sudoers rule installed — 'adderall on/off' won't prompt for a password"
else
  warn "generated sudoers rule failed validation; skipping (adderall will prompt for sudo)"
fi
rm -f "$SUDO_TMP"

# 3. SwiftBar plugin (optional) ----------------------------------------------
if [ "${ADDERALL_NO_SWIFTBAR:-}" != "1" ] && [ -d "/Applications/SwiftBar.app" ]; then
  PLUGDIR="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || echo "$HOME/.config/swiftbar")"
  mkdir -p "$PLUGDIR"
  sed "s#__ADDERALL_BIN__#$BIN#" "$REPO/integrations/swiftbar/adderall.5s.sh" > "$PLUGDIR/adderall.5s.sh"
  chmod +x "$PLUGDIR/adderall.5s.sh"
  info "SwiftBar plugin installed -> $PLUGDIR/adderall.5s.sh"
  open "swiftbar://refreshallplugins" 2>/dev/null || true
else
  warn "SwiftBar not found in /Applications — skipping menu-bar plugin (brew install --cask swiftbar)"
fi

cat <<DONE

adderall installed. Try:
  adderall on        # keep awake, even lid-closed
  adderall           # status
  adderall off       # restore normal sleep

Optional prompt/status-line integrations are documented in the README.
DONE
