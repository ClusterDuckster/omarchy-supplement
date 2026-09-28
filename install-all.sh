#!/bin/bash

cd "$(dirname "$0")"

# Install everything in order
./bashrc-folder-loader.sh
./install-locale.sh
./install-yubikey.sh
./install-yubikey-sshkey.sh
./install-stow.sh
./install-dotfiles.sh
./install-bitwarden.sh
./install-dns-utils.sh
./install-wireguard.sh
./install-vpn-widget.sh
./install-zen-browser.sh
./install-keymapp.sh
./install-podman.sh
./install-signal.sh
./install-anytype.sh
