#!/usr/bin/env bash

set -e

SCR_DIR="$HOME/dot3.0/Scripts/_helpers"
PKG_LST="$HOME/dot3.0/Scripts/pkgs.txt"
DOTFILES_DIR="$HOME/dot3.0"
YAY_DIR="HOME/.yay"
# C_DIR="$HOME/.config/quickshell/caelestia"

show_header() {
    cat << "EOF"

     ██╗ ██╗███╗   ██╗██╗  ██╗
     ██║███║████╗  ██║╚██╗██╔╝
     ██║╚██║██╔██╗ ██║ ╚███╔╝ 
██   ██║ ██║██║╚██╗██║ ██╔██╗ 
╚█████╔╝ ██║██║ ╚████║██╔╝ ██╗
 ╚════╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝

EOF
}

install_yay(){
  echo "[ + ] Installing yay"
  sudo pacman -Sy --needed git base-devel
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  cd "$YAY_DIR"
  makepkg -si --noconfirm
  cd ~
  rm -rf "$YAY_DIR"
}

ensure_yay() {
    if ! command -v yay &> /dev/null; then
        echo "{ ! } yay not found. Installing..."
        install_yay
    else
        echo -e "{ - } yay is already installed.."
    fi
}

install_pkgs(){
  if [[ -f "$PKG_LST" ]]; then
    echo -e "[ + ] Installing packages from "$PKG_LST"..."
    yay -S --noconfirm --needed $(grep -vE '^\s*#' "$PKG_LST" | tr '\n' ' ')
  else
    echo -e "[ ! ] Package list not found: "$PKG_LST" "
  fi
}

install_caelestia(){
  echo " Installing Caelestia"
  yay -S --noconfirm caelestia-shell-git caelestia-cli-git 

  # echo " Cloning Caelestia Repo"
  # mkdir -p $C_DIR
  # git clone https://github.com/caelestia-dots/shell.git $C_DIR

  # echo " Building Caelestia"
  # cd $C_DIR
  # cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DINSTALL_QSCONFDIR=$C_DIR
  # cmake --build build
  # sudo cmake --install build
  # sudo chown -R $USER $C_DIR
}

git_modules(){
  echo "[+] Initializing Submodules" 
  cd $DOTFILES_DIR
  git submodule update --init --recursive
  echo "[!] Done"
}

stow_dots(){
  #init submodules before STOW
  cd $DOTFILES_DIR
    git_modules
 
  if ! command -v stow &> /dev/null; then
    echo "{ + } Installing stow..."
    yay -S --noconfirm stow
  else
    echo "{ - } Stow already installed..."
  fi

  echo "{ ! } Stowing dotfiles..."
  cd $DOTFILES_DIR
  stow -v Configs Local zsh git
}

stow_alt(){
  echo -e "{ ! } Stowing dotfiles..."
  cd "$DOTFILES_DIR"

  for dir in */; do
    # Exclude .git/, & Scripts/ Patches/
    [[ "$dir" == ".git/" ]] && continue
    [[ "$dir" == "Scripts/" ]] && continue
    [[ "$dir" == "Patches/" ]] && continue

    echo -e "Stowing ${dir%/}..."
    stow -v "${dir%/}"
  done

  if [[ -d ".git/" ]]; then
    echo -e "{ ! } Skipping .git/, Scripts/ & Patches"
  fi
}

helper_scripts(){
  echo "[ + ] Setting up ZSH"
  $SCR_DIR/setup_zsh.sh
  
  echo "[ + ] Setting up TMUX & TPM"
  $SCR_DIR/tpm.sh

  echo "[ + ] Setting up Boot-themes"
  $SCR_DIR/setup_boot_themes.sh
  
  echo "[ + ] Setting up Audio & Bluetooth"
  $SCR_DIR/setup_audio.sh

  echo "[ + ] Setting up Keypad-Sounds (Wayvibes)"
  $SCR_DIR/setup_keyboard.sh

  echo "[ + ] Setting up PATCHES for Themes"
  $SCR_DIR/setup_patches.sh

  echo "[ + ] Setting up Spotify [spicetify]"
  $SCR_DIR/spicetify.sh

}

main(){
show_header
ensure_yay
install_pkgs
install_caelestia
git_modules
stow_dots
helper_scripts
}


main
