#!/bin/bash

set -e

ICON_DIR="$HOME/.local/share/applications/icons"
DESKTOP_DIR="$HOME/.local/share/applications/"

# Predefined list of web apps to remove
WEB_APPS=(
  "Basecamp"
  "Figma"
  "Google Contacts"
  "Google Messages"
  "Google Photos"
  "HEY"
  "X"
  "Zoom"
)

for APP_NAME in "${WEB_APPS[@]}"; do
  DESKTOP_FILE="$DESKTOP_DIR/$APP_NAME.desktop"
  ICON_FILE="$ICON_DIR/$APP_NAME.png"
  
  # Remove desktop file if it exists
  if [[ -f "$DESKTOP_FILE" ]]; then
    rm -f "$DESKTOP_FILE"
    echo "Removed $APP_NAME desktop file"
  else
    echo "Desktop file not found for $APP_NAME (skipped)"
  fi
  
  # Remove icon file if it exists
  if [[ -f "$ICON_FILE" ]]; then
    rm -f "$ICON_FILE"
    echo "Removed $APP_NAME icon"
  else
    echo "Icon file not found for $APP_NAME (skipped)"
  fi
done

echo "Done removing WebApps."
