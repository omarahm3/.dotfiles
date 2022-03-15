#!/bin/bash

SERVER="mail.privateemail.com"
NETRC="$HOME/.config/polybar/private/mail.netrc"

INBOX=$(curl -sf --netrc-file "$NETRC" -X "STATUS INBOX (UNSEEN)" imaps://"$SERVER"/INBOX | tr -d -c "[:digit:]")

if [ "$INBOX" ] && [ "$INBOX" -gt 0 ]; then
  echo " $INBOX"
else
  echo " "
fi
