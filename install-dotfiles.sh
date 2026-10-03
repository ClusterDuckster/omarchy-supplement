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

  echo "removing conflicting configs"
  # Stow cannot symlink over existing regular files. Omarchy 4 creates these
  # as plain files, and the defaults are regenerable via `omarchy refresh`.
  # Never remove a path that already resolves into this repo: a folded stow
  # symlink (e.g. ~/.config/xkb -> ../dotfiles/xkb/.config/xkb) makes its
  # targets look like plain files here, and the rm would delete the source
  # it is meant to link to.
  for f in ~/.gitconfig \
           ~/.config/hypr/input.lua \
           ~/.config/hypr/bindings.lua \
           ~/.config/xkb/symbols/us_intl_custom; do
    [ -e "$f" ] || continue
    case "$(readlink -f "$f")" in
      "$HOME/$REPO_NAME"/*) continue ;;
    esac
    [ -f "$f" ] && [ ! -L "$f" ] && rm -f "$f"
  done

  # Neovim: only personal plugin files are stowed; Omarchy keeps owning the
  # rest of ~/.config/nvim (including its generated lua/plugins/theme.lua).
  # --no-folding keeps lua/plugins a real directory so the stowed files sit
  # next to Omarchy's instead of replacing the whole directory.
  stow bash
  stow git
  stow ssh
  stow hyprland
  stow xkb
  stow --no-folding nvim

  hyprctl reload
  omarchy-shell shell rescanPlugins
else
  echo "Failed to clone the repository."
  exit 1
fi
