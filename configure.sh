#!/bin/bash

sudo apt update
sudo apt install -y software-properties-common stow

install_regolith() {
  sudo add-apt-repository -y ppa:regolith-linux/release
  sudo apt update
  sudo apt install -y regolith-desktop i3xrocks-net-traffic i3xrocks-cpu-usage i3xrocks-time i3xrocks-keyboard-layout i3xrocks-volume i3xrocks-weather i3xrocks-battery
}

install_zsh() {
  git clone --depth=1 git@github.com:ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  git clone --depth=1 git@github.com:romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone --depth=1 git@github.com:zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 git@github.com:zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  sudo apt install -y zsh autojump
}

install_nvim() {
  git clone --depth=1 git@github.com:artofnothingness/nvim.git ~/.config/nvim
  source ~/.config/nvim/utils/install.sh
}

install_tools() {
  sudo apt update
  sudo apt install -y \
    zsh \
    neofetch \
    fzf \
    fonts-font-awesome \
    lm-sensors \
    ranger \
    tmux \
    tmuxinator \
    autojump \
    python3-pip

  pip install i3ipc libtmux
  git clone git@github.com:alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
}

stow -t ~ */

while test $# -gt 0
do
    case "$1" in
        --zsh) install_zsh
            ;;
        --nvim) install_nvim
            ;;
        --regolith) install_regolith
            ;;
        --*) echo "Bad option $1"
            ;;
        *) echo "Argument $1"
            ;;
    esac
    shift
done

install_tools
