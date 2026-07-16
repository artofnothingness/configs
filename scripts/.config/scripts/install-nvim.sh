#!/bin/bash

set -euo pipefail

VERSION=${NVIM_VERSION:-nightly}
ARCHIVE="nvim-linux-x86_64.tar.gz"

if [ "$VERSION" = "nightly" ]; then
    URL="https://github.com/neovim/neovim/releases/download/nightly/$ARCHIVE"
else
    LATEST=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" \
        | grep '"tag_name"' \
        | head -1 \
        | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
    URL="https://github.com/neovim/neovim/releases/download/${LATEST}/$ARCHIVE"
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading neovim ($VERSION) from $URL"
curl -fsSL -o "$TMPDIR/$ARCHIVE" "$URL"

mkdir -p "$TMPDIR/extracted"
tar xzf "$TMPDIR/$ARCHIVE" -C "$TMPDIR/extracted"

DEST="/usr/local"
if dpkg -s neovim &>/dev/null; then
    echo "Removing old apt neovim package..."
    sudo apt remove -y neovim
fi

sudo apt install -y \
    python3-pip \
    python3-venv \
    ripgrep \
    fd-find \
    unzip \
    python3-pynvim \
    npm \
    xclip

SRC="$TMPDIR/extracted/nvim-linux-x86_64"

sudo mkdir -p "$DEST/bin" "$DEST/lib" "$DEST/share"
sudo cp "$SRC/bin/nvim" "$DEST/bin/"
sudo cp -r "$SRC/lib/nvim" "$DEST/lib/"
sudo cp -r "$SRC/share/"* "$DEST/share/"

if [ -f "$DEST/bin/nvim" ]; then
    NVIM_VERSION=$("$DEST/bin/nvim" --version | head -1)
    echo "Installed: $NVIM_VERSION"
else
    echo "ERROR: nvim binary not found after install"
    exit 1
fi
