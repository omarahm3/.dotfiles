#!/bin/bash

TERMINAL=""
CODE=""
DISCORD="碌"
TELEGRAM=""
THUNAR=""
CHROME=""

RES=`echo "$TERMINAL|$CODE|$DISCORD|$THUNAR|$CHROME|$TELEGRAM" | rofi -dmenu -sep "|" -theme dock -monitor -1`

[[ $RES == $TERMINAL ]] && kitty
[[ $RES == $CODE ]] && nvim
[[ $RES == $DISCORD ]] && discord
[[ $RES == $THUNAR ]] && nautilus
[[ $RES == $CHROME ]] && google-chrome
[[ $RES == $TELEGRAM ]] && telegram-desktop
