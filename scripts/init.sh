#!/bin/sh

githubuser=holysugar

# install XCode (?)

# install homebrew
# https://brew.sh/index_ja.html
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brew-file
# https://homebrew-file.readthedocs.io/en/latest/installation.html
brew install rcmdnk/file/brew-file

# generate ssh key of ed25519
if [ ! -e ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519
  ssh-add

  # register public key to github
  open https://github.com/settings/keys
  pbcopy < ~/.ssh/id_ed25519.pub
fi

if ! ssh-add -l > /dev/null; then
  ssh-add
fi

# create src (before installing ghq)
mkdir -p ~/src/github.com/${githubuser}

# dotfiles
(
  cd ~/src/github.com/${githubuser}
  git clone git@github.com:holysugar/dotfiles
  sh -x dotfiles/scripts/dotfiles.sh
)

if ! which mas > /dev/null; then
  brew install mas
fi

if mas version | grep 1.3; then
  brew uninstall mas
  brew install mas
fi

brew file install

# chsh
if ! dscl . -read /Users/holy UserShell | grep zsh > /dev/null; then
  sudo dscl . -create /Users/$USER UserShell /bin/zsh
fi
