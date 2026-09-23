#!/usr/bin/env bash
# starter-kit SessionStart hook.
#
# Writes a short Hungarian context note for the model as SessionStart JSON:
#   (a) no configured workspace   -> suggest /starter-kit:setup
#   (b) workspace, profile empty  -> "Munkaterület: <path>" + suggest /starter-kit:onboard
#   (c) workspace ready           -> "Munkaterület: <path>" (+ pointer to CLAUDE.md if cwd differs)
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
    msg="A starter-kit plugin telepítve van, de még nincs beállított munkaterület."
    if [ -n "$workspace" ]; then
      msg="$msg (A korábban beállított mappa nem található: $workspace)"
    fi
    msg="$msg Az első érdemi válaszodban egy rövid mondatban ajánld fel a /starter-kit:setup futtatását, ami létrehozza a munkaterületet."
  else
    msg="Munkaterület: $workspace"
    local profile="$workspace/About Me/rolam.md"
    if [ ! -f "$profile" ] || grep -q 'Utolsó frissítés: —' "$profile" 2>/dev/null; then
      # State (b)
      msg="$msg"$'\n'"A tulajdonos profilja (About Me/rolam.md) még nincs kitöltve. Az első érdemi válaszodban egy rövid mondatban ajánld fel a /starter-kit:onboard futtatását."
    fi
    local here ws_real
    here=$(resolve_dir "${CLAUDE_PROJECT_DIR:-$PWD}")
    ws_real=$(resolve_dir "$workspace")
    if [ -n "$ws_real" ] && [ "$here" != "$ws_real" ]; then
      msg="$msg"$'\n'"A session nem a munkaterületből indult: a fő-agent szabályai a $workspace/CLAUDE.md fájlban vannak."
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
