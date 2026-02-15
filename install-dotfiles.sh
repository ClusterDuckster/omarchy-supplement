#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/clusterduckster/dotfiles"
REPO_URL_PUSH="git@github.com:ClusterDuckster/dotfiles.git"
REPO_NAME="dotfiles"
CLONED=false

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL" && CLONED=true
fi

# Exit if clone failed
if [ "$CLONED" = true ] || [ -d "$REPO_NAME/.git" ]; then
  cd "$REPO_NAME" || exit 1

  if [ "$CLONED" = true ]; then
    echo "Setting push URL to $REPO_URL_PUSH"
    git remote set-url --push origin "$REPO_URL_PUSH"
  fi

  echo "removing old configs"
  #rm -rf ~/.config/nvim ~/.config/starship.toml ~/.local/share/nvim/ ~/.cache/nvim/ ~/.config/ghostty/config
  rm -rf ~/.config/git/config

  stow bash
  stow git
  #stow zshrc
  #stow ghostty
  #stow tmux
  #stow nvim
  #stow starship
else
  echo "Failed to clone the repository."
  exit 1
fi
