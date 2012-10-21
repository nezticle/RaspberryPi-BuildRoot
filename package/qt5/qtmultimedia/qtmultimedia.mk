QTMULTIMEDIA_VERSION = 8907cecc0dbe72deec3273f4800008b005c90544
QTMULTIMEDIA_SITE = git://gitorious.org/qt/qtmultimedia.git
QTMULTIMEDIA_SITE_METHOD = git
QTMULTIMEDIA_DEPENDENCIES = qtbase qtdeclarative
QTMULTIMEDIA_INSTALL_STAGING = YES

define QTMULTIMEDIA_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTMULTIMEDIA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTMULTIMEDIA_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTMULTIMEDIA_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQtMultimedia*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins/* $(TARGET_DIR)/usr/plugins
	cp -dpfr $(STAGING_DIR)/usr/imports/* $(TARGET_DIR)/usr/imports
endef

define QTMULTIMEDIA_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQtMultimedia*.so.*
	-rm -r $(TARGET_DIR)/usr/imports/QtMultimedia
endef

$(eval $(generic-package))
