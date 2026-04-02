#!/usr/bin/env bash

#################
### Constants ###
#################
PROJECT_NAME="imbrex"
DEFAULT_DATA_DIR="$XDG_DATA_HOME/$PROJECT_NAME"
DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/$PROJECT_NAME"

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

if [[ -n "$outputDirFlag" ]]; then outputDir="$outputDirFlag"; else outputDir="$DEFAULT_DATA_DIR"/composite.png; fi

##################
### Validation ###
##################
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

if [ "$failed" = true ]; then
    echo "Validation failed!  If you need to initialize, run: $0 -i"
    exit 1
fi

#####################
### Source/Export ###
#####################
source "$scriptsDir"/internal/imbrex_initialize.sh
source "$scriptsDir"/internal/imbrex_printHelp.sh
source "$scriptsDir"/internal/imbrex_readFileList.sh
source "$scriptsDir"/internal/imbrex_validate.sh

source "$scriptsDir"/composeImage.sh

# Profiles api
export IMAGES_DIR="$activeProfileImagesDir"
export -f composeImage

#############
### Work! ###
#############
if [ "$printHelpFlag" = true ]; then
    printHelp
    exit 0
fi
if [ "$initializeFlag" = true ]; then
    initialize
    exit 0
fi


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
  -flatten "$outputDir"
