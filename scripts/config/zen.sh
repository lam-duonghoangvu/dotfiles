#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZEN_DOTFILES_DIR="$SCRIPT_DIR/../../zen"
ZEN_APP_SUPPORT="$HOME/Library/Application Support/Zen"
source "$SCRIPT_DIR/../variables/colors.sh"

echo -e "${CYAN}ZEN BROWSER${RESET}"

if [ ! -d "$ZEN_APP_SUPPORT/Profiles" ]; then
  echo "${RED} $ZEN_APP_SUPPORT/Profiles. Skipping Zen Browser config${RESET}"
  exit 0
fi

for profile in "$ZEN_APP_SUPPORT/Profiles"/*; do
  if [ -d "$profile" ]; then
    profile_name="$(basename "$profile")"
    echo -e " Setting up profile: ${GREEN}${profile_name}${RESET}"

    ln -sf "$ZEN_DOTFILES_DIR/user.js" "$profile/user.js"

    ln -snf "$ZEN_DOTFILES_DIR/config" "$profile/config"

    # Symlink chrome directory contents
    mkdir -p "$profile/chrome"
    for item in "$ZEN_DOTFILES_DIR/chrome"/*; do
      item_name="$(basename "$item")"
      ln -snf "$item" "$profile/chrome/$item_name"
    done

    echo "   Linked user.js, config, and modular chrome CSS into $profile_name"
  fi
done

echo -e "${GREEN}Zen Browser configuration applied successfully!${RESET}"
