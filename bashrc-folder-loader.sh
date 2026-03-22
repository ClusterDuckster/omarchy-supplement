#!/usr/bin/env bash

BASHRC="$HOME/.bashrc"

START_MARK="# >>> bashrc.d loader >>>"
END_MARK="# <<< bashrc.d loader <<<"

SNIPPET=$(cat <<'EOF'
# >>> bashrc.d loader >>>
# Source additional shell configurations
if [ -d "$HOME/.bashrc.d" ]; then
    for config in "$HOME/.bashrc.d"/*.{bashrc,sh}; do
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
    echo "bashrc.d loader already present. Updating."
    # Extract the content before the start mark and after the end mark
    before=$(sed -n "1,/$(echo "$START_MARK" | sed 's/[[/.*^$]/\\&/g')/p" "$BASHRC" | sed '/'"$(echo "$START_MARK" | sed 's/[[/.*^$]/\\&/g')"'/d')
    after=$(sed -n '/'"$(echo "$END_MARK" | sed 's/[[/.*^$]/\\&/g')"'/,$ p' "$BASHRC" | tail -n +2)
    printf "%s\n\n%s\n%s\n" "$before" "$SNIPPET" "$after" > "$BASHRC"
else
    echo "Adding bashrc.d loader to $BASHRC"
    printf "\n%s\n" "$SNIPPET" >> "$BASHRC"
fi
