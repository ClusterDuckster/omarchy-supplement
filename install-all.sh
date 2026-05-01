#!/bin/bash

# Install all packages in order
./bashrc-folder-loader.sh
./install-locale.sh
./install-yubikey.sh
./install-yubikey-sshkey.sh
./install-stow.sh
./install-dotfiles.sh
./install-bitwarden.sh
./install-wireguard.sh
./install-zen-browser.sh
./install-keymapp.sh
./install-signal.sh
./install-anytype.sh
./patch-waybar.sh
