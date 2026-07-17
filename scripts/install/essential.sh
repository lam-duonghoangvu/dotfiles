#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

ESSENTIAL_BREWFILE="brew/.config/brew/Brewfile"

echo -e "${CYAN}HOMEBREW FORMULAE AND CASKS${RESET}"
if [ ! -f "$ESSENTIAL_BREWFILE" ]; then
  echo "$ESSENTIAL_BREWFILE not found. Skipping"
  exit 1
fi

"$SCRIPT_DIR/bundle_progress.sh" "$ESSENTIAL_BREWFILE" "All essential dependencies are installed"
