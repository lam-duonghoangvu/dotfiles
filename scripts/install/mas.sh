#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

OS="$(uname -s)"
if [ "$OS" != "Darwin" ]; then
  exit 0
fi

MAS_BREWFILE="brew/.config/brew/mas.Brewfile"

if [ ! -f "$MAS_BREWFILE" ]; then
  echo "$MAS_BREWFILE not found. Skipping"
  exit 1
fi

echo -e "${CYAN}APP STORE APPLICATIONS${RESET}"
printf "Install mas and App Store applications? [y/N]: "
read -r ans </dev/tty || read -r ans || ans="n"
case "$ans" in
[yY][eE][sS] | [yY])
  "$SCRIPT_DIR/bundle_progress.sh" "$MAS_BREWFILE" "App Store applications are installed"
  ;;
*)
  echo "Skipping App Store applications"
  ;;
esac
