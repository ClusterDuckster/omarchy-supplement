#!/bin/sh

# Add the stowed WireGuard shell plugin to the Omarchy bar.
WIDGET_ID="olli.wireguard"
PLUGIN_DIR="$HOME/.config/omarchy/plugins/$WIDGET_ID"
SHELL_JSON="$HOME/.config/omarchy/shell.json"

if [ ! -f "$PLUGIN_DIR/manifest.json" ]; then
  echo "Plugin not found at $PLUGIN_DIR. Run install-dotfiles.sh first."
  exit 1
fi

omarchy-shell shell rescanPlugins

if grep -q "\"$WIDGET_ID\"" "$SHELL_JSON" 2>/dev/null; then
  echo "$WIDGET_ID already in bar layout"
else
  omarchy bar put "$WIDGET_ID" --section right --before omarchy.bluetooth
fi
