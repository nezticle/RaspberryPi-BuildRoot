# Getting started with the Bsquask SDK: #

The objective of this project is to provide an SDK and root file system for the Raspberry Pi that is lightweight and takes full advantage of the hardware available.  The resulting image produced is small distro known as Bsquask (linux).

The Bsquask SDK provides a GCC 4.6.3 toolchain for building armv6 binaries with the hardfloat ABI, as well as bootloaders, kernel image, rootfs, and development sysroot for the Raspberry Pi.

## Generating Image and Sysroot: ##

Building is fairly strait-forward as buildroot is Makefile based.  One caveat though is that you can not specify the number of make jobs (-jN) for the top level Makefile.  This is handled automatically, so expect build failure if you set the number of jobs explicitly.

To Build (in source):  
`make raspberrypi_defconfig`

To do a shadow build (recommended):  
`make raspberrypi_defconfig O=/build/output/directory`  
`cd /build/output/directory`  
`make` 

Wait for the build to complete, which can take up to a couple of hours if you have a slow machine.


## Create SD Image ##

Format an SD card with two partitions:  
*75Mb Fat32*  
*500+Mb Ext4*  

Extract outputDirectory/images/boot.tar.gz to the Fat32 partition:  
`tar -zxvf boot.tar.gz -C /media/boot`

extract outputDirectory/images/rootfs.tar.gz to the ext4 partition as root:  
`sudo tar -zxvf rootfs.tar.gz -C /media/rootfs`

## SDK + Toolchain: ##
SDK host tools are in:  
*output/host/usr/bin*

Add this to you PATH environment variable to make use of these tools.

Sysroot containing header files and development library files is located here:  
*outputDirectory/staging*

Target directory used to make images is here:  
*outputDirectory/target*

If you want to regenerate your image with your changes to target, just run make again.

## Note: ##
Right now the default setup downloads an external toolchain that only works with x86_64 systems.  It is also possible to change the configuration to build your own compatible toolchain, but for this you should consult the BuildRoot documentation.

### The Bsquask SDK is based on BuildRoot 2012.05 ###
