# GNU Ring
RING_SRC="$HOME/dev/ring"
RING_PREFIX="$HOME/ring_install"

function make-contrib {
    mkdir -p "$RING_SRC/daemon/contrib/native"
    cd "$RING_SRC/daemon/contrib/native"
    ../bootstrap
    clean=false
    libs=()
    for i in "$@"
    do
        case "$i" in
            -h | --help)
                echo "Usage: ${FUNCNAME[0]} [clean|build|full] [libs]"
                return 0
                ;;
            clean)
                make distclean
                return 0
                ;;
            build)
                clean=false
                ;;
            full)
                clean=true
                ;;
            *)
                libs+=("$i")
        esac
    done
    if [ ${#libs[@]} -eq 0 ]; then
        if $clean; then
            make mostlyclean
        fi
        make
    else
        for lib in $libs
        do
            if $clean; then
                rm -f "../tarballs/${lib}"*
                rm -rf "$lib" ".$lib" ".sum-$lib"
            fi
            make ".$lib"
        done
    fi
}

function make-daemon {
    cd "$RING_SRC/daemon"
    RING_CONF='--prefix="'"${RING_PREFIX}"'"'
    f=false
    for i in "$@"
    do
        case "$i" in
            -h | --help)
                echo "Usage: ${FUNCNAME[0]} [clean|build|full] [--configuration]"
                return 0
                ;;
            clean)
                ./autogen.sh
                ./configure
                make clean
                return 0
                ;;
            full)
                f=true
                ;;
            *)
                RING_CONF+=" "$i
                ;;
        esac
    done
    ./autogen.sh
    ./configure $RING_CONF
    if $f; then
        make clean
    fi
    make -j
    make install
}

alias make-lrc='cd "$RING_SRC/lrc" && rm -rf build && mkdir build && cd build && cmake .. -DRING_BUILD_DIR="$RING_SRC/daemon/src" -DCMAKE_INSTALL_PREFIX="$RING_PREFIX" && make -j8 && make install'
alias make-client='cd "$RING_SRC/client-gnome" && rm -rf build && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX="$RING_PREFIX" && make -j8 && make install'
alias ring-daemon='"$RING_PREFIX/lib/ring/dring" -cdp'
alias ring-gnome='LD_LIBRARY_PATH="$RING_PREFIX/lib/" "$RING_PREFIX/bin/gnome-ring"'
