#!/usr/bin/env bash
# herdr-agents-lib.sh — one place for the per-agent quirks.
#
# Sourced by herdr-agent-worktree and herdr-pipeline. Every quirk below was
# found by running the agent for real on this machine; do not "simplify" one
# away without re-testing that agent headless.

# Absolute paths. Herdr panes launch $SHELL, but plugin actions and cron run
# through /bin/sh, which does not read .zshrc. opencode lives outside the
# default PATH entirely, and codex is installed under an n/node prefix, so
# resolve each one instead of assuming a single bin directory.
_resolve_agent() {
	local name="$1"
	shift
	local c
	for c in "$@"; do
		[[ -x $c ]] && {
			printf '%s' "$c"
			return 0
		}
	done
	c=$(command -v "$name" 2>/dev/null) && {
		printf '%s' "$c"
		return 0
	}
	printf '%s' "$name" # last resort: let PATH fail loudly
}

AGENT_CLAUDE="${AGENT_CLAUDE:-$(_resolve_agent claude "$HOME/.local/bin/claude")}"
AGENT_CODEX="${AGENT_CODEX:-$(_resolve_agent codex "$HOME/n/bin/codex" "$HOME/.local/bin/codex")}"
AGENT_OPENCODE="${AGENT_OPENCODE:-$(_resolve_agent opencode "$HOME/.opencode/bin/opencode")}"
AGENT_AGY="${AGENT_AGY:-$(_resolve_agent agy "$HOME/.local/bin/agy")}"

# Model defaults per lane. Authors are on flat-rate plans (Claude Max,
# OpenCode Go) so they carry the long generative prompts. Reviewers are on
# metered plans ($20 Codex, Agy Pro) so they get short, high-value prompts.
MODEL_OPENCODE="${MODEL_OPENCODE:-opencode-go/glm-5.3}"
MODEL_OPENCODE_CHEAP="${MODEL_OPENCODE_CHEAP:-opencode/mimo-v2.5-free}"
MODEL_AGY="${MODEL_AGY:-gemini-3.1-pro-high}"

agent_bin() {
	case "$1" in
	claude) printf '%s' "$AGENT_CLAUDE" ;;
	codex) printf '%s' "$AGENT_CODEX" ;;
	opencode) printf '%s' "$AGENT_OPENCODE" ;;
	agy) printf '%s' "$AGENT_AGY" ;;
	*) return 1 ;;
	esac
}

agent_available() {
	local b
	b=$(agent_bin "$1") || return 1
	[[ -x $b ]]
}

# Codex gates an interactive TUI behind a per-directory trust prompt that does
# NOT inherit from $HOME or from the source repo, so every fresh worktree would
# block. `codex exec` has no such gate inside a git repo, but we pre-trust the
# directory anyway so an interactive takeover in the pane also works.
codex_trust_dir() {
	local dir="$1" cfg="$HOME/.codex/config.toml"
	[[ -f $cfg ]] || return 0
	grep -qF "[projects.\"$dir\"]" "$cfg" 2>/dev/null && return 0
	printf '\n[projects."%s"]\ntrust_level = "trusted"\n' "$dir" >>"$cfg"
}

# Run an agent headlessly in $PWD and print its final response to stdout.
#   agent_run <kind> <prompt> [model]
#
# Quirks encoded here:
#   claude   -p takes the prompt as a normal argument.
#   codex    `exec` needs no trust prompt inside a git repo.
#   opencode `run` takes the prompt positionally; -m selects the model.
#   agy      --print MUST carry the prompt attached with '=' or it swallows the
#            next flag as its prompt. Without --dangerously-skip-permissions the
#            headless run auto-denies the command permission and prints nothing.
agent_run() {
	local kind="$1" prompt="$2" model="${3:-}" bin
	bin=$(agent_bin "$kind") || {
		printf 'unknown agent kind: %s\n' "$kind" >&2
		return 2
	}
	[[ -x $bin ]] || {
		printf 'agent not installed: %s (%s)\n' "$kind" "$bin" >&2
		return 3
	}

	case "$kind" in
	claude)
		if [[ -n $model ]]; then "$bin" -p "$prompt" --model "$model"; else "$bin" -p "$prompt"; fi
		;;
	codex)
		codex_trust_dir "$PWD"
		if [[ -n $model ]]; then "$bin" exec -m "$model" "$prompt"; else "$bin" exec "$prompt"; fi
		;;
	opencode)
		if [[ -n $model ]]; then "$bin" run -m "$model" "$prompt"; else "$bin" run -m "$MODEL_OPENCODE" "$prompt"; fi
		;;
	agy)
		# order matters: skip-permissions first, prompt attached to --print.
		# --print-timeout defaults to 5m, which a real review on a large repo
		# routinely exceeds; raise it so the run does not die mid-answer.
		local agy_to="${AGY_PRINT_TIMEOUT:-20m}"
		if [[ -n $model ]]; then
			"$bin" --dangerously-skip-permissions --print-timeout "$agy_to" --model "$model" --print="$prompt"
		else
			"$bin" --dangerously-skip-permissions --print-timeout "$agy_to" --model "$MODEL_AGY" --print="$prompt"
		fi
		;;
	esac
}

# tanda's AGENTS.md rules that an agent will not know unless told. Prepended to
# every prompt dispatched into a tanda checkout.
repo_rules() {
	local repo="$1"
	[[ -f "$repo/AGENTS.md" ]] || return 0
	cat <<'EOF'
Repository rules you MUST follow (from this repo's AGENTS.md):
- Package manager is bun, not npm or yarn. Run `bun install` from the repo root.
- The shell is zsh: quote every glob, e.g. --include="*.ts".
- Use rg, not grep -rn. Do not chain discovery searches with &&.
- Do not assume the working directory persists between shell calls; use
  absolute paths or chain with `cd <dir> && <cmd>` in one invocation.
- Verification commands: `bun run typecheck`, `bun run lint`, `bun run test`.
- Before editing a function/class/method, run GitNexus impact analysis and
  report the blast radius. Never rename symbols with find-and-replace.

EOF
}
