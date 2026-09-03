#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/install/zsh.sh"
"$SCRIPT_DIR/install/homebrew.sh"
