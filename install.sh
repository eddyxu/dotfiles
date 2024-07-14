#!/usr/bin/env bash
#

OS=`uname`

if [[ $OS = 'Linux' ]]; then
  # Ubuntu 24.04+ only
  sudo apt update -y
  sudo apt install -y zsh clang cmake protobuf-compiler
  sudo snap install nvim --classic -y
  sudo chsh -s $(which zsh) $(whoami)
fi

# Zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
ln -s -f ${PWD}/_zshrc ~/.zshrc
ln -s -f ${PWD}/_gitconfig ~/.gitconfig
ln -s $(realpath .config/nvim) ~/.config/nvim


# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y --no-update-default-toolchain
cargo install starship --locked
