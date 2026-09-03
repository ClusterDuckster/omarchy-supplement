#!/bin/sh

# German hyphenation data for LibreOffice
omarchy pkg add hyphen-de libreoffice-fresh-de

# The us_intl_custom keyboard layout is stowed from dotfiles to
# ~/.config/xkb/symbols/ and activated via ~/.config/hypr/input.lua.
# No system files needed on Omarchy 4 (Hyprland/Wayland uses libxkbcommon,
# which searches ~/.config/xkb). The old Xorg 00-keyboard.conf is obsolete.
