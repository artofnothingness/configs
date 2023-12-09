#!/bin/bash

sudo apt update
sudo apt install -y software-properties-common stow

install_zsh() {
  git clone --depth=1 git@github.com:ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  git clone --depth=1 git@github.com:romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone --depth=1 git@github.com:zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 git@github.com:zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  sudo apt install -y zsh autojump
}

install_tools() {
  sudo apt update
  sudo apt install -y \
    zsh \
    neofetch \
    fzf \
    lm-sensors \
    tmux \
    autojump \
    python3-pip

  pip install i3ipc libtmux
}

stow -t ~ */

while test $# -gt 0
do
    case "$1" in
        --tools) install_tools
            ;;
        --zsh) install_zsh
            ;;
        --*) echo "Bad option $1"
            ;;
        *) echo "Argument $1"
            ;;
    esac
    shift
done
