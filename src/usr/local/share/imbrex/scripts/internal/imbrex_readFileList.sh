#!/usr/bin/env bash

readFileList() {
  local config="$1"
  local line z file
  local -a layerFiles=()

  [ ! -f "$config" ] && { echo "No config found for $activeProfile"; exit 1; }

  while IFS= read -r line; do
    [[ -z "$line" || "${line:0:1}" == "#" ]] && continue
    linePath="$activeProfileImagesDir/$line"
    [ -f "$linePath" ] && layerFiles+=("$linePath")

  done < "$config"

  printf '%s\n' "${layerFiles[@]}"
}