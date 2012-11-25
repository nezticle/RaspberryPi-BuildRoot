QTGRAPHICALEFFECTS_VERSION = bcdaf070ba43c372664ef385d4cb154d020df264
QTGRAPHICALEFFECTS_SITE = git://gitorious.org/qt/qtgraphicaleffects.git
QTGRAPHICALEFFECTS_SITE_METHOD = git
QTGRAPHICALEFFECTS_DEPENDENCIES = qtdeclarative
QTGRAPHICALEFFECTS_INSTALL_STAGING = YES

define QTGRAPHICALEFFECTS_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTGRAPHICALEFFECTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTGRAPHICALEFFECTS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTGRAPHICALEFFECTS_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtGraphicalEffects $(TARGET_DIR)/usr/qml
endef

define QTGRAPHICALEFFECTS_UNINSTALL_TARGET_CMDS
	-rm -r $(TARGET_DIR)/usr/qml/QtGraphicalEffects
endef

$(eval $(generic-package))
