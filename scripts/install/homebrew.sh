#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

OS="$(uname -s)"
BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

echo -e "${CYAN}HOMEBREW${RESET}"
if [ -x "$BREW_BIN" ] || command -v brew >/dev/null 2>&1; then
  echo -e "${GREEN} [✓] Homebrew: Installed at ${BREW_BIN}${RESET}"
  exit 0
fi

if [ "$OS" = "Linux" ]; then
  echo "Installing Linux build dependencies for Homebrew..."
  if [ -f /etc/debian_version ]; then
    sudo apt-get update && sudo apt-get install -y build-essential procps curl file git
  elif [ -f /etc/redhat-release ] || [ -f /etc/dnf/dnf.conf ]; then
    sudo dnf groupinstall -y "Development Tools" && sudo dnf install -y procps-ng curl file git
  elif [ -f /etc/arch-release ]; then
    sudo pacman -S --needed --noconfirm base-devel procps-ng curl file git
  fi
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
