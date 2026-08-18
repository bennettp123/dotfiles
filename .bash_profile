# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/bennett/.docker/bin"
# End of Docker Desktop section.

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

. "$HOME/.cargo/env"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
eval "$(nodenv init - bash)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:${HOME}/.lmstudio/bin"
# End of LM Studio CLI section

# set up ccache
if [ -d "$(brew --prefix)/opt/ccache/libexec" ]; then
  export PATH="$(brew --prefix)/opt/ccache/libexec:$PATH"
fi
