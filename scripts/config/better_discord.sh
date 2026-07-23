#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BD_DOTFILES_DIR="$SCRIPT_DIR/../../better-discord"
BD_APP_SUPPORT="$HOME/Library/Application Support/BetterDiscord"
source "$SCRIPT_DIR/../variables/colors.sh"

echo -e "${CYAN}BETTER DISCORD${RESET}"

if [ ! -d "$BD_APP_SUPPORT" ]; then
  echo "${RED} $BD_APP_SUPPORT not found. Skipping Better Discord config${RESET}"
  exit 0
fi

if [ -f "$BD_DOTFILES_DIR/custom.css" ]; then
  mkdir -p "$BD_APP_SUPPORT/data"
  if [ -d "$BD_APP_SUPPORT/data/stable" ]; then
    ln -sf "$BD_DOTFILES_DIR/custom.css" "$BD_APP_SUPPORT/data/stable/custom.css"
    echo -e "${GREEN} Linked custom.css into BetterDiscord/data/stable/${RESET}"
  fi
fi
