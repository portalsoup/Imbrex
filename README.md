# Imbrex

Profile-driven image compositor.

    Usage: imbrex [OPTIONS]

    -i              Create data, config, and profile directories if they don't exist.
    -c <dir>        Specify custom config directory.
    -d <dir>        Specify custom data directory.
    -p <profile>    Specify a profile to load by name, overriding the 'activeprofile' file.
    -o              Specify an output path for the resulting composite folder.
    -h              Show this help message.


Profiles are stored in the config directory under 'profiles/<profile_name>/'.
Each profile contains:
* config: An ordered list of images by filename inside '<profile>/images/' directory.
* images: folder containing image files.
* setup.sh (optional): script to manipulate images before composition.


## Installation

### Run a self contained test and generate an image in this directory:

    $ make test

### Install the core app with:

    $ make install

### Install the demo profile with:

    $ make install-demo

### Remove project files:

    $ make clean

### Uninstall the core application

    $ make uninstall

### Delete installed profile data

    $ make delete-profiles


