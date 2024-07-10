#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set the directory in which to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# download zinit, if it's not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# load zinit
source "${ZINIT_HOME}/zinit.zsh"

# load powerlevel10k prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
export PYENV_ROOT="$HOME/.pyenv"; command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"; eval "$(pyenv init -)"
eval "$(rbenv init - zsh)"
export PATH="$HOME/.jenv/bin:$PATH"; eval "$(jenv init -)"

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
zinit snippet ~/.zsh-plugins/bennetts-dotfiles/bennetts-dotfiles.plugin.zsh

# custom aliases
#alias aws-azure-login='AWS_PROFILE=aad nvm exec 20 -- aws-azure-login'
alias aws-azure-login='( nodenv shell 20.15.0 && AWS_PROFILE=aad nodenv exec aws-azure-login )'
#alias lighthouse='nvm exec 20 -- lighthouse'
alias lighthouse='( nodenv shell 20.15.0 && nodenv exec exec lighthouse'
#alias lhci='nvm exec 20 -- lhci'
alias lhci='( nodenv shell 20.15.0 && nodenv exec nvm exec lhci )'
if command -v nvim >/dev/null; then alias vim=nvim; fi

# custom stuff

# set the behaviour of kill-word, backward-kill-word, etc
# default is '*?_-.[]~=/&;!#$%^(){}<>'
#  --> remove '/='
#     --> add '@,:'
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>@,:'

# initialize nodenv
eval "$(nodenv init - zsh)"

# other stuff below, possibly broken 🤷🏼😅


fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
#source /opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh

source "${HOME}/.aws-helpers.sh"

path=($HOME/.docker/bin $path)
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# use the right version of homebrew (rosetta vs arm)
if [ "$(arch)" = "i386" ]; then
  PATH="/usr/local/bin:$PATH"
fi

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="${HOME}/.bin:$PATH"

