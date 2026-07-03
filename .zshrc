#!/bin/zsh

# To customize prompt, run `starship configure or edit ~/.config/starship.toml
eval "$(starship init zsh)"

# override some zinit/oh-my-zsh stuff
SHOW_AWS_PROMPT=false # disable OMZP::aws prompt (handled by starship)

# set the directory in which to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# download zinit, if it's not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# more tweaks
setopt globdots
autoload -U colors && colors

# load completions
autoload -U compinit && compinit

# replay cached completions
zinit cdreplay -q

# emacs keybindings
bindkey -e

# history
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# more completion tweaks
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color "$realpath"'

# shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# override terminal-notifier because it's slow for some reason
terminal-notifier () {
  # Run it in the background. Breaks $? but thems the breaks.
  ( "$(whence -p terminal-notifier)" "$@" & )
}

# add snippets
zinit snippet OMZP::git
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::bgnotify
zinit snippet OMZP::brew
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::colorize
zinit ice as"completion"; zinit snippet OMZP::docker/completions/_docker
zinit ice as"completion"; zinit snippet ~/.zsh-plugins/container/_container
zinit snippet ~/.zsh-plugins/bennetts-dotfiles/bennetts-dotfiles.plugin.zsh
if [ -r ~/.zsh-plugins/bennetts-private-dotfiles/bennetts-private-dotfiles.plugin.zsh ]; then
  zinit snippet ~/.zsh-plugins/bennetts-private-dotfiles/bennetts-private-dotfiles.plugin.zsh
fi

function _az2aws() {
  ## todo use [mise](https://mise.jdx.dev) instead?
  ( set -e
    nodenv shell 24
    if ! nodenv exec npm ls -g az2aws >/dev/null 2>&1; then
      echo 'installing az2aws...' >&2
        npm install -g az2aws >&2
    fi
    AWS_PROFILE=aad nodenv exec az2aws "${@:---no-prompt}"
  )
}

# custom aliases
alias aws-azure-login='echo "deprecated; using az2aws instead">&2 && _az2aws'
alias az2aws='_az2aws'
alias lighthouse='( nodenv shell 20.15.0 && nodenv exec exec lighthouse'
alias lhci='( nodenv shell 20.15.0 && nodenv exec nvm exec lhci )'
if command -v nvim >/dev/null; then alias vim=nvim; fi
alias aws-ecr-login=aws-login-ecr

# custom stuff

# set the behaviour of kill-word, backward-kill-word, etc
# default is '*?_-.[]~=/&;!#$%^(){}<>'
#  --> remove '/='
#     --> add '@,:'
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>@,:'

fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
eval "$(nodenv init - zsh)"
if command -v pyenv >/dev/null 2>&1; then eval "$(pyenv init - zsh)"; fi
eval "$(rbenv init - zsh)"
export PATH="$HOME/.jenv/bin:$PATH"; eval "$(jenv init -)"

# other stuff below, possibly broken 🤷🏼😅


#source /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh

source "${HOME}/.aws-helpers.sh"

path=($HOME/.docker/bin $path)
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# use the right version of homebrew (rosetta vs arm)
if [ "$(arch)" = "i386" ]; then
  PATH="/usr/local/bin:$PATH"
fi

export PATH="${HOME}/.bin:$PATH"

# warn about missing dependencies
source ~/.bin/_check_dependencies.zsh

# moved to a wrapper script; see ../.bin/git-gpg-ssh-wrapper.sh
#if [ -r "${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]; then
#  export SSH_AUTH_SOCK="${HOME}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
#fi

#__SSH_CMD="${__SSH_CMD:-$(command -v ssh)}"

# use kitten wrapper for ssh in kitty terminal
#function ssh() {
#  if grep -qs kitty <<<"${TERM}" >/dev/null 2>&1 && command -v kitten >/dev/null 2>&1; then
#    kitten ssh "${@}"
#  else
#    "${__SSH_CMD}" "${@}"
#  fi
#}

if ! command -v tailscale >/dev/null 2>&1; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=("${HOME}/.docker/completions" $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# use bake for docker-compose
COMPOSE_BAKE=true

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$(brew --prefix)/Caskroom/miniconda/base/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$(brew --prefix)/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "$(brew --prefix)/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



# Added by LM Studio CLI (lms)
export PATH="$PATH:${HOME}/.lmstudio/bin"
# End of LM Studio CLI section

# set up ccache
path=("$(brew --prefix)/opt/ccache/libexec" $path)

if command -v eza >/dev/null 2>&1 && [[ -o interactive ]]; then
  alias ls='eza --hyperlink --group --icons=auto'
fi

# if nothing else is available, use mysql from mysql-client
path=($path "$(brew --prefix)/opt/mysql-client/bin" )

# prefer some homebrew-provided utils
path=("$(brew --prefix)/opt/curl/bin" $path)
path=("$(brew --prefix)/opt/bind/bin" $path)

# use cocoapods from bundler, if available
alias pod='function __podwrapper_2c8b9fc4() { bundle exec -- bash -c "command -v pod" >/dev/null 2>&1 && bundle exec -- pod "${@}" || pod "${@}" }; __podwrapper_2c8b9fc4'

# wake-on-lan
alias wake='wakeonlan'
#alias wake-miniserver='wakeonlan -i 192.168.178.80 d8:bb:c1:a0:93:db'
#alias wake-cachyos='wakeonlan -i 192.168.178.103 0c:ef:15:5f:08:18 && wakeonlan -i 192.168.178.125 18:c0:4d:04:4d:bb'
alias wake-miniserver='wakeonlan d8:bb:c1:a0:93:db'
alias wake-cachyos='wakeonlan 0c:ef:15:5f:08:18 && wakeonlan 18:c0:4d:04:4d:bb'
alias wake-cachy='wake-cachyos'


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=("${HOME}/.docker/completions" $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

