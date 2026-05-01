#!/bin/bash

# Get the active layout index from hyprctl
ACTIVE_INDEX=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_layout_index // -1')

case "$ACTIVE_INDEX" in
    0)
        DISPLAY_TEXT="US"
        CLASS="us"
        ;;
    1)
        DISPLAY_TEXT="US-INTL"
        CLASS="us-intl"
        ;;
    *)
        DISPLAY_TEXT="??"
        CLASS="unknown"
        ;;
esac

# Output in JSON format for waybar
printf '{"text":"%s","class":"%s"}\n' "$DISPLAY_TEXT" "$CLASS"