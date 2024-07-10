#!/bin/zsh

# This will become a way to hint to myself that dependences are
# missing, and provide quick instructions for installing them.
# 
# Expected usage: add to the end of `~/.zshrc`:
# 
# ```zsh
# source ~/.bin/_check_dependencies.zsh
# ```

colors >/dev/null 2>&1 || :

FIRST_MESSAGE="${fg[reg]}warning${fg[yellow]}: you have missing dependencies!${reset_color}"
unset SOME_WERE_MISSING

# Print a warning message about a missing dependency
#
# Usage:
# ```sh
# missing_dependency <command> [hint]
# ```
#
# `<command>`    the missing command (eg 'nodenv')
#    `[hint]`    a hint on how to resolve the missing dependency
#                (eg 'brew install nodenv')
#
function missing_dependency() {
  local HINT
  local MESSAGE
  MESSAGE="missing command ${1}"
  HINT="${fg_bold[green]}hint${reset_color}: ${fg_bold[white]}${2}${reset_color}"
  if [ -n "${2}" ]; then
    MESSAGE="${MESSAGE} (${HINT})"
  fi
  if [ -n "${FIRST_MESSAGE}" ]; then
    echo >&2
    echo "  ${FIRST_MESSAGE}" >&2
  fi
  unset FIRST_MESSAGE
  echo "    ${MESSAGE}" >&2
  SOME_WERE_MISSING=true
}

if ! command -v brew >/dev/null 2>&1; then
  missing_dependency brew 'https://brew.sh'
fi

if ! command -v nodenv >/dev/null 2>&1; then
  missing_dependency nodenv '`brew install nodenv`'
fi

if ! nodenv commands | grep -qs '^alias$' >/dev/null; then
  missing_dependency 'nodenv alias' 'brew tap nodenv/nodenv && brew install nodenv-aliases'
fi

if [ -n "${SOME_WERE_MISSING}" ]; then
  echo >&2
  echo >&2
fi

