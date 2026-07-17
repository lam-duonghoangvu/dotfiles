#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

STOW_PACKAGES="bash bat brew btop fastfetch ghostty nvim starship tmux zsh"

echo -e "${CYAN}STOWING CONFIGS${RESET}"
for pkg in $STOW_PACKAGES; do
  echo " Stowing $pkg"
  stow -R "$pkg"
done
