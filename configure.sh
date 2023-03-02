#!/bin/bash

sudo apt update
sudo apt install -y software-properties-common stow

install_regolith() {
  wget -qO - https://regolith-desktop.org/regolith.key | \
    gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

  echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
    https://regolith-desktop.org/release-ubuntu-jammy-amd64 jammy main" | \
    sudo tee /etc/apt/sources.list.d/regolith.list

  sudo apt update
  sudo apt install regolith-desktop regolith-compositor-picom-glx
  sudo apt install -y i3xrocks-focused-window-name i3xrocks-rofication i3xrocks-info i3xrocks-app-launcher i3xrocks-memory
  sudo apt upgrade
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
  echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:stig124:nnn.list
  curl -fsSL https://download.opensuse.org/repositories/home:stig124:nnn/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg > /dev/null

  sudo apt update
  sudo apt install -y \
    zsh \
    neofetch \
    fzf \
    fonts-font-awesome \
    lm-sensors \
    nnn \
    tmux \
    tmuxinator \
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
