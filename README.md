# yet another dotfiles thang

this is my dotfiles repo

highly opinionated&mdash;if you want to use it, you may need to fork it first 😛


## installing the dotfiles

```bash
# clone this repo
mkdir -p ~/src
git clone <this-repo> ~/src/dotfiles
cd ~/src/dotfiles

# prepare folders
scripts/prepare-target-folders
scripts/fix-permissions

brew install stow
stow . -t ~
```

`stow` will never delete anything it doesn't "own"; you'll need to
clean up any existing files before running the commands above.


## shell helpers

A custom helper script is installed for [https://ohmyz.sh](oh-my-zsh), which
warns noisily if dotfiles are modified without being committed & pushed.

There's currently no way to suppress this behaviour.


## system-level scripts

optionally, system-level dotfiles can be installed using the
commands below:

```bash
mkdir -p ~/src
git clone <this-repo> ~/src/dotfiles
cd ~/src/dotfiles/system

sudo ./install.sh
```

