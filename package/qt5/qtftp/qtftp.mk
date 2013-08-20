QTFTP_VERSION = 8f60c8c0adca6e6183fb31b528d306439ca2d2c1
QTFTP_SITE = git://gitorious.org/qt/qtftp.git
QTFTP_SITE_METHOD = git
QTFTP_DEPENDENCIES = qtbase
QTFTP_INSTALL_STAGING = YES

define QTFTP_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTFTP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTFTP_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTFTP_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Ftp.a $(TARGET_DIR)/usr/lib
endef

define QTFTP_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Ftp.a
endef

$(eval $(generic-package))
