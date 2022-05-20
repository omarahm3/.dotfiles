#!/usr/bin/env bash

UPDATES=$(yay -Qqu | tr -s ' ' | wc -l)

if [ $UPDATES -gt 0 ]; then
  echo " $UPDATES"
else
  echo " "
fi
