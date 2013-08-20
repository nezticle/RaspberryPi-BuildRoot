QTJSBACKEND_VERSION = 5.1.0
QTJSBACKEND_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTJSBACKEND_VERSION)/submodules/
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
