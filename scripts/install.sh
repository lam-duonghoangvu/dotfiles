#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/install/zsh.sh"
"$SCRIPT_DIR/install/homebrew.sh"
"$SCRIPT_DIR/install/essential.sh"
"$SCRIPT_DIR/install/macos.sh"
"$SCRIPT_DIR/install/personal.sh"
"$SCRIPT_DIR/install/vscode.sh"
"$SCRIPT_DIR/install/mas.sh"
