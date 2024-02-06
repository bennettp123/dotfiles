# yet another dotfiles thang

this is my dotfiles

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


