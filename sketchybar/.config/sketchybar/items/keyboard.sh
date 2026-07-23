#!/usr/bin/env sh

sketchybar --add event input_change \
  --add item keyboard right \
  --subscribe keyboard input_change front_app_switched \
  --set keyboard update_freq=2 \
  icon=󰌌 \
  click_script="sketchybar --set \$NAME popup.drawing=toggle" \
  script="$PLUGIN_DIR/keyboard.sh"

HELPER="$HELPER_DIR/input_source"

if [ -x "$HELPER" ]; then
  "$HELPER" list | while IFS=$'\t' read -r name id; do
    [ -z "$name" ] && continue
    clean_id=$(echo "$id" | sed 's/[^a-zA-Z0-9]/_/g')
    item_name="keyboard.item.$clean_id"

    sketchybar --add item "$item_name" popup.keyboard \
      --set "$item_name" label="$name" \
      click_script="$HELPER select '$id'; sketchybar --set keyboard popup.drawing=off; sketchybar --trigger input_change"
  done
fi
