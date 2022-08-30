#!/bin/bash

set -e

project=~/github/Spatial-Media-Lab/

devices="\
  tracker\
"

if [[ -d "$1" ]]; then
  devices=$(basename "$1")
fi

rm -rf build/
mkdir build/

for i in $devices; do
  name=$(basename $i)
  meta=$(grep V2DEVICE_METADATA $project/$i/$name.ino)
  # V2DEVICE_METADATA("com.versioduo.pad", 4, "versioduo:samd:pad")
  match='.*V2DEVICE_METADATA\("(.*)",[[:space:]]([0-9]*),[[:space:]]"(.*)"\).*'
  id=$(echo $meta | sed -E "s/$match/\1/")
  version=$(echo $meta | sed -E "s/$match/\2/")
  board=$(echo $meta | sed -E "s/$match/\3/")
  firmware=$id.firmware-$version.bin

  arduino-cli compile --fqbn $board --output-dir build $project/$i
  mv build/$name.ino.bin build/$firmware

  rm -f $id.firmware-$version.uf2
  python3 ../uf2-samdx1/lib/uf2/utils/uf2conv.py -b 16384 -c -o build/$id.firmware-$version.uf2 build/$firmware
done

if [[ "$1" == "--clean" ]]; then
  rm -f *.firmware-*
fi

chmod 0444 build/*.bin
mv -f build/*.bin .
mv -f build/*.uf2 .
rm -rf build/
git add *.firmware-*

./build-index.sh
