#############################################################
#
# libnl
#
#############################################################

LIBNL_VERSION = 3.2.11
LIBNL_SITE = http://www.infradead.org/~tgr/libnl/files
LIBNL_INSTALL_STAGING = YES
LIBNL_DEPENDENCIES = host-bison
LIBNL_MAKE = $(MAKE1)
LIBNL_BINARIES = class-add class-delete class-list classid-lookup cls-add \
	cls-delete cls-list link-list pktloc-lookup qdisc-add qdisc-delete \
	qdisc-list

define LIBNL_UNINSTALL_TARGET_CMDS
	rm -r $(TARGET_DIR)/usr/lib/libnl.* $(TARGET_DIR)/usr/lib/libnl-*.*
	rm -rf $(TARGET_DIR)/usr/lib/libnl
endef

define LIBNL_REMOVE_TOOLS
	rm -rf $(addprefix $(TARGET_DIR)/usr/sbin/nl-, $(LIBNL_BINARIES))
endef

ifneq ($(BR2_PACKAGE_LIBNL_TOOLS),y)
LIBNL_POST_INSTALL_TARGET_HOOKS += LIBNL_REMOVE_TOOLS
endif

$(eval $(call AUTOTARGETS))
