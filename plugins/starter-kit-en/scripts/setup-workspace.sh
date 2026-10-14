#!/usr/bin/env bash
# starter-kit-en workspace installer (called by the /starter-kit-en:setup skill
# and by the one-line installers with their English option).
#
# Usage: setup-workspace.sh <plugin-data-dir> <workspace-path> [main-agent-name]
#
# - Copies templates/workspace/ (including hidden .claude/) into <workspace-path>
#   WITHOUT overwriting any existing file. Safe to re-run (idempotent).
# - Replaces the default main-agent name "Max" with [main-agent-name], but only
#   in files created by this run (never touches files the user already has).
# - Writes "workspace=<absolute path>" into <plugin-data-dir>/config.
#
# Paths: POSIX paths, "~", "~/..." and "~\..." work everywhere. On Windows
# (Git Bash / MSYS) "C:\...", "C:/..." and backslash-separated relative paths
# work too; the config then stores the "C:/Users/..." form, which both Git Bash
# and Claude Code's own tools understand.
#
# Output is English, meant to be relayed to the user by the skill.

set -u

DEFAULT_NAME="Max"

if [ $# -lt 2 ]; then
  echo "Usage: setup-workspace.sh <plugin-data-dir> <workspace-path> [main-agent-name]" >&2
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

# Turn a user-supplied path into a path this shell can use. On Windows shells:
# drive-letter paths go through cygpath (or a manual fallback), and backslashes
# become slashes. Elsewhere the path is returned unchanged (a backslash is a
# legal filename character on macOS/Linux).
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

# The form written into the config: "C:/Users/..." on Windows, unchanged elsewhere.
to_config_path() {
  if is_windows_shell && command -v cygpath >/dev/null 2>&1; then
    cygpath -m "$1"
  else
    printf '%s' "$1"
  fi
}

# In-place sed that works with both GNU sed (Git Bash, Linux) and BSD sed (macOS).
if sed --version >/dev/null 2>&1; then
  sed_inplace() { sed -i "$@"; }
else
  sed_inplace() { sed -i '' "$@"; }
fi

data_dir=$(to_posix_path "$1")
target=$(to_posix_path "$2")
name=${3:-$DEFAULT_NAME}
[ -n "$name" ] || name=$DEFAULT_NAME

script_dir=$(cd "$(dirname "$0")" && pwd -P)
template="$script_dir/../templates/workspace"

if [ ! -d "$template" ]; then
  echo "ERROR: template not found: $template" >&2
  exit 1
fi

# Expand a leading ~ (the skill may pass it literally).
case $target in
  "~") target=$HOME ;;
  "~/"*) target="$HOME/${target#\~/}" ;;
  "~\\"*) target="$HOME/${target#\~\\}" ;;
esac

case $target in
  /*) ;;
  [A-Za-z]:\\*|[A-Za-z]:/*)
    echo "ERROR: a Windows path ($target) only works on Windows (in Git Bash)." >&2
    exit 1
    ;;
  *) target="$PWD/$target" ;;
esac

if [ -e "$target" ] && [ ! -d "$target" ]; then
  echo "ERROR: the given path exists but is not a folder: $target" >&2
  exit 1
fi

mkdir -p "$target" || { echo "ERROR: could not create: $target" >&2; exit 1; }
target=$(cd "$target" && pwd)
shown=$(to_config_path "$target")

created=0
skipped=0
created_list=""
skipped_list=""
repl=$(printf '%s' "$name" | sed -e 's/[\\&|]/\\&/g')

# Walk the template (hidden files included), copy only what is missing.
while IFS= read -r -d '' src; do
  rel=${src#"$template"/}
  dst="$target/$rel"
  if [ -d "$src" ]; then
    mkdir -p "$dst"
    continue
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    skipped=$((skipped + 1))
    skipped_list="$skipped_list  - $rel"$'\n'
    continue
  fi
  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst" || { echo "ERROR: copy failed: $rel" >&2; exit 1; }
  created=$((created + 1))
  created_list="$created_list  - $rel"$'\n'
  if [ "$name" != "$DEFAULT_NAME" ] && grep -q "$DEFAULT_NAME" "$dst" 2>/dev/null; then
    sed_inplace -e "s|$DEFAULT_NAME|$repl|g" "$dst" \
      || { echo "ERROR: name replacement failed: $rel" >&2; exit 1; }
  fi
done < <(find "$template" -mindepth 1 ! -name '.DS_Store' -print0)

mkdir -p "$data_dir" || { echo "ERROR: could not create: $data_dir" >&2; exit 1; }
printf 'workspace=%s\n' "$shown" > "$data_dir/config" \
  || { echo "ERROR: config is not writable: $data_dir/config" >&2; exit 1; }

echo "Workspace: $shown"
echo "Config: $(to_config_path "$data_dir")/config"
echo "Main agent name (in new files): $name"
echo "New files: $created"
[ -n "$created_list" ] && printf '%s' "$created_list"
echo "Already existed, left untouched: $skipped"
[ -n "$skipped_list" ] && printf '%s' "$skipped_list"

# Own agents from before 0.2.0 lived under Team/<Department>/ with a symlink
# in ~/.claude/agents/. Report them so the skill can offer the move.
legacy=""
while IFS= read -r -d '' f; do
  if is_agent_file "$f"; then legacy=$f; break; fi
done < <(find "$target/Team" -mindepth 2 -maxdepth 2 -type f -name '*.md' -print0 2>/dev/null)
if [ -n "$legacy" ]; then
  echo "Own teammates in the old location: found in subfolders of Team/ (can be moved: migrate-agents.sh)."
fi

if [ -d "$target/.git" ]; then
  echo "Git: already a git repository."
else
  echo "Git: not a git repository yet."
fi
exit 0
