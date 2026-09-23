#!/usr/bin/env bash
# starter-kit-en SessionStart hook.
#
# Writes a short English context note for the model as SessionStart JSON:
#   (a) no configured workspace   -> suggest /starter-kit-en:setup
#   (b) workspace, profile empty  -> "Workspace: <path>" + suggest /starter-kit-en:onboard
#   (c) workspace ready           -> "Workspace: <path>" (+ pointer to CLAUDE.md if cwd differs)
#
# Constraints: plain bash (macOS ships bash 3.2), no python/jq dependency,
# never exits non-zero. On any unexpected problem it prints nothing.

# JSON string escaping without jq/python: backslash, double quote, tab, and
# newlines (lines are joined with a literal \n by awk).
json_escape() {
  local tab
  tab=$(printf '\t')
  printf '%s' "$1" \
    | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e "s/${tab}/\\\\t/g" \
    | awk 'NR > 1 { printf "\\n" } { printf "%s", $0 }'
}

# Strip control characters (a path could in theory contain them; JSON forbids them raw).
strip_ctrl() {
  printf '%s' "$1" | LC_ALL=C tr -d '\000-\010\013-\037'
}

resolve_dir() {
  (cd "$1" 2>/dev/null && pwd -P)
}

main() {
  local data_dir=${CLAUDE_PLUGIN_DATA:-}
  local config="" workspace="" msg=""

  if [ -n "$data_dir" ]; then
    config="$data_dir/config"
  fi

  if [ -n "$config" ] && [ -f "$config" ]; then
    workspace=$(sed -n 's/^workspace=//p' "$config" 2>/dev/null | head -n 1)
    workspace=$(strip_ctrl "$workspace")
  fi

  if [ -z "$workspace" ] || [ ! -d "$workspace" ]; then
    # State (a)
    msg="The starter-kit-en plugin is installed, but no workspace has been set up yet."
    if [ -n "$workspace" ]; then
      msg="$msg (The previously configured folder was not found: $workspace)"
    fi
    msg="$msg In your first substantive reply, offer in one short sentence to run /starter-kit-en:setup, which creates the workspace."
  else
    msg="Workspace: $workspace"
    local profile="$workspace/About Me/about-me.md"
    if [ ! -f "$profile" ] || grep -q 'Last updated: —' "$profile" 2>/dev/null; then
      # State (b)
      msg="$msg"$'\n'"The owner's profile (About Me/about-me.md) is not filled in yet. In your first substantive reply, offer in one short sentence to run /starter-kit-en:onboard."
    fi
    local here ws_real
    here=$(resolve_dir "${CLAUDE_PROJECT_DIR:-$PWD}")
    ws_real=$(resolve_dir "$workspace")
    if [ -n "$ws_real" ] && [ "$here" != "$ws_real" ]; then
      msg="$msg"$'\n'"This session was not started from the workspace: the main agent's rules are in $workspace/CLAUDE.md."
    fi
  fi

  local esc
  esc=$(json_escape "$msg")
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$esc"
}

out=$(main 2>/dev/null) || out=""
if [ -n "$out" ]; then
  printf '%s\n' "$out"
fi
exit 0
