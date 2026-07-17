#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/install_brew.sh"
"$SCRIPT_DIR/install_essential.sh"
"$SCRIPT_DIR/install_formulae.sh"
"$SCRIPT_DIR/install_casks.sh"
"$SCRIPT_DIR/install_vscode.sh"
"$SCRIPT_DIR/install_mas.sh"
