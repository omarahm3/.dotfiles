#!/bin/bash

clear

# Can be used to send password to the current active tmux pane
# ACTIVE_PANE="$1"

items=$(bw list items --session 5bV3kCnJgAG49Dtzlx/3YmnkkpRwjeRpTPmUrBb0/BwzcM3nl2Rv2G+d/UZCJMrNcs1atCMNv0MNP3MPcTI1qA== | jq -r "map({ (.name|tostring): .login.password })|add")
key=$(echo "$items" | jq -r ".|keys[]" | fzf --cycle --reverse)
password=$(echo "$items" | jq ".\"$key\"")

if [ "$password" == "null" ]; then
  exit 0
fi

password=${password:1:-1}

echo -n "$password" | xclip -selection clipboard  


# clear
read -r -p "password copied, paste then exist to remove clipboard"
