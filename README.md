# Aphex Screensaver and Idle

A local Omarchy idle plugin derived from `omarchy.idle`, packaged with the Aphex CRT screensaver and launcher. The scene uses a SYRO green logo, scanlines, perspective grid, reflection and Iosevka telemetry on each display.

## Files

| Path | Purpose |
| --- | --- |
| `manifest.json` | `neo.idle` plugin metadata |
| `Service.qml` | Idle timers, stay-awake state and screensaver lifecycle |
| `IdleModel.js` | Timeout and window-tracking helpers |
| `screensaver/shell.qml` | Standalone Quickshell screensaver |
| `screensaver/assets/` | Logo, GLSL source and compiled shader |
| `bin/aphex-screensaver` | Foreground launcher and lock-state guard |

`screensaver/` and `bin/` are versionable snapshots copied from the installed paths below. They are **not automatically synchronized**. The plugin still launches the installed executable, not this packaged copy. The screensaver is self-contained and does not import `neo.lock` QML; actual locking uses the active Omarchy lock provider.

## Requirements

Requires Omarchy, Hyprland, Quickshell with Qt Quick/Wayland and Hyprland modules, Bash, and Omarchy lock/wake/toggle commands. Iosevka is the intended font. Qt Shader Tools (`qsb`) is needed only when rebuilding shaders.

## Installation

The canonical repository is `~/Developer/aphex-screensaver`. The installed plugin path `~/.config/omarchy/plugins/neo.idle` is a compatibility symlink to it; `~/Projects/aphex-screensaver` resolves through that installed path. Edit and run Git commands in the canonical repository. Packaged `screensaver/` and `bin/` snapshots still require explicit deployment to their separate installed destinations.

Current installed locations:

| Packaged files | Installed path |
| --- | --- |
| Root QML, JS and manifest | `~/.config/omarchy/plugins/neo.idle/` |
| `screensaver/` contents | `~/.config/omarchy/screensavers/org.omarchy.screensaver/` |
| `bin/aphex-screensaver` | `~/.local/bin/aphex-screensaver` |

Before deploying, back up those destinations and `~/.config/omarchy/shell.json`. From a separate checkout, copy root plugin files to the plugin directory and deploy the snapshots:

```bash
mkdir -p ~/.config/omarchy/screensavers/org.omarchy.screensaver ~/.local/bin
cp -a screensaver/. ~/.config/omarchy/screensavers/org.omarchy.screensaver/
install -m 755 bin/aphex-screensaver ~/.local/bin/aphex-screensaver
omarchy plugin enable neo.idle
omarchy restart shell
```

Run deployment and shell restarts only while unlocked. Keep only one idle provider enabled. The optional launcher-menu override lives separately in `~/.config/omarchy/extensions/omarchy-menu.jsonc`; it is not bundled or required for automatic idle operation.

## Behavior and use

`idle.screensaver` and `idle.lock` in `~/.config/omarchy/shell.json` are seconds since inactivity began; defaults are 150 and 300. Zero disables the corresponding action. Idle inhibitors and the persisted stay-awake toggle are respected.

The foreground screensaver process defines its lifetime. Dismissal cancels the pending idle cycle. The launcher returns code 42 if the session is already locked, leaving display blanking to the lock service. Mouse movement, clicks, scrolling or keys dismiss the scene after an initial 800 ms guard. Shader animation updates approximately every 33 ms.

```bash
~/.local/bin/aphex-screensaver --preview
omarchy-shell idle status
omarchy-shell idle disable       # Stay awake
omarchy-shell idle enable
```

Preview bypasses the screensaver-off toggle but still refuses to launch over a locked session. The stay-awake marker is `~/.local/state/omarchy/indicators/stay-awake`; it is local state, not project source.

After shader edits, rebuild from this repository:

```bash
/usr/lib/qt6/bin/qsb --glsl '100 es,120,150' --hlsl 50 --msl 12 -o screensaver/assets/crt.frag.qsb screensaver/assets/crt.frag
bash -n bin/aphex-screensaver
```

Deploy edited snapshots explicitly; editing `screensaver/` alone does not update the installed screensaver. Keep `.qsb` packages versioned because they are runtime inputs.

## Restore and validation

To return to the stock idle provider, run `omarchy plugin enable omarchy.idle`, then `omarchy restart shell` while unlocked. A historical configuration backup is `~/.config/omarchy/shell.json.before-aphex-screensaver`.

Organization checks cover JSON, launcher syntax and byte-for-byte snapshot equality. The automatic idle cycle, real authentication and display blanking were not exercised during cleanup. Git is initialized; no commit or remote was created.

## Origin

The idle service is based on Omarchy; CRT visuals and launcher integration are local customizations. The original logo is retained. No new license grant is implied for upstream code or artwork.
