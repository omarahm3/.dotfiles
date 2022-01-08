#!/bin/bash

rofi_command="rofi -theme ~/.config/rofi/network-manager.rasi -location 3 -yoffset +55 -xoffset -15" 

## Get info
IFACE="$(nmcli | grep -i interface | awk '/interface/ {print $2}')"
STATUS="$(nmcli radio wifi)"
INTERFACE="$(nmcli device | awk '$2=="wifi" {print $1}')"

if (ping -c 1 archlinux.org) &>/dev/null; then
  if [[ $STATUS == *"enable"* ]]; then
    if [[ $IFACE == e* ]]; then
      amogus="Connected"
      connected="Disconnect from WiFi"
    else
      amogus="Connected"
      connected="Disconnect from WiFi"
    fi
    SSID="$(iwgetid -r)"
  fi
else
  SSID="Disconnected"
  PIP="NA"
  amogus="Offline"
  connected="Connect to WiFi"
fi

## Icons
launch_cli="Open Network Manager"
launch="Open Connection Editor"

options="$connected\n$launch_cli\n$launch"

## Main
chosen="$(echo -e "$options" | $rofi_command -p " Interface: $INTERFACE ~ Status: $amogus" -dmenu -selected-row 1)"
case $chosen in
  $connected)
    if [[ $STATUS == *"enable"* ]]; then
      nmcli radio wifi off
    else
      nmcli radio wifi on
    fi 
    ;;
  $launch_cli)
    kitty -e nmtui
    ;;
  $launch)
    nm-connection-editor
    ;;
esac
