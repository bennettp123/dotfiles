export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

. "$HOME/.cargo/env"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
eval "$(nodenv init - bash)"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bennett/.lmstudio/bin"
# End of LM Studio CLI section

