. "$HOME/.cargo/env"

export PATH="$(brew --prefix)/opt/ruby/bin:$PATH"

# set up nodenv
_SHELL="`ps -p $$ -o 'comm='`"
case "$_SHELL" in
    bash)
        eval "$(nodenv init - bash)"
        ;;
    sh)
        eval "$(nodenv init - sh)"
        ;;
    zsh)
        eval "$(nodenv init - zsh)"
        ;;
esac

# set default editor
export EDITOR=vim
export VISUAL=vim

# increase the maximum number of open files
if [ "$(ulimit -Hn)" != 'unlimited' ] && [ $(ulimit -Hn) -lt 16384 ]; then ulimit -Hn 16384; fi
if [ "$(ulimit -Sn)" != 'unlimited' ] && [ $(ulimit -Sn) -lt  8192 ]; then ulimit -Sn  8192; fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bennett/.lmstudio/bin"
# End of LM Studio CLI section

