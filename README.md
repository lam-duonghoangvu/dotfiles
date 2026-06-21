# Dotfiles

Personal configurations and dotfiles managed with GNU Stow.

## Installation Guide

Follow these steps to set up your environment on a new machine.

### Step 1: Install Zsh (Non-macOS only)

#### On Ubuntu / Debian:

```bash
sudo apt update
sudo apt install zsh -y
```

#### On Fedora / RHEL:

```bash
sudo dnf install zsh -y
```

#### On Arch Linux:

```bash
sudo pacman -S zsh --noconfirm
```

#### Set Zsh as your Default Shell

Once installed, change your default login shell to Zsh:

```bash
chsh -s $(which zsh)
```

_(You may need to log out and log back in for changes to take effect.)_

---

### Step 2: Install Homebrew (brew)

#### Installation Command

Run the official installation script:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Add Homebrew to your Shell Environment

Depending on your hardware and OS, run the following commands to add Homebrew to your PATH.

##### For Apple Silicon Macs (M1/M2/M3/M4):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

##### For Linux:

```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

##### For Intel Macs:

Homebrew is installed in `/usr/local` by default, but you can ensure it's in your shell environment:

```bash
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

---

### Step 3: Install Brew Formulae and Casks

This repository includes a [Brewfile](brew/.Brewfile) listing all necessary tools, fonts, casks (GUI apps), and Mac App Store apps.

Navigate to the repository root and run:

```bash
brew bundle --file brew/.Brewfile
```

---

### Step 4: Apply Dotfiles (Using GNU Stow)

Once the brew packages are installed (including `stow`), you can symlink configurations to your home directory using GNU Stow.

From the repository root directory, stow the packages you want to use:

```bash
cd ~/dotfiles
```

```bash
stow <package>
```
