set -g -x fish_greeting ''
set PATH /home/mrgeek/.local/bin $PATH
set PATH /home/mrgeek/go/bin $PATH
set PATH /home/mrgeek/.config/composer/vendor/bin $PATH
set PATH /home/mrgeek/.cargo/bin $PATH
set PATH /home/mrgeek/n/bin $PATH
set PATH /home/mrgeek/.luarocks/bin $PATH
set PATH /home/mrgeek/.local/share/gem/ruby/3.0.0/bin $PATH
set PATH /home/mrgeek/.krew/bin $PATH

source ~/.config/fish/private.fish

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

_execute_command nerdfetch

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

if test -x (command -v fw)
  if test -x (command -v fzf)
    fw print-fish-setup -f | source
  else
    fw print-fish-setup | source
  end
end

alias cd z

# FZF catppuccin theme
set -Ux FZF_DEFAULT_OPTS "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"

set -e EDITOR
set -Ux EDITOR nvim
