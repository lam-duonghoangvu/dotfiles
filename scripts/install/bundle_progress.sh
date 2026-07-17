#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

BREWFILE="${1:-}"
LABEL="${2:-Dependencies installed}"

if [ -z "$BREWFILE" ] || [ ! -f "$BREWFILE" ]; then
  echo "Usage: $0 <path-to-Brewfile> [completion-label]"
  exit 1
fi

TOTAL=$(grep -cE '^\s*(brew|cask|vscode|mas|tap)\b' "$BREWFILE" 2>/dev/null || echo 0)

if [ "$TOTAL" -eq 0 ]; then
  "$BREW_BIN" bundle install --file="$BREWFILE"
  printf "\r\033[K${GREEN} [✓] %s${RESET}\n" "$LABEL"
  exit 0
fi

CURRENT=0

while IFS= read -r line; do
  if echo "$line" | grep -qE '^(Installing|Using|Upgrading)\b'; then
    CURRENT=$((CURRENT + 1))
    if [ "$CURRENT" -gt "$TOTAL" ]; then
      CURRENT=$TOTAL
    fi
    printf "\r\033[K${CYAN}[%d/%d]${RESET} %s" "$CURRENT" "$TOTAL" "$line"
  fi
done < <("$BREW_BIN" bundle install --file="$BREWFILE" --verbose 2>&1)

printf "\r\033[K${GREEN} [✓] %s${RESET}\n" "$LABEL"
