#!/usr/bin/env sh

sketchybar --add event media_change \
  --add item media left \
  --subscribe media media_change system_woke front_app_switched \
  --set media update_freq=3 \
  updates=on \
  drawing=off \
  scroll_texts=on \
  label.scroll_duration=1000 \
  label.max_chars=55 \
  script="$PLUGIN_DIR/media.sh"
