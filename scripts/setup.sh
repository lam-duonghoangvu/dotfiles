#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear 2>/dev/null || printf"\033[2J\033[H"
"$SCRIPT_DIR/install.sh"
"$SCRIPT_DIR/stow.sh"
"$SCRIPT_DIR/config.sh"
