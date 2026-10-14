#!/bin/bash
# Claude Code starter kit: macOS installer (main part).
#
# Normally started by ../install-mac.sh (the one-line bootstrap), which
# downloads this file and runs it with stdin redirected from /dev/null. It can
# also be run on its own: bash mac/installer.sh [--english]
#
# Must work with the bash 3.2 that ships with macOS: no associative arrays,
# no ${var,,}, no mapfile.
#
# Questions are asked on /dev/tty, never on stdin (under "curl | bash" stdin
# is the bootstrap script itself). Every claude/git call gets </dev/null for
# the same reason. Without a terminal (no /dev/tty) the defaults are used
# without asking.
#
# Steps (each is skipped when already done, so re-running is safe):
#   1. macOS 13 or newer
#   2. Xcode Command Line Tools (git). Needed both for "git init" and for
#      "claude plugin marketplace add owner/repo", which clones with git
#      (measured: without git on PATH the add fails with ENOENT). When
#      missing, the system installer window is opened and the run stops;
#      the user re-runs the same command afterwards.
#   3. Claude Code; installed with the official install.sh when missing
#   4. Marketplace + plugin via the claude CLI (no login needed for this)
#   5. Workspace via the plugin's scripts/setup-workspace.sh
#
# --ref is the release ref the bootstrap downloaded this file from (shown in
# the title only). The marketplace itself is added WITHOUT a ref on purpose:
# a marketplace added as owner/repo#<tag> stays on that tag for good
# ("claude plugin marketplace update" never leaves it, and re-adding with a
# newer ref does not change it), so users would never get later releases.
# Unpinned, it follows the default branch, which only receives releases.
# Contract with the plugin that therefore must stay compatible across
# releases: scripts/setup-workspace.sh <data-dir> <path> [name], and the data
# dir name <plugin>-claude-starter-kit.
#
# Test overrides (each prints a yellow warning): STARTER_KIT_REF adds the
# marketplace at that branch (it then stays there until
# "claude plugin marketplace remove claude-starter-kit"), STARTER_KIT_SOURCE
# replaces the marketplace source (e.g. a local clone).

set -u

REPO='outlookonenote/claude-starter-kit'
MARKETPLACE='claude-starter-kit'

english=''
ref=''
while [ $# -gt 0 ]; do
  case $1 in
    --english|-English|-english|--en) english=1 ;;
    --ref) shift; ref=${1:-} ;;
  esac
  [ $# -gt 0 ] && shift
done

if [ -n "$english" ]; then
  PLUGIN='starter-kit-en'
  OTHER_PLUGIN='starter-kit'
  DEFAULT_NAME='Max'
  DEFAULT_FOLDER='Workspace'
else
  PLUGIN='starter-kit'
  OTHER_PLUGIN='starter-kit-en'
  DEFAULT_NAME='Máté'
  DEFAULT_FOLDER='Munkaterulet'
fi
PLUGIN_ID="$PLUGIN@$MARKETPLACE"

# --- Messages ---------------------------------------------------------------
# %s marks where a value goes (printf).

if [ -n "$english" ]; then
  M_TITLE='Claude Code starter kit installer (macOS)'
  M_TEST_SOURCE='Test source (marketplace): %s. Not for regular use; afterwards: claude plugin marketplace remove claude-starter-kit'
  M_MIGRATE_HINT='Your own teammates from the earlier version are still in the old location: start claude in the workspace and run /starter-kit-en:setup, which offers to move them.'
  M_LINUX='This installer is for macOS. On Linux, follow the README.'
  M_NOT_MAC='This installer is for macOS. On Windows use install-windows.ps1, elsewhere follow the README.'
  M_OLD_MAC='Claude Code needs macOS 13 (Ventura) or newer, this Mac has %s. Update macOS, then run this installer again.'
  M_STEP1='[1/5] Checking macOS'
  M_STEP2='[2/5] Command Line Tools (git)'
  M_STEP3='[3/5] Claude Code'
  M_STEP4='[4/5] The starter kit plugin'
  M_STEP5='[5/5] The workspace'
  M_MAC_OK='macOS %s: OK'
  M_GIT_FOUND='git found: %s'
  M_CLT_MISSING='The Xcode Command Line Tools (which include git) are missing. A system window has opened: click Install, wait until it finishes (a few minutes), then run the same command again.'
  M_CLT_NO_WINDOW='The Xcode Command Line Tools (which include git) are missing. Run this in Terminal: xcode-select --install, click Install in the window that opens, wait until it finishes, then run this installer again.'
  M_CLAUDE_FOUND='Claude Code found: %s'
  M_CLAUDE_INSTALLING='Claude Code is missing, installing it with the official installer now (no administrator password needed).'
  M_CLAUDE_FAILED='Installing Claude Code did not succeed. Try it by hand: curl -fsSL https://claude.ai/install.sh | bash, then run this installer again.'
  M_CLAUDE_NOT_FOUND='Claude Code was installed, but I cannot find it. Open a new Terminal window and run this installer again.'
  M_MP_PRESENT='The marketplace is already added.'
  M_MP_ADDING='Adding the marketplace: %s'
  M_MP_FAILED='Adding the marketplace did not succeed. Check the internet connection, then run this installer again.'
  M_PLUGIN_PRESENT='The plugin is already installed (%s), checking for updates.'
  M_PLUGIN_INSTALLING='Installing the plugin: %s'
  M_PLUGIN_FAILED='Installing the plugin did not succeed. Run this installer again; if it fails again, see the troubleshooting section of the README.'
  M_PLUGIN_ENABLED='The plugin was disabled; I enabled it.'
  M_PLUGIN_NO_PATH='The plugin is installed, but I cannot find its folder. Start claude in the workspace folder and run /starter-kit-en:setup there.'
  M_BOTH_EDITIONS='Note: the Hungarian edition (starter-kit) is installed too. One is enough; you can disable the other in claude with the /plugin menu.'
  M_WS_EXISTING='A workspace is already set up: %s. Missing template files will be added, existing files are left alone.'
  M_ASK_NAME='What should the main agent be called? (Enter = %s) '
  M_NO_TTY='No terminal to ask questions on, so I am using the defaults.'
  M_WS_CREATING='Creating the workspace: %s'
  M_WS_FAILED='Creating the workspace did not succeed (details above). Run this installer again, or start claude and run /starter-kit-en:setup.'
  M_NAME_WARN='Note: the main agent name did not make it into CLAUDE.md. After starting claude, ask the main agent to put its name into CLAUDE.md.'
  M_ASK_GIT='Put the workspace under version control (git)? It lets you go back to earlier versions of your notes and rules. (Y/n) '
  M_GIT_INIT_DONE='The workspace is now a git repository.'
  M_GIT_INIT_FAILED='git init did not succeed; you can run it later in the workspace folder.'
  M_GIT_ALREADY='The workspace is already a git repository.'
  M_DONE='Done. What happened:'
  M_DONE_GIT='  - git: %s'
  M_DONE_CLAUDE='  - Claude Code: %s'
  M_DONE_PLUGIN='  - Plugin: %s'
  M_DONE_WS='  - Workspace: %s (main agent: %s)'
  M_NEXT='How to start (this window works too):'
  M_NEXT_NEW_WINDOW='How to start: open a NEW Terminal window (this one does not know the claude command yet), then:'
  M_NEXT1='  1. %s'
  M_NEXT2='  2. claude'
  M_NEXT3='  3. Log in with your Claude account in the browser that opens (a paid plan is needed).'
  M_NEXT4='  4. When asked whether you trust this folder, answer Yes.'
  M_NEXT5='  5. Type: %s'
  M_PATH_ADDED='The official installer does not put ~/.local/bin on the PATH, so I added it in %s (applies to new Terminal windows).'
  M_NEXT_NO_PATH='The claude command is not on the PATH of your terminal. Start it with its full path: %s, or add %s to the PATH.'
  YES_WORDS=' y yes '
else
  M_TITLE='Claude Code starter kit telepítő (macOS)'
  M_TEST_SOURCE='Teszt forrás (marketplace): %s. Nem rendes használatra; utána: claude plugin marketplace remove claude-starter-kit'
  M_MIGRATE_HINT='A korábbi verzióval felvett saját kollégáid még a régi helyükön vannak: indítsd el a claude-ot a munkaterületen, és add ki a /starter-kit:setup parancsot, ami felajánlja az áthelyezésüket.'
  M_LINUX='Ez a telepítő macOS-re készült. Linuxon a README leírását kövesd.'
  M_NOT_MAC='Ez a telepítő macOS-re készült. Windowson az install-windows.ps1 telepítőt használd, máshol a README leírását kövesd.'
  M_OLD_MAC='A Claude Code-hoz macOS 13 (Ventura) vagy újabb kell, ezen a gépen %s van. Frissítsd a macOS-t, majd futtasd újra ezt a telepítőt.'
  M_STEP1='[1/5] macOS ellenőrzése'
  M_STEP2='[2/5] Command Line Tools (git)'
  M_STEP3='[3/5] Claude Code'
  M_STEP4='[4/5] A starter kit plugin'
  M_STEP5='[5/5] A munkaterület'
  M_MAC_OK='macOS %s: rendben'
  M_GIT_FOUND='git megvan: %s'
  M_CLT_MISSING='Hiányzik az Xcode Command Line Tools (ebben van a git). Megnyílt egy rendszerablak: kattints a Telepítés (Install) gombra, várd meg, amíg végez (pár perc), majd futtasd újra ugyanazt a parancsot.'
  M_CLT_NO_WINDOW='Hiányzik az Xcode Command Line Tools (ebben van a git). Írd be a Terminálba: xcode-select --install, a megnyíló ablakban kattints a Telepítés (Install) gombra, várd meg, amíg végez, majd futtasd újra ezt a telepítőt.'
  M_CLAUDE_FOUND='Claude Code megvan: %s'
  M_CLAUDE_INSTALLING='A Claude Code hiányzik, most telepítem a hivatalos telepítővel (rendszergazdai jelszó nem kell).'
  M_CLAUDE_FAILED='A Claude Code telepítése nem sikerült. Próbáld kézzel: curl -fsSL https://claude.ai/install.sh | bash, majd futtasd újra ezt a telepítőt.'
  M_CLAUDE_NOT_FOUND='A Claude Code települt, de nem találom. Nyiss új Terminál-ablakot, és futtasd újra ezt a telepítőt.'
  M_MP_PRESENT='A marketplace már fel van véve.'
  M_MP_ADDING='Marketplace felvétele: %s'
  M_MP_FAILED='A marketplace felvétele nem sikerült. Ellenőrizd az internetkapcsolatot, majd futtasd újra ezt a telepítőt.'
  M_PLUGIN_PRESENT='A plugin már telepítve van (%s), frissítést keresek.'
  M_PLUGIN_INSTALLING='Plugin telepítése: %s'
  M_PLUGIN_FAILED='A plugin telepítése nem sikerült. Futtasd újra ezt a telepítőt; ha ismét hibát kapsz, nézd meg a README hibaelhárítás részét.'
  M_PLUGIN_ENABLED='A plugin ki volt kapcsolva, bekapcsoltam.'
  M_PLUGIN_NO_PATH='A plugin telepítve van, de a mappáját nem találom. Indítsd el a claude-ot a munkaterület mappájában, és ott add ki a /starter-kit:setup parancsot.'
  M_BOTH_EDITIONS='Megjegyzés: az angol kiadás (starter-kit-en) is telepítve van. Elég az egyik; a másikat a claude-ban a /plugin menüben kapcsolhatod ki.'
  M_WS_EXISTING='Már van beállított munkaterület: %s. A hiányzó sablonfájlokat pótolom, a meglévőkhöz nem nyúlok.'
  M_ASK_NAME='Mi legyen a fő-agent neve? (Enter = %s) '
  M_NO_TTY='Nincs terminál, ahol kérdezhetnék, ezért az alapértelmezéseket használom.'
  M_WS_CREATING='Munkaterület létrehozása: %s'
  M_WS_FAILED='A munkaterület létrehozása nem sikerült (a részletek fent). Futtasd újra ezt a telepítőt, vagy indítsd el a claude-ot, és add ki a /starter-kit:setup parancsot.'
  M_NAME_WARN='Figyelem: a fő-agent neve nem került be a CLAUDE.md fájlba. A claude indítása után kérd meg a fő-agentet, hogy írja be a nevét a CLAUDE.md fájlba.'
  M_ASK_GIT='Legyen verziókövetés (git) a munkaterületen? Így a jegyzeteid és szabályaid korábbi állapota is visszanézhető. (I/n) '
  M_GIT_INIT_DONE='A munkaterület mostantól git repó.'
  M_GIT_INIT_FAILED='A git init nem sikerült; később a munkaterület mappájában pótolhatod.'
  M_GIT_ALREADY='A munkaterület már git repó.'
  M_DONE='Kész. Ami megtörtént:'
  M_DONE_GIT='  - git: %s'
  M_DONE_CLAUDE='  - Claude Code: %s'
  M_DONE_PLUGIN='  - Plugin: %s'
  M_DONE_WS='  - Munkaterület: %s (fő-agent: %s)'
  M_NEXT='Így indulj (ebben az ablakban is mehet):'
  M_NEXT_NEW_WINDOW='Így indulj: nyiss ÚJ Terminál-ablakot (ez az ablak még nem ismeri a claude parancsot), majd:'
  M_NEXT1='  1. %s'
  M_NEXT2='  2. claude'
  M_NEXT3='  3. A megnyíló böngészőben jelentkezz be a Claude-fiókoddal (fizetős előfizetés kell).'
  M_NEXT4='  4. Arra a kérdésre, hogy megbízol-e ebben a mappában, válaszolj igennel (Yes).'
  M_NEXT5='  5. Írd be: %s'
  M_PATH_ADDED='A hivatalos telepítő nem veszi fel a ~/.local/bin mappát a PATH-ra, ezért felvettem a %s fájlban (az új Terminál-ablakokban érvényes).'
  M_NEXT_NO_PATH='A claude parancs nincs a terminálod PATH-ján. Indítsd a teljes útjával: %s, vagy vedd fel a %s mappát a PATH-ra.'
  YES_WORDS=' i igen y yes '
fi

# --- Output helpers -----------------------------------------------------------

if [ -t 1 ]; then
  C_CYAN=$'\033[36m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_RESET=$'\033[0m'
else
  C_CYAN='' C_GREEN='' C_YELLOW='' C_RED='' C_RESET=''
fi

# say <color> <format> [values...]
say() {
  local color=$1 format=$2
  shift 2
  # shellcheck disable=SC2059  # the format comes from the message table above
  printf "%s$format%s\n" "$color" "$@" "$C_RESET"
}

step() {
  printf '\n'
  say "$C_CYAN" "$1"
}

info() {
  local format=$1
  shift
  say '' "  $format" "$@"
}

# A failure we expect and explain in one sentence; ends the run.
stop_installer() {
  local format=$1
  shift
  printf '\n'
  say "$C_RED" "$format" "$@"
  exit 1
}

# True when /dev/tty can actually be opened (it exists even when the process
# has no controlling terminal, then opening it fails).
have_tty() {
  ( exec </dev/tty >/dev/tty ) 2>/dev/null
}

# ask <prompt> -> the answer on stdout (empty when there is no terminal).
ask() {
  local answer=''
  printf '  %s' "$1" >/dev/tty
  IFS= read -r answer </dev/tty || answer=''
  printf '%s' "$answer"
}

is_yes() {
  local a
  a=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  [ -z "$a" ] && return 0
  case $YES_WORDS in
    *" $a "*) return 0 ;;
  esac
  return 1
}

# --- JSON (claude ... --json) -----------------------------------------------
# macOS has no jq by default; JavaScript for Automation (osascript) is always
# there. Anything printed before the JSON itself is skipped.

# json_query <json> <mode> <arg>
#   mode "has-name": prints 1 if an element has name == arg
#   mode "plugin":   prints "version<TAB>enabled<TAB>installPath" of id == arg
json_query() {
  osascript -l JavaScript -e '
    function run(argv) {
      var text = argv[0], mode = argv[1], key = argv[2];
      var start = text.search(/[\[{]/);
      if (start < 0) return "";
      var data;
      try { data = JSON.parse(text.slice(start)); } catch (e) { return ""; }
      if (!Array.isArray(data)) return "";
      for (var i = 0; i < data.length; i++) {
        var item = data[i];
        if (!item) continue;
        if (mode === "has-name" && item.name === key) return "1";
        if (mode === "plugin" && item.id === key) {
          return [item.version || "?", item.enabled === false ? "false" : "true", item.installPath || ""].join("\t");
        }
      }
      return "";
    }' "$1" "$2" "$3" 2>/dev/null </dev/null
}

# --- Steps ------------------------------------------------------------------

check_macos() {
  local version major
  step "$M_STEP1"
  case $(uname -s) in
    Darwin) ;;
    Linux) stop_installer "$M_LINUX" ;;
    *) stop_installer "$M_NOT_MAC" ;;
  esac
  version=$(sw_vers -productVersion 2>/dev/null)
  major=${version%%.*}
  case $major in
    ''|*[!0-9]*) major=0 ;;
  esac
  if [ "$major" -lt 13 ]; then
    stop_installer "$M_OLD_MAC" "${version:-?}"
  fi
  info "$M_MAC_OK" "$version"
}

# On a Mac without the Command Line Tools, /usr/bin/git is only a stub that
# opens the installer window, so it is never run before xcode-select -p
# says the tools are there. A git elsewhere (e.g. Homebrew) is fine as is.
ensure_git() {
  local git_path
  step "$M_STEP2"
  git_path=$(command -v git 2>/dev/null)
  if xcode-select -p >/dev/null 2>&1 </dev/null; then
    if [ -n "$git_path" ] && git --version >/dev/null 2>&1 </dev/null; then
      GIT=$git_path
      info "$M_GIT_FOUND" "$GIT"
      return
    fi
  elif [ -n "$git_path" ] && [ "$git_path" != /usr/bin/git ]; then
    if git --version >/dev/null 2>&1 </dev/null; then
      GIT=$git_path
      info "$M_GIT_FOUND" "$GIT"
      return
    fi
  fi
  # Opens the system window and returns at once; fails when it cannot.
  if xcode-select --install >/dev/null 2>&1 </dev/null; then
    stop_installer "$M_CLT_MISSING"
  fi
  stop_installer "$M_CLT_NO_WINDOW"
}

find_claude() {
  if [ -x "$HOME/.local/bin/claude" ]; then
    printf '%s' "$HOME/.local/bin/claude"
    return
  fi
  command -v claude 2>/dev/null
}

ensure_claude() {
  local tmp rc version
  step "$M_STEP3"
  CLAUDE=$(find_claude)
  if [ -z "$CLAUDE" ]; then
    info "$M_CLAUDE_INSTALLING"
    # Downloaded to a file and run with stdin from /dev/null, so it cannot
    # read anything from our stdin.
    rc=1
    tmp=$(mktemp -t claude-install) || stop_installer "$M_CLAUDE_FAILED"
    if curl -fsSL https://claude.ai/install.sh -o "$tmp" </dev/null; then
      /bin/bash "$tmp" </dev/null
      rc=$?
    fi
    rm -f "$tmp"
    # The official installer puts the launcher into ~/.local/bin.
    case ":$PATH:" in
      *":$HOME/.local/bin:"*) ;;
      *) PATH="$HOME/.local/bin:$PATH"; export PATH ;;
    esac
    hash -r
    CLAUDE=$(find_claude)
    if [ -z "$CLAUDE" ]; then
      [ "$rc" -ne 0 ] && stop_installer "$M_CLAUDE_FAILED"
      stop_installer "$M_CLAUDE_NOT_FOUND"
    fi
  fi
  version=$("$CLAUDE" --version 2>/dev/null </dev/null | head -n 1)
  if [ -n "$version" ]; then
    info "$M_CLAUDE_FOUND" "$CLAUDE ($version)"
  else
    info "$M_CLAUDE_FOUND" "$CLAUDE"
  fi
  ensure_on_path
}

# The official installer only prints a hint when ~/.local/bin is not on the
# PATH (measured with 2.1.x: it does not touch the shell startup files), so a
# fresh Mac would not find "claude" in any Terminal window. Add the line it
# suggests, once, to the startup file of the user's login shell. Appending
# only; nothing in the file is changed.
ensure_on_path() {
  local profile f
  [ "$CLAUDE" = "$HOME/.local/bin/claude" ] || return 0
  [ -z "$(PATH=$ORIGINAL_PATH command -v claude 2>/dev/null)" ] || return 0
  shell_profile_has "$HOME/.local/bin" && return 0
  case $(basename "${SHELL:-/bin/zsh}") in
    zsh) profile="$HOME/.zshrc" ;;
    bash)
      # A bash login shell reads only the first of these that exists; creating
      # .bash_profile next to an existing .bash_login/.profile would hide it.
      profile="$HOME/.bash_profile"
      for f in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile"; do
        if [ -f "$f" ]; then profile=$f; break; fi
      done
      ;;
    *) return 0 ;;
  esac
  # shellcheck disable=SC2016  # written literally, expanded by the shell later
  if printf '\n# Claude Code (added by the starter kit installer)\nexport PATH="$HOME/.local/bin:$PATH"\n' >>"$profile"; then
    info "$M_PATH_ADDED" "$(tilde_path "$profile")"
  fi
}

# ~/... form of a path inside the home folder, for messages.
tilde_path() {
  local tilde='~'
  case $1 in
    "$HOME"/*) printf '%s/%s' "$tilde" "${1#"$HOME"/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

marketplace_source() {
  if [ -n "${STARTER_KIT_SOURCE:-}" ]; then
    printf '%s' "$STARTER_KIT_SOURCE"
  elif [ -n "${STARTER_KIT_REF:-}" ]; then
    printf '%s#%s' "$REPO" "$STARTER_KIT_REF"
  else
    printf '%s' "$REPO"
  fi
}

plugin_list_json() {
  "$CLAUDE" plugin list --json 2>/dev/null </dev/null
}

install_plugin() {
  local source known plugins mine other version enabled
  step "$M_STEP4"

  # Marketplace: unpinned (see the header for why); test overrides only.
  source=$(marketplace_source)
  known=$("$CLAUDE" plugin marketplace list --json 2>/dev/null </dev/null)
  if [ "$(json_query "$known" has-name "$MARKETPLACE")" = 1 ]; then
    info "$M_MP_PRESENT"
    "$CLAUDE" plugin marketplace update "$MARKETPLACE" </dev/null
  else
    info "$M_MP_ADDING" "$source"
    "$CLAUDE" plugin marketplace add "$source" </dev/null || stop_installer "$M_MP_FAILED"
  fi

  # Plugin.
  plugins=$(plugin_list_json)
  mine=$(json_query "$plugins" plugin "$PLUGIN_ID")
  other=$(json_query "$plugins" plugin "$OTHER_PLUGIN@$MARKETPLACE")
  if [ -n "$mine" ]; then
    version=$(printf '%s' "$mine" | cut -f 1)
    enabled=$(printf '%s' "$mine" | cut -f 2)
    info "$M_PLUGIN_PRESENT" "$version"
    "$CLAUDE" plugin update "$PLUGIN_ID" </dev/null
    if [ "$enabled" = false ]; then
      "$CLAUDE" plugin enable "$PLUGIN_ID" </dev/null
      info "$M_PLUGIN_ENABLED"
    fi
  else
    info "$M_PLUGIN_INSTALLING" "$PLUGIN_ID"
    "$CLAUDE" plugin install "$PLUGIN_ID" </dev/null || stop_installer "$M_PLUGIN_FAILED"
  fi
  [ -n "$other" ] && info "$M_BOTH_EDITIONS"

  # Where the installed copy lives (the update above may have moved it).
  PLUGIN_PATH=$(json_query "$(plugin_list_json)" plugin "$PLUGIN_ID" | cut -f 3)
  if [ -z "$PLUGIN_PATH" ] || [ ! -f "$PLUGIN_PATH/scripts/setup-workspace.sh" ]; then
    stop_installer "$M_PLUGIN_NO_PATH"
  fi
}

read_config_workspace() {
  [ -f "$1" ] || return 0
  sed -n 's/^workspace=//p' "$1" | head -n 1
}

create_workspace() {
  local config_dir data_dir config_file existing name answer output rc
  step "$M_STEP5"
  config_dir=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
  data_dir="$config_dir/plugins/data/$PLUGIN-$MARKETPLACE"
  config_file="$data_dir/config"

  existing=$(read_config_workspace "$config_file")
  name=$DEFAULT_NAME
  if [ -n "$existing" ] && [ -d "$existing" ]; then
    target=$existing
    info "$M_WS_EXISTING" "$target"
    WS_IS_NEW=''
  else
    existing=''
    target="$HOME/$DEFAULT_FOLDER"
    if have_tty; then
      # shellcheck disable=SC2059  # the format comes from the message table
      answer=$(ask "$(printf "$M_ASK_NAME" "$DEFAULT_NAME")")
      # Control characters and quotes are dropped, surrounding blanks trimmed.
      answer=$(printf '%s' "$answer" | tr -d '[:cntrl:]"' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
      [ -n "$answer" ] && name=$answer
    else
      info "$M_NO_TTY"
    fi
    info "$M_WS_CREATING" "$target"
    WS_IS_NEW=1
  fi

  # The default name is the script's own default, so it is not passed.
  if [ "$name" = "$DEFAULT_NAME" ]; then
    output=$(/bin/bash "$PLUGIN_PATH/scripts/setup-workspace.sh" "$data_dir" "$target" 2>&1 </dev/null)
  else
    output=$(/bin/bash "$PLUGIN_PATH/scripts/setup-workspace.sh" "$data_dir" "$target" "$name" 2>&1 </dev/null)
  fi
  rc=$?
  [ -n "$output" ] && printf '%s\n' "$output" | sed 's/^/    /'
  [ "$rc" -eq 0 ] || stop_installer "$M_WS_FAILED"

  WORKSPACE=$(read_config_workspace "$config_file")
  if [ -z "$WORKSPACE" ] || [ ! -d "$WORKSPACE" ]; then
    stop_installer "$M_WS_FAILED"
  fi
  WS_NAME=$name

  # Check that a non-default name made it into CLAUDE.md.
  if [ -z "$existing" ] && [ "$name" != "$DEFAULT_NAME" ] && [ -f "$WORKSPACE/CLAUDE.md" ]; then
    if ! grep -qF -- "$name" "$WORKSPACE/CLAUDE.md"; then
      say "$C_YELLOW" "  $M_NAME_WARN"
    fi
  fi

  # Offer git init (only once: skipped when the folder is already a repo).
  if [ -e "$WORKSPACE/.git" ]; then
    info "$M_GIT_ALREADY"
  else
    answer=''
    have_tty && answer=$(ask "$M_ASK_GIT")
    if is_yes "$answer"; then
      if "$GIT" -C "$WORKSPACE" init --quiet </dev/null >/dev/null 2>&1; then
        info "$M_GIT_INIT_DONE"
      else
        info "$M_GIT_INIT_FAILED"
      fi
    fi
  fi

  LEGACY_AGENTS=''
  case $output in
    *migrate-agents.sh*) LEGACY_AGENTS=1 ;;
  esac
}

# How to type the path in Terminal: ~/... when it is inside the home folder
# and needs no quoting, otherwise the full path in quotes.
cd_command() {
  local rel
  case $1 in
    "$HOME"/*)
      rel=${1#"$HOME"/}
      case $rel in
        *[!A-Za-z0-9._/-]*) printf 'cd "%s"' "$1" ;;
        *) printf 'cd ~/%s' "$rel" ;;
      esac
      ;;
    *) printf 'cd "%s"' "$1" ;;
  esac
}

write_summary() {
  local shown_name=$WS_NAME claude_dir found
  [ -n "$WS_IS_NEW" ] || shown_name='-'
  printf '\n'
  say "$C_GREEN" "$M_DONE"
  say '' "$M_DONE_GIT" "$GIT"
  say '' "$M_DONE_CLAUDE" "$CLAUDE"
  say '' "$M_DONE_PLUGIN" "$PLUGIN_ID"
  say '' "$M_DONE_WS" "$WORKSPACE" "$shown_name"
  [ -n "$LEGACY_AGENTS" ] && say "$C_YELLOW" "  $M_MIGRATE_HINT"
  printf '\n'

  # Does the user's own terminal find claude? This script runs in a child
  # process, so the PATH it extended above does not reach that terminal.
  claude_dir=$(dirname "$CLAUDE")
  found=$(PATH=$ORIGINAL_PATH command -v claude 2>/dev/null)
  if [ -n "$found" ]; then
    say "$C_GREEN" "$M_NEXT"
  elif shell_profile_has "$claude_dir"; then
    say "$C_GREEN" "$M_NEXT_NEW_WINDOW"
  else
    say "$C_YELLOW" "$M_NEXT_NO_PATH" "$CLAUDE" "$claude_dir"
    say "$C_GREEN" "$M_NEXT"
  fi
  say '' "$M_NEXT1" "$(cd_command "$WORKSPACE")"
  say '' "$M_NEXT2"
  say '' "$M_NEXT3"
  say '' "$M_NEXT4"
  say '' "$M_NEXT5" "/$PLUGIN:onboard"
}

# True if a shell startup file mentions the folder (or ~/.local/bin, the way
# the official installer writes it), i.e. a new Terminal window will find it.
shell_profile_has() {
  local f short lines tilde='~'
  short=$1
  case $1 in
    "$HOME"/*) short=${1#"$HOME"/} ;;
  esac
  for f in "$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.profile"; do
    [ -f "$f" ] || continue
    # Commented-out lines do not count.
    lines=$(grep -v '^[[:space:]]*#' "$f" 2>/dev/null)
    case $lines in
      *"$1"* | *"\$HOME/$short"* | *"$tilde/$short"*) return 0 ;;
    esac
  done
  return 1
}

# --- Main -------------------------------------------------------------------

ORIGINAL_PATH=$PATH
GIT=''
CLAUDE=''
PLUGIN_PATH=''
WORKSPACE=''
WS_NAME=''
WS_IS_NEW=''
LEGACY_AGENTS=''

title=$M_TITLE
[ -n "$ref" ] && title="$title, $ref"
say "$C_GREEN" "%s" "$title"
if [ -n "${STARTER_KIT_SOURCE:-}" ] || [ -n "${STARTER_KIT_REF:-}" ]; then
  say "$C_YELLOW" "$M_TEST_SOURCE" "$(marketplace_source)"
fi

check_macos
ensure_git
ensure_claude
install_plugin
create_workspace
write_summary
exit 0
