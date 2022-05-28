#!/usr/bin/env bash

GET_UPDATES=$(yay -Qqu 2> /dev/null)

if [ $? -ne 0 ]; then
    echo " Error"
    exit 1
fi

GET_UPDATES=$(echo $GET_UPDATES | tr -s ' ')

if [ -z "$GET_UPDATES" ]; then
  echo " "
  exit 0
fi

UPDATES=$(echo $GET_UPDATES | wc -l)

if [ $UPDATES -gt 0 ]; then
  echo " $UPDATES"
else
  echo " "
fi
