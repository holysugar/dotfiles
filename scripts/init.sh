#!/bin/sh

origdir=$(cd $(dirname $0)/.. ; pwd)

cd ~

for i in \
  .gitconfig \
  .gitignore_global \
  .gvimrc \
  .screenrc \
  .vim \
  .vimrc \
  .zshenv \
  .zshrc \
  rails.watchr \
; do
  ln -s $origdir/$i ~/
done

# .config/brewfile
mkdir -p ~/.config/brewfile 2>/dev/null
(
  cd ~/.config/brewfile
  ln -s $origdir/dotconfig/brewfile/Brewfile .
)

# chsh
sudo dscl . -create /Users/$USER UserShell /bin/zsh
