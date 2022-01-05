#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar --reload bar-dwm -q -c ~/.config/polybar/config.ini &
#     MONITOR=$m polybar --reload bar-apps -q -c ~/.config/polybar/config.ini &
#     MONITOR=$m polybar --reload bar-menus -q -c ~/.config/polybar/config.ini &
#   done
# else
    # polybar --reload bar-right -q -c ~/.config/polybar/config.ini &
    # polybar --reload bar-right-background -q -c ~/.config/polybar/config.ini &
    # polybar --reload bar-left -q -c ~/.config/polybar/config.ini &
    # polybar --reload bar-left-background -q -c ~/.config/polybar/config.ini &
    polybar --reload bar-center-background -q -c ~/.config/polybar/config.ini &
# fi
