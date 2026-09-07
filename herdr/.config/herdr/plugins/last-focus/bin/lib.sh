#!/usr/bin/env bash
# Shared helpers for the last-focus plugin actions.

LAST_FOCUS_STATE_DIR="${HERDR_PLUGIN_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/herdr/plugins/mrgeek.last-focus}"

# Echo a state value, or nothing when the tracker has not recorded one yet.
last_focus_read() {
	local file="$LAST_FOCUS_STATE_DIR/$1"
	[[ -r $file ]] || return 0
	local value
	read -r value <"$file" || return 0
	printf '%s' "$value"
}

# Only needed when herdr did not pass HERDR_WORKSPACE_ID, e.g. a manual run.
last_focus_focused_workspace() {
	"${HERDR_BIN_PATH:-herdr}" api snapshot |
		jq -r '.result.snapshot.focused_workspace_id // empty'
}
