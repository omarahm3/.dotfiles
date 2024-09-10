
set PATH /home/mrgeek/.local/bin $PATH
set PATH /home/mrgeek/go/bin $PATH
set PATH /home/mrgeek/.config/composer/vendor/bin $PATH
set PATH /home/mrgeek/.cargo/bin $PATH
set PATH /home/mrgeek/n/bin $PATH
set PATH /home/mrgeek/.luarocks/bin $PATH
set PATH /home/mrgeek/.local/share/gem/ruby/3.2.0/bin $PATH
set PATH /home/mrgeek/.krew/bin $PATH
set PATH /home/mrgeek/.zx/bin $PATH
set PATH /home/mrgeek/.fly/bin $PATH
set PATH /home/mrgeek/.ebcli-virtual-env/executables $PATH
set PATH /opt/android-sdk/tools/bin $PATH
set PATH /opt/android-sdk/platform-tools $PATH

source ~/.config/fish/variables.fish
source ~/.config/fish/private.fish
source ~/.config/fish/pyenv-checker.fish

# Execute commands safely by first checking if the command exist or not
# To avoid errors occurs on fish shell
function _execute_command
    if type -q $argv[1]
        eval $argv
        true
    else
        false
    end
end

_execute_command starship >/dev/null 2>&1

if test $status -eq 0
    set -Ux STARSHIP_CONFIG /home/mrgeek/.config/starship/starship.toml
    starship init fish | source
end

_execute_command thefuck >/dev/null 2>&1

if test $status -eq 0
    thefuck --alias | source
end

_execute_command zoxide >/dev/null 2>&1

if test $status -eq 0
    zoxide init fish | source
end

_execute_command bass source ~/.cargo/env

_execute_command nvm use 14.16.0 >/dev/null 2>&1

if test -z "$DISABLE_NERD_FETCH"
    _execute_command nerdfetch
end

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

alias cd z
alias ls exa
alias vim lvim
alias twork 'tmux a'
alias tdev 'tmux -Ldevelopment a'

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME "/home/mrgeek/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -gx CONDA_AUTO_ACTIVATE_BASE false

~/.local/bin/mise activate fish | source
# envio DO NOT MODIFY
 bass source /home/mrgeek/.envio/setenv.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /home/mrgeek/anaconda3/bin/conda
#     eval /home/mrgeek/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# else
#     if test -f "/home/mrgeek/anaconda3/etc/fish/conf.d/conda.fish"
#         . "/home/mrgeek/anaconda3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH "/home/mrgeek/anaconda3/bin" $PATH
#     end
# end
# <<< conda initialize <<<

