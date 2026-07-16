#!/bin/bash

sudo apt install -y \
    python3-pip \
    python3-venv \
    ripgrep \
    fd-find \
    unzip \
    xclip


set -euo pipefail

export PATH="$HOME/.cargo/bin:$PATH"

if ! command -v cargo &>/dev/null; then
    echo "Installing rustup (for cargo)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
fi

cargo install tree-sitter-cli

sudo rm -f /usr/local/bin/tree-sitter
sudo ln -s "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter

echo "Installed: $(tree-sitter --version)"
