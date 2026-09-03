#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

MEDIA="$(swift "$HOME/.config/sketchybar/helper/media.swift" 2>/dev/null)"
MEDIA_ICON="󰎈"

if [ -n "$MEDIA" ] && [ "$MEDIA" != "NO_MEDIA" ]; then
  sketchybar --set "$NAME" drawing=on \
    icon="$MEDIA_ICON" \
    icon.color=$ICON_ACCENT_COLOR \
    label="$MEDIA"
else
  sketchybar --set "$NAME" drawing=off
fi
