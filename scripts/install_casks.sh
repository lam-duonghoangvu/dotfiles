#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

CASK_BREWFILE="brew/.config/brew/cask.Brewfile"

if [ ! -f "$CASK_BREWFILE" ]; then
  echo "$CASK_BREWFILE not found. Skipping"
  exit 1
fi

check_output=$("$BREW_BIN" bundle check --file="$CASK_BREWFILE" --verbose 2>&1 || true)
if echo "$check_output" | grep -q "dependencies are satisfied"; then
  echo -e "${GREEN} [✓] Homebrew casks are already installed${RESET}"
  exit 0
fi

printf "Install Homebrew casks? [y/N]: "
read -r ans </dev/tty || read -r ans || ans="n"
case "$ans" in
[yY][eE][sS] | [yY])
  missing_pkgs=$(echo "$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/')
  if [ -n "$missing_pkgs" ]; then
    echo -e "${YELLOW} Missing items:${RESET}"
    for pkg in $missing_pkgs; do echo "   [→] $pkg"; done
  fi
  echo -e "${CYAN} Installing Homebrew casks...${RESET}"
  "$BREW_BIN" bundle install --quiet --file="$CASK_BREWFILE"
  echo -e "${GREEN} [✓] Homebrew casks are installed${RESET}"
  ;;
*)
  echo "Skipping Homebrew casks"
  ;;
esac
