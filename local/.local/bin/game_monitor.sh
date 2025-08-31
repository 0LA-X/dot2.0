#!/bin/bash

export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

WATCHED_PROCESSES=("Terraria.bin.x86_64" "wine" "dolphin-emu" "steam" "lutris" "terraria-server")
STATE="resumed"

while true; do
    found=false
    for proc in "${WATCHED_PROCESSES[@]}"; do
        if pgrep -f "$proc" > /dev/null; then
            found=true
            break
        fi
    done

    if $found && [ "$STATE" != "paused" ]; then
        pkill -STOP hypridle 2>/dev/null
        notify-send -u low -t 2000 "Hypridle Paused 󱤳 " "Game detected: hypridle paused."
        STATE="paused"
    elif ! $found && [ "$STATE" != "resumed" ]; then
        pkill -CONT hypridle 2>/dev/null
        notify-send -u low -t 2000 "Hypridle Resumed 󱤵 " "Game exited: hypridle resumed."
        STATE="resumed"
    fi

    sleep 5
done
