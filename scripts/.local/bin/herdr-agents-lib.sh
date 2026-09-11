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
# Codex top tier available to a ChatGPT (OAuth) account. Verified 6 Sep 2026:
# gpt-5.6-terra / gpt-5.6-sol / gpt-5.5 work; every *-codex slug (gpt-5.3-codex,
# gpt-5.6-codex) returns HTTP 400 "not supported when using Codex with a ChatGPT
# account", and gpt-6-astra needs a newer CLI than 0.151.0 (it works via the
# Hermes transport, just not this binary). Do not "upgrade" this to a -codex id.
MODEL_CODEX="${MODEL_CODEX:-gpt-5.6-terra}"

agent_bin() {
	local b
	case "$1" in
	claude) b="$AGENT_CLAUDE" ;;
	codex) b="$AGENT_CODEX" ;;
	opencode) b="$AGENT_OPENCODE" ;;
	agy) b="$AGENT_AGY" ;;
	*) return 1 ;;
	esac
	# An EMPTY value is a resolution failure, not a valid binary. Returning 0 with
	# empty stdout let `bin=$(agent_bin x) || return` sail past its own guard, and
	# agent_argv then emitted `cat prompt | '' -p` — printf '%q' renders empty as
	# ''. The pane ran that, did nothing, stayed "idle", and the stage blocked on
	# its sentinel until HERDR_PANE_TIMEOUT. Two runs were lost to it looking like
	# a hung model rather than an unresolved path.
	[[ -n $b ]] || return 1
	printf '%s' "$b"
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
# Print the argv an agent would run, one shell-quoted word per line, WITHOUT
# executing it. This exists so a caller can hand the same command to a Herdr pane
# (where the run is visible to `herdr agent list`) instead of a hidden subprocess.
# The prompt is passed via a FILE, never interpolated into the command string:
# prompts contain quotes, newlines and backticks, and a run must not be able to
# turn its own task description into shell syntax.
#   agent_argv <kind> <prompt-file> [model]
agent_argv() {
	local kind="$1" pfile="$2" model="${3:-}" bin
	bin=$(agent_bin "$kind") || return 2
	[[ -x $bin ]] || return 3
	# The prompt is piped on STDIN, never inlined into argv. A round-2 triage prompt
	# carries two full reviews (codex alone hit 1.5 MB), and `cmd "$(cat file)"`
	# blows E2BIG -> the shell reports "argument list too long" INTO the output file,
	# which then reads like a real answer downstream. claude/codex/opencode all
	# accept a bare stdin prompt; agy does not, so it keeps --print= and gets a
	# truncated prompt instead (see truncate_for_argv).
	local p
	p="cat $(printf '%q' "$pfile") | "
	case "$kind" in
	claude)
		if [[ -n $model ]]; then printf '%s%q -p --model %q' "$p" "$bin" "$model"
		else printf '%s%q -p' "$p" "$bin"; fi ;;
	codex) codex_trust_dir "$PWD"; printf '%s%q exec -m %q -' "$p" "$bin" "${model:-$MODEL_CODEX}" ;;
	opencode) printf '%s%q run -m %q' "$p" "$bin" "${model:-$MODEL_OPENCODE}" ;;
	agy) printf '%q --dangerously-skip-permissions --print-timeout %q --model %q --print="$(cat %q)"' \
		"$bin" "${AGY_PRINT_TIMEOUT:-20m}" "${model:-$MODEL_AGY}" "$pfile" ;;
	*) return 2 ;;
	esac
}

# ONE PEN PER WORKTREE.
#
# Kill every agent process whose cwd is inside <dir>. /proc is the ground truth
# herdr cannot get wrong: any agent sitting in this worktree belongs to this
# stage, and a stage that is over must leave none behind. Never widen the match
# past <dir> — matching on the binary name alone would kill a sibling run.
#
# Returns 0 if it killed nothing, 1 if it had to kill something (the caller can
# then report that the previous stage lied about being finished).
#   reap_agents_in_dir <dir>
#
# SELF-IMMOLATION GUARD. The candidate scan is `pgrep -f`, which matches the
# WHOLE command line — and this runner's own command line carries the seat names
# whenever the caller passes `--implementer claude --reviewers codex,agy`. The
# runner's stage subshell also runs with cwd = the worktree, so it matched its own
# filter and SIGKILLed itself before dispatching anything: every lane returned
# rc=137 and the run reported "every implementer in the lane failed" over a
# perfectly healthy tree. Never kill this process, any ancestor of it, or any
# process whose command line is a herdr runner rather than an agent.
_agent_reaper_skip() {
	local pid="$1" p
	# Self, and every ancestor up to init.
	p=$$
	while [[ -n $p && $p -gt 1 ]]; do
		[[ $pid == "$p" ]] && return 0
		p=$(awk '{print $4}' "/proc/$p/stat" 2>/dev/null) || return 1
	done
	# A herdr runner is never an agent, whatever words its argv happens to carry.
	tr '\0' ' ' <"/proc/$pid/cmdline" 2>/dev/null | grep -q 'herdr-sdlc\|herdr-pipeline\|herdr-agents-lib' && return 0
	return 1
}

reap_agents_in_dir() {
	local dir="$1" victim vcwd killed=0
	dir=$(readlink -f "$dir" 2>/dev/null) || return 0
	[[ -n $dir && $dir != "/" && $dir != "$HOME" ]] || return 0
	for victim in $(pgrep -u "$(id -u)" -f 'opencode|codex|claude|agy' 2>/dev/null); do
		_agent_reaper_skip "$victim" && continue
		vcwd=$(readlink -f "/proc/$victim/cwd" 2>/dev/null) || continue
		[[ $vcwd == "$dir" || $vcwd == "$dir"/* ]] || continue
		kill -KILL "$victim" 2>/dev/null && killed=1
	done
	((killed == 0)) || sleep 1
	return "$killed"
}

# Is any agent still working inside <dir>?
#   agents_live_in_dir <dir>
agents_live_in_dir() {
	local dir="$1" victim vcwd
	dir=$(readlink -f "$dir" 2>/dev/null) || return 1
	for victim in $(pgrep -u "$(id -u)" -f 'opencode|codex|claude|agy' 2>/dev/null); do
		_agent_reaper_skip "$victim" && continue
		vcwd=$(readlink -f "/proc/$victim/cwd" 2>/dev/null) || continue
		[[ $vcwd == "$dir" || $vcwd == "$dir"/* ]] || continue
		return 0
	done
	return 1
}

# Run an agent inside a Herdr pane so it is visible to `herdr agent list` and
# `herdr pane read`, and block until it exits. Output lands in <out>.
#
# Herdr renders most agent CLIs on the terminal's ALTERNATE screen, and rows that
# leave the alternate screen never enter host scrollback - so `pane read` cannot be
# trusted to recover a full transcript. The command therefore redirects to a file
# and signals completion through a sentinel file, which is authoritative; the pane
# is for watching, the file is for reading.
#   agent_run_pane <kind> <prompt-file> <out> <workspace-label> <pane-title> [model]
agent_run_pane() {
	local kind="$1" pfile="$2" out="$3" label="$4" title="$5" model="${6:-}"
	local HERDR="${HERDR_BIN_PATH:-herdr}"
	command -v "$HERDR" >/dev/null 2>&1 || return 10
	"$HERDR" status >/dev/null 2>&1 || return 10

	local argv ws pane done_file
	argv=$(agent_argv "$kind" "$pfile" "$model") || return 2
	# Belt and braces: a malformed argv must never reach `herdr pane run`. An empty
	# binary renders as '' and the pane silently does nothing until the timeout.
	# NOTE: do NOT diagnose this from the pane title — herdr strips absolute binary
	# paths out of terminal_title, so a perfectly good command displays as
	# `cat prompt |  -p` and looks broken when it is not. Trace argv instead.
	[[ -n $argv && $argv != *"| ''"* && $argv != *"|  "* ]] || {
		printf 'agent_argv produced an unusable command for %s: %s\n' "$kind" "$argv" >&2
		return 2
	}
	done_file="${out}.done"
	rm -f "$done_file"

	# PRE-DISPATCH GUARD — never open a second pen on one worktree.
	# A stage that ended (cleanly, by timeout, or by a premature sentinel) must
	# leave no agent behind. If one is still here, the previous stage lied about
	# being finished: kill it BEFORE dispatching, or two agents edit one tree and
	# clobber each other mid-read. This is the condition that produced two live
	# `opencode run` processes (kimi-k2.7-code and minimax-m3) in one worktree.
	if agents_live_in_dir "$PWD"; then
		printf 'agent still live in %s from a previous stage; reaping before dispatch\n' "$PWD" >&2
		reap_agents_in_dir "$PWD" || true
	fi

	ws=$("$HERDR" workspace list 2>/dev/null | jq -r --arg l "$label" \
		'.result.workspaces[]? | select(.label == $l) | .workspace_id' | head -n1)
	if [[ -z $ws ]]; then
		ws=$("$HERDR" workspace create --cwd "$PWD" --label "$label" --no-focus 2>/dev/null |
			jq -r '.result.workspace.workspace_id')
	fi
	[[ -n $ws && $ws != null ]] || return 10

	# One tab per stage, named for the seat, so the sidebar reads like a run log.
	# The flag is --label; `tab create` has no --title (that is `pane`/`tab rename`).
	pane=$("$HERDR" tab create --workspace "$ws" --cwd "$PWD" --label "$title" --no-focus 2>/dev/null |
		jq -r '.result.root_pane.pane_id')
	[[ -n $pane && $pane != null ]] || return 10

	# Preserve any previous attempt's transcript. `>` truncates on redirect, so a
	# fallback attempt destroyed the prior model's output the instant its pane
	# started — 65 KB of a COMPLETED implementation was lost this way, leaving no
	# evidence of what had already been done. Roll the old file aside instead.
	if [[ -s $out ]]; then
		local n=1
		while [[ -e ${out}.attempt-${n} ]]; do n=$((n + 1)); done
		cp -f "$out" "${out}.attempt-${n}" 2>/dev/null || true
	fi

	"$HERDR" pane run "$pane" "{ $argv ; } >$(printf '%q' "$out") 2>&1; printf '%s' \$? >$(printf '%q' "$done_file")" \
		>/dev/null 2>&1 || return 10

	# Poll the sentinel. The pane stays readable the whole time.
	local waited=0 limit="${HERDR_PANE_TIMEOUT:-3600}"
	while [[ ! -f $done_file ]]; do
		sleep 5
		waited=$((waited + 5))
		if ((waited >= limit)); then
			# TIMEOUT MUST KILL. Returning 124 while leaving the agent alive let a
			# timed-out implementer keep editing the worktree while the caller
			# started a FALLBACK implementer in the same directory — two agents
			# writing one tree. Seen for real: glm-5.3 had already finished the
			# work, hit the 3600s limit, was declared failed, and kept running
			# alongside its own replacement.
			# There is no `pane kill-process` subcommand. Ctrl-C via send-keys is
			# the graceful path; process-info gives the real foreground pgid for
			# the SIGKILL fallback. The pane is left open so the transcript stays
			# readable.
			"$HERDR" pane send-keys "$pane" ctrl-c >/dev/null 2>&1 || true
			sleep 3
			local pgid
			pgid=$("$HERDR" pane process-info --pane "$pane" 2>/dev/null |
				jq -r '.result.process_info.foreground_process_group_id // empty')
			if [[ -n $pgid && $pgid =~ ^[0-9]+$ ]]; then
				# Only kill if something other than the bare shell is still up.
				local fg
				fg=$("$HERDR" pane process-info --pane "$pane" 2>/dev/null |
					jq -r '[.result.process_info.foreground_processes[]?.name] | join(",")')
				if [[ -n $fg && $fg != "zsh" && $fg != "bash" && $fg != "sh" ]]; then
					kill -TERM "-$pgid" 2>/dev/null || true
					sleep 2
					kill -KILL "-$pgid" 2>/dev/null || true
				fi
			fi
			# REAP BY CWD — the authoritative kill, do not remove.
			# Everything above depends on herdr answering `pane process-info` with a
			# real foreground pgid. When it answers empty (or the agent has
			# re-parented away from the pane's process group) NOTHING is killed and
			# the timed-out agent survives. That is not theoretical: ten orphaned
			# `opencode run` processes accumulated over 2.5 days, held ~2.7 GB, and
			# starved every subsequent model into its own 3600s timeout — five
			# fallbacks deep, twice per round. The run looked "busy" for 30 hours
			# while doing nothing.
			# /proc is the ground truth herdr cannot get wrong: any process whose cwd
			# is this worktree belongs to this stage. Never widen this past $PWD —
			# matching on the binary name alone would kill a sibling run's agent.
			local victim vcwd
			for victim in $(pgrep -u "$(id -u)" -f 'opencode|codex|claude|agy' 2>/dev/null); do
				vcwd=$(readlink -f "/proc/$victim/cwd" 2>/dev/null) || continue
				[[ $vcwd == "$PWD" || $vcwd == "$PWD"/* ]] || continue
				kill -KILL "$victim" 2>/dev/null || true
			done
			return 124
		fi
	done
	# THE SENTINEL IS NOT PROOF THE AGENT IS GONE.
	# `{ cmd ; } >out; printf $? >done` writes the sentinel when the FOREGROUND
	# pipeline returns — but an agent that re-parents, forks a child, or is
	# resumed by its own CLI can outlive that moment. The caller then reads a
	# clean rc, declares the stage over, and dispatches the next model into a
	# worktree the previous one is still editing: two agents, one tree.
	# Always reap by cwd after the sentinel, and downgrade rc to a failure if we
	# had to — a stage whose agent had to be killed did not finish honestly.
	local rc
	rc="$(cat "$done_file" 2>/dev/null || echo 1)"
	if ! reap_agents_in_dir "$PWD"; then
		printf 'stage wrote its sentinel but left a live agent in %s; killed it\n' "$PWD" >&2
		((rc == 0)) && rc=125
	fi
	return "$rc"
}

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
		if [[ -n $model ]]; then "$bin" exec -m "$model" "$prompt"; else "$bin" exec -m "$MODEL_CODEX" "$prompt"; fi
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

# Rules an agent will not know unless told, prepended to every dispatched prompt.
# Keyed by repo because the media repo's rules are nothing like the app's — feeding
# it "package manager is bun, run bun run typecheck" sends the agent chasing commands
# that do not exist there.
repo_rules() {
	local repo="$1"
	[[ -f "$repo/AGENTS.md" ]] || return 0

	# Media production: Blender/Python, no bun, hard creative gates.
	if [[ -f "$repo/START-HERE.md" && -d "$repo/storyboards" ]]; then
		cat <<'EOF'
Repository rules you MUST follow (from this repo's AGENTS.md / START-HERE.md):
- Read START-HERE.md FIRST, then docs/pipeline.md, docs/agents.md, docs/repository.md.
  It states the current stage, the current gate, and what is frozen.
- There is no bun/npm here. Python package is src/tanda_video/; Blender renders,
  OpenCut assembles. Do not introduce another production tool.
- NEVER recreate or approximate the TANDA app UI. Use the real screen recordings or
  approved real captures only.
- The narration WAV is canonical for timing; the recording is canonical for behavior.
- Typography is Outfit; Arabic is Cairo. TANDA lime is an accent, never a neon wash.
- Apply the stop-slop skill to ALL prose: scripts, captions, headlines, reports.
- Avoid AI-startup aesthetics: blurred neon glows, floating-phone mockups, excess bloom,
  everything centered, unnecessary darkness. Use photographed physical surfaces instead.
- One milestone at a time. Stop at every gate. Never approve your own work. Frozen work
  is frozen. "It rendered" is NOT success — compare against the storyboard and check
  readability at mobile size.
- Do not commit rendered outputs or restricted commercial assets.

EOF
		return 0
	fi

	# App repo (bun/TypeScript monorepo).
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
