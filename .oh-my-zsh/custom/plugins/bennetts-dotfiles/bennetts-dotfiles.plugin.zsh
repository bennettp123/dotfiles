#!/bin/zsh

SOURCE_DIR_RAW="$(dirname "${0}")/../../../.."
SOURCE_DIR="$( cd "${SOURCE_DIR}" && echo "${PWD}" )"

dotfiles_are_committed() {
  ( cd "${SOURCE_DIR}" && test -z "$(git status --porcelain)" )
}

changes_are_pushed() {
  ( cd "${SOURCE_DIR}" && test -z "$(git log HEAD --not --remotes)" )
}

DOTFILE_WARNING="${fg[red]}$(<<EOF
warning${reset_color}: there are uncommitted dotfiles at ${SOURCE_DIR}!
to suppress this warning, commit all modified dotfiles, or
run the commands below:
  ${fg_no_bold[white]}
  ( cd "${SOURCE_DIR}" && git commit . && git push )
  ${reset_color}
EOF
)"

warn_about_uncommitted_dotfiles() {
  if ! ( dotfiles_are_committed && changes_are_pushed ); then
    echo
    echo "${DOTFILE_WARNING}" | sed 's/^/  /'
    echo
  fi
}

if (( $precmd_functions[(Ie)warn_about_uncommitted_dotfiles] )); then
  precmd_functions[$precmd_functions[(Ie)warn_about_uncommitted_dotfiles]]=()
fi

precmd_functions+=(warn_about_uncommitted_dotfiles)

