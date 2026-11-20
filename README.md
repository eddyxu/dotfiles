# dotfiles

Personal config for zsh, git, tmux, neovim and Ghostty.

## New machine

```bash
git clone <this repo> ~/work/dotfiles
cd ~/work/dotfiles
./install.sh
```

`install.sh` is idempotent: it installs packages (Homebrew + `Brewfile` on macOS, apt on Ubuntu),
Oh My Zsh, Rust and starship, then symlinks the configs below. Existing real files are
moved to `*.bak.<timestamp>`.

| Repo path | Linked to |
|---|---|
| `_zshrc` | `~/.zshrc` (machine-specific bits go in `~/.zshrc.local`) |
| `_gitconfig` | `~/.gitconfig` |
| `_tmux.conf` | `~/.tmux.conf` (tuned for claude/codex over ssh) |
| `.config/nvim` | `~/.config/nvim` |
| `.config/ghostty` | `~/.config/ghostty` |

`vim/` is the legacy plain-vim setup (`vim/set_vim.sh`); not installed by default.

## Remote machines

Only tmux config is needed: `ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf`.
