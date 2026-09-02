hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@59.95",
    position = "0x0",
    scale = 1
})

hl.monitor({
    output = "eDP-2",
    mode = "2560x1600@240",
    position = "2560x0",
    scale = 1
})

hl.config({
    misc = {
        vrr = 1
    },

    input = {
        kb_layout = "us,ara",
        kb_options = "grp:alt_shift_toggle",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        accel_profile = "flat",
        sensitivity = 0,
        special_fallthrough = true,
        force_no_accel = true,
        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = false,
            clickfinger_behavior = true,
            scroll_factor = 0.5
        }
    }
})
