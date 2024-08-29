#!/usr/bin/env bash
#

set -ex

OS=`uname`

if [ $OS = 'Linux' ]; then
  # Ubuntu 24.04+ only
  sudo apt update -y
  sudo apt install -y zsh clang cmake protobuf-compiler unzip pkg-config libssl-dev
  sudo snap install nvim --classic
  sudo chsh -s $(which zsh) $(whoami)
fi

# Zsh
rm -rf ~/.oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
ln -s -f ${PWD}/_zshrc ~/.zshrc
ln -s -f ${PWD}/_gitconfig ~/.gitconfig
mkdir -p ~/.config
ln -s $(realpath .config/nvim) ~/.config/nvim


# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-update-default-toolchain
. "$HOME/.cargo/env"
cargo install starship --locked
