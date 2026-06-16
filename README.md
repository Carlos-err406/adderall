# 💊 adderall

[![shellcheck](https://github.com/Carlos-err406/adderall/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/Carlos-err406/adderall/actions/workflows/shellcheck.yml)

**Keep your Mac awake — even with the lid closed.**

Close the laptop and walk away while your long-running jobs keep going: builds,
downloads, training runs, or **AI agents** that you don't want to pause the
moment the screen folds shut.

`adderall` combines two macOS mechanisms into one command:

- [`caffeinate`](https://ss64.com/osx/caffeinate.html) — blocks display, idle, and system sleep
- `pmset disablesleep 1` — the extra bit that allows **clamshell (lid-closed) operation**

…and tracks state in a pidfile so a menu-bar icon, your shell prompt, and any
other integration all agree on whether it's on.

```
$ adderall on
💊 adderall ON — sleep blocked, even with the lid closed (PID 42137)

$ adderall
💊 adderall is ON — your Mac won't sleep, even with the lid closed (PID 42137)
   run 'adderall off' to restore normal sleep

$ adderall off
😴 adderall OFF — normal sleep restored
```

> ⚠️ While `adderall` is on, your Mac will **not** sleep with the lid shut. Keep
> it on a hard, ventilated surface and turn it **off** when you're done — or use a
> timed run like `adderall on 2h` so it auto-restores sleep and you can't forget it.

## Requirements

- macOS
- `sudo` access (one-time, to install a tightly-scoped permission rule)
- Optional: [SwiftBar](https://github.com/swiftbar/SwiftBar) for the menu-bar pill
- Optional: [Raycast](https://raycast.com) (+ Node) for the extension

## Install

```sh
git clone https://github.com/Carlos-err406/adderall.git
cd adderall
./install.sh
```

The installer:

1. links `adderall` into `~/.local/bin` (override with `ADDERALL_BIN_DIR=…`),
2. installs a **scoped, passwordless** `sudoers` rule so toggling never prompts
   for a password (see [Why sudo?](#why-sudo)),
3. installs the SwiftBar plugin if SwiftBar is present.

Uninstall with `./uninstall.sh`.

## Usage

| Command | Does |
| --- | --- |
| `adderall` | show status (default) |
| `adderall on [duration]` | keep awake; set or change the auto-off timer (`30m`, `2h`, `90s`) — even while already on. Bare `adderall on` clears the timer. |
| `adderall off` | restore normal sleep |
| `adderall toggle [dur]` | flip on/off (duration applies when turning on) |
| `adderall active` | exit `0` if on, `1` if off — no output (for prompts/scripts) |
| `adderall remaining` | time left on a timed run, e.g. `1h47m` (no output if none) |
| `adderall help` | usage |

## Why sudo?

`caffeinate` alone can't keep the Mac awake with the lid **closed** — only
`pmset disablesleep` can, and that needs root. So toggling doesn't nag you for a
password every time, `install.sh` adds a rule at `/etc/sudoers.d/adderall`
scoped to exactly those two commands and nothing else:

```
<you> ALL=(root) NOPASSWD: /usr/bin/pmset disablesleep 0, /usr/bin/pmset disablesleep 1
```

It's validated with `visudo -cf` before installation. Remove it any time with
`sudo rm /etc/sudoers.d/adderall` (or `./uninstall.sh`).

## Integrations

Every integration is driven by the same pidfile, so they all stay in sync. Use
`adderall active` (exit code, no output) as the check.

### Menu bar (SwiftBar)

Installed automatically when SwiftBar is present. A monochrome **template icon**
appears in the menu bar while active (auto-matching the system light/dark menu bar):
a **pill** for an indefinite run, or a **pill + timer** on a timed run, with the
exact remaining time in the dropdown. Click it → **Turn off**. The icon hides itself
when off. (Icons are built from `integrations/swiftbar/icons/` via `make-icon.swift`.)

### Shell prompt (Starship)

Add to `~/.config/starship.toml` — `${custom.adderall}` somewhere in your
`format`, plus:

```toml
[custom.adderall]
description = "💊 when adderall is keeping the Mac awake"
when = "adderall active"
command = "true"
shell = ["sh"]
symbol = "💊"
style = "bold yellow"
format = "[$symbol]($style) "
```

### Claude Code status line

In your status-line script, prepend a pill when active:

```bash
adderall active 2>/dev/null && printf '💊 '
```

### Raycast

A small [Raycast extension](https://developers.raycast.com) lives in
[`integrations/raycast/`](integrations/raycast) with three commands:

- **Adderall On** — keep awake (no timer).
- **Adderall Off** — restore normal sleep.
- **Adderall On with Timer** — opens a list of durations (`15m`/`30m`/`1h`/`2h`/`4h`/`8h`,
  or type a custom one); picking one sets/changes the auto-off timer.

Install it locally:

```sh
cd integrations/raycast
npm install
npm run dev      # registers it in Raycast; the commands stay after you stop it
```

The commands call the `adderall` binary by absolute path, since Raycast (like all GUI
apps) runs with a minimal `PATH`.

## How it works

`adderall on` launches `caffeinate -disu` (disowned), records its PID in
`$TMPDIR/adderall.pid`, and sets `pmset disablesleep 1`. `adderall off` kills
that process, clears the pidfile, and sets `pmset disablesleep 0`. The
`active` check is just "does the pidfile point at a live process?" — which is
why a crashed `caffeinate` never leaves a false "on".

With a duration, `adderall on 2h` uses `caffeinate -t` plus a background watcher
that restores sleep when the timer fires. Running `adderall on <dur>` again while
already on re-arms the timer in place — the new `caffeinate` PID is written before
the old one is killed, so the old watcher sees the changed pidfile and exits without
toggling sleep. (`pmset` is invoked by absolute path so the passwordless rule matches
even from a minimal `PATH`, e.g. the Raycast extension.)

## License

[MIT](./LICENSE) © Carlos Daniel Vilaseca Illnait
