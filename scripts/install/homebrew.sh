#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"
echo "${CYAN}HOMEBREW${RESET}"

OS="$(uname -s)"
if [ "$OS" != "Darwin" ]; then
  echo "${RED} Homerbrew should not be installed anywhere outside of MacOS ${RESET}"
  exit 1
fi

BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

if [ -x "$BREW_BIN" ] || command -v brew >/dev/null 2>&1; then
  echo "${GREEN} [✓] Homebrew: Installed at ${BREW_BIN}${RESET}"
  exit 0
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
