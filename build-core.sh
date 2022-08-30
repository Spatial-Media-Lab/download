#!/bin/bash

set -e

if [[ "$1" == "--clean" ]]; then
  rm -f spatialmedialab-samd-*
fi

rm -rf arduino-board-package
git clone --depth=1 git@github.com:Spatial-Media-Lab/arduino-board-package
(cd arduino-board-package && git submodule update --init --recursive --remote --recommend-shallow)

rm -rf samd/
mkdir samd/

# Our board definitions
cp -a  arduino-board-package/{variants,boards.txt,platform.txt} samd/

# The SAMD core from Adafruit
cp -a  arduino-board-package/ArduinoCore-samd/cores samd/
rm -f  samd/cores/arduino/math_helper.*

# Copy only the needed libraries
cp -aL  arduino-board-package/libraries/ samd/libraries/

# Disable debug, it occupies Serial1.
sed -i '' 's/#define CFG_TUSB_DEBUG 2/#define CFG_TUSB_DEBUG 0/' samd/libraries/Adafruit_TinyUSB_Arduino/src/arduino/ports/samd/tusb_config_samd.h

version=$(grep 'version=' arduino-board-package/platform.txt | sed -E 's/.*version=([0-9]*).*/\1/')

# Create reproducible tar, use the timestamp of the last commit from the board package repository.
date=$(git log -1 --format=%cd arduino-board-package)
#tar --numeric-owner --owner=0 --group=0 --sort=name --clamp-mtime --mtime="$date" -cjf spatialmedialab-samd-$version.tar.bz2 samd/
tar --numeric-owner -cjf spatialmedialab-samd-$version.tar.bz2 samd/

hash=$(shasum -a 256 spatialmedialab-samd-$version.tar.bz2 | sed -E 's/ .*//')

cp package_spatialmedialab_index.json.in package_spatialmedialab_index.json
sed -i '' -E "s/@@VERSION@@/$version/" package_spatialmedialab_index.json
sed -i '' -E "s/@@HASH@@/$hash/" package_spatialmedialab_index.json

rm -rf arduino-board-package
rm -rf samd/
git add spatialmedialab-samd-$version.tar.bz2
