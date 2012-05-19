MKIMAGE_VERSION = master
MKIMAGE_SITE = git://github.com/raspberrypi/tools.git
MKIMAGE_SITE_METHOD = git
MKIMAGE_INSTALL_HOST = yes

define HOST_MKIMAGE_INSTALL_CMDS
	#copy first32k.bin to host/usr/share/mkimage/
	mkdir -p $(HOST_DIR)/usr/share/mkimage
	cp $(@D)/mkimage/first32k.bin $(HOST_DIR)/usr/share/mkimage/first32k.bin
endef

$(eval $(call GENTARGETS,host))

