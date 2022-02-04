#!/bin/zsh

set -e

# Get the list of devices.
typeset -A devices
for i in *.firmware-*.bin; do
  local meta=$(strings $i | grep '"com.versioduo.firmware"')
  local id=$(echo $meta | sed -E 's/.*"id":"([^"]+).*/\1/')
  local version=$(echo $meta | sed -E 's/.*"version":([^,]+).*/\1/')
  devices[$id]="$id"
done

output=index.json

echo '{' > $output

# Write the device array.
local comma=''
for device versions in "${(@kv)devices}"; do
  echo -ne $comma >> $output
  comma=",\n"
  echo '  "'$device'": [' >> $output

  # Write the firmware versions for this device.
  local comma2=''
  for i in $device.firmware-*.bin; do
    echo -ne $comma2 >> $output
    comma2=",\n"
    meta=$(strings "$i" | grep '"com.versioduo.firmware"')
    id=$(echo $meta | sed -E 's/.*"id":"([^"]+).*/\1/')
    version=$(echo $meta | sed -E 's/.*"version":([^,]+).*/\1/')
    board=$(echo $meta | sed -E 's/.*"board":"([^"]+).*/\1/')
    hash=$(shasum -a 1 $i | sed -E 's/ .*//')
    echo '    {' >> $output
    echo '      "file": "'$i'",' >> $output
    echo '      "version": '$version',' >> $output
    echo '      "board": "'$board'",' >> $output
    echo '      "hash": "'$hash'"' >> $output
    echo -n '    }' >> $output
  done

  echo -ne '\n  ]' >> $output
done

echo -e "\n}" >> $output

