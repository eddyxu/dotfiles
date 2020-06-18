#!/bin/sh

set -e

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip3 install --upgrade neovim
mkdir -p ~/.config/nvim
cp _vimrc ~/.config/nvim/init.vim

nvim +PlugInstall +UpdateRemotePlugins +qa
