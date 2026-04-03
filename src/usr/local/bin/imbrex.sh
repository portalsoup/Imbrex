#!/usr/bin/env bash

#################
### Constants ###
#################
PROJECT_NAME="imbrex"
DEFAULT_DATA_DIR="$XDG_DATA_HOME/$PROJECT_NAME"
DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/$PROJECT_NAME"
DEFAULT_CACHE_DIR="$XDG_CACHE_HOME/$PROJECT_NAME"

#########################
### Argument Handling ###
#########################
initializeFlag=false
printHelpFlag=false
dataDirFlag=""
configDirFlag=""
activeProfileFlag=""
outputDirFlag=""

while getopts "ic:d:p:o:h" opt; do
    case $opt in
        i ) initializeFlag=true ;;
        c ) configDirFlag="$OPTARG" ;;
        d ) dataDirFlag="$OPTARG" ;;
        h ) printHelpFlag=true ;;
        p ) activeProfileFlag="$OPTARG" ;;
        o ) outputDirFlag="$OPTARG" ;;
        * ) printHelpFlag=true ;;
    esac
done

#########################
### Dynamic variables ###
#########################
if [[ -n "$dataDirFlag" ]]; then dataDir="$dataDirFlag"; else dataDir="$DEFAULT_DATA_DIR"; fi
if [[ -n "$configDirFlag" ]]; then configDir="$configDirFlag"; else configDir="$DEFAULT_CONFIG_DIR"; fi

scriptsDir="$dataDir"/scripts

profilesRootDir="$configDir/profiles"
activeProfileFile="$configDir/activeprofile"

if [[ -n "$activeProfileFlag" ]]; then activeProfile="$activeProfileFlag"; else activeProfile=$(cat "$activeProfileFile" 2> /dev/null); fi

activeProfileRootDir="$profilesRootDir/$activeProfile"
activeProfileConfig="$activeProfileRootDir/config"
activeProfileImagesDir="$activeProfileRootDir/images"

if [[ -n "$outputDirFlag" ]]; then outputDir="$outputDirFlag"; else outputDir="$DEFAULT_CACHE_DIR"; fi
outputFile="$outputDir"/composite.png

######################
### Source Helpers ###
######################
source "$scriptsDir"/internal/imbrex_readFileList.sh

source "$scriptsDir"/composeImage.sh
source "$scriptsDir"/createGradient.sh
source "$scriptsDir"/math.sh
##################
### Validation ###
##################
if [ "$printHelpFlag" = true ]; then
    read -r -d '' msg << MSG
imbrex - Profile-driven image compositor.

Usage: $0 [OPTIONS]

Options:
  -i            Initialize folders and configuration.
                    Creates data, config, and profile directories if they don't exist.

  -c <dir>      Specify custom config directory.
                    Default: $DEFAULT_CONFIG_DIR

  -d <dir>      Specify custom data directory.
                    Default: $DEFAULT_DATA_DIR

  -p <profile>  Specify a profile to load by name instead of using the 'activeprofile' file.

  -o            Specify an output path for the resulting composite folder.
                    Default: $DEFAULT_CACHE_DIR

  -h            Show this help message.

Description:
  imbrex reads a profile configuration and a set of image layers
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
    exit 0
fi

if [ "$initializeFlag" = true ]; then
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
    if [ ! -f "$outputDir" ]; then
        echo "Creating a new output folder... $outputDir"
        mkdir -p "$outputDir"
    fi
    echo "Initialization complete!"
    exit 1
fi

# Validate each expected filesystem element
failed=false
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
if [ ! -d "$outputDir" ]; then
    echo "No output folder found: $outputDir"
    failed=true
fi

if [ "$failed" = true ]; then
    echo ""
    echo "  If you need to initialize, run: $0 -i"
    exit 1
fi

####################
### Profiles API ###
####################
export IMAGES_DIR="$activeProfileImagesDir"
export -f composeImage
export -f createGradient
export -f dailyWave
export -f normalizeRange

#############
### Work! ###
#############
# Profile pre-setup to prepare images if needed
profileSetup="$activeProfileRootDir"/setup.sh
if [ -f "$profileSetup"  ]; then
    "$profileSetup" "$activeProfileRootDir"
fi

# get declared images from profile config
mapfile -t files < <(readFileList "$activeProfileConfig")

# squash all layers into one flat image
magick "${files[@]}" \
  -background none \
  -flatten "$outputFile"

echo "Image created $outputFile"
