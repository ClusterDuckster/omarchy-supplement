#!/bin/sh

# wireguard-tools for wg-quick, openresolv for DNS
omarchy pkg add wireguard-tools openresolv

# Passwordless wg-quick and profile listing for the WireGuard bar widget
SUDOERS=/etc/sudoers.d/wireguard-widget
if [ ! -f "$SUDOERS" ] && [ ! -f /etc/sudoers.d/waybar-vpn ]; then
  echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/wg-quick, /usr/bin/find /etc/wireguard -maxdepth 1 -name *.conf" | sudo tee "$SUDOERS" > /dev/null
  sudo chmod 440 "$SUDOERS"
fi
