#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/git_config.sh"
"$SCRIPT_DIR/tmux_config.sh"
