#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/variables/colors.sh"

DOTFILES_REPO="https://github.com/lam-duonghoangvu/dotfiles.git"

echo -e "${CYAN}PULLING LATEST DOTFILES${RESET}"
OLD_HASH=$(git hash-object Makefile 2>/dev/null || echo "1")
echo "Pulling latest changes from $DOTFILES_REPO..."

if git pull "$DOTFILES_REPO"; then
  NEW_HASH=$(git hash-object Makefile 2>/dev/null || echo "2")
  if [ "$OLD_HASH" != "$NEW_HASH" ]; then
    echo -e "${YELLOW}[!] Makefile has been amended. Re-executing with the new Makefile...${RESET}"
    exec make all
  else
    echo -e "${GREEN}[✓] Makefile is unchanged. Running scripts...${RESET}"
    exec make all
  fi
else
  echo -e "${RED}[✗] Failed to pull from $DOTFILES_REPO${RESET}"
  exit 1
fi
