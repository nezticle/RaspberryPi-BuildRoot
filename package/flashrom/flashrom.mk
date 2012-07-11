#############################################################
#
# flashrom
#
#############################################################
FLASHROM_VERSION = 0.9.3
FLASHROM_SOURCE  = flashrom-$(FLASHROM_VERSION).tar.bz2
FLASHROM_SITE    = http://download.flashrom.org/releases

FLASHROM_DEPENDENCIES = pciutils

define FLASHROM_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FLASHROM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/flashrom $(TARGET_DIR)/usr/sbin/flashrom
endef

$(eval $(call GENTARGETS))
