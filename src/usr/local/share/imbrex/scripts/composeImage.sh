#!/bin/bash

composeImage() {
    local OPTIND=1

    local inputFile=""
    local outputFile=""
    local canvasWidth=1920
    local canvasHeight=1080
    local scaleXY=""
    local anchorXY="+0+0"
    local rotation=0
    local colorToAlpha="white"

    while getopts "d:i:o:W:H:s:w:h:p:r:" opt; do
        case $opt in
        i ) inputFile="$OPTARG" ;;
        o ) outputFile="$OPTARG" ;;
        W ) canvasWidth="$OPTARG" ;;
        H ) canvasHeight="$OPTARG" ;;
        s ) scaleXY="$OPTARG" ;;
        p ) anchorXY="$OPTARG" ;;
        r ) rotation="$OPTARG" ;;
        a ) colorToAlpha="$OPTARG" ;;
        * ) echo "Unsupported flag: $OPTARG"; exit 1 ;;
        esac
    done

    local failed=false
    if [ ! -f "$inputFile" ]; then
        echo "Missing input file!"
        failed=true
    fi
    if [ -z "$outputFile" ]; then
        echo "Missing output file!"
        failed=true
    fi
    if [ ! -n "$canvasWidth" ]; then
        echo "Missing canvas width!"
        failed=true
    fi
    if [ ! -n "$canvasHeight" ]; then
        echo "Missing canvas height!"
        failed=true
    fi
    if [ ! -n "$scaleXY" ]; then
        echo "Missing resize scale!"
        failed=true
    fi
    if [ "$failed" = true ]; then exit 1; fi


    magick -size "${canvasWidth}x${canvasHeight}" canvas:none \
      \( "$inputFile" -resize "${scaleXY}" -rotate "$rotation" \) \
      -gravity center \
      -geometry "$anchorXY" \
      -transparent "$colorToAlpha" \
      -composite "$outputFile"
}