#!/bin/bash
# Claude Code starter kit: one-line macOS installer (bootstrap).
#
#   curl -fsSL https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-mac.sh | bash
#
# English edition:
#   curl -fsSL https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-mac.sh | bash -s -- --english
#
# The real installer (mac/installer.sh) is downloaded to a temporary file and
# run from there with stdin redirected from /dev/null: under "curl | bash"
# stdin is this very script, and anything reading stdin would eat it. The
# installer asks its questions on /dev/tty instead. When this file is run
# from a clone (bash install-mac.sh), the sibling mac/installer.sh is used
# instead of downloading.
#
# Everything is inside main(), called on the last line, so a download cut
# off halfway runs nothing at all.
#
# Must work with the bash 3.2 that ships with macOS.
#
# RELEASE: the installer is downloaded from the git tag in RELEASE_REF below,
# not from the moving main branch. Every release must bump this constant AND
# $ReleaseRef in install-windows.ps1 (and create the tag) together with the
# plugin versions; see CHANGELOG.md.
#
# STARTER_KIT_REF (environment variable) overrides the ref for testing a
# branch; a yellow warning is printed when it is set. STARTER_KIT_SOURCE is
# passed through to the installer (alternative marketplace source).

RELEASE_REF='v0.2.1'

main() {
  local english='' arg ref url here local_installer tmp rc
  local fail_msg test_msg yellow='' red='' reset=''

  for arg in "$@"; do
    case $arg in
      --english|-English|-english|--en) english=1 ;;
    esac
  done

  ref=${STARTER_KIT_REF:-$RELEASE_REF}
  url="https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/$ref/mac/installer.sh"

  if [ -t 1 ]; then
    yellow=$'\033[33m'
    red=$'\033[31m'
    reset=$'\033[0m'
  fi
  if [ -n "$english" ]; then
    fail_msg='Could not download the installer. Check the internet connection and try again in a few minutes.'
    test_msg='Test source (installer): '
  else
    fail_msg='Nem sikerült letölteni a telepítőt. Ellenőrizd az internetkapcsolatot, és próbáld újra pár perc múlva.'
    test_msg='Teszt forrás (telepítő): '
  fi

  # Run from a clone: use the sibling installer. Under "curl | bash" there is
  # no script file, so BASH_SOURCE is empty and this is skipped.
  here=${BASH_SOURCE[0]:-}
  local_installer=''
  if [ -n "$here" ] && [ -f "$here" ]; then
    local_installer="$(cd "$(dirname "$here")" && pwd)/mac/installer.sh"
    [ -f "$local_installer" ] || local_installer=''
  fi

  if [ -n "$local_installer" ]; then
    tmp=$local_installer
  else
    if [ -n "${STARTER_KIT_REF:-}" ]; then
      printf '%s%s%s%s\n' "$yellow" "$test_msg" "$url" "$reset"
    fi
    tmp=$(mktemp -t starter-kit-installer) || { printf '%s%s%s\n' "$red" "$fail_msg" "$reset"; exit 1; }
    if ! curl -fsSL "$url" -o "$tmp" </dev/null; then
      rm -f "$tmp"
      printf '%s%s%s\n' "$red" "$fail_msg" "$reset"
      exit 1
    fi
  fi

  if [ -n "$english" ]; then
    /bin/bash "$tmp" --ref "$ref" --english </dev/null
  else
    /bin/bash "$tmp" --ref "$ref" </dev/null
  fi
  rc=$?
  [ "$tmp" = "$local_installer" ] || rm -f "$tmp"
  exit "$rc"
}

main "$@"
