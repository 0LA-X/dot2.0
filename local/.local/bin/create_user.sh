#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "Run this script as root (sudo)."
  exit 1
fi

# Ask for new username
read -rp "Enter the new username: " NEW_USER

# Check if user already exists
if id "$NEW_USER" &>/dev/null; then
  echo "User '$NEW_USER' already exists."
  exit 1
fi

# Create user with home directory
useradd -m "$NEW_USER"
echo "User '$NEW_USER' created."

# Set password
echo "Set password for '$NEW_USER':"
passwd "$NEW_USER"

# Ask about shared group
read -rp "Add '$NEW_USER' to shared group? (y/n): " ADD_SHARED
if [[ $ADD_SHARED =~ ^[Yy]$ ]]; then
  # Create shared group if it doesn't exist
  getent group shared >/dev/null || groupadd shared
  usermod -aG shared "$NEW_USER"
  echo "Added to 'shared' group."
fi

# Ask about root privileges
read -rp "Give '$NEW_USER' root (sudo) privileges? (y/n): " GIVE_ROOT
if [[ $GIVE_ROOT =~ ^[Yy]$ ]]; then
  usermod -aG wheel "$NEW_USER"
  echo "Added to 'wheel' group for sudo access."
fi

# Always add to input/output-related groups
for grp in input video audio; do
  getent group "$grp" >/dev/null && usermod -aG "$grp" "$NEW_USER"
done
echo "Added to input/video/audio groups (if they exist)."

echo "✅ Done. You can now log in as '$NEW_USER'."
