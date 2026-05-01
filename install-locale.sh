#!/bin/sh

# hyphenation data for libre office
sudo pacman -S --noconfirm hyphen-de libreoffice-fresh-de

# Install custom US intl keyboard without dead keys (German umlauts on AltGr)
sudo mkdir -p /usr/share/X11/xkb/symbols
sudo cp keyboard/us_intl_custom /usr/share/X11/xkb/symbols/us_intl_custom

# Set up persistent keyboard layout in Xorg
if [ ! -f /etc/X11/xorg.conf.d/00-keyboard.conf ]; then
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo cp keyboard/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
fi


