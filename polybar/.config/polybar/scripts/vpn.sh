#!/usr/bin/env bash

TOGGLE=$1

function check() {
  CHECK_COMMAND="openvpn3 sessions-list | grep -i 'session name' | cut -d ':' -f2 | tr -d ' '"
  echo $(eval $CHECK_COMMAND)
}

function default() {
  CHECK=$(check)
  if [ -n "$CHECK" ]; then
    echo " $CHECK"
  else
    echo " "
  fi
}

function toggle() {
  CHECK=$(check)
  if [ -n "$CHECK" ]; then
    fish -C "vpn_disconnect" && notify-send "VPN is disconnected"
  else
    fish -C "vpn_connect" && notify-send "VPN is connected"
  fi
}

case "$1" in
  --toggle)
    toggle
    ;;
  *)
    default
    ;;
esac
