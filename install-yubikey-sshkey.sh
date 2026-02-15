#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Configuration
# -----------------------------
DOTFILES_REPO="git@github.com:clusterduckster/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
HANDLE_DIR="$HOME/.ssh"

# Map Credential IDs to human-readable names
declare -A CRED_MAP=(
    ["6edffc4d"]="yubikey-5c-backup-resident"
    ["7c2dd26e"]="yubikey-5c-main-resident"
    ["9796a1a6"]="yubikey-nano-resident"
)

# -----------------------------
# Detect single YubiKey
# -----------------------------
SERIALS=$(ykman list --serials 2>/dev/null || true)
NUM_KEYS=$(echo "$SERIALS" | wc -l)
if [ "$NUM_KEYS" -ne 1 ]; then
    echo "Please insert exactly one YubiKey. Detected: $NUM_KEYS"
    exit 1
fi
SERIAL="$SERIALS"
echo "Using YubiKey with serial: $SERIAL"

# -----------------------------
# Detect resident SSH credential on this key
# -----------------------------
SSH_CRED_ID=$(ykman -d "$SERIAL" fido credentials list 2>/dev/null | \
    tail -n +2 | \
    awk '$2 == "ssh:" {print $1}' | head -n1)

# Strip trailing dots from truncated Credential ID
SSH_CRED_ID=${SSH_CRED_ID%%...}

if [ -z "$SSH_CRED_ID" ]; then
    echo "No resident SSH key found on this YubiKey."
    exit 1
fi
echo "Detected Credential ID: $SSH_CRED_ID"

# -----------------------------
# Map to human-readable name
# -----------------------------
HUMAN_NAME=${CRED_MAP[$SSH_CRED_ID]:-unknown}
if [ "$HUMAN_NAME" == "unknown" ]; then
    echo "No mapping for Credential ID $SSH_CRED_ID. Update CRED_MAP."
    exit 1
fi

PRIV_HANDLE="$HANDLE_DIR/id_ed25519_${HUMAN_NAME}"
PUB_HANDLE="$PRIV_HANDLE.pub"

# -----------------------------
# Generate handle if missing
# -----------------------------
if [ ! -f "$PRIV_HANDLE" ]; then
    echo "Generating handle for $HUMAN_NAME..."
    ssh-keygen -K -f "$PRIV_HANDLE"
    mv id_ed25519_sk_rk "$PRIV_HANDLE"
    mv id_ed25519_sk_rk.pub "$PUB_HANDLE"
else
    echo "Handle already exists: $PRIV_HANDLE"
fi

# -----------------------------
# Clone dotfiles repo if missing
# -----------------------------
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles using handle $PRIV_HANDLE..."
    GIT_SSH_COMMAND="ssh -i $PRIV_HANDLE -o IdentitiesOnly=yes" \
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "Dotfiles directory already exists, skipping clone."
fi

