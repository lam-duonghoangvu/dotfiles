#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/config/git_config.sh"
"$SCRIPT_DIR/config/tmux_config.sh"
