-- Drop upstream defaults that clash with the bindings below.
-- Without these the old bind and the new one both fire.
hl.unbind("SUPER + L")
hl.unbind("SUPER + SHIFT + L")
hl.unbind("SUPER + Q")
hl.unbind("SUPER + E")
hl.unbind("SUPER + ALT + Space")
hl.unbind("CTRL + ALT + Delete")
hl.unbind("SUPER + SHIFT + B")
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + R")
hl.unbind("SUPER + X")
hl.unbind("SUPER + Tab")
hl.unbind("SUPER + H")
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")

-- Launchers
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("gtk-launch $(xdg-settings get default-web-browser)"),
    { description = "Launch browser" })
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("nautilus --new-window"),
    { description = "Launch Nautilus" })
hl.bind("SUPER + X", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"),
    { description = "Screen snip >> edit" })

-- Shell
hl.bind("SUPER + Space", hl.dsp.global("quickshell:overviewToggleRelease"),
    { description = "Toggle overview" })
hl.bind("SUPER + Tab", hl.dsp.global("quickshell:overviewToggle"),
    { description = "Toggle overview (alt)" })
hl.bind("SUPER + SHIFT + B", hl.dsp.global("quickshell:sessionToggle"),
    { description = "Toggle session menu" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("qs -c $qsConfig ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell"))

for i = 1, 8 do
    local button = { "mouse:272", "mouse:273", "mouse:274", "mouse:275", "mouse:276", "mouse:277", "mouse_up",
        "mouse_down" }
    hl.bind("SUPER + " .. button[i], hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"), { mouse = true })
end

-- Focus
for i = 1, 4 do
    local key = { "H", "L", "K", "J" }
    local dir = { "l", "r", "u", "d" }
    hl.bind("SUPER + " .. key[i], hl.dsp.focus({ direction = dir[i] }),
        { description = "Window: Focus " .. dir[i] })
    hl.bind("SUPER + SHIFT + " .. key[i], hl.dsp.window.move({ direction = dir[i] }),
        { description = "Window: Move " .. dir[i] })
end

-- Windows
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })

-- Move window to workspace
for i = 1, 10 do
    local key = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
    hl.bind("SUPER + SHIFT + " .. key[i], hl.dsp.window.move({ workspace = i, follow = false }))
end
