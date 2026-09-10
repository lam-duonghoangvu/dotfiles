#!/usr/bin/env bash

LAYOUT="$("$HOME/.config/sketchybar/helper/input_source")"

if [ -z "$LAYOUT" ]; then
  LAYOUT="ABC"
fi

case "$LAYOUT" in
*"ABC"*) LAYOUT="ABC" ;;
*"Telex"*) LAYOUT="VNI" ;;
esac

sketchybar --set "$NAME" label="$LAYOUT"
