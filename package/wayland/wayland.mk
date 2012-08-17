WAYLAND_VERSION = c855d6eec4c5e63489da5bc08451a2376e6d2aea
WAYLAND_SITE = git://anongit.freedesktop.org/wayland/wayland
WAYLAND_SITE_METHOD = git
HOST_WAYLAND_DEPENDENCIES = host-expat host-libffi
WAYLAND_DEPENDENCIES = host-pkg-config udev VideoCore libffi host-wayland
WAYLAND_INSTALL_STAGING = YES

# Wayland needs the host tool wayland-scanner to be built first

HOST_WAYLAND_AUTORECONF = YES

define HOST_WAYLAND_CONFIG_CMDS
	(cd $(@D) && rm -rf config.cache; \
	        $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
	)
endef

WAYLAND_CONF_OPT += --disable-scanner

WAYLAND_AUTORECONF = YES

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))