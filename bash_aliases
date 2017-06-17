# GNU Ring
RING_SRC="$HOME/dev/ring"
RING_PREFIX="$HOME/ring_install"

function clear-contrib {
    cd "$RING_SRC/daemon/contrib"
    if [ -z $1 ]; then
        if [ ! -e build/Makefile ]; then
            return 1
        fi
        cd build
        make mostlyclean
    else
        for dep in "$@"
        do
            rm -f "tarballs/${dep}"*
            cd build
            rm -rf "$dep" ".$dep" ".sum-$dep"
        done
    fi
}

function make-contrib {
    cd "$RING_SRC/daemon/contrib"
    if [ ! -e build ]; then
        mkdir build
    fi
    cd build
    if [ -z $1 ]; then
        make mostlyclean
        ../bootstrap
        make list
        make
    else
        for dep in "$@"
        do
            rm -rf "$dep" ".$dep" ".sum-$dep"
            make ".$dep"
        done
    fi
}

function make-daemon {
    cd "$RING_SRC/daemon"
    ./autogen.sh
    RING_CONF="--prefix="$RING_PREFIX" $@"
    ./configure $RING_CONF
    make clean
    make -j
    make install
}

alias make-lrc='cd "$RING_SRC/lrc" && rm -rf build && mkdir build && cd build && cmake .. -DRING_BUILD_DIR="$RING_SRC/daemon/src" -DCMAKE_INSTALL_PREFIX="$RING_PREFIX" && make -j8 && make install'
alias make-client='cd "$RING_SRC/client-gnome" && rm -rf build && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX="$RING_PREFIX" && make -j8 && make install'
alias ring-daemon='"$RING_PREFIX/lib/ring/dring" -cdp'
alias ring-gnome='LD_LIBRARY_PATH="$RING_PREFIX/lib/" "$RING_PREFIX/bin/gnome-ring"'
