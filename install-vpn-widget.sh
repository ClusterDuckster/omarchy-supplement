#!/bin/sh

# Install and configure the omarchy-vpn widget (WireGuard, NetBird, WARP, Tailscale).
omarchy pkg aur add omarchy-vpn

# Add the widget to the Omarchy bar (idempotent)
omarchy-vpn --setup

# Passwordless wg-quick for WireGuard backend (NetBird/WARP don't need this)
SUDOERS=/etc/sudoers.d/omarchy-vpn
if [ ! -f "$SUDOERS" ]; then
  echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/wg-quick, /usr/bin/ls /etc/wireguard" | sudo tee "$SUDOERS" > /dev/null
  sudo chmod 440 "$SUDOERS"
fi
