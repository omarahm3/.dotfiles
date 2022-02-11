#!/bin/bash

LIST_DATA="#{window_name} #{pane_title} #{pane_current_path} #{pane_current_command}"
FZF_COMMAND="fzf --reverse --with-nth 4 --color=hl:2"

TARGET_SPEC="#{session_name}:#{window_id}:#{pane_id}"

PANE=$(tmux list-panes -a -F "$TARGET_SPEC $LIST_DATA" | $FZF_COMMAND)

ARGS=(${PANE//:/ })

SESSION_NAME=${ARGS[0]}
WINDOW_ID=${ARGS[1]}
PANE_ID=${ARGS[2]}

tmux select-pane -t $PANE_ID && tmux select-window -t $WINDOW_ID && tmux switch-client -t $SESSION_NAME
