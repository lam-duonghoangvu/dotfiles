#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" icon.color="$ICON_ACCENT_COLOR" icon.highlight=on
else
  sketchybar --set "$NAME" icon.color="$TEXT" icon.highlight=off
fi
