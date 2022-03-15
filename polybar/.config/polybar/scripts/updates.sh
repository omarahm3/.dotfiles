#!/usr/bin/env bash

UPDATES=$(apt list --upgradable 2> /dev/null | grep -c upgradable)

if [ $UPDATES -gt 0 ]; then
  echo " $UPDATES"
else
  echo " "
fi
