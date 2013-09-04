QTWEBKIT_VERSION = 5.1.1
QTWEBKIT_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTWEBKIT_VERSION)/submodules/
QTWEBKIT_SOURCE = qtwebkit-opensource-src-$(QTWEBKIT_VERSION).tar.xz
QTWEBKIT_DEPENDENCIES = qtbase qtxmlpatterns qtdeclarative qtmultimedia qtjsbackend host-ruby
QTWEBKIT_INSTALL_STAGING = YES

define QTWEBKIT_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTWEBKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTWEBKIT_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTWEBKIT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebKit*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebKit $(TARGET_DIR)/usr/qml/
endef

define QTWEBKIT_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Webkit*.so.*
endef

$(eval $(generic-package))
