#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_WAYBAR="$SCRIPT_DIR/waybar"
TARGET="$HOME/.config/waybar"

if [ ! -d "$REPO_WAYBAR" ]; then
    echo "Error: repo waybar directory not found at $REPO_WAYBAR"
    exit 1
fi

echo "Copying Waybar config from $REPO_WAYBAR to $TARGET..."
mkdir -p "$TARGET"
cp -a "$REPO_WAYBAR/." "$TARGET/"

chmod +x -R "$TARGET/scripts/"

echo "Copied Waybar files from repo waybar/ to $TARGET."
