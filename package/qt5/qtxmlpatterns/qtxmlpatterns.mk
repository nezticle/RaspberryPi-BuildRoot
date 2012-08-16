QTXMLPATTERNS_VERSION = master
QTXMLPATTERNS_SITE = git://gitorious.org/qt/qtxmlpatterns.git
QTXMLPATTERNS_SITE_METHOD = git
QTXMLPATTERNS_DEPENDENCIES = qtbase
QTXMLPATTERNS_INSTALL_STAGING = YES

define QTXMLPATTERNS_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTXMLPATTERNS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTXMLPATTERNS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTXMLPATTERNS_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQtXmlPatterns*.so.* $(TARGET_DIR)/usr/lib
endef

define QTXMLPATTERNS_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQtXmlPatterns*.so.*
endef

$(eval $(call GENTARGETS))