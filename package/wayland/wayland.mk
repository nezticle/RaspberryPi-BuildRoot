WAYLAND_VERSION = 1.1.0
WAYLAND_SITE = http://wayland.freedesktop.org/releases/
WAYLAND_SOURCE = wayland-$(WAYLAND_VERSION).tar.xz
HOST_WAYLAND_DEPENDENCIES = host-expat host-libffi
WAYLAND_DEPENDENCIES = host-pkgconf udev VideoCore libffi host-wayland
WAYLAND_INSTALL_STAGING = YES

# Wayland needs the host tool wayland-scanner to be built first

HOST_WAYLAND_AUTORECONF = YES

define HOST_WAYLAND_CONFIGURE_CMDS
	(cd $(@D) && rm -rf config.cache; \
	        $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-documentation \
	)
endef

WAYLAND_CONF_OPT += --disable-scanner --disable-documentation

WAYLAND_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
