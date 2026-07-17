#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/banner.sh"
"$SCRIPT_DIR/install.sh"
"$SCRIPT_DIR/stow.sh"
"$SCRIPT_DIR/config.sh"
