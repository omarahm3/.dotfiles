#!/usr/bin/env bash
# Shared helpers for the herdr-* scripts (ported from the tmux-* scripts).

set -euo pipefail

HERDR_PROJECTS_FILE="${HERDR_PROJECTS_FILE:-$HOME/.config/herdr/projects}"
HERDR_LISTS_DIR="${HERDR_LISTS_DIR:-$HOME/.config/herdr/lists}"
HERDR_FOCUS_STATE="${HERDR_FOCUS_STATE:-${XDG_STATE_HOME:-$HOME/.local/state}/herdr/focus-history.json}"

FZF_OPTS=(--cycle --reverse --color=hl:2)

herdr_project_roots() {
	[[ -r $HERDR_PROJECTS_FILE ]] || {
		printf 'herdr: missing projects file: %s\n' "$HERDR_PROJECTS_FILE" >&2
		exit 1
	}
	sed -e 's/#.*//' -e 's:/*$::' -e "s:^~:$HOME:" "$HERDR_PROJECTS_FILE" |
		grep -v '^[[:space:]]*$'
}

herdr_label_for() {
	basename "$1" | tr . _
}

herdr_workspace_id_by_label() {
	herdr workspace list |
		jq -r --arg label "$1" \
			'.result.workspaces[] | select(.label == $label) | .workspace_id' |
		head -n 1
}

# Focus the workspace whose label matches the directory, creating it if absent.
herdr_open_workspace() {
	local dir="${1%/}" label id
	[[ -d $dir ]] || {
		printf 'herdr: not a directory: %s\n' "$dir" >&2
		exit 1
	}
	label=$(herdr_label_for "$dir")
	id=$(herdr_workspace_id_by_label "$label")

	if [[ -n $id ]]; then
		herdr workspace focus "$id" >/dev/null
	else
		herdr workspace create --cwd "$dir" --label "$label" --focus >/dev/null
	fi
}

# Create a focused tab and echo its root pane id.
herdr_new_tab_pane() {
	herdr tab create --label "$1" --focus |
		jq -er '.result.root_pane.pane_id'
}

herdr_focused_workspace_id() {
	herdr api snapshot |
		jq -r '.result.snapshot.focused_workspace_id // empty'
}

# Focus history is maintained by herdr-focus-tracker. A missing file just means
# the tracker has not seen a move yet, so the callers no-op.
herdr_previous_workspace_id() {
	[[ -r $HERDR_FOCUS_STATE ]] || return 0
	jq -r '.workspace.previous // empty' "$HERDR_FOCUS_STATE"
}

herdr_previous_tab_id() {
	[[ -r $HERDR_FOCUS_STATE ]] || return 0
	jq -r --arg ws "$1" '.tabs[$ws].previous // empty' "$HERDR_FOCUS_STATE"
}
