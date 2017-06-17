#!/bin/bash

dir="$HOME/dev/dotfiles"
backup="$HOME/dev/dotfiles.bak"
file_list="bash_aliases bashrc gitconfig profile vimrc"

mkdir -p $backup
cd $dir
for file in $file_list; do
    if [[ -e "$HOME/.$file" ]]; then
        echo "Back up $HOME/.$file to $backup/$file"
        mv "$HOME/.$file" "$backup/$file"
    fi
    echo "Creating symlink to $file"
    ln -s $dir/$file ~/.$file
done
