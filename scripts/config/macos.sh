#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

echo -e "${CYAN}MACOS CONFIG${RESET}"

defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0
killall Dock 2>/dev/null || true

echo -e "${GREEN} [✓] Dock autohide delay and animation speed set to 0${RESET}"
