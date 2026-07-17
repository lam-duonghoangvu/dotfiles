#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

ESSENTIAL_BREWFILE="brew/.config/brew/Brewfile"

echo -e "${CYAN}HOMEBREW FORMULAE AND CASKS${RESET}"
if [ ! -f "$ESSENTIAL_BREWFILE" ]; then
  echo "$ESSENTIAL_BREWFILE not found. Skipping"
  exit 1
fi

check_output=$("$BREW_BIN" bundle check --file="$ESSENTIAL_BREWFILE" --verbose 2>&1 || true)
if echo "$check_output" | grep -q "dependencies are satisfied"; then
  echo -e "${GREEN} [✓] All essential dependencies are already installed${RESET}"
else
  missing_pkgs=$(echo "$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/')
  if [ -n "$missing_pkgs" ]; then
    echo -e "${YELLOW} Missing essential dependencies:${RESET}"
    for pkg in $missing_pkgs; do echo "   [→] $pkg"; done
  fi
  echo -e "${CYAN} Installing essential dependencies...${RESET}"
  "$BREW_BIN" bundle install --quiet --file="$ESSENTIAL_BREWFILE"
  echo -e "${GREEN} [✓] All essential dependencies are installed${RESET}"
fi
