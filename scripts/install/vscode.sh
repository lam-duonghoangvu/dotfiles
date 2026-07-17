#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../variables/colors.sh"

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

printf "Install Visual Studio Code and extensions? [y/N]: "
read -r ans </dev/tty || read -r ans || ans="n"
case "$ans" in
[yY][eE][sS] | [yY])
  "$SCRIPT_DIR/bundle_progress.sh" "$VSCODE_BREWFILE" "Visual Studio Code and extensions are installed"
  ;;
*)
  echo "Skipping Visual Studio Code"
  ;;
esac

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
