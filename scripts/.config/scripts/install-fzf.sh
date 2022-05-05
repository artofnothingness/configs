#!/bin/sh

git clone --depth 1 https://github.com/junegunn/fzf.git ./tmp-fzf
./tmp-fzf/install --bin
sudo cp ./tmp-fzf/bin/* /usr/local/bin

rm -rf ./tmp-fzf
