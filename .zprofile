# homebrew
eval "$("$(brew --prefix)/bin/brew" shellenv)"

if ! echo "$PATH" | grep -q '/Users/bennett/.local/bin'; then
  PATH="/Users/bennett/.local/bin:${PATH}"
fi

# initialize nodenv
eval "$(nodenv init - zsh)"

export PATH

# increase the maximum number of open files
if [ "$(ulimit -Hn)" != 'unlimited' ] && [ $(ulimit -Hn) -lt 16384 ]; then ulimit -Hn 16384; fi
if [ "$(ulimit -Sn)" != 'unlimited' ] && [ $(ulimit -Sn) -lt  8192 ]; then ulimit -Sn  8192; fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
#source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# pyenv
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)"
fi

