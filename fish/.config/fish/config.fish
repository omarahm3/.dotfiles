set -g -x fish_greeting ''
set PATH /home/mrgeek/.local/bin $PATH
set PATH /home/mrgeek/go/bin $PATH
set PATH /home/mrgeek/.config/composer/vendor/bin $PATH
set PATH /home/mrgeek/.fly/bin $PATH
set PATH /home/mrgeek/.deta/bin $PATH
set PATH /home/mrgeek/.cargo/bin $PATH
set PATH /home/mrgeek/.gem/ruby/2.7.0/bin $PATH

source ~/.config/fish/private.fish

starship init fish | source

thefuck --alias | source

bass source ~/.cargo/env
