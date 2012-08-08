VIDEOCORE_VERSION = 7680bb3
VIDEOCORE_SITE = http://bsquask.com/downloads/firmware
VIDEOCORE_SOURCE = raspberrypi-firmware-$(VIDEOCORE_VERSION).tar.gz
VIDEOCORE_INSTALL_STAGING = YES
VIDEOCORE_INSTALL_TARGET = YES

define VIDEOCORE_INSTALL_STAGING_CMDS
	cp -r $(@D)/hardfp/opt $(STAGING_DIR)/
endef

define VIDEOCORE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/vc
	cp -r $(@D)/hardfp/opt/vc/bin $(TARGET_DIR)/opt/vc
	cp -r $(@D)/hardfp/opt/vc/lib $(TARGET_DIR)/opt/vc
	cp -r $(@D)/hardfp/opt/vc/sbin $(TARGET_DIR)/opt/vc
endef

$(eval $(call GENTARGETS))
