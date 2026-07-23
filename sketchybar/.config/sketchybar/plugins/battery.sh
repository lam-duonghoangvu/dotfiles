#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

BATT_INFO="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT_INFO" | grep -o "[0-9]\{1,3\}%" | tr -d '%')"
CHARGING="$(echo "$BATT_INFO" | grep 'AC Power')"
LOW_POWER="$(pmset -g | grep -w 'lowpowermode' | awk '{print $2}')"

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

COLOR=$TEXT
ICON="󰁹"

if [ -n "$CHARGING" ]; then
  ICON="󰂄"
  COLOR=$GREEN
else
  case "$PERCENTAGE" in
  9[0-9] | 100) ICON="󰁹" ;;
  8[0-9]) ICON="󰂂" ;;
  7[0-9]) ICON="󰂀" ;;
  6[0-9]) ICON="󰁿" ;;
  5[0-9]) ICON="󰁾" ;;
  4[0-9]) ICON="󰁽" ;;
  3[0-9]) ICON="󰁼" COLOR=$RED ;;
  2[0-9]) ICON="󰁻" COLOR=$RED ;;
  1[0-9]) ICON="󰁺" COLOR=$RED ;;
  *) ICON="󰂎" COLOR=$RED ;;
  esac
fi

if [ "$LOW_POWER" = "1" ]; then
  COLOR=$YELLOW
fi

sketchybar --set "$NAME" icon="$ICON" \
  icon.color="$COLOR" \
  label="${PERCENTAGE}%"
