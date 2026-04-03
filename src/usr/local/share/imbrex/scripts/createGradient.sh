#!/usr/bin/env bash

createGradient() {
    local bottomColor=""
    local topColor=""
    local intensity=""
    local width=1920
    local height=1080
    local rotation=0
    local output=""

    while getopts "b:t:i:w:h:o:r:" opt; do
        case $opt in
        b ) bottomColor="$OPTARG" ;;
        t ) topColor="$OPTARG" ;;
        i ) intensity="$OPTARG" ;;
        w ) width="$OPTARG" ;;
        h ) height="$OPTARG" ;;
        o ) output="$OPTARG" ;;
        r ) rotation="$OPTARG" ;;
        * ) echo "Invalid flag!"; exit 1; ;;
        esac
    done

    if [[ -z "$bottomColor" || -z "$topColor" || -z "$intensity" || -z "$output" ]]; then
        echo "Flags -b, -t, -i, o are required"
        exit 1
    fi

    if ! test -f "$output"; then
        mkdir -p "$(dirname "$output")"
        touch "$output"
    fi

    magick \
      \( \
      -size "$width"x"$height" \
      gradient:"$topColor"-"$bottomColor" \
      -level "0%,${intensity}%" \
      -distort SRT "$rotation" \
      \) \
      png:- > "$output"


}
