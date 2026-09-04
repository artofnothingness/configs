#!/bin/bash

set -euo pipefail

if command -v tmux >/dev/null 2>&1; then
    VERSION=$(tmux -V 2>/dev/null | sed -n 's/^tmux \([0-9][0-9.]*\).*/\1/p')
    if [ -n "$VERSION" ] && dpkg --compare-versions "$VERSION" ge 3.4; then
        echo "tmux $VERSION already installed"
        exit 0
    fi
    echo "apt tmux is $VERSION, building fresh..."
else
    echo "tmux not installed, building fresh..."
fi

sudo apt install -y \
    build-essential \
    bison \
    pkg-config \
    libevent-dev \
    libncurses-dev

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

VERSION=3.7c
curl -fsSL -o "$TMPDIR/tmux.tar.gz" \
    "https://github.com/tmux/tmux/releases/download/$VERSION/tmux-$VERSION.tar.gz"
tar xzf "$TMPDIR/tmux.tar.gz" -C "$TMPDIR"

cd "$TMPDIR/tmux-$VERSION"
./configure
make -j"$(nproc)"
sudo make install

sudo apt remove -y tmux

echo "Installed: $(tmux -V)"