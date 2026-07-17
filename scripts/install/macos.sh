#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

MACOS_BREWFILE="brew/.config/brew/macos.Brewfile"

if [ ! -f "$MACOS_BREWFILE" ]; then
  echo "$MACOS_BREWFILE not found. Skipping"
  exit 1
fi

printf "Install Homebrew macOS casks? [y/N]: "
read -r ans </dev/tty || read -r ans || ans="n"
case "$ans" in
[yY][eE][sS] | [yY])
  "$SCRIPT_DIR/bundle_progress.sh" "$MACOS_BREWFILE" "Homebrew macOS casks are installed"
  ;;
*)
  echo "Skipping Homebrew macOS casks"
  ;;
esac
