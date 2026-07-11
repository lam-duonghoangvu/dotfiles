# Dotfiles

Personal configurations and dotfiles managed with GNU Stow.

## Installation Guide

### Setup

Install `zsh`, `Homebrew` and dependencies with `make`

### Apply Dotfiles

Once the brew packages are installed (including `stow`), you can symlink configurations to your home directory using GNU Stow.

From the repository root directory, stow the packages you want to use:

```zsh
cd ~/dotfiles
```

```zsh
stow <package>
```

### tmux
```zsh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
