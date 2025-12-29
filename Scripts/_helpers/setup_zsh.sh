#!/usr/bin/env bash

set -e

echo "  Starting Zsh + Plugin + Starship setup on Arch Linux..."

# Check yay installation
if ! command -v yay &> /dev/null; then
    echo "  'yay' is not installed. Please install yay first."
    exit 1
fi

# Check and install Zsh if needed
if ! command -v zsh &> /dev/null; then
    echo "  Zsh not found. Installing Zsh..."
    yay -S --noconfirm zsh 
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"\n
fi

# Set Zsh as default shell if not already
CURRENT_SHELL="$(basename "$SHELL")"
if [ "$CURRENT_SHELL" != "zsh" ]; then
    echo "  Setting Zsh as the default shell for user: $USER"
    chsh -s "$(which zsh)"
else
    echo "  Zsh is already the default shell."
fi

# Install eza + pokego
if ! command -v eza &> /dev/null; then
    echo "  Installing eza/pokego..."
    yay -S --noconfirm eza pokego-bin
fi

# Install Starship prompt
if ! command -v starship &> /dev/null; then
    echo "  Installing Starship prompt..."
    yay -S --noconfirm starship
fi

# Plugin base directory
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    echo "  Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    echo "  Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

# zsh-interactive-cd
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-interactive-cd" ]; then
    echo "  Installing zsh-interactive-cd..."
    git clone https://github.com/changyuheng/zsh-interactive-cd "${ZSH_CUSTOM}/plugins/zsh-interactive-cd"
fi

echo "  All components installed! Restart your terminal to apply changes."
