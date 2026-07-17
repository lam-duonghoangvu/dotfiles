#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

OS="$(uname -s)"

echo -e "${CYAN}ZSH${RESET}"
if command -v zsh >/dev/null 2>&1; then
  echo -e "${GREEN} [✓] Zsh: Installed at $(command -v zsh)${RESET}"
  exit 0
fi

if [ "$OS" = "Darwin" ]; then
  echo "macOS detected Zsh is usually pre-installed"
elif [ "$OS" = "Linux" ]; then
  if [ -f /etc/debian_version ]; then
    echo "Debian/Ubuntu detected. Installing zsh..."
    sudo apt-get update && sudo apt-get install -y zsh
  elif [ -f /etc/redhat-release ] || [ -f /etc/dnf/dnf.conf ]; then
    echo "Fedora/RHEL/CentOS detected. Installing zsh..."
    sudo dnf install -y zsh || sudo yum install -y zsh
  elif [ -f /etc/arch-release ]; then
    echo "Arch Linux detected. Installing zsh..."
    sudo pacman -S --noconfirm zsh
  else
    echo "Unsupported Linux distribution. Please install zsh manually"
    exit 1
  fi
else
  echo "Unsupported OS: $OS"
  exit 1
fi
