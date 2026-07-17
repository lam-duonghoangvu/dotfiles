#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

BREW_BIN=$(which brew 2>/dev/null ||
  { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } ||
  { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } ||
  { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } ||
  echo brew)

VSCODE_BREWFILE="brew/.config/brew/vscode.Brewfile"
WSL_VSCODE_EXT="ms-vscode-remote.remote-wsl"
IS_WSL=0

if grep -qi microsoft /proc/version 2>/dev/null || [ -n "${WSL_DISTRO_NAME:-}" ]; then
  IS_WSL=1
fi

echo -e "${CYAN}VISUAL STUDIO CODE${RESET}"
if [ ! -f "$VSCODE_BREWFILE" ]; then
  echo "$VSCODE_BREWFILE not found. Skipping"
  exit 1
fi

check_output=$("$BREW_BIN" bundle check --file="$VSCODE_BREWFILE" --verbose 2>&1 || true)
if ! echo "$check_output" | grep -q "dependencies are satisfied"; then
  printf "Install Visual Studio Code and extensions? [y/N]: "
  read -r ans </dev/tty || read -r ans || ans="n"
  case "$ans" in
  [yY][eE][sS] | [yY])
    missing_pkgs=$(echo "$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/')
    if [ -n "$missing_pkgs" ]; then
      echo -e "${YELLOW} Missing items:${RESET}"
      for pkg in $missing_pkgs; do echo "   [→] $pkg"; done
    fi
    echo -e "${CYAN} Installing Visual Studio Code and extensions...${RESET}"
    "$BREW_BIN" bundle install --quiet --file="$VSCODE_BREWFILE"
    ;;
  *)
    echo "Skipping Visual Studio Code"
    ;;
  esac
fi

if ! echo "$check_output" | grep -q "dependencies are satisfied"; then
  exit 1
fi

echo -e "${GREEN} [✓] Visual Studio Code is installed${RESET}"
echo -e "${GREEN} [✓] Visual Studio Code extensions are installed${RESET}"

if [ "$IS_WSL" = "1" ]; then
  echo -e "${CYAN}WSL DETECTED${RESET}"
  if command -v code >/dev/null 2>&1; then
    if code --list-extensions 2>/dev/null | grep -qi "^${WSL_VSCODE_EXT}$"; then
      echo -e "${GREEN} [✓] WSL VS Code extension (${WSL_VSCODE_EXT}) is already installed${RESET}"
    else
      echo -e "${CYAN} Installing WSL VS Code extension (${WSL_VSCODE_EXT})...${RESET}"
      code --install-extension "$WSL_VSCODE_EXT"
      echo -e "${GREEN} [✓] WSL VS Code extension installed${RESET}"
    fi
  else
    echo -e "${YELLOW} [!] 'code' CLI command not found. Skipping WSL VS Code extension installation.${RESET}"
  fi
fi
