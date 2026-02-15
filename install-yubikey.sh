#!/bin/sh

# install middleware library to communicate with FIDO device over USB
yay -S --noconfirm --needed libfido2

# install yubikey-manager for e.g. setting or changing FIDO2 PIN
yay -S --noconfirm --needed yubikey-manager

