#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"

START_MARK="# >>> bashrc.d loader >>>"
END_MARK="# <<< bashrc.d loader <<<"

SNIPPET=$(cat <<'EOF'
# >>> bashrc.d loader >>>
# Source additional shell configurations
if [ -d "$HOME/.bashrc.d" ]; then
    for config in "$HOME/.bashrc.d"/*.sh; do
        [ -r "$config" ] && source "$config"
    done
fi
# <<< bashrc.d loader <<<
EOF
)

# Create .bashrc if it does not exist
touch "$BASHRC"

# Check if marker already exists
if grep -qF "$START_MARK" "$BASHRC"; then
    echo "bashrc.d loader already present. Skipping."
else
    echo "Adding bashrc.d loader to $BASHRC"
    printf "\n%s\n" "$SNIPPET" >> "$BASHRC"
fi

