#!/bin/bash

# Kill all existing waybar instances
killall -9 waybar
notify-send "Terminated Waybar"

# Optional: wait for the processes to terminate
sleep 0.5

# Restart waybar in the background
waybar &
notify-send "Waybar Reloaded"
