#!/usr/bin/bash

set -e  # Exit immediately if a command fails

# === CONFIGURATION ===
PLYMOUTH_THEME_NAME="colorful_loop"
PLYMOUTH_THEME_DIR="$HOME/dot2.0/patches/plymouth-themes/$PLYMOUTH_THEME_NAME"

GRUB_THEME_NAME="Sekiro_theme"
GRUB_THEME_SRC="$HOME/dot2.0/patches/grub-themes/$GRUB_THEME_NAME"
GRUB_THEME_DEST="/boot/grub/themes/$GRUB_THEME_NAME"
GRUB_CFG="/etc/default/grub"
GRUB_CFG_BAK="/etc/default/grub.bak"

echo "=== Boot Theme Installer ==="

# 1. Install Plymouth if not already installed
echo "[1/5] Installing plymouth..."
if ! pacman -Qi plymouth &>/dev/null; then
    sudo pacman -S --noconfirm plymouth
else
    echo "plymouth is already installed."
fi

# 2. Install and set Plymouth theme
echo "[2/5] Setting Plymouth theme: $PLYMOUTH_THEME_NAME"

if [ -d "$PLYMOUTH_THEME_DIR" ]; then
    sudo cp -r "$PLYMOUTH_THEME_DIR" /usr/share/plymouth/themes/
    sudo plymouth-set-default-theme -R "$PLYMOUTH_THEME_NAME"
else
    echo "Error: Plymouth theme not found at $PLYMOUTH_THEME_DIR"
    exit 1
fi

# 3. Install GRUB theme
echo "[3/5] Installing GRUB theme: $GRUB_THEME_NAME"

if [ -d "$GRUB_THEME_SRC" ]; then
    sudo mkdir -p "$GRUB_THEME_DEST"
    sudo cp -r "$GRUB_THEME_SRC/"* "$GRUB_THEME_DEST/"
else
    echo "Error: GRUB theme not found at $GRUB_THEME_SRC"
    exit 1
fi

# 4. Set GRUB theme in /etc/default/grub
echo "[4/5] Updating GRUB configuration to use the new theme..."

if grep -q "^GRUB_THEME=" "$GRUB_CFG"; then
    sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$GRUB_THEME_DEST/theme.txt\"|" "$GRUB_CFG"
else
    echo "Adding GRUB_THEME entry to $GRUB_CFG"
    echo "GRUB_THEME=\"$GRUB_THEME_DEST/theme.txt\"" | sudo tee -a "$GRUB_CFG" > /dev/null
fi

# Backup the old grub config
sudo cp "$GRUB_CFG" "$GRUB_CFG_BAK"

# 5. Regenerate GRUB config
echo "[5/5] Regenerating GRUB config..."
if [ -d /boot/efi ]; then
    # UEFI system
    sudo grub-mkconfig -o /boot/efi/EFI/*/grub/grub.cfg 2>/dev/null || sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    # BIOS system
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

echo -e " Boot themes installed and configured successfully!"
echo "Please reboot to see the changes."
