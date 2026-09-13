#!/usr/bin/env bash

LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources |
  grep -E -m 1 'KeyboardLayout Name|Input Mode' |
  sed -E 's/.*= *"?([^";]+)"?;/\1/')"

case "$LAYOUT" in
*"ABC"*) LAYOUT="ABC" ;;
*"Telex"*) LAYOUT="VNI" ;;
*)       LAYOUT="NIL" ;;
esac

sketchybar --set "$NAME" label="$LAYOUT"
