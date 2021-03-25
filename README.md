# download

[spatial-media-lab.github.io/download](https://spatial-media-lab.github.io/download/)

## Firmware
Binary firmware images: `com.spatialmedialab.$DEVICE.firmware-$VERSION.bin`, automatically picked up by the 
web [configure](https://spatial-media-lab.github.io/configure/) interface; or can be uploaded to the device
with [BOSSA](https://github.com/shumatech/BOSSA).

Firmware updates, installed using the [Mass Storage Interface](https://github.com/microsoft/uf2): 
`com.spatialmedialab.$DEVICE.firmware-$VERSION.uf2`; a recovery option in case the
bootloader is updated and there is no running firmware, or in case the web [configure](https://spatial-media-lab.github.io/configure/)
interface is unable to update the device.

## Bootloader
Binary bootloader images, installed using a chip programming interface/device: `com.spatialmedialab.$DEVICE.bootloader-$VERSION.bin`.

Boot loader updates installed using the [Mass Storage Interface](https://github.com/microsoft/uf2): `com.spatialmedialab.$DEVICE.bootloader-$VERSION.uf2`.

## Web Interface
Index of firmware updates, picked up by the web [configure](https://spatial-media-lab.github.io/configure/) interface: 
[`index.json`](https://spatial-media-lab.github.io/download/index.json).

## Arduino Board Manager
Core, tools, boards [configuration](https://github.com/arduino/Arduino/wiki/Arduino-IDE-1.6.x-package_index.json-format-specification)
for the Arduino CLI and IDE: [`package_spatialmedialab_index.json`](https://spatial-media-lab.github.io/download/package_spatialmedialab_index.json).

## Build System
Builds all bootloders: `build-bootloader.sh`.

Builds the core package: `build-core.sh`.

Builds all firmware images: `build-firmware.sh`.
