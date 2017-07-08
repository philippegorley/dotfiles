function up() {
    for i in `seq ${1:-1}`; do cd ..; done;
}

function battman {
    for bat in $(upower -e | grep "battery"); do
        n=$(upower -i $bat|grep "native-path"|awk '{print $2}')
        s=$(upower -i $bat|grep "state"|awk '{print $2}')
        e=$(upower -i $bat|grep "time to empty"|awk '{print $4 " " $5}')
        f=$(upower -i $bat|grep "time to full"|awk '{print $4 " " $5}')
        p=$(upower -i $bat|grep "percentage"|awk '{print $2}')
        echo "$n: $s ($p)"
        if [[ $s == "discharging" ]]; then
            if [[ -n $e ]]; then
                echo "    time to empty: $e"
            fi
        elif [[ $s == "charging" ]]; then
            if [[ -n $f ]]; then
                echo "    time to full: $f"
            fi
        fi
    done
}


# GNU Ring
RING_SRC="$HOME/dev/ring"
RING_PREFIX="$HOME/ring_install"

function make-contrib {
    clean=false
    build=true
    libs=()
    for i in "$@"
    do
        case "$i" in
            -h | --help)
                echo "Usage: ${FUNCNAME[0]} [clean|build|full] [libs]"
                return 0
                ;;
            clean)
                clean=true
                build=false
                ;;
            build)
                clean=false
                build=true
                ;;
            full)
                clean=true
                build=true
                ;;
            *)
                libs+=("$i")
        esac
    done
    mkdir -p "$RING_SRC/daemon/contrib/native"
    cd "$RING_SRC/daemon/contrib/native"
    ../bootstrap
    if [ ${#libs[@]} -eq 0 ]; then
        if $clean; then
            make mostlyclean
        fi
        if $build; then
            make
        fi
    else
        for lib in $libs
        do
            if $clean; then
                rm -f "../tarballs/${lib}"*
                rm -rf "$lib" ".$lib" ".lib${lib}" ".sum-$lib"
            fi
            if $build; then
                make ".$lib"
            fi
        done
    fi
}

function make-daemon {
    RING_CONF="--prefix="${RING_PREFIX}""
    clean=false
    build=true
    for i in "$@"
    do
        case "$i" in
            -h | --help)
                echo "Usage: ${FUNCNAME[0]} [clean|build|full] [--configuration]"
                return 0
                ;;
            clean)
                clean=true
                build=false
                ;;
            build)
                clean=false
                build=true
                ;;
            full)
                clean=true
                build=true
                ;;
            *)
                RING_CONF+=" "$i
                ;;
        esac
    done
    cd "$RING_SRC/daemon"
    if $clean; then
        make clean
    fi
    if $build; then
        ./autogen.sh
        ./configure $RING_CONF
        make -j
        make install
    fi
}

function make-lrc {
    clean=false
    build=true
    for i in "$@"; do
        case "$i" in
            -h|--help)
                echo "Usage: ${FUNCNAME[0]} [clean|build|full]"
                return 0
                ;;
            clean)
                clean=true
                build=false
                ;;
            build)
                clean=false
                build=true
                ;;
            full)
                clean=true
                build=true
                ;;
        esac
    done
    cd "$RING_SRC/lrc"
    if $clean; then
        rm -rf build
    fi
    if $build; then
        mkdir -p build
        cd build
        cmake .. "-DRING_BUILD_DIR=\"$RING_SRC/daemon/src\" -DCMAKE_INSTALL_PREFIX=\"$RING_PREFIX\""
        make -j8
        make install
        cd ..
    fi
}

function make-client-gnome {
    clean=false
    build=true
    for i in "$@"; do
        case "$i" in
            -h|--help)
                echo "Usage: ${FUNCNAME[0]} [clean|build|full]"
            clean)
                clean=true
                build=false
                ;;
            build)
                clean=false
                build=true
                ;;
            full)
                clean=true
                build=true
                ;;
        esac
    done
    cd "$RING_SRC/lrc"
    if $clean; then
        rm -rf build
    fi
    if $build; then
        mkdir -p build
        cd build
        cmake .. "-DCMAKE_INSTALL_PREFIX=\"$RING_PREFIX\""
        make -j8
        make install
        cd ..
    fi    
}

# keep these aliases with the gnu ring functions
alias ring-daemon='"$RING_PREFIX/lib/ring/dring" -cdp'
alias ring-gnome='LD_LIBRARY_PATH="$RING_PREFIX/lib/" "$RING_PREFIX/bin/gnome-ring"'


