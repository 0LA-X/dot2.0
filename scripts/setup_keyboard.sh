#!/bin/bash

# Exit on errors
set -e

# Check for AUR helper (default: yay)
AUR_HELPER=$(command -v yay || command -v paru)

if [ -z "$AUR_HELPER" ]; then
    echo "No AUR helper (yay/paru) found. Install one and rerun."
    exit 1
fi

# Install wayvibes-git
echo "[+] Installing wayvibes-git..."
$AUR_HELPER -S --noconfirm wayvibes-git

# Add current user to input group
echo "[+] Adding user '$USER' to 'input' group..."
sudo usermod -aG input "$USER"

# Inform user to reboot or re-login
echo "[!] You must log out and log back in (or reboot) for 'input' group changes to take effect."

# Run wayvibes (if in correct group already)
WAYVIBES_CMD="wayvibes ~/.config/key-sounds/akko_lavender_purples -v 6 --background"
echo "[+] Running: $WAYVIBES_CMD"
eval "$WAYVIBES_CMD"
