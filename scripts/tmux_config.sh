#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

TMUX_TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"
TMUX_INSTALL_PLUGINS="$TMUX_TPM_DIR/bin/install_plugins"
TMUX_TPM_GIT_REMOTE="https://github.com/tmux-plugins/tpm"

echo -e "${CYAN}TMUX CONFIG${RESET}"
if [ ! -d "$TMUX_TPM_DIR" ]; then
  echo "Installing TPM..."
  mkdir -p "$(dirname "$TMUX_TPM_DIR")"
  git clone "$TMUX_TPM_GIT_REMOTE" "$TMUX_TPM_DIR"
  echo -e "${GREEN} [✓] TPM is installed${RESET}"
else
  echo -e "${GREEN} [✓] TPM is already installed${RESET}"
fi

if [ -x "$TMUX_INSTALL_PLUGINS" ]; then
  echo "Installing Tmux plugins..."
  "$TMUX_INSTALL_PLUGINS"
  echo -e "${GREEN} [✓] Tmux plugins installed${RESET}"
fi
