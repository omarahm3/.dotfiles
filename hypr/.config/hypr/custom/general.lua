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

-- Monitor layout is per machine, so each host owns a file under custom/hosts/
-- named after its hostname. Keeping them apart stops the two machines from
-- fighting over this file on every merge.

local function current_host()
    local file = assert(io.open("/etc/hostname", "r"), "hypr: cannot read /etc/hostname")
    local name = file:read("l")
    file:close()
    return (name:match("^%s*(.-)%s*$"))
end

local host = current_host()
local host_file = HOME .. "/.config/hypr/custom/hosts/" .. host .. ".lua"

if is_file_exists(host_file) then
    -- dofile, not require: a dotted hostname would break module-path mapping.
    dofile(host_file)
else
    -- Deferred because the notification daemon is not up at config-parse time.
    -- Without a host file the upstream catch-all leaves monitors auto-detected.
    hl.on("hyprland.start", function()
        hl.exec_cmd(
            "notify-send --app-name=Hyprland --urgency=critical "
            .. "'No monitor config for " .. host .. "' "
            .. "'Create custom/hosts/" .. host .. ".lua - monitors are auto-detected until then'"
        )
    end)
end
