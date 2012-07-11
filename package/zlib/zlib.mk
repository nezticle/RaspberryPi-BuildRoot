#############################################################
#
# zlib
#
#############################################################

ZLIB_VERSION = 1.2.7
ZLIB_SOURCE =zlib-$(ZLIB_VERSION).tar.bz2
ZLIB_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libpng
ZLIB_INSTALL_STAGING = YES

ifeq ($(BR2_PREFER_STATIC_LIB),y)
ZLIB_PIC :=
ZLIB_SHARED := --static
else
ZLIB_PIC := -fPIC
ZLIB_SHARED := --shared
endif

define ZLIB_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(ZLIB_PIC)" \
		./configure \
		$(ZLIB_SHARED) \
		--prefix=/usr \
	)
endef

define HOST_ZLIB_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(HOST_CONFIGURE_ARGS) \
		$(HOST_CONFIGURE_OPTS) \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
endef

define ZLIB_BUILD_CMDS
	$(MAKE1) -C $(@D)
endef

define HOST_ZLIB_BUILD_CMDS
	$(MAKE1) -C $(@D)
endef

define ZLIB_INSTALL_STAGING_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) LDCONFIG=true install
endef

define ZLIB_INSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(TARGET_DIR) LDCONFIG=true install
endef

define HOST_ZLIB_INSTALL_CMDS
	$(MAKE1) -C $(@D) LDCONFIG=true install
endef

define ZLIB_CLEAN_CMDS
	-$(MAKE1) -C $(@D) clean
endef

define ZLIB_UNINSTALL_STAGING_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) uninstall
endef

define ZLIB_UNINSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) DESTDIR=$(TARGET_DIR) uninstall
endef

define HOST_ZLIB_UNINSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) uninstall
endef

$(eval $(call GENTARGETS))
$(eval $(call GENTARGETS,host))
