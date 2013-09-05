QTSERIALPORT_VERSION = 5.1.1
QTSERIALPORT_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTSERIALPORT_VERSION)/submodules/
QTSERIALPORT_SOURCE = qtserialport-opensource-src-$(QTSERIALPORT_VERSION).tar.xz
QTSERIALPORT_DEPENDENCIES = qtbase
QTSERIALPORT_INSTALL_STAGING = YES

define QTSERIALPORT_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(TARGET_MAKE_ENV) qmake )
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
