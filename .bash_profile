export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

. "$HOME/.cargo/env"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
