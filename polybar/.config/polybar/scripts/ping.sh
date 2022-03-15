#!/bin/bash

HOST=8.8.8.8

if ! ping=$(ping -n -c 1 -W 1 $HOST); then
  echo " N/A"
else
  rtt=$(echo "$ping" | sed -rn 's/.*time=([0-9]{1,})\.?[0-9]{0,} ms.*/\1/p')
  echo "泌 $rtt ms"
fi
