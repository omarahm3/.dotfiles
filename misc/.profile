#!/usr/bin/env bash

# sway related env variables
if [ "$MRGEEK_ENVIRONMENT" == "sway" ]; then
	export MOZ_ENABLE_WAYLAND=1
	export XDG_CURRENT_DESKTOP=sway
	export XDG_SESSION_TYPE=wayland
	export WLR_NO_HARDWARE_CURSORS=1
	#export WLR_NO_HARDWARE_CURSORS=0
	export WLR_RENDERER_ALLOW_SOFTWARE=1
	export WLC_REPEAT_RATE=60
	export WLC_REPEAT_DELAY=250
	export SDL_VIDEODRIVER=wayland
	export _JAVA_AWT_WM_NONREPARENTING=1
	export QT_QPA_PLATFORM=wayland
	export XDG_SESSION_DESKTOP=sway
	export SWAYFADER_CON_INAC=0.9
fi

export BROWSER=google-chrome-stable
. "$HOME/.cargo/env"
