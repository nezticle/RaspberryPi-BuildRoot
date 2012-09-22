MKIMAGE_VERSION = bed344f
MKIMAGE_SITE = http://bsquask.com/downloads/toolchains
MKIMAGE_SOURCE = raspberrypi-tools-$(MKIMAGE_VERSION).tar.gz
MKIMAGE_INSTALL_HOST = YES

define HOST_MKIMAGE_INSTALL_CMDS
	#copy first32k.bin to host/usr/share/mkimage/
	mkdir -p $(HOST_DIR)/usr/share/mkimage
	cp $(@D)/mkimage/first32k.bin $(HOST_DIR)/usr/share/mkimage/first32k.bin
endef

$(eval $(host-generic-package))

