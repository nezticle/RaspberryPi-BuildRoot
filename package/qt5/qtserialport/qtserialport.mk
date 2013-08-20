QTSERIALPORT_VERSION = 238309f65ba8faaa0b88a4f3d06a224fe3652467
QTSERIALPORT_SITE = git://gitorious.org/qt/qtserialport.git
QTSERIALPORT_SITE_METHOD = git
QTSERIALPORT_DEPENDENCIES = qtbase
QTSERIALPORT_INSTALL_STAGING = YES

define QTSERIALPORT_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTSERIALPORT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTSERIALPORT_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTSERIALPORT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5SerialPort*.so.* $(TARGET_DIR)/usr/lib
endef

define QTSERIALPORT_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5SerialPort*.so.*
endef

$(eval $(generic-package))
