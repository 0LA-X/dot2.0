#!/bin/bash

# Detect Ethernet
eth_dev=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep ":ethernet:connected" | cut -d: -f1)
if [[ -n "$eth_dev" ]]; then
    echo '{"text": "󰈀", "class": "ethernet"}'
    exit 0
fi

# Detect Wi-Fi
wifi_dev=$(nmcli -t -f DEVICE,TYPE,STATE dev | grep ":wifi:connected" | cut -d: -f1)
if [[ -n "$wifi_dev" ]]; then
    signal=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2)

    if [[ $signal -ge 80 ]]; then
        icon=" ▂▄▆█"
        cls="wifi5"
    elif [[ $signal -ge 60 ]]; then
        icon=" ▂▄▆"
        cls="wifi4"
    elif [[ $signal -ge 40 ]]; then
        icon=" ▂▄"
        cls="wifi3"
    elif [[ $signal -ge 20 ]]; then
        icon=" ▂"
        cls="wifi2"
    else
        icon=" ▁"
        cls="wifi1"
    fi

    echo "{\"text\": \"$icon\", \"class\": \"$cls\"}"
    exit 0
fi

# Not connected 
echo '{"text": "", "class": "disconnected"}'
