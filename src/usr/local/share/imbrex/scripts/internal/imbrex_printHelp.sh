#!/usr/bin/env bash

printHelp() {
  read -r -d '' msg << MSG
pswallpaper - Dynamic wallpaper compositor

Usage: $0 [OPTIONS]

Options:
  -i            Initialize folders and configuration.
                    Creates data, config, and profile directories if they don't exist.

  -c <dir>      Specify custom config directory.
                    Default: $DEFAULT_CONFIG_DIR

  -d <dir>      Specify custom data directory.
                    Default: $DEFAULT_DATA_DIR

  -p <profile>  Specify a profile to load by name instead of using the 'activeprofile' file.

  -h            Show this help message.

Description:
  pswallpaper reads a profile configuration and a set of image layers
  to generate a composite wallpaper, which is then applied using 'feh'.

  Profiles are stored in the config directory under 'profiles/<profile_name>'.
  Each profile contains:
    - config: ordered list of image files by name inside '<profile>/images/' directory to be layered.
    - images: folder containing image files.
    - setup.sh (optional): script to manipulate images before composition.

  Specify which profile to use by declaring it's folder name inside the $DEFAULT_CONFIG_DIR/activeprofile

Example:
  Initialize directories and set up the environment:
    $0 -i

  Use a custom config directory and data directory:
    $0 -c /path/to/config -d /path/to/data
MSG
  printf "%s\n" "$msg"
}