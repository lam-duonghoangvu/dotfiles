#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BEEPER_DOTFILES_DIR="$SCRIPT_DIR/../../beeper"
BEEPER_APP_SUPPORT="$HOME/Library/Application Support/BeeperTexts"
source "$SCRIPT_DIR/../variables/colors.sh"

echo -e "${CYAN}BEEPER${RESET}"

if [ ! -d "$BEEPER_APP_SUPPORT" ]; then
  echo "${RED} $BEEPER_APP_SUPPORT not found. Skipping Beeper config${RESET}"
  exit 0
fi

if [ -f "$BEEPER_DOTFILES_DIR/custom.css" ]; then
  ln -sf "$BEEPER_DOTFILES_DIR/custom.css" "$BEEPER_APP_SUPPORT/custom.css"
  echo -e "${GREEN} Linked custom.css into BeeperTexts${RESET}"
fi
