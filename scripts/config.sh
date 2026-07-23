#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/config/git.sh"
"$SCRIPT_DIR/config/tmux.sh"
"$SCRIPT_DIR/config/zen.sh"
"$SCRIPT_DIR/config/beeper.sh"
"$SCRIPT_DIR/config/better_discord.sh"
"$SCRIPT_DIR/config/macos.sh"
