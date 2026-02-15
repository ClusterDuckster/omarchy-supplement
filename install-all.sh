#!/bin/bash

# Install all packages in order
./bashrc-folder-loader.sh
./install-yubikey.sh
./install-yubikey-sshkey.sh
./install-stow.sh
./install-dotfiles.sh
./install-bitwarden.sh
./install-keymapp.sh
./install-anytype.sh

