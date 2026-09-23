#!/usr/bin/env bash
# starter-kit-en workspace installer (called by the /starter-kit-en:setup skill).
#
# Usage: setup-workspace.sh <plugin-data-dir> <workspace-path> [main-agent-name]
#
# - Copies templates/workspace/ (including hidden .claude/) into <workspace-path>
#   WITHOUT overwriting any existing file. Safe to re-run (idempotent).
# - Replaces the default main-agent name "Max" with [main-agent-name], but only
#   in files created by this run (never touches files the user already has).
# - Writes "workspace=<absolute path>" into <plugin-data-dir>/config.
#
# Output is English, meant to be relayed to the user by the skill.

set -u

DEFAULT_NAME="Max"

if [ $# -lt 2 ]; then
  echo "Usage: setup-workspace.sh <plugin-data-dir> <workspace-path> [main-agent-name]" >&2
  exit 2
fi

data_dir=$1
target=$2
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
esac

case $target in
  /*) ;;
  *) target="$PWD/$target" ;;
esac

if [ -e "$target" ] && [ ! -d "$target" ]; then
  echo "ERROR: the given path exists but is not a folder: $target" >&2
  exit 1
fi

mkdir -p "$target" || { echo "ERROR: could not create: $target" >&2; exit 1; }
target=$(cd "$target" && pwd)

created=0
skipped=0
created_list=""
skipped_list=""

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
    # Escape sed replacement specials: backslash, ampersand, delimiter.
    repl=$(printf '%s' "$name" | sed -e 's/[\\&|]/\\&/g')
    sed -i '' -e "s|$DEFAULT_NAME|$repl|g" "$dst" 2>/dev/null \
      || sed -i -e "s|$DEFAULT_NAME|$repl|g" "$dst"
  fi
done < <(find "$template" -mindepth 1 ! -name '.DS_Store' -print0)

mkdir -p "$data_dir" || { echo "ERROR: could not create: $data_dir" >&2; exit 1; }
printf 'workspace=%s\n' "$target" > "$data_dir/config" \
  || { echo "ERROR: config is not writable: $data_dir/config" >&2; exit 1; }

echo "Workspace: $target"
echo "Config: $data_dir/config"
echo "Main agent name (in new files): $name"
echo "New files: $created"
[ -n "$created_list" ] && printf '%s' "$created_list"
echo "Already existed, left untouched: $skipped"
[ -n "$skipped_list" ] && printf '%s' "$skipped_list"
if [ -d "$target/.git" ]; then
  echo "Git: already a git repository."
else
  echo "Git: not a git repository yet."
fi
exit 0
