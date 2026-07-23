#!/usr/bin/env sh

sketchybar --add item battery right \
  --subscribe battery power_source_change system_woke front_app_switched \
  --set battery update_freq=15 \
  script="$PLUGIN_DIR/battery.sh"
