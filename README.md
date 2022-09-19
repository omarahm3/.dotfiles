# omarahm3 dotfiles

This is my personal repository for my arch linux dotfiles (will be always WIP)

## About

- Window manager: [i3wm](https://github.com/Airblader/i3)
- Compositor: [polybar](https://github.com/yshui/picom)
- Terminal: [st](https://github.com/LukeSmithxyz/st)
- Shell: [fish](https://github.com/fish-shell/fish-shell)
- Prompt: [starship](https://github.com/starship/starship)
- Editor: [neovim](https://github.com/neovim/neovim)
- Panel: [polybar](https://github.com/polybar/polybar)
- Notifications: [dunst](https://github.com/k-vernooy/dunst.git)
- Application launcher: [rofi](https://github.com/davatorium/rofi)

## Setup

This config depend heavy on [GNU Stow](https://www.gnu.org/software/stow/) to sync all files to their corresponding locations. My current default location is `~/.dotfiles`

`./sync` is a small script used to sync current changes witht the system, please make sure to modify the script if you have the dotfiles on different path
