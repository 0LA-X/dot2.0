#!/bin/bash

set -e

# Colors and Nerd Font Icons
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CHECK=""  # Nerd Font checkmark
CROSS=""  # Nerd Font cross
INFO=""   # Nerd Font info icon
ARROW=""  # Nerd Font arrow
GEAR=""   # Nerd Font gear
PC=""     # Nerd Font PC
PACKAGE="" # Nerd Font package
GIT=""    # Nerd Font git icon
FONT=""   # Nerd Font font icon

REPO_URL="https://github.com/0LA-X/dot2.0.git"
DOTFILES_DIR="$HOME/dot2.0"
scriDir="$DOTFILES_DIR/scripts"
PACKAGE_LIST="$DOTFILES_DIR/scripts/pkg.txt"
YAY_DIR="$HOME/.yay"

# ASCII Art Header
function show_header() {
    echo -e "${BLUE}"
    cat << "EOF"

     ██╗ ██╗███╗   ██╗██╗  ██╗
     ██║███║████╗  ██║╚██╗██╔╝
     ██║╚██║██╔██╗ ██║ ╚███╔╝ 
██   ██║ ██║██║╚██╗██║ ██╔██╗ 
╚█████╔╝ ██║██║ ╚████║██╔╝ ██╗
 ╚════╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝

EOF
    echo -e "${NC}"
}

# Clone or pull dotfiles repo
function manage_dotfiles_repo() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo -e "${GREEN}${GIT} Cloning dotfiles repo...${NC}"
        git clone "$REPO_URL" "$DOTFILES_DIR"
    else
        echo -e "${BLUE}${GIT} Updating dotfiles repo...${NC}"
       cd "$DOTFILES_DIR"
        git pull
    fi
}

# Install yay AUR helper
function install_yay() {
    echo -e "${YELLOW}${ARROW} Installing yay...${NC}"
    sudo pacman -Sy --needed git base-devel
    git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
    cd "$YAY_DIR"
    makepkg -si --noconfirm
    cd ~
    rm -rf "$YAY_DIR"
}

# Check and install yay if needed
function ensure_yay() {
    if ! command -v yay &> /dev/null; then
        echo -e "${YELLOW}${INFO} yay not found. Installing...${NC}"
        install_yay
    else
        echo -e "${GREEN}${CHECK} yay is already installed.${NC}"
    fi
}

# Check and install stow if needed
function ensure_stow() {
    if ! command -v stow &> /dev/null; then
        echo -e "${YELLOW}${ARROW} Installing stow...${NC}"
        yay -S --noconfirm stow
    fi
}

# Update system packages
function update_system() {
    echo -e "${BLUE}${GEAR} Updating system...${NC}"
    yay -Syu --noconfirm
}

# Install packages from package list
function install_packages() {
    if [[ -f "$PACKAGE_LIST" ]]; then
        echo -e "${GREEN}${PACKAGE} Installing packages from $PACKAGE_LIST...${NC}"
        yay -S --noconfirm --needed $(grep -vE '^\s*#' "$PACKAGE_LIST" | tr '\n' ' ')
    else
        echo -e "${RED}${CROSS} Package list not found: $PACKAGE_LIST${NC}"
    fi
}

# Stow dotfiles configuration
function stow_dotfiles() {
    echo -e "${BLUE}${GEAR} Stowing dotfiles...${NC}"
    cd "$DOTFILES_DIR"

    for dir in */; do
        # Exclude .git/ and scripts/
        [[ "$dir" == ".git/" ]] && continue
        [[ "$dir" == "scripts/" ]] && continue
        [[ "$dir" == "patches/" ]] && continue

        echo -e "${YELLOW}${ARROW} Stowing ${dir%/}...${NC}"
        stow -v "${dir%/}"
    done

    if [[ -f "README.md" ]]; then
        echo -e "${YELLOW}${INFO} Skipping .git/ & scripts/ & README.md${NC}"
    fi
}

# Install TPM (Tmux Plugin Manager)
function install_tpm() {
    local TMUX_CONF="$HOME/.config/tmux/tmux.conf"
    local TPM_DIR="$HOME/.config/tmux/plugins/tpm"

    if [[ -f "$TMUX_CONF" ]]; then
        echo -e "${GREEN}${CHECK} Detected tmux.conf at $TMUX_CONF${NC}"

        if [[ ! -d "$TPM_DIR" ]]; then
            echo -e "${YELLOW}${ARROW} Installing TPM into $TPM_DIR...${NC}"
            git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        else
            echo -e "${GREEN}${CHECK} TPM already installed at $TPM_DIR.${NC}"
        fi

        echo -e "${BLUE}${GEAR} Installing TPM plugins...${NC}"
        "$TPM_DIR/bin/install_plugins"
    else
        echo -e "${YELLOW}${INFO} No tmux.conf found in ~/.config/tmux — skipping TPM install.${NC}"
    fi
}

# Install FiraCode Nerd Font
function install_firacode() {
    if ! fc-list | grep -iq "FiraCode Nerd Font"; then
        echo -e "${YELLOW}${ARROW} ${FONT} Installing FiraCode Nerd Font...${NC}"
        yay -S --noconfirm ttf-firacode-nerd
        echo -e "${BLUE}${GEAR} Refreshing font cache...${NC}"
        fc-cache -fv
    else
        echo -e "${GREEN}${CHECK} ${FONT} FiraCode Nerd Font already installed.${NC}"
    fi
}

# boot_theme_setup () {
#   if [[ -f "$scriDir/setup_boot_themes.sh" ]]; then
#     echo " Calling Helper Scripts"
#       "$scriDir/setup_boot_themes.sh" 
#    else
#       echo "script not found!"
#   fi
# }

# Main execution
function main() {
  show_header
  manage_dotfiles_repo
  ensure_yay
  ensure_stow
  update_system
  install_packages
  stow_dotfiles
  install_tpm
  install_firacode
  # boot_theme_setup

  echo -e "${GREEN}${CHECK} Dotfiles setup and dependencies complete!${NC}"
}

main
