#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

OS="$(uname -s)"
if [ "$OS" != "Darwin" ]; then
  exit 0
fi

BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

MAS_BREWFILE="brew/.config/brew/mas.Brewfile"

if [ ! -f "$MAS_BREWFILE" ]; then
  echo "$MAS_BREWFILE not found. Skipping installing App Store application"
  exit 1
fi

echo -e "${CYAN}APP STORE APPLICATIONS${RESET}"
check_output=$("$BREW_BIN" bundle check --file="$MAS_BREWFILE" --verbose 2>&1 || true)
if echo "$check_output" | grep -q "dependencies are satisfied"; then
  echo -e "${GREEN} [✓] mas is already installed${RESET}"
  echo -e "${GREEN} [✓] App Store applications are already installed${RESET}"
  exit 0
fi

printf "Install mas and App Store applications? [y/N]: "
read -r ans </dev/tty || read -r ans || ans="n"
case "$ans" in
[yY][eE][sS] | [yY])
  missing_pkgs=$(echo "$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/')
  if [ -n "$missing_pkgs" ]; then
    echo -e "${YELLOW} Missing items:${RESET}"
    for pkg in $missing_pkgs; do echo "   [→] $pkg"; done
  fi
  echo -e "${CYAN} Installing App Store applications...${RESET}"
  "$BREW_BIN" bundle install --quiet --file="$MAS_BREWFILE"
  echo -e "${GREEN} [✓] mas is installed${RESET}"
  echo -e "${GREEN} [✓] App Store applications are installed${RESET}"
  ;;
*)
  echo "Skipping App Store applications"
  ;;
esac
