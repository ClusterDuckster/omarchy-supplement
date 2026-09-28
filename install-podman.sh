#!/bin/sh

omarchy pkg add podman podman-desktop

# Rootless API socket so Podman Desktop can connect without manual setup
systemctl --user enable --now podman.socket
