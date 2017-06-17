#!/bin/bash

dir="$HOME/dev/dotfiles"
backup="$HOME/dev/dotfiles.bak"
file_list="bash_aliases bashrc gitconfig profile vimrc"

mkdir -p $olddir
cd $dir
echo "Moving existing dotfiles from ~ to $backup"
for file in $file_list; do
    mv "~/.$file" "$backup/$file"
    echo "Creating symlink to $file"
    ln -s $dir/$file ~/.$file
done
