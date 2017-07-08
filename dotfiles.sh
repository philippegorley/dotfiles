#!/usr/bin/env bash

dir="$HOME/dev/dotfiles"
backup="$HOME/dev/dotfiles.bak"
files="bash_functions bash_aliases bashrc gitconfig profile vimrc radare2rc"
mkdir -p $dir
cd $dir

function usage() {
    echo "$0 {backup|setup|save|pull} [--restart|--no-restart]"
    echo "  backup        run before git pull"
    echo "  setup         run after git pull"
    echo "  save          run before git push"
    echo "  pull          backup, git stash, git pull, setup"
    echo "  --help|-h     show this help and exit"
    echo "  --restart     execute operations that may or may not require a reboot"
    echo "  --no-restart  don't execute operations which may require a reboot (default)"
}

function backup() {
    for file in $files; do
        if [[ -e "$HOME/.$file" ]]; then
            echo "Back up $HOME/.$file to $backup/$file"
            rm -f "$backup/$file"
            cp "$HOME/.$file" "$backup/$file"
        fi
    done
    cp "$dir/cinnamon.conf" "$backup/cinnamon.conf"
}

function setup() {
    for file in $files; do
        echo "Creating symlink to $file"
        ln -sf $dir/$file ~/.$file
    done
    if $rst; then
        dconf load /org/cinnamon/ < "$dir/cinnamon.conf"
    fi
}

function save() {
    dconf dump /org/cinnamon/ > cinnamon.conf
}

function pull() {
    backup
    git stash
    git pull
    setup
}

rst=false
for arg in "${@:2}"
do
    case "$arg" in
    --restart)
        rst=true
        ;;
    --no-restart)
        rst=false
        ;;
    *)
        usage
        exit 1
        ;;
    esac
done

case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    backup)
        backup
        ;;
    setup)
        setup
        ;;
    save)
        save
        ;;
    pull)
        pull
        ;;
    *)
        usage
        exit 1
        ;;
esac

