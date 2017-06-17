#!/bin/bash

dir="$HOME/dev/dotfiles"
backup="$HOME/dev/dotfiles.bak"
file_list="bash_aliases bashrc gitconfig profile vimrc"

mkdir -p $backup
cd $dir
for file in $file_list; do
    echo "Checking $file"
    mv -f "~/.$file" "$backup/$file"
    ln -f -s $dir/$file ~/.$file
done
