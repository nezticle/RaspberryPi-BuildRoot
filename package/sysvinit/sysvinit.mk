#############################################################
#
# sysvinit
#
#############################################################
SYSVINIT_VERSION = 2.88
SYSVINIT_SOURCE  = sysvinit_$(SYSVINIT_VERSION)dsf.orig.tar.gz
SYSVINIT_PATCH   = sysvinit_$(SYSVINIT_VERSION)dsf-13.1.diff.gz
SYSVINIT_SITE    = $(BR2_DEBIAN_MIRROR)/debian/pool/main/s/sysvinit

# Override Busybox implementations if Busybox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSVINIT_DEPENDENCIES = busybox
endif

define SYSVINIT_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

SYSVINIT_POST_PATCH_HOOKS = SYSVINIT_DEBIAN_PATCHES

define SYSVINIT_BUILD_CMDS
	# Force sysvinit to link against libcrypt as it otherwise
	# use an incorrect test to see if it's available
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LCRYPT="-lcrypt" -C $(@D)/src
endef

define SYSVINIT_INSTALL_TARGET_CMDS
	for x in halt init shutdown; do \
		install -D -m 0755 $(@D)/src/$$x $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
	# Override Busybox's inittab with an inittab compatible with
	# sysvinit
	install -D -m 0644 package/sysvinit/inittab $(TARGET_DIR)/etc/inittab
endef

define SYSVINIT_UNINSTALL_TARGET_CMDS
	for x in halt init shutdown; do \
		rm -f $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
endef

define SYSVINIT_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

$(eval $(call GENTARGETS))
