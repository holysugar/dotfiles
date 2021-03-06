#!/bin/sh

origdir=$( cd $(dirname $0)/.. ; pwd )
dotfiles=$( cd $origdir; echo dotfiles/{*,.*} )

cd ~

for i in ${dotfiles}; do
  # ignore directory entries
  # ${i:-1} とすると意味が変わってしまうので ${i: -1} のスペースは必須
  if [ "${i: -1}" = "." ]; then
    continue
  fi
  ln -s $origdir/$i 2>/dev/null
done

