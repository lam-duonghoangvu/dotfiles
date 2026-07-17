#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

PERSONAL_BREWFILE="brew/.config/brew/personal.Brewfile"

if [ ! -f "$PERSONAL_BREWFILE" ]; then
  echo "$PERSONAL_BREWFILE not found. Skipping"
  exit 1
fi

printf "Install Homebrew personal formulae and casks? [y/N]: "
read -r ans </dev/tty || read -r ans || ans="n"
case "$ans" in
[yY][eE][sS] | [yY])
  "$SCRIPT_DIR/bundle_progress.sh" "$PERSONAL_BREWFILE" "Homebrew personal formulae and casks are installed"
  ;;
*)
  echo "Skipping Homebrew personal formulae and casks"
  ;;
esac
