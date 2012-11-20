QTMULTIMEDIA_VERSION = db8f5da7af46b00e8819f0525fc71c480f4f585a
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
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Multimedia*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins/* $(TARGET_DIR)/usr/plugins
	cp -dpfr $(STAGING_DIR)/usr/qml/* $(TARGET_DIR)/usr/qml
endef

define QTMULTIMEDIA_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Multimedia*.so.*
	-rm -r $(TARGET_DIR)/usr/qml/QtMultimedia
endef

$(eval $(generic-package))
