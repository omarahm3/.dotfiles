set -g -x fish_greeting ''

# FZF catppuccin theme
set -Ux FZF_DEFAULT_OPTS "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"

set -gx EDITOR lvim

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/mrgeek/.ghcup/bin # ghcup-env

# pnpm
set -gx PNPM_HOME "/home/mrgeek/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

set -gx ANDROID_HOME /opt/android-sdk
set -gx JAVA_HOME /usr/lib/jvm/java-21-openjdk/
set -gx N_PREFIX /home/mrgeek/n
set -gx GOROOT /usr/local/go
