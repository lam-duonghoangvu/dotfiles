#!/usr/bin/env sh

sketchybar --add item calendar right \
  --subscribe calendar system_woke forced \
  --set calendar update_freq=10 \
  icon=󰃭 \
  script="$PLUGIN_DIR/calendar.sh"
