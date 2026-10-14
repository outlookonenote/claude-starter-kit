#!/usr/bin/env bash
# starter-kit-en: move own agents from the pre-0.2.0 layout to the new one.
#
# Usage: migrate-agents.sh <workspace-path> [--apply]
#
# Old layout (0.1.x): <workspace>/Team/<Department>/<name>.md, made visible
#   by a symlink ~/.claude/agents/<name>.md (on Git Bash "ln -s" usually made a
#   plain copy instead, which then went stale).
# New layout (0.2.0+): <workspace>/.claude/agents/<Department>/<name>.md, loaded
#   by Claude Code as project agents when it is started from the workspace.
#
# Without --apply it only prints the plan (dry run) and changes nothing.
# With --apply it moves each agent file and removes the old entry under
# ~/.claude/agents/ ONLY if it is a symlink to that file or a byte-identical
# copy of it. Anything else is left in place and reported. Existing files in
# the new location are never overwritten.
#
# Output is English, meant to be relayed to the user by the skill.

set -u

TEAM_DIR="Team"

# Arguments: the workspace path and an optional --apply, in any order.
ws_arg=""
apply=0
for arg in "$@"; do
  case $arg in
    --apply) apply=1 ;;
    *) [ -z "$ws_arg" ] && ws_arg=$arg ;;
  esac
done
if [ -z "$ws_arg" ]; then
  echo "Usage: migrate-agents.sh <workspace-path> [--apply]" >&2
  exit 2
fi

# True if the file starts with a YAML frontmatter block ("---" on the first
# line, closed by another "---") that contains a non-empty "name:" field.
# Only such files are agent definitions; README.md and other notes are not.
is_agent_file() {
  awk '
    { sub(/\r$/, "") }
    NR == 1 { if ($0 != "---") { bad = 1; exit } next }
    /^---$/ { closed = 1; exit }
    /^name:[ \t]*[^ \t]/ { found = 1 }
    END { exit (!bad && closed && found) ? 0 : 1 }
  ' "$1" 2>/dev/null
}

is_windows_shell() {
  case $(uname -s 2>/dev/null) in
    MINGW*|MSYS*|CYGWIN*) return 0 ;;
  esac
  return 1
}

to_posix_path() {
  local p=$1 drive rest
  if is_windows_shell; then
    case $p in
      [A-Za-z]:|[A-Za-z]:\\*|[A-Za-z]:/*)
        if command -v cygpath >/dev/null 2>&1; then
          p=$(cygpath -u "$p")
        else
          drive=$(printf '%s' "${p%%:*}" | tr '[:upper:]' '[:lower:]')
          rest=${p#?:}
          rest=${rest//\\//}
          p="/$drive$rest"
        fi
        ;;
      *)
        p=${p//\\//}
        ;;
    esac
  fi
  printf '%s' "$p"
}

ws=$(to_posix_path "$ws_arg")

case $ws in
  "~") ws=$HOME ;;
  "~/"*) ws="$HOME/${ws#\~/}" ;;
esac

if [ ! -d "$ws" ]; then
  echo "ERROR: workspace not found: $ws" >&2
  exit 1
fi
ws=$(cd "$ws" && pwd)

user_agents="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
user_agents=$(to_posix_path "$user_agents")/agents

found=0
moved=0
kept=0

while IFS= read -r -d '' src; do
  rel=${src#"$ws/$TEAM_DIR/"}
  if ! is_agent_file "$src"; then
    echo "- $TEAM_DIR/$rel: SKIPPED, not an agent file (no frontmatter at the top, or no name: field in it), left in place."
    continue
  fi
  found=$((found + 1))
  dept=${rel%%/*}
  file=${rel#*/}
  dst="$ws/.claude/agents/$dept/$file"
  old="$user_agents/$file"

  # Classify the old entry under ~/.claude/agents/ BEFORE moving anything.
  old_state="none"
  if [ -L "$old" ]; then
    if [ "$old" -ef "$src" ]; then old_state="symlink"; else old_state="other"; fi
  elif [ -f "$old" ]; then
    if cmp -s "$old" "$src"; then old_state="copy"; else old_state="different"; fi
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "- $TEAM_DIR/$rel: SKIPPED, a file with this name already exists in the new location (.claude/agents/$dept/$file)."
    kept=$((kept + 1))
    continue
  fi

  if [ $apply -eq 0 ]; then verb="will be removed"; else verb="removed"; fi
  case $old_state in
    symlink) old_note="the old symlink ($old) $verb" ;;
    copy)    old_note="the old identical copy ($old) $verb" ;;
    different) old_note="WARNING: $old differs from the workspace file, so it is left alone; review it by hand" ;;
    other)   old_note="WARNING: $old is a symlink pointing elsewhere, left alone" ;;
    *)       old_note="no matching entry under ~/.claude/agents/" ;;
  esac

  if [ $apply -eq 0 ]; then
    echo "- $TEAM_DIR/$rel -> .claude/agents/$dept/$file ($old_note)"
    continue
  fi

  mkdir -p "$ws/.claude/agents/$dept" \
    || { echo "ERROR: could not create: $ws/.claude/agents/$dept" >&2; exit 1; }
  mv "$src" "$dst" || { echo "ERROR: move failed: $TEAM_DIR/$rel" >&2; exit 1; }
  case $old_state in
    symlink|copy) rm -f "$old" ;;
  esac
  rmdir "$ws/$TEAM_DIR/$dept" 2>/dev/null
  moved=$((moved + 1))
  echo "- Moved: $TEAM_DIR/$rel -> .claude/agents/$dept/$file ($old_note)"
done < <(find "$ws/$TEAM_DIR" -mindepth 2 -maxdepth 2 -type f -name '*.md' -print0 2>/dev/null)

if [ $found -eq 0 ]; then
  echo "No own teammates to move in the subfolders of $TEAM_DIR/."
elif [ $apply -eq 0 ]; then
  echo "This is only the plan, nothing was changed. To carry it out: the same command with --apply."
else
  echo "Moved: $moved, skipped: $kept. The new location takes effect from the next claude start."
fi
exit 0
