#!/bin/bash

# Define paths
SAVE_DIR="$(xdg-user-dir PICTURES)/Screenshots"
TIMESTAMP="$(date '+%Y-%m-%d_%H.%M.%S')"
FILENAME="Screenshot_${TIMESTAMP}.png"
FULL_PATH="${SAVE_DIR}/${FILENAME}"

# Create screenshot directory if it doesn't exist
mkdir -p "$SAVE_DIR"

# Use slurp to select a region
REGION=$(slurp)

# If user canceled slurp, exit
[ -z "$REGION" ] && notify-send -u low "Screenshot Cancelled" "No region selected." && exit 1

# Take screenshot, save it, and copy to clipboard
grim -g "$REGION" - | tee "$FULL_PATH" | wl-copy

# Send feedback
notify-send -u low -t 2000 " Screenshot Taken" "Saved to ~/Pictures/Screenshots and copied to clipboard"
