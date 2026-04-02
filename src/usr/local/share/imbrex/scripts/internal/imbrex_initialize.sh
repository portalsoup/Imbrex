#!/usr/bin/env bash

initialize() {
  if [ ! -d "$dataDir" ]; then
    echo "Creating data folder... $dataDir"
    mkdir -p "$dataDir"
  fi
  if [ ! -d "$configDir" ]; then
    echo "Creating config folder... $configDir"
    mkdir -p "$configDir"
  fi
  if [ ! -d "$profilesRootDir" ]; then
    echo "Creating profiles folder... $profilesRootDir"
    mkdir -p "$profilesRootDir"
  fi
  if [ ! -f "$activeProfileFile" ]; then
    echo "Creating active profile file... $activeProfileFile"
    touch "$activeProfileFile"
  fi
  echo "Initialization complete!"
}