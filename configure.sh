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

install_regolith() {
    wget -qO - https://regolith-desktop.org/regolith.key | \
        gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

    echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
    https://regolith-desktop.org/release-current-ubuntu-jammy-amd64 jammy main" | \
    sudo tee /etc/apt/sources.list.d/regolith.list

    sudo apt update

    sudo apt install \
        regolith-desktop \
        regolith-session-flashback

    sudo apt install \
        i3xrocks-battery \
        i3xrocks-weather \
        i3xrocks-rofication \
        i3xrocks-focused-window-name \
        i3xrocks-disk-capacity \
        i3xrocks-app-launcher \
        i3xrocks-info \
        i3xrocks-volume \
        i3xrocks-keyboard-layout
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
        --regolith) install_regolith
            ;;
        --*) echo "Bad option $1"
            ;;
        *) echo "Argument $1"
            ;;
    esac
    shift
done
