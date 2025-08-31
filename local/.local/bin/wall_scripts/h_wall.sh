#!/bin/bash

scrDir="$HOME/.local/lib/wall_scripts"
cacheDir="$HOME/.config/hypr/.cache"
themeFile="$cacheDir/.theme"
wallCache="$cacheDir/.wallpaper"
hyprpaper_conf="$HOME/.config/hypr/hyprpaper.conf"

theme=$(cat "$themeFile")
wallDir="$HOME/.config/hypr/Wallpapers/${theme}"

[[ ! -f "$wallCache" ]] && touch "$wallCache"

PICS=($(find "${wallDir}" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))

if [[ ${#PICS[@]} -eq 0 ]]; then
    echo "No wallpapers found in $wallDir"
    exit 1
fi

wallpaper=${PICS[$RANDOM % ${#PICS[@]}]}

notify-send -i "${wallpaper}" "Changing Wallpaper" -t 1500

# Update hyprpaper config and restart
echo "preload = $wallpaper" > "$hyprpaper_conf"
echo "wallpaper = ,$wallpaper" >> "$hyprpaper_conf"
pkill hyprpaper
hyprpaper &

# Optionally run Wallust here (uncomment if you use it)
# wallust run ~/.config/wallust/templates "${wallpaper}"

# Update cache
ln -sf "${wallpaper}" "$cacheDir/current_wallpaper.png"
echo "$(basename "${wallpaper}" | sed 's/\.[^.]*$//')" > "$wallCache"

sleep 0.5
"$scrDir/wallcache.sh"
