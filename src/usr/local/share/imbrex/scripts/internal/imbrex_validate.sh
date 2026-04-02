#!/usr/bin/env bash

validate() {
  local failed=false
  if [ ! -d "$dataDir" ]; then
    echo "No data folder found: $dataDir"
    failed=true
  fi
  if [ ! -d "$configDir" ]; then
    echo "No config folder found: $configDir"
    failed=true
  fi
  if [ ! -f "$activeProfileFile" ]; then
    echo "No active profile set.  Please set one in $activeProfileFile"
    failed=true
  fi
  if [ ! -d "$activeProfileRootDir" ]; then
    echo "No declared profile $activeProfile set inside $configDir/profiles"
    failed=true
  fi
  if [ ! -f "$activeProfileConfig" ]; then
    echo "No configuration found for profile: $activeProfile"
    failed=true
  fi

  if [ -s "$activeProfile" ]; then
    echo "No active profile name found in $activeProfile!"
    failed=true
  fi
  if [ ! -d "$activeProfileImagesDir" ]; then
    echo "No images found in $activeProfile/images!"
    failed=true
  fi

  if [ "$failed" = true ]; then
    echo "Validation failed!  If you need to initialize, run: $0 -i"
    exit 1
  fi
}