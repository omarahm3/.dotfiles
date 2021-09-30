set -g -x fish_greeting ''
set PATH /home/mrgeek/.local/bin $PATH
set PATH /home/mrgeek/go/bin $PATH
set PATH /home/mrgeek/.config/composer/vendor/bin $PATH
set PATH /home/mrgeek/.fly/bin $PATH
set PATH /home/mrgeek/.deta/bin $PATH

source ~/.config/fish/private.fish

starship init fish | source

thefuck --alias | source

nvm use lts > /dev/null
