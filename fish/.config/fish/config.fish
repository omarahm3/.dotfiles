set -g -x fish_greeting ''
set PATH /home/mrgeek/.local/bin $PATH
set PATH /home/mrgeek/go/bin $PATH
set PATH /home/mrgeek/.config/composer/vendor/bin $PATH
set PATH /home/mrgeek/.fly/bin $PATH
set PATH /home/mrgeek/.deta/bin $PATH
set PATH /home/mrgeek/.cargo/bin $PATH
set PATH /home/mrgeek/.gem/ruby/2.7.0/bin $PATH

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
  _execute_command starship init fish | source
end

_execute_command thefuck >/dev/null 2>&1

if test $status -eq 0
  _execute_command thefuck --alias | source
end

_execute_command bass source ~/.cargo/env

_execute_command nvm use 14.16.0 >/dev/null 2>&1

_execute_command nerdfetch
