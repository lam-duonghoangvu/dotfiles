#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item "space.$sid" left \
    --subscribe "space.$sid" aerospace_workspace_change \
    --set "space.$sid" \
    icon="$sid" \
    icon.color=$TEXT \
    icon.highlight_color=$ICON_ACCENT_COLOR \
    icon.padding_left=10 \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/plugins/aerospacer.sh $sid"
done
