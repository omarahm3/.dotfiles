#!/usr/bin/env bash

TOGGLE=$1

function check() {
  CHECK_COMMAND="ps -aux | grep -i @tunnel | grep -v 'grep' | tr -s ' ' | cut -d' ' -f2"
  echo $(eval $CHECK_COMMAND)
}

function default() {
  CHECK=$(check)
  if [ -n "$CHECK" ]; then
    echo "  Tunneling"
  else
    echo " "
  fi
}

function toggle() {
  CHECK=$(check)
  if [ -n "$CHECK" ]; then
    fish -C "ctunnel" && notify-send "Tunnel is disconnected"
  else
    fish -C "ctunnel" && notify-send "Tunnel is connected"
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
