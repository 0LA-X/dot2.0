#!/bin/bash

# Directories
scriDir="$HOME/.local/bin"
wallDIR="$HOME/.config/hypr/Wallpapers"
cache_dir="$HOME/.config/hypr/.cache"
wallCache="$cache_dir/.wallpaper"

# Ensure required dirs/files
mkdir -p "$cache_dir"
[[ ! -f "$wallCache" ]] && touch "$wallCache"

# Gather images
mapfile -d '' PICS < <(find "$wallDIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

[[ ${#PICS[@]} -eq 0 ]] && { echo "No wallpapers found in $wallDIR"; exit 1; }

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="🔀 Random"

# Rofi menu
menu() {
  for pic in "${PICS[@]}"; do
    pic_name=$(basename "$pic")
    [[ "$pic_name" =~ \.gif$ ]] && continue
    printf "%s\x00icon\x1f%s\n" "${pic_name%.*}" "$pic"
  done
  printf "%s\n" "$RANDOM_PIC_NAME"
}

choice=$(menu | rofi -dmenu -show -config ~/.config/rofi/styles/rofi-wall.rasi)

[[ -z "$choice" ]] && exit 0

# Find selection
if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    selected_pic="$RANDOM_PIC"
else
    for pic in "${PICS[@]}"; do
        if [[ "$(basename "$pic")" == "$choice"* ]]; then
            selected_pic="$pic"
            break
        fi
    done
fi

# Start swww-daemon if needed
if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon --format xrgb &
    sleep 1
fi

# Apply wallpaper
if [[ -n "$selected_pic" ]]; then
    notify-send -i "$selected_pic" "Setting wallpaper..." -t 1200
    swww img "$selected_pic" --transition-type wipe --transition-step 90 --transition-fps 60
    ln -sf "$selected_pic" "$cache_dir/current_wallpaper.png"
    echo "${selected_pic##*/}" | sed 's/\.[^.]*$//' > "$wallCache"
else
    notify-send -u normal -t 2000 " Image not found!"
    echo "Error: image not found."
    exit 1
fi


# Call Helper Script
sleep 0.5

if [[ -f "$scriDir/wallcache.sh" ]]; then
    notify-send -u low -t 1000 "󰃠 Generating wallpaper cache..."
    "$scriDir/wallcache.sh" && \
        notify-send -u low -t 1000 "󰄴 Wallpaper cache updated."
else
    notify-send -u normal -t 2000 " wallcache.sh not found!"
fi
