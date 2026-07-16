#!/bin/bash

XDG_CONFIG_HOME=~/.config

sudo apt update
sudo apt install -y software-properties-common stow curl

install_zsh() {
  curl -sS https://starship.rs/install.sh | sudo sh -s -- --yes
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  sudo apt install -y zsh zoxide
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
        i3xrocks-volume \
        i3xrocks-time \
        i3xrocks-keyboard-layout
}


install_tools() {
  sudo apt update
  sudo apt install -y \
    fastfetch \
    lm-sensors \
    tmux \
    autojump \
    python3-pip \
    python3-venv \
    ripgrep \
    fd-find \
    unzip \
    xclip

  sudo apt install python3-i3ipc python3-libtmux

  . ${XDG_CONFIG_HOME}/scripts/install-lazygit.sh
  . ${XDG_CONFIG_HOME}/scripts/install-yazi.sh
  . ${XDG_CONFIG_HOME}/scripts/install-fzf.sh

    git config --global user.email "aibudyakov@gg.com"
    git config --global user.name "Aleksey"
    git config --global pull.rebase true

    curl -fsSL https://opencode.ai/install | bash
}

install_neovim() {
    . ${XDG_CONFIG_HOME}/scripts/install-git.sh
    . ${XDG_CONFIG_HOME}/scripts/install-nvim.sh
    . ${XDG_CONFIG_HOME}/scripts/install-tree-sitter.sh
    if [ ! -d "$XDG_CONFIG_HOME/nvim" ]; then
        git clone https://github.com/artofnothingness/nvim.git $XDG_CONFIG_HOME/nvim
    fi

    sudo sysctl -w kernel.yama.ptrace_scope=0
}

install_gdb() {
    . ${XDG_CONFIG_HOME}/scripts/install-gdb.sh
}

install_wezterm() {
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

    sudo apt update
    sudo apt install -y wezterm
}

stow -v -R -t ~ */

while test $# -gt 0
do
    case "$1" in
        --tools) install_tools
            ;;
        --zsh) install_zsh
            ;;
        --regolith) install_regolith
            ;;
        --nvim) install_neovim
            ;;
        --gdb) install_gdb
            ;;
        --wezterm) install_wezterm
            ;;
        --*) echo "Bad option $1"
            ;;
        *) echo "Argument $1"
            ;;
    esac
    shift
done
