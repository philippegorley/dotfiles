#!/bin/bash

dir="$HOME/dev/dotfiles"
backup="$HOME/dev/dotfiles.bak"
file_list="bash_aliases bashrc gitconfig profile vimrc"

mkdir -p $backup
cd $dir
echo "Moving existing dotfiles from ~ to $backup"
for file in $file_list; do
    echo "Checking $file"
    echo "Moving from ~/.$file to $backup/$file"
    mv -f "~/.$file" "$backup/$file"
    echo "Creating symlink to $file"
    ln -f -s $dir/$file ~/.$file
done
