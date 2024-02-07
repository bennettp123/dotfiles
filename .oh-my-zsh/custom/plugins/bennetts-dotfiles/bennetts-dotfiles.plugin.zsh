#!/bin/zsh

commit_and_push_dotfiles() {
  (
    set -e -o pipefail
    load_dotfiles_settings_dfa259
    cd "${DOTFILES_SOURCE}"
    git add .
    git commit
    git push
  )
}

install_dotfiles() {
  (
    set -e -o pipefail
    load_dotfiles_settings_dfa259
    stow "${DOTFILES_SOURCE}" -t "${DOTFILES_TARGET}"
  )
}

load_dotfiles_settings_dfa259() {
  if test -r "${BENNETTS_DOTFILES_CONFIG:-"${HOME}/.bennetts-dotfiles.config"}"; then
    source "${BENNETTS_DOTFILES_CONFIG:-"${HOME}/.bennetts-dotfiles.config"}"
  fi
  DOTFILES_SOURCE="${DOTFILES_SOURCE:-"${HOME}/.dotfiles"}"
  DOTFILES_TARGET="${DOTFILES_TARGET:-"${HOME}"}"
}

dotfiles_are_committed_867a65() {
  (
    set -e -o pipefail
    load_dotfiles_settings_dfa259
    cd "${DOTFILES_SOURCE}"
    test -z "$(git status --porcelain)"
  )
}

changes_are_pushed_d2faff() {
  (
    set -e -o pipefail
    load_dotfiles_settings_dfa259
    cd "${DOTFILES_SOURCE}"
    test -z "$(git log HEAD --not --remotes)"
  )
}

warn_about_uncommitted_dotfiles_dc75e1() {
  (
    set -e -o pipefail
    load_dotfiles_settings_dfa259
    test -d "${DOTFILES_SOURCE}" || exit 0
    WARNING="$(<<EOF_7f55d7
      ${fg[red]}
      warning${reset_color}: there are uncommitted dotfiles
      in ${DOTFILES_SOURCE}! to suppress this warning, commit
      and push all modified dotfiles, or run the command below:

      ${fg_no_bold[white]}
        commit_and_push_dotfiles
      ${reset_color}
EOF_7f55d7
    )"
    if ! ( dotfiles_are_committed_867a65 && changes_are_pushed_d2faff ); then
      echo
      echo "  ${fg_no_bold[white]}----------${reset_color}"
      echo "${WARNING}" | sed 's/^  //'
      echo
      echo "  ${fg_no_bold[white]}----------${reset_color}"
      echo
    fi
  )
}

if (( $precmd_functions[(Ie)warn_about_uncommitted_dotfiles] )); then
  precmd_functions[$precmd_functions[(Ie)warn_about_uncommitted_dotfiles]]=()
fi

if (( $precmd_functions[(Ie)warn_about_uncommitted_dotfiles_dc75e1] )); then
  precmd_functions[$precmd_functions[(Ie)warn_about_uncommitted_dotfiles_dc75e1]]=()
fi

precmd_functions+=(warn_about_uncommitted_dotfiles_dc75e1)

