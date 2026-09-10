#!/usr/bin/env sh

sketchybar --add event input_change \
  --add item keyboard right \
  --subscribe keyboard input_change front_app_switched \
  --set keyboard update_freq=2 \
  icon=󰌌 \
  click_script="sketchybar --set \$NAME popup.drawing=toggle" \
  script="$PLUGIN_DIR/keyboard.sh"
