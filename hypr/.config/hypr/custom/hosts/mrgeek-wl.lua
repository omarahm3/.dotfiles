-- DP-2 sits above the laptop panel; eDP-1's x offset centres it under DP-2
-- ((2560 - 2880/1.8) / 2 = 480).

hl.monitor({
    output = "DP-2",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1
})

hl.monitor({
    output = "eDP-1",
    mode = "2880x1800@90",
    position = "480x1440",
    scale = 1.8
})
