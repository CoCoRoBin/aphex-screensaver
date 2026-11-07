# Aphex CRT Screensaver

SYRO #bfd630 phosphor logo, CRT glass, scanlines, animated perspective grid,
reflection, stars and Iosevka telemetry. Original PNG is bundled unchanged.
GPU shader runs at approximately 30 updates/second on each connected display.

Manual preview:

    ~/.local/bin/aphex-screensaver --preview

Move the mouse, click, scroll or press a key to dismiss after the initial 800ms
input guard. Cursor is hidden only inside the screensaver surfaces.

Automatic launch is provided by the user-owned `neo.idle` clone. It keeps the
existing 150 second screensaver / 300 second lock settings and stay-awake toggle.
It tracks the foreground screensaver process because layer surfaces do not emit
normal Hyprland window events. Dismissal cancels the current idle cycle; normal
system lock terminates the screensaver through its org.omarchy.screensaver path.
The system.screensaver menu action is overridden in the user menu extension
to run aphex-screensaver force; menu and automatic idle both use this design.

Restore the stock idle launcher:

    omarchy plugin enable omarchy.idle
    omarchy restart shell

Restart only while unlocked. Configuration backup:
~/.config/omarchy/shell.json.before-aphex-screensaver

Edit shell.qml for typography and input behavior, assets/crt.frag for visuals.
Recompile after shader edits:

    /usr/lib/qt6/bin/qsb --glsl '100 es,120,150' --hlsl 50 --msl 12 -o assets/crt.frag.qsb assets/crt.frag

Validation: shader compilation, shell syntax, actual runtime and dual-display
full-screen preview. Automatic 150/300 second cycle was not waited through.
