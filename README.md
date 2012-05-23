Raspberry Pi Buildroot SDK readme

This project is a fork of the BuildRoot project that is setup for building Images and SDK's for the Raspberry Pi using a armv6 hardfloat toolchain.

To use just run:

make raspberrypi_defconfig
or
make raspberrypi_defconfig O=/build/output/directory

Wait for the build to complete, which can take up to a couple of hours if you have a slow machine.

Create an SD card with two partitions:
75Mb Fat32
500+Mb Ext4

extract output/images/boot.tar.gz to the Fat32 partition:
tar -zxvf boot.tar.gz -C /media/boot

extract output/images/rootfs.tar.gz to the ext4 partition as root:
sudo tar -zxvf rootfs.tar.gz -C /media/rootfs

SDK + Toolchain:
SDK host tools are in output/host/usr/bin
Add this to you PATH environment variable to make use of these tools.

Sysroot containing header files and development library files is located here:
output/staging

Target directory used to make images is here:
output/target

If you want to regenerate your image with your changes to target, just run make again.


Note:
Right now the default setup downloads an external toolchain that only works with x86_64 systems.  It is also possible to change the configuration to build your own compatible toolchain, but for this you should consult the BuildRoot documentation.
