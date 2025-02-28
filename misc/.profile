#!/usr/bin/env bash

# sway related env variables
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

export VDPAU_DRIVER=nvidia
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __EGL_VENDOR_LIBRARY_FILENAMES="/usr/share/glvnd/egl_vendor.d/10_nvidia.json"
export WLR_NO_HARDWARE_CURSORS=1

export BROWSER=brave
export TERM=kitty
export QT_QPA_PLATFORMTHEME="qt5ct"

. "$HOME/.cargo/env"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
