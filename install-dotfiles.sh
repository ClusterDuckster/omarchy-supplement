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

  # Neovim: omarchy-nvim seeds ~/.config/nvim from skel, so replace it with the
  # stowed dotfiles copy. rm -rf does not follow symlinks, so a previously
  # stowed tree is safe to clear.
  nvim_cfg="$HOME/.config/nvim"
  if [ -L "$nvim_cfg" ]; then
    rm -f "$nvim_cfg"
  elif [ -d "$nvim_cfg" ]; then
    rm -rf "$nvim_cfg"
  fi

  stow bash
  stow git
  stow ssh
  stow hyprland
  stow xkb
  # --no-folding keeps real directories so Omarchy's generated
  # lua/plugins/theme.lua can sit next to the stowed files.
  stow --no-folding nvim

  # theme.lua is runtime state Omarchy regenerates on theme change, not tracked.
  ln -sfn ../../../../.local/state/omarchy/current/theme/neovim.lua \
    "$nvim_cfg/lua/plugins/theme.lua"

  hyprctl reload
  omarchy-shell shell rescanPlugins
else
  echo "Failed to clone the repository."
  exit 1
fi
