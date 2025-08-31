#!/usr/bin/bash

# Shared Directory Setup Script
echo "=== Shared Directory Setup ==="

# 1. Create shared directory
SHARED_DIR="/home/shared"
sudo mkdir -p "$SHARED_DIR"
echo "Created directory: $SHARED_DIR"

# 2. Create shared group
GROUP_NAME="shared"
sudo groupadd "$GROUP_NAME"
echo "Created group: $GROUP_NAME"

# 3. Prompt for users to add
echo ""
echo "Which users should be added to the $GROUP_NAME group?"
echo "Enter usernames separated by spaces (e.g., alice bob carol):"
read -p "Users: " USER_LIST

# Add each user to the group
for USER in $USER_LIST; do
    if id "$USER" &>/dev/null; then
        sudo usermod -aG "$GROUP_NAME" "$USER"
        echo "  Added $USER to $GROUP_NAME group"
    else
        echo "  Warning: User $USER does not exist (skipped)"
    fi
done

# 4. Set directory permissions
sudo chgrp -R "$GROUP_NAME" "$SHARED_DIR"
sudo chmod -R g+rwX "$SHARED_DIR"
sudo chmod g+s "$SHARED_DIR"
sudo setfacl -Rdm g:"$GROUP_NAME":rwX "$SHARED_DIR"

echo ""
echo "=== Setup Complete ==="
echo "Directory: $SHARED_DIR"
echo "Group: $GROUP_NAME"
echo "Members: $USER_LIST"
echo ""
echo "Note: Users may need to logout/login for changes to take effect."
