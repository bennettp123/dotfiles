. "$HOME/.cargo/env"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

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


