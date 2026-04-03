#!/usr/bin/env bash

dailyWave() {
    local epoch
    local tzOffset
    epoch=$(date +%s)
    tzOffset=$(date +%z)

    local sign="${tzOffset:0:1}"
    local hours="${tzOffset:1:2}"

    local offsetSeconds=$((10#$hours * 3600))
    [[ "$sign" == "-" ]] && offsetSeconds=$(( -offsetSeconds ))

    local secondsPerDay=$((60 * 60 * 24))
    local secondsIntoDay=$(( (epoch + offsetSeconds) % secondsPerDay ))

    # Compute cosine using awk
    awk -v t="$secondsIntoDay" -v s="$secondsPerDay" '
        BEGIN {
            pi = 3.14159
            frac = t / s
            wave = -cos(frac * 2 * pi)
            print wave
        }
    '
}

normalizeRange() {
    local OPTIND=1

    local value=
    local smin=
    local smax=
    local tmin=0
    local tmax=1

    while getopts "v:s:S:t:T:" opt; do
        case "$opt" in
        v) value="$OPTARG" ;;
        s) smin="$OPTARG" ;;
        S) smax="$OPTARG" ;;
        t) tmin="$OPTARG" ;;
        T) tmax="$OPTARG" ;;
        *) echo "Usage: $0 -v <value> -s <src_min> -S <src_max> [-t <target_min>] [-T <target_max>]"; exit 1 ;;
        esac
    done

    if [[ -z "$value" || -z "$smin" || -z "$smax" ]]; then
        echo "Flags -v, -s, -S are required"
        exit 1
    fi

    awk -v v="$value" -v smin="$smin" -v smax="$smax" \
      -v tmin="$tmin" -v tmax="$tmax" \
      'BEGIN { print tmin + (v - smin) * (tmax - tmin) / (smax - smin) }'
}