QTJSBACKEND_VERSION = 5.0.1
QTJSBACKEND_SITE = http://releases.qt-project.org/qt5/$(QTJSBACKEND_VERSION)/submodules_tar
QTJSBACKEND_SOURCE = qtjsbackend-opensource-src-$(QTJSBACKEND_VERSION).tar.xz
QTJSBACKEND_DEPENDENCIES = qtbase
QTJSBACKEND_INSTALL_STAGING = YES

define QTJSBACKEND_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTJSBACKEND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTJSBACKEND_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTJSBACKEND_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5V8*.so.* $(TARGET_DIR)/usr/lib
endef

define QTJSBACKEND_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5V8*.so.*
endef

$(eval $(generic-package))
