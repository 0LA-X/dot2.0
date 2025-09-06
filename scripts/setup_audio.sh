#!/bin/bash

# Audio and Bluetooth setup script

echo "Installing audio and Bluetooth packages..."
sudo pacman -S --noconfirm \
  pipewire pipewire-audio pipewire-pulse pipewire-alsa \
  sof-firmware wireplumber \
  bluez bluez-utils bluetooth-autoconnect \
  gst-plugin-pipewire \
  blueman pulseaudio-bluetooth \
  pavucontrol

echo "Enabling Bluetooth services..."
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now bluetooth-autoconnect.service

echo "Enabling PipeWire and WirePlumber services..."
sudo systemctl enable --now pipewire pipewire-pulse wireplumber

echo "Adding user '$USER' to 'audio' and 'input' groups..."
sudo usermod -aG audio,input "$USER"

echo "Audio setup complete!"
echo "Please reboot for all changes to take effect."
echo "After reboot, you can use 'pavucontrol' to manage audio settings."
