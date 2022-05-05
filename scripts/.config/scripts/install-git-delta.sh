#!/bin/sh

curl -Lo git-delta.deb "https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb"
sudo dpkg -i git-delta.deb

rm -rf git-delta.deb
