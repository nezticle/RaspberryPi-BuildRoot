QTGAMEPAD_VERSION = dfab937b75e27d0e4b26c80db31b1a4dafb79358
QTGAMEPAD_SITE = https://github.com/nezticle/qtgamepad.git
QTGAMEPAD_SITE_METHOD = git
QTGAMEPAD_DEPENDENCIES = qtbase
QTGAMEPAD_INSTALL_STAGING = YES

define QTGAMEPAD_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTGAMEPAD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTGAMEPAD_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTGAMEPAD_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Gamepad*.so.* $(TARGET_DIR)/usr/lib
endef

define QTGAMEPAD_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Gamepad*.so.*
endef

$(eval $(generic-package))
