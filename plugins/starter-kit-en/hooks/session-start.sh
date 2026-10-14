#!/usr/bin/env bash
# starter-kit-en SessionStart hook.
#
# Writes a short English context note for the model as SessionStart JSON:
#   (a) no configured workspace   -> suggest /starter-kit-en:setup
#   (b) workspace, profile empty  -> "Workspace: <path>" + suggest /starter-kit-en:onboard
#   (c) workspace ready           -> "Workspace: <path>" (+ pointer to CLAUDE.md if cwd is outside it)
#
# Constraints: plain bash (macOS ships bash 3.2), no python/jq dependency,
# never exits non-zero. On any unexpected problem it prints nothing.
# On Windows the hook runs in Git Bash: CLAUDE_PLUGIN_DATA / CLAUDE_PROJECT_DIR
# may be "C:\..." paths and the config holds "C:/..."; all are converted with
# cygpath before use, and the cwd comparison ignores case there.

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

is_windows_shell() {
  case $(uname -s 2>/dev/null) in
    MINGW*|MSYS*|CYGWIN*) return 0 ;;
  esac
  return 1
}

# "C:\x" / "C:/x" -> "/c/x" on Windows shells; unchanged elsewhere.
to_posix_path() {
  local p=$1
  if is_windows_shell; then
    case $p in
      [A-Za-z]:|[A-Za-z]:\\*|[A-Za-z]:/*)
        if command -v cygpath >/dev/null 2>&1; then
          p=$(cygpath -u "$p")
        fi
        ;;
    esac
    p=${p//\\//}
  fi
  printf '%s' "$p"
}

resolve_dir() {
  [ -n "$1" ] || return 0
  (cd "$(to_posix_path "$1")" 2>/dev/null && pwd -P)
}

# True if directory $1 is $2 or lies below it. Paths on Windows are
# case-insensitive, so they are compared lowercased there.
inside_dir() {
  local a=$1 b=$2
  if is_windows_shell; then
    a=$(printf '%s' "$a" | tr '[:upper:]' '[:lower:]')
    b=$(printf '%s' "$b" | tr '[:upper:]' '[:lower:]')
  fi
  case "$a/" in
    "$b/"*) return 0 ;;
  esac
  return 1
}

main() {
  local data_dir=${CLAUDE_PLUGIN_DATA:-}
  local config="" workspace="" msg=""

  if [ -n "$data_dir" ]; then
    config="$(to_posix_path "$data_dir")/config"
  fi

  if [ -n "$config" ] && [ -f "$config" ]; then
    workspace=$(sed -n 's/^workspace=//p' "$config" 2>/dev/null | head -n 1)
    workspace=$(strip_ctrl "$workspace")
  fi
  local ws_posix=""
  [ -n "$workspace" ] && ws_posix=$(to_posix_path "$workspace")

  if [ -z "$workspace" ] || [ ! -d "$ws_posix" ]; then
    # State (a)
    msg="The starter-kit-en plugin is installed, but no workspace has been set up yet."
    if [ -n "$workspace" ]; then
      msg="$msg (The previously configured folder was not found: $workspace)"
    fi
    msg="$msg In your first substantive reply, offer in one short sentence to run /starter-kit-en:setup, which creates the workspace."
  else
    msg="Workspace: $workspace"
    local profile="$ws_posix/About Me/about-me.md"
    if [ ! -f "$profile" ] || grep -q 'Last updated: —' "$profile" 2>/dev/null; then
      # State (b)
      msg="$msg"$'\n'"The owner's profile (About Me/about-me.md) is not filled in yet. In your first substantive reply, offer in one short sentence to run /starter-kit-en:onboard."
    fi
    local here ws_real
    here=$(resolve_dir "${CLAUDE_PROJECT_DIR:-$PWD}")
    ws_real=$(resolve_dir "$workspace")
    if [ -n "$ws_real" ] && ! inside_dir "$here" "$ws_real"; then
      msg="$msg"$'\n'"This session was not started from the workspace: the main agent's rules are in $workspace/CLAUDE.md, and your own teammates (under $workspace/.claude/agents/) are also only available in a session started from the workspace."
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
