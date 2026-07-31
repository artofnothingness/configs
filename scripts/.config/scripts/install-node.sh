#!/bin/bash

set -euo pipefail

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

VERSION=$(curl -fsSL --retry 3 --retry-all-errors -o "$TMPDIR/index.json" https://nodejs.org/dist/index.json \
    && grep -m1 '"lts": *"[^"]' "$TMPDIR/index.json" \
    | sed -E 's/.*"version": *"([^"]+)".*/\1/')

ARCHIVE="node-${VERSION}-linux-x64.tar.xz"

echo "Downloading node $VERSION from nodejs.org"
curl -fsSL --retry 3 --retry-all-errors -o "$TMPDIR/$ARCHIVE" "https://nodejs.org/dist/$VERSION/$ARCHIVE"

mkdir -p "$TMPDIR/extracted"
tar xJf "$TMPDIR/$ARCHIVE" -C "$TMPDIR/extracted"

SRC="$TMPDIR/extracted/node-${VERSION}-linux-x64"

if [ -x /usr/bin/node ] && dpkg -s nodejs &>/dev/null; then
    echo "Removing old apt nodejs package..."
    sudo apt remove -y nodejs
fi

sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/share /usr/local/include
sudo cp -r "$SRC/bin/." /usr/local/bin/
sudo cp -r "$SRC/lib/." /usr/local/lib/
sudo cp -r "$SRC/share/." /usr/local/share/
sudo cp -r "$SRC/include/." /usr/local/include/

node --version
npm --version
