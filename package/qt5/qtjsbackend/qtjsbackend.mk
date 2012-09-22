QTJSBACKEND_VERSION = ffa3a7026e1cdcb1825ede90c6e3cddc8c8002b7
QTJSBACKEND_SITE = git://gitorious.org/qt/qtjsbackend.git
QTJSBACKEND_SITE_METHOD = git
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
	cp -dpf $(STAGING_DIR)/usr/lib/libQtV8*.so.* $(TARGET_DIR)/usr/lib
endef

define QTJSBACKEND_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQtV8*.so.*
endef

$(eval $(generic-package))
