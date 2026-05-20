set -g -x fish_greeting ''

# FZF catppuccin theme
set -Ux FZF_DEFAULT_OPTS "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"

set -gx EDITOR lvim

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/mrgeek/.ghcup/bin # ghcup-env

# pnpm
set -gx PNPM_HOME "/home/mrgeek/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

set -Ux JAVA_HOME /usr/lib/jvm/java-17-openjdk
set -Ux ANDROID_HOME $HOME/Android/Sdk
set -eU ANDROID_SDK_ROOT
set -Ux ANDROID_USER_HOME $HOME/.android
set -Ux ANDROID_AVD_HOME $HOME/.android/avd
fish_add_path -U $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path -U $ANDROID_HOME/platform-tools
fish_add_path -U $ANDROID_HOME/emulator
