# yet another dotfiles thang

this is my dotfiles repo

highly opinionated&mdash;if you want to use it, you may need to fork it first 😛

## requirements

* `brew install font-meslo-lg-nerd-font`
* `brew install chroma`
* `brew install terminal-notifier`
* `brew install neovim` (optional)
* `brew install fzf`
* `brew install fd`
* `brew install tree-sitter`
* `brew install tree-sitter-cli`

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

## custom helpers

A custom helper script is installed, which warns noisily if dotfiles are
modified without being committed & pushed.

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

# Prompt

Currently done using [starship](https://starship.rs), using a modified version
of the [Catppuccin Powerline](https://starship.rs/presets/catppuccin-powerline)
preset&mdash;changes can be found in
[`patches/0001-customize-starship-preset.patch`][1].

Upstream changes can be applied by resetting the config and re-applying the
customizations:

```bash
# re-generate the preset
starship preset catppuccin-powerline -o ~/.config/starship.toml

# re-apply the changes from the patch
git apply patches/0001-customize-starship-preset.patch
```

[1]: ./patches/0001-customize-starship-preset.patch
