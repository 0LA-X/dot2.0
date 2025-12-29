#!/usr/bin/env bash

set -euo pipefail

PATCH_DIR="$HOME/dot3.0/Patches"

ICONS="$PATCH_DIR/icons.tar.xz"
ICONS_DEST="$HOME/.local/share/icons"

FONTS="$PATCH_DIR/fonts.tar.xz"
FONTS_DEST="$HOME/.local/share/fonts"

extract_archive() {
  local archive="$1"
  local dest="$2"
  local name="$3"

  echo "[ ! ] Checking $name directory..."
  if [[ ! -d "$dest" ]]; then
    echo "[ + ] Creating $name directory at $dest"
    mkdir -p "$dest"
  else
    echo "[ ! ] $name directory already exists, skipping..."
  fi

  echo "[ + ] Extracting $name from archive..."
  if [[ -f "$archive" ]]; then
pv "$archive" | tar -xJf - --strip-components=1 -C "$dest"
    echo "[ ✓ ] $name extraction complete!"
  else
    echo "[ ✗ ] Archive not found: $archive"
    exit 1
  fi
}

# Run for both icons and fonts
extract_archive "$ICONS" "$ICONS_DEST" "icons"
extract_archive "$FONTS" "$FONTS_DEST" "fonts"

