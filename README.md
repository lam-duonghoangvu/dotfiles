# Dotfiles

Personal configurations and dotfiles managed with GNU Stow.

## Installation Guide

Follow these steps to set up your environment on a new machine.

### Install Zsh

#### On Ubuntu / Debian:

```shell
sudo apt update
sudo apt install zsh -y
```

#### On Fedora / RHEL:

```shell
sudo dnf install zsh -y
```

#### On Arch Linux:

```shell
sudo pacman -S zsh --noconfirm
```

---

### Install Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### Install Brew Formulae and Casks

This repository includes a [Brewfile](brew/.Brewfile) listing all necessary tools, fonts, casks (GUI apps), and Mac App Store apps.

```zsh
brew bundle install --file ~/.config/brew/Brewfile
```

---

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
