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

# .config
mkdir -p ~/.config/brewfile 2>/dev/null
ln -s $origdir/.config/brewfile/Brefile

# chsh
sudo dscl . -create /Users/$USER UserShell /bin/zsh
