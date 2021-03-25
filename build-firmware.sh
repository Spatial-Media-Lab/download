#!/bin/bash

set -e

projects="\
  tracker\
"

output=index.json

rm -rf build/
mkdir build/

comma=''
echo '{' > $output

for i in $projects; do
  name=$(basename $i)
  project=~/Documents/Arduino/spatialmedialab/$i
  meta=$(grep V2DEVICE_METADATA $project/$(basename $name).ino)
  # V2DEVICE_METADATA("com.versioduo.pad", 4, "versioduo:samd:pad")
  match='.*V2DEVICE_METADATA\("(.*)",[[:space:]]([0-9]*),[[:space:]]"(.*)"\).*'
  id=$(echo $meta | sed -E "s/$match/\1/")
  version=$(echo $meta | sed -E "s/$match/\2/")
  board=$(echo $meta | sed -E "s/$match/\3/")
  firmware=$id.firmware-$version.bin

  arduino-cli compile --fqbn $board --output-dir build $project
  mv build/$name.ino.bin build/$firmware

  hash=$(shasum -a 1 build/$firmware | sed -E 's/ .*//')

  echo -ne $comma >> $output
  comma=",\n"

  echo '  "'$id'": {' >> $output
  echo '    "file": "'$firmware'",' >> $output
  echo '    "version": '$version',' >> $output
  echo '    "board": "'$board'",' >> $output
  echo '    "hash": "'$hash'"' >> $output
  echo -n '  }' >> $output

  rm -f $id.firmware-$version.uf2
  python ../uf2-samdx1/lib/uf2/utils/uf2conv.py -b 16384 -c -o build/$id.firmware-$version.uf2 build/$firmware
done

echo -e "\n}" >> $output

chmod 0444 build/*.bin
mv -f build/*.bin .
mv -f build/*.uf2 .
rm -rf build/
git add *.bin *.uf2

