#!/usr/bin/env bash
# Bootstrap a new machine (macOS or Ubuntu 24.04+). Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname)"

# link <source in repo> <target>: symlink, backing up any existing real file
link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "backed up $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

# --- Packages ---
if [ "$OS" = Darwin ]; then
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew bundle --file="$DOTFILES/Brewfile"
elif [ "$OS" = Linux ]; then
  sudo apt update -y
  sudo apt install -y zsh tmux git curl clang cmake protobuf-compiler unzip \
    pkg-config libssl-dev fzf fd-find ripgrep bat
  command -v nvim >/dev/null || sudo snap install nvim --classic
  [ "$(basename "$SHELL")" = zsh ] || sudo chsh -s "$(command -v zsh)" "$(whoami)"
fi

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Rust (+ starship on Linux; macOS gets it from brew) ---
if ! command -v rustup >/dev/null && [ ! -d "$HOME/.cargo" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-update-default-toolchain
fi
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
if ! command -v starship >/dev/null; then
  cargo install starship --locked
fi

# --- Config symlinks ---
link _zshrc      "$HOME/.zshrc"
link _gitconfig  "$HOME/.gitconfig"
link _tmux.conf  "$HOME/.tmux.conf"
link .config/nvim    "$HOME/.config/nvim"
link .config/ghostty "$HOME/.config/ghostty"

echo "Done. Open a new terminal; start nvim once to install plugins."
