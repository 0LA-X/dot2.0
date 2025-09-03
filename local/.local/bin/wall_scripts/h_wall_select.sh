#!/bin/bash

# Directories
scriDir="$HOME/.local/bin/wall_scripts"
wallDIR="$HOME/.config/hypr/Wallpapers"
hyprpaper_conf="$HOME/.config/hypr/hyprpaper.conf"

# Check wallpaper directory
if [[ ! -d "$wallDIR" ]]; then
    echo "Wallpaper directory does not exist: $wallDIR"
    notify-send -i "󰃠 Directory does not exist: $wallDIR" -t 1500
    exit 1
fi

# Gather image files
PICS=()
while IFS= read -r -d $'\0' file; do
    PICS+=("$file")
done < <(find "$wallDIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No wallpapers found in $wallDIR"
    exit 1
fi

# Random wallpaper option
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="${#PICS[@]}. random"

# Rofi config
rofi_command="rofi -show -dmenu -config ~/.config/rofi/styles/rofi-wall.rasi"

# Rofi menu
menu() {
  for pic in "${PICS[@]}"; do
    pic_name=$(basename "$pic")
    if [[ ! "$pic_name" =~ \.gif$ ]]; then
      printf "%s\x00icon\x1f%s\n" "${pic_name%.*}" "$pic"
    else
      printf "%s\n" "$pic_name"
    fi
  done
  printf "$RANDOM_PIC_NAME\n"
}

# Get user choice
choice=$(menu | $rofi_command)

# Exit if no choice
[[ -z "$choice" ]] && exit 0

# Handle random selection
if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    selected_pic="$RANDOM_PIC"
else
    selected_pic=""
    for pic in "${PICS[@]}"; do
        if [[ "$(basename "$pic")" == "$choice"* ]]; then
            selected_pic="$pic"
            break
        fi
    done
fi

# Apply wallpaper via hyprpaper
if [[ -n "$selected_pic" ]]; then
    notify-send -i "$selected_pic" "󰄴 Changing wallpaper" -t 1500

    echo "preload = $selected_pic" > "$hyprpaper_conf"
    echo "wallpaper = ,$selected_pic" >> "$hyprpaper_conf"

    pkill hyprpaper
    hyprpaper &

else
    echo "Image not found."
    exit 1
fi
